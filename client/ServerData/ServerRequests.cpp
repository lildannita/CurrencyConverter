#include "ServerRequests.hpp"

const QString &SERVER_ADDRESS = QString("http://localhost:8081/");
const QUrl &VALUTE_INFO_REQUEST = QUrl(SERVER_ADDRESS + QString("getData/valuteInfo"));
const QUrl &LAST_EXCHANGE_RATES = QUrl(SERVER_ADDRESS + QString("getData/lastExchangeRates"));
