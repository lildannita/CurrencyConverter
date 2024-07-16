#include "ExchangeRatesModel.hpp"

#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkRequest>

#include "ServerRequests.hpp"

ExchangeRatesModel::ExchangeRatesModel(Config &config, AppState &appState, ServerState &serverState,
                                       QObject *parent)
    : QObject(parent),
      _isFromInit(false),
      _isToInit(false),
      _resultExchange(0),
      _loadingDone(false),
      _config(&config),
      _appState(&appState),
      _serverState(&serverState) {
    _manager = new QNetworkAccessManager(this);

    if (_config->getChosenIsInit(true)) searchValuteByCode(_config->getChosenValute(true).abbreviation, true);

    if (_config->getChosenIsInit(false))
        searchValuteByCode(_config->getChosenValute(false).abbreviation, false);
}

void ExchangeRatesModel::sendServerRequest() {
    _loadingDone = false;
    emit loadingDoneChanged();

    QNetworkReply *reply = _manager->get(QNetworkRequest(LAST_EXCHANGE_RATES));
    QObject::connect(reply, &QNetworkReply::finished, this, &ExchangeRatesModel::getDataFromServer);
}

// Получение и обработка данных
void ExchangeRatesModel::getDataFromServer() {
    QNetworkReply *reply = dynamic_cast<QNetworkReply *>(sender());

    qDebug() << "Trying to connect to" << LAST_EXCHANGE_RATES << "...";
    if (reply->error()) {
        qDebug() << "Connection to" << LAST_EXCHANGE_RATES << "refused!";
        getDataFromCache();
        _manager->clearConnectionCache();
        return;
    } else {
        qDebug() << "Connected to" << LAST_EXCHANGE_RATES << ".";
    }

    QJsonObject jsonObject = QJsonDocument::fromJson(QString(reply->readAll()).toUtf8()).object();
    _serverData = jsonObject.toVariantMap();

    bool dataReady = _serverData.value("Data Ready").toBool();
    _connection = ServerInfo(_serverData.value("Internet Connection").toBool(),
                             _serverData.value("CBR Connection").toBool(), dataReady, _config->checkConfig());
    _serverState->setRatesState(_connection);

    if (dataReady) {
        QMap<QString, QVariant> dataMap = _serverData.value("Data").toMap();
        QMap<QString, QVariant>::iterator dataIt;
        QMap<QString, QVariant> valuteData;

        _data.clear();
        for (dataIt = dataMap.begin(); dataIt != dataMap.end(); dataIt++) {
            valuteData = dataIt.value().toMap();
            _data << ExchangeRates(dataIt.key(), valuteData.value("Value").toReal(),
                                   valuteData.value("Previous").toReal());
        }
        _config->setLastExchangeRates(_data);

        _loadingDone = true;
        emit loadingDoneChanged();
    } else {
        getDataFromCache();
    }

    _manager->clearConnectionCache();
}

// Получение и обработка данных с кэша (конфига)
void ExchangeRatesModel::getDataFromCache() {
    bool isConfigAvailiable = _config->checkConfig();

    if (isConfigAvailiable) {
        _data = _config->getLastExchangeRates();

        if (_appState->saveLastRates()) initLastChoices();
    }

    _loadingDone = true;
    emit loadingDoneChanged();

    _connection = ServerInfo(false, false, isConfigAvailiable, isConfigAvailiable);
    _serverState->setRatesState(_connection);
}

void ExchangeRatesModel::initLastChoices() {
    _isFromInit = _config->getChosenIsInit(true);
    _isToInit = _config->getChosenIsInit(false);
    if (_isFromInit) searchValuteByCode(_config->getChosenValute(true).abbreviation, true);

    if (_isToInit) searchValuteByCode(_config->getChosenValute(false).abbreviation, false);
}

void ExchangeRatesModel::searchValuteByCode(QString request, bool isFromVal) {
    foreach (ExchangeRates rates, _data) {
        if (rates.code == request) {
            if (isFromVal) {
                _valuteFrom = rates;
                _isFromInit = true;
            } else {
                _valuteTo = rates;
                _isToInit = true;
            }

            fillRatesValues();

            isFromVal ? emit isFromInitChanged() : emit isToInitChanged();

            return;
        }
    }
}

QString ExchangeRatesModel::calculate(QString value) {
    if (!_isFromInit || !_isToInit) return value;
    return checkCalcString(
        QString::number(value.replace(",", ".").toDouble() * _resultExchange, 'f', 2).replace(".", ","));
}

QString ExchangeRatesModel::checkCalcString(QString calcStr) {
    if (calcStr.right(2) == "00") calcStr.chop(3);
    return calcStr;
}

QString ExchangeRatesModel::getExchangeInfo() {
    if (_isFromInit && _isToInit) {
        return QString("1 " + _valuteFrom.code + " = " + QString::number(_resultExchange) + " " +
                       _valuteTo.code);
    } else {
        if (!_isFromInit && !_isToInit) return QString(tr("Выберите валюты"));
        if (!_isFromInit) return QString(tr("Выберите начальную валюту"));
        return QString(tr("Выберите конечную валюту"));
    }
}

void ExchangeRatesModel::swapValutes() {
    ExchangeRates tmp = _valuteFrom;
    _valuteFrom = _valuteTo;
    _valuteTo = tmp;

    bool tmpInit = _isFromInit;
    _isFromInit = _isToInit;
    _isToInit = tmpInit;

    emit isFromInitChanged();
    emit isToInitChanged();

    fillRatesValues();
}

void ExchangeRatesModel::fillRatesValues() {
    if ((_isFromInit && !_isToInit) || (!_isFromInit && _isToInit)) emit exchangeInfoChanged();

    if (!_isFromInit || !_isToInit) return;

    qreal _resultExchangeOriginal = (1 / _valuteTo.value) * _valuteFrom.value;
    qreal _prevExchangeOriginal = (1 / _valuteTo.previous) * _valuteFrom.previous;

    _resultExchange = qRound(_resultExchangeOriginal * 10000) / 10000.0;
    emit exchangeInfoChanged();

    _isUpDown = compare(_resultExchangeOriginal, _prevExchangeOriginal);
    emit isUpDownChanged();
}

int ExchangeRatesModel::compare(qreal left, qreal right) {
    if (left > right) return 1;
    if (left < right) return -1;
    return 0;
}
