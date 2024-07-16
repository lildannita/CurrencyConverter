#pragma once

#include <QObject>
#include <QPointer>
#include <QString>

#include "Config.hpp"
#include "ServerData/ServerInfo.hpp"

class ServerState final : public QObject {
    Q_OBJECT

signals:
    void errorMsgIsReady(QString cntMsg, QString cacheMsg);

public:
    ServerState(Config &config, QObject *parent = nullptr);

    void setValutesState(ServerInfo valutesState);
    void setRatesState(ServerInfo ratesState);

private:
    ServerInfo _valutesState;
    ServerInfo _ratesState;

    bool _isValutesStateInit;
    bool _isRatesStateInit;

    QString _connectionMsg;
    QString _cacheMsg;
    void tryToMakeErrorExp();

    QPointer<Config> _config;
};
