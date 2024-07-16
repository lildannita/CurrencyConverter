#include "Config.hpp"

#include <QStringList>

Config::Config() { _confName = QString("converter.ini"); }

// Проверка наличия информации в конфиге
bool Config::checkConfig() {
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");
    return _config.allKeys().size() > 0;
}

// Проверка наличия настроек в конфиге
bool Config::checkConfigGeneralSettings() {
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");
    return _config.childGroups().contains("GeneralSettings");
}

// Добавление последних данных о валютах в конфиг
void Config::setValutesInfo(QVector<ValData> valutes) {
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.remove("ValutesInfo");
    _config.beginGroup("ValutesInfo");
    _config.beginWriteArray("InfoArray");
    for (int i = 0; i < valutes.size(); i++) {
        _config.setArrayIndex(i);
        _config.setValue("abbreviation", valutes.at(i).abbreviation);
        _config.setValue("id", valutes.at(i).id);
        _config.setValue("name", valutes.at(i).name);
        _config.setValue("engName", valutes.at(i).engName);
        _config.setValue("imgPath", valutes.at(i).imgPath);
        _config.setValue("symbol", valutes.at(i).symbol);
    }
    _config.endArray();
    _config.endGroup();
}

QVector<ValData> Config::getValutesInfo() {
    QVector<ValData> data;
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.beginGroup("ValutesInfo");
    int size = _config.beginReadArray("InfoArray");
    for (int i = 0; i < size; i++) {
        _config.setArrayIndex(i);
        data << ValData(_config.value("abbreviation").toString(), _config.value("symbol").toString(),
                        _config.value("name").toString(), _config.value("engName").toString(),
                        _config.value("id").toString(), _config.value("imgPath").toString());
    }
    _config.endArray();
    _config.endGroup();

    return data;
}

void Config::setBaseValute(BaseData base) {
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.beginGroup("BaseInfo");
    _config.setValue("abbreviation", base.abbreviation);
    _config.setValue("symbol", base.symbol);
    _config.setValue("name", base.name);
    _config.setValue("engName", base.engName);
    _config.endGroup();
}

BaseData Config::getBaseValute() {
    BaseData base;
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.beginGroup("ValutesInfo");
    base = BaseData(_config.value("abbreviation").toString(), _config.value("symbol").toString(),
                    _config.value("name").toString(), _config.value("engName").toString());
    _config.endGroup();

    return base;
}

// Добавление выбранной валюты в конфиг
void Config::setChosenValute(ValData valute, bool isInit, bool isFromVal) {
    QString valGroup = isFromVal ? "ValuteFrom" : "ValuteTo";
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.beginGroup(valGroup);
    _config.setValue("isInit", isInit);
    _config.setValue("abbreviation", valute.abbreviation);
    _config.setValue("symbol", valute.symbol);
    _config.setValue("name", valute.name);
    _config.setValue("engName", valute.engName);
    _config.setValue("id", valute.id);
    _config.setValue("imgPath", valute.imgPath);
    _config.endGroup();
}

bool Config::getChosenIsInit(bool isFromVal) {
    QString valGroup = isFromVal ? "ValuteFrom" : "ValuteTo";
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.beginGroup(valGroup);
    bool result = _config.value("imgPath").toBool();
    _config.endGroup();

    return result;
}

ValData Config::getChosenValute(bool isFromVal) {
    ValData valute;
    QString valGroup = isFromVal ? "ValuteFrom" : "ValuteTo";
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.beginGroup(valGroup);
    valute = ValData(_config.value("abbreviation").toString(), _config.value("symbol").toString(),
                     _config.value("name").toString(), _config.value("engName").toString(),
                     _config.value("id").toString(), _config.value("imgPath").toString());
    _config.endGroup();

    return valute;
}

void Config::clearChosenValutes() {
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");
    _config.remove("ValuteFrom");
    _config.remove("ValuteTo");
}

void Config::setLastRequestTime(QString time) {
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.beginGroup("GeneralSettings");
    _config.setValue("LastRequestTime", time);
    _config.endGroup();
}

QString Config::getLastRequestTime() {
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.beginGroup("GeneralSettings");
    QString time = _config.value("LastRequestTime").toString();
    _config.endGroup();

    return time;
}

// Добавление последних данных о курсах валют в конфиг
void Config::setLastExchangeRates(QVector<ExchangeRates> rates) {
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.remove("ValutesRates");
    _config.beginGroup("ValutesRates");
    _config.beginWriteArray("RatesArray");
    for (int i = 0; i < rates.size(); i++) {
        _config.setArrayIndex(i);
        _config.setValue("code", rates.at(i).code);
        _config.setValue("value", rates.at(i).value);
        _config.setValue("previous", rates.at(i).previous);
    }
    _config.endArray();
    _config.endGroup();
}

QVector<ExchangeRates> Config::getLastExchangeRates() {
    QVector<ExchangeRates> data;
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.beginGroup("ValutesRates");
    int size = _config.beginReadArray("RatesArray");
    for (int i = 0; i < size; i++) {
        _config.setArrayIndex(i);
        data << ExchangeRates(_config.value("code").toString(), _config.value("value").toReal(),
                              _config.value("previous").toReal());
    }
    _config.endArray();
    _config.endGroup();

    return data;
}

QVector<FavInfo> Config::getFavExchange() {
    QVector<FavInfo> data;
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.beginGroup("FavExchange");
    int size = _config.beginReadArray("FavArray");
    for (int i = 0; i < size; i++) {
        _config.setArrayIndex(i);
        data << FavInfo(_config.value("leftCode").toString(), _config.value("rightCode").toString());
    }
    _config.endArray();
    _config.endGroup();

    return data;
}

void Config::addFavExchange(FavInfo element, int index) {
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.beginGroup("FavExchange");
    _config.beginWriteArray("FavArray");

    _config.setArrayIndex(index);
    _config.setValue("leftCode", element.leftCode);
    _config.setValue("rightCode", element.rightCode);

    _config.endArray();
    _config.endGroup();
}

void Config::deleteFavExchange(QVector<FavInfo> newData) {
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.remove("FavExchange");
    _config.beginGroup("FavExchange");
    _config.beginWriteArray("FavArray");
    for (int i = 0; i < newData.size(); i++) {
        _config.setArrayIndex(i);
        _config.setValue("leftCode", newData.at(i).leftCode);
        _config.setValue("rightCode", newData.at(i).rightCode);
    }
    _config.endArray();
    _config.endGroup();
}

QMap<QString, bool> Config::getAppState() {
    QMap<QString, bool> appState;
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.beginGroup("GeneralSettings");
    appState.insert("saveLastRates", _config.value("saveLastRates").toBool());
    appState.insert("askBeforeRemovingFav", _config.value("askBeforeRemovingFav").toBool());
    appState.insert("isRussianLanguage", _config.value("isRussianLanguage").toBool());
    appState.insert("isAlternativeTheme", _config.value("isAlternativeTheme").toBool());
    _config.endGroup();

    return appState;
}

void Config::initAppStateInConfig(QMap<QString, bool> values) {
    QMap<QString, bool>::iterator valuesIt;
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.beginGroup("GeneralSettings");
    for (valuesIt = values.begin(); valuesIt != values.end(); valuesIt++) {
        _config.setValue(valuesIt.key(), valuesIt.value());
    }
    _config.endGroup();
}

void Config::setAppStateValue(QString key, bool value) {
    QSettings _config(_confName, QSettings::IniFormat);
    _config.setIniCodec("UTF-8");

    _config.beginGroup("GeneralSettings");
    _config.setValue(key, value);
    _config.endGroup();
}
