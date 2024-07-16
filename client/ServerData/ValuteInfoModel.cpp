#include "ValuteInfoModel.hpp"

#include <QDebug>
#include <QFileInfo>
#include <QGuiApplication>
#include <QJsonDocument>
#include <QJsonObject>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkRequest>

#include "ServerRequests.hpp"

ValuteInfoModel::ValuteInfoModel(Config &config, AppState &appState, ServerState &serverState,
                                 FavouritesModel &favouritesModel, QObject *parent)
    : QAbstractListModel(parent),
      _loadingDone(false),
      _defaultIconPath(QString("qrc:/flags/default.svg")),
      _config(&config),
      _appState(&appState),
      _serverState(&serverState),
      _favouriteModel(&favouritesModel) {
    _manager = new QNetworkAccessManager(this);
}

void ValuteInfoModel::sendServerRequest() {
    _loadingDone = false;
    emit loadingDoneChanged();

    QNetworkReply *reply = _manager->get(QNetworkRequest(VALUTE_INFO_REQUEST));
    QObject::connect(reply, &QNetworkReply::finished, this, &ValuteInfoModel::getDataFromServer);
}

int ValuteInfoModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) return 0;
    return _data.count();
}

QVariant ValuteInfoModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid()) return QVariant();

    const ValData &data = _data.at(index.row());
    switch (role) {
        case AbbreviationRole:
            return data.abbreviation;
        case SymbolRole:
            return data.symbol;
        case NameRole:
            return data.name;
        case EngNameRole:
            return data.engName;
        case IdRole:
            return data.id;
        case ImgPathRole:
            return data.imgPath;
        default:
            return QVariant();
    }
}

QHash<int, QByteArray> ValuteInfoModel::roleNames() const {
    static QHash<int, QByteArray> mapping{
        { AbbreviationRole, "abbreviation" },
        { SymbolRole, "symbol" },
        { NameRole, "name" },
        { EngNameRole, "engName" },
        { IdRole, "id" },
        { ImgPathRole, "imgPath" }
    };
    return mapping;
}

// Получение и обработка данных
void ValuteInfoModel::getDataFromServer() {
    QNetworkReply *reply = dynamic_cast<QNetworkReply *>(sender());

    qDebug() << "Trying to connect to" << VALUTE_INFO_REQUEST << "...";
    if (reply->error()) {
        qDebug() << "Connection to" << VALUTE_INFO_REQUEST << "refused!";
        getDataFromCache();
        _manager->clearConnectionCache();
        return;
    }

    qDebug() << "Connected to" << VALUTE_INFO_REQUEST << ".";

    _time = QDateTime::currentDateTime().toString("hh:mm:ss dd.MM.yyyy");
    _config->setLastRequestTime(_time);
    emit timeChanged();

    QJsonObject jsonObject = QJsonDocument::fromJson(QString(reply->readAll()).toUtf8()).object();
    _serverData = jsonObject.toVariantMap();

    bool dataReady = _serverData.value("Data Ready").toBool();
    _connection = ServerInfo(_serverData.value("Internet Connection").toBool(),
                             _serverData.value("CBR Connection").toBool(), dataReady, _config->checkConfig());
    _serverState->setValutesState(_connection);

    if (dataReady) {
        QMap<QString, QVariant> baseData = _serverData.value("Base").toMap();
        _base = BaseData(baseData.value("Code").toString(), baseData.value("Symbol").toString(),
                         baseData.value("Name").toString(), baseData.value("NameEng").toString());
        _config->setBaseValute(_base);

        QMap<QString, QVariant> dataMap = _serverData.value("Data").toMap();
        QMap<QString, QVariant>::iterator dataIt;
        QMap<QString, QVariant> valuteData;

        QString code;

        _originalData.clear();
        _originalData << ValData(_base.abbreviation, _base.symbol, _base.name, _base.engName, "R00000",
                                 getIconPath(_base.abbreviation));

        for (dataIt = dataMap.begin(); dataIt != dataMap.end(); dataIt++) {
            valuteData = dataIt.value().toMap();
            code = dataIt.key();
            _originalData << ValData(
                code, valuteData.value("Symbol").toString(), valuteData.value("Name").toString(),
                valuteData.value("EngName").toString(), valuteData.value("ID").toString(), getIconPath(code));
        }

        backToOriginalData();
        _config->setValutesInfo(_originalData);

        _appState->saveLastRates() ? initLastChoices() : _config->clearChosenValutes();

        _loadingDone = true;
        emit loadingDoneChanged();
    } else {
        getDataFromCache();
    }

    _manager->clearConnectionCache();
}

