#pragma once

#include <QByteArray>
#include <QMap>
#include <QObject>
#include <QPointer>
#include <QString>
#include <QVariant>
#include <QVector>
#include <QtNetwork/QNetworkAccessManager>

#include "ServerInfo.hpp"
#include "Share/AppState.hpp"
#include "Share/Config.hpp"
#include "Share/ServerState.hpp"

class ExchangeRatesModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool loadingDone READ loadingDone NOTIFY loadingDoneChanged FINAL)
    Q_PROPERTY(QString exchangeInfo READ getExchangeInfo NOTIFY exchangeInfoChanged FINAL)
    Q_PROPERTY(bool isFromInit READ isFromInit NOTIFY isFromInitChanged FINAL)
    Q_PROPERTY(bool isToInit READ isToInit NOTIFY isToInitChanged FINAL)
    Q_PROPERTY(int isUpDown READ isUpDown NOTIFY isUpDownChanged FINAL)

signals:
    void loadingDoneChanged();
    void exchangeInfoChanged();
    void isFromInitChanged();
    void isToInitChanged();
    void isUpDownChanged();

public:
    ExchangeRatesModel(Config &config, AppState &appState, ServerState &serverState,
                       QObject *parent = nullptr);

    bool loadingDone() { return _loadingDone; }
    bool isFromInit() { return _isFromInit; }
    bool isToInit() { return _isToInit; }
    int isUpDown() { return _isUpDown; }

    Q_INVOKABLE void sendServerRequest();

    Q_INVOKABLE void searchValuteByCode(QString request, bool isFromVal);
    Q_INVOKABLE QString calculate(QString value);
    Q_INVOKABLE QString getExchangeInfo();
    Q_INVOKABLE void swapValutes();

private slots:
    void getDataFromServer();

private:
    QMap<QString, QVariant> _serverData;
    ServerInfo _connection;
    QVector<ExchangeRates> _data;

    ExchangeRates _valuteFrom;
    ExchangeRates _valuteTo;
    bool _isFromInit;
    bool _isToInit;
    int _isUpDown;
    qreal _resultExchange;

    QNetworkAccessManager *_manager;
    bool _loadingDone;

    void fillRatesValues();
    int compare(qreal left, qreal right);

    QPointer<Config> _config;
    QPointer<AppState> _appState;
    QPointer<ServerState> _serverState;
    void getDataFromCache();
    void initLastChoices();

    QString checkCalcString(QString calcStr);
};
