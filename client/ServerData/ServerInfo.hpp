#pragma once

#include <QString>

struct ValData {
    ValData() {}
    ValData(const QString& _abbreviation, const QString& _symbol, const QString& _name,
            const QString& _engName, const QString& _id, const QString& _imgPath)
        : abbreviation(_abbreviation),
          symbol(_symbol),
          name(_name),
          engName(_engName),
          id(_id),
          imgPath(_imgPath) {}
    bool operator==(ValData data) const {
        return (data.abbreviation == this->abbreviation && data.id == this->id);
    }
    QString abbreviation;
    QString symbol;
    QString name;
    QString engName;
    QString id;
    QString imgPath;
};

struct ExchangeRates {
    ExchangeRates() {}
    ExchangeRates(const QString& _code, const qreal& _value, const qreal& _previous)
        : code(_code), value(_value), previous(_previous) {}
    QString code;
    qreal value;
    qreal previous;
};

struct BaseData {
    BaseData() {}
    BaseData(const QString& _abbreviation, const QString& _symbol, const QString& _name,
             const QString& _engName)
        : abbreviation(_abbreviation), symbol(_symbol), name(_name), engName(_engName) {}
    QString abbreviation;
    QString symbol;
    QString name;
    QString engName;
};

struct FavInfo {
    FavInfo() {}
    FavInfo(const QString& _leftCode, const QString& _rightCode)
        : leftCode(_leftCode), rightCode(_rightCode) {}
    bool operator==(FavInfo data) const {
        return (data.leftCode == this->leftCode && data.rightCode == this->rightCode);
    }
    QString leftCode;
    QString rightCode;
};

struct ServerInfo {
    ServerInfo() : internet(false), cbr(false), data(false), config(false) {}
    ServerInfo(bool _internet, bool _cbr, bool _data, bool _config)
        : internet(_internet), cbr(_cbr), data(_data), config(_config) {}
    bool internet;
    bool cbr;
    bool data;
    bool config;
};
