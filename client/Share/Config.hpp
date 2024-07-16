#pragma once

#include <QMap>
#include <QObject>
#include <QSettings>
#include <QString>
#include <QVariant>
#include <QVector>

#include "ServerData/ServerInfo.hpp"

class Config final : public QObject {
public:
    Config();

    bool checkConfig();
    bool checkConfigGeneralSettings();

    void setValutesInfo(QVector<ValData> valutes);
    QVector<ValData> getValutesInfo();
    void setBaseValute(BaseData base);
    BaseData getBaseValute();
    void setChosenValute(ValData valute, bool isInit, bool isFromVal);
    bool getChosenIsInit(bool isFromVal);
    ValData getChosenValute(bool isFromVal);
    void clearChosenValutes();

    void setLastRequestTime(QString time);
    QString getLastRequestTime();

    void setLastExchangeRates(QVector<ExchangeRates> rates);
    QVector<ExchangeRates> getLastExchangeRates();

    QVector<FavInfo> getFavExchange();
    void addFavExchange(FavInfo element, int index);
    void deleteFavExchange(QVector<FavInfo> newData);

    QMap<QString, bool> getAppState();
    void setAppStateValue(QString key, bool value);
    void initAppStateInConfig(QMap<QString, bool> values);

private:
    QString _confName;
};