// Получение и обработка данных с кэша (конфига)
void ValuteInfoModel::getDataFromCache() {
    if (_config->checkConfigGeneralSettings()) {
        _time = _config->getLastRequestTime();
        emit timeChanged();
    }

    bool isConfigAvailiable = _config->checkConfig();
    if (isConfigAvailiable) {
        _originalData = _config->getValutesInfo();
        backToOriginalData();

        _base = _config->getBaseValute();

        _appState->saveLastRates() ? initLastChoices() : _config->clearChosenValutes();
    }

    _loadingDone = true;
    emit loadingDoneChanged();

    _connection = ServerInfo(false, false, isConfigAvailiable, isConfigAvailiable);
    _serverState->setValutesState(_connection);
}

void ValuteInfoModel::initLastChoices() {
    _isFromInit = _config->getChosenIsInit(true);
    _isToInit = _config->getChosenIsInit(false);
    if (_isFromInit) _fromValute = _config->getChosenValute(true);
    if (_isToInit) _toValute = _config->getChosenValute(false);
    if (_isFromInit && _isToInit)
        _favouriteModel->setCurrentExchange(FavInfo(_fromValute.abbreviation, _toValute.abbreviation));
    if (_isFromInit || _isToInit) emit lastChosenValutesSetFromCache(_isFromInit, _isToInit);
}

void ValuteInfoModel::setFavValutes(QString leftCode, QString rightCode) {
    searchValuteByCode(leftCode, true);
    searchValuteByCode(rightCode, false);
    _favouriteModel->setCurrentExchange(FavInfo(_fromValute.abbreviation, _toValute.abbreviation));
    emit valutesSetFromFavList();
}

// Функция поиска валюты по ключевым словам
void ValuteInfoModel::sortDataByRequest(QString request) {
    beginResetModel();
    _data.clear();
    foreach (ValData valute, _originalData)
        if (valute.abbreviation.contains(request, Qt::CaseInsensitive) ||
            valute.name.contains(request, Qt::CaseInsensitive) ||
            valute.engName.contains(request, Qt::CaseInsensitive))
            if (!_data.contains(valute)) _data << valute;
    endResetModel();
}

// Возврат модели к исходному состоянию
void ValuteInfoModel::backToOriginalData() {
    beginResetModel();
    _data.clear();
    _data = _originalData;
    endResetModel();
}

QString ValuteInfoModel::getIconPath(const QString &code) {
    QString pathToIcon = QString(":/flags/") + code + QString(".svg");
    QFileInfo checkFile(pathToIcon);
    return (checkFile.exists() && checkFile.isFile()) ? QString("qrc") + pathToIcon : _defaultIconPath;
}

void ValuteInfoModel::searchValute(QString request, bool isFromVal, bool isCode) {
    foreach (ValData valute, _originalData)
        if ((isCode ? valute.abbreviation : valute.id) == request) {
            if (isFromVal) {
                _isFromInit = true;
                _fromValute = valute;
                _config->setChosenValute(valute, _isFromInit, true);
            } else {
                _isToInit = true;
                _toValute = valute;
                _config->setChosenValute(valute, _isToInit, false);
            }

            if (_isFromInit && _isToInit)
                _favouriteModel->setCurrentExchange(
                    FavInfo(_fromValute.abbreviation, _toValute.abbreviation));
            return;
        }
}

void ValuteInfoModel::searchValuteById(QString request, bool isFromVal) {
    searchValute(request, isFromVal, false);
}

void ValuteInfoModel::searchValuteByCode(QString request, bool isFromVal) {
    searchValute(request, isFromVal, true);
}

void ValuteInfoModel::swapValutes() {
    ValData tmpValute = _fromValute;
    bool tmpIsInit = _isFromInit;
    _fromValute = _toValute;
    _toValute = tmpValute;
    _isFromInit = _isToInit;
    _isToInit = tmpIsInit;

    _config->setChosenValute(_fromValute, _isFromInit, true);
    _config->setChosenValute(_toValute, _isToInit, false);

    if (_isFromInit && _isToInit)
        _favouriteModel->setCurrentExchange(FavInfo(_fromValute.abbreviation, _toValute.abbreviation));
}

QString ValuteInfoModel::getImgPathOfFavouriteValute(QString valCode) {
    foreach (ValData valute, _originalData)
        if (valute.abbreviation == valCode) return valute.imgPath;
    return _defaultIconPath;
}

QString ValuteInfoModel::getImgPathOfSearchedValute(bool isFromVal) {
    return isFromVal ? _fromValute.imgPath : _toValute.imgPath;
}

QString ValuteInfoModel::getAbbrOfSearchedValute(bool isFromVal) {
    return isFromVal ? _fromValute.abbreviation : _toValute.abbreviation;
}
