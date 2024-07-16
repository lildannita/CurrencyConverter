#pragma once

#include <QString>
#include <QUrl>

extern const QString &SERVER_ADDRESS;
extern const QUrl &VALUTE_INFO_REQUEST;
extern const QUrl &LAST_EXCHANGE_RATES;

class CurrencyPeriod {
public:
    CurrencyPeriod() { _startOfRequest = QString(SERVER_ADDRESS + QString("getData/currencyPeriod?")); };

    QUrl periodExchangeRates(QString leftDate, QString rightDate, QString valuteId) {
        _resultRequest = QUrl(_startOfRequest + QString("left_date=") + leftDate + QString("&right_date=") +
                              rightDate + QString("&valute=") + valuteId);
        return _resultRequest;
    }

    QUrl getLastRequest() { return _resultRequest; }

private:
    QUrl _resultRequest;
    QString _startOfRequest;
};
