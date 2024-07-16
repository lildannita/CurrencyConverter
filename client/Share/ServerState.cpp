#include "ServerState.hpp"

ServerState::ServerState(Config &config, QObject *parent)
    : QObject(parent), _connectionMsg(""), _cacheMsg(""), _config(&config) {}

// Обработка информации о получении данных о валютах
void ServerState::setValutesState(ServerInfo valutesState) {
    _valutesState = valutesState;
    _isValutesStateInit = true;
    tryToMakeErrorExp();
}

// Обработка информации о получении данных о курсах валют
void ServerState::setRatesState(ServerInfo ratesState) {
    _ratesState = ratesState;
    _isRatesStateInit = true;
    tryToMakeErrorExp();
}

// Обработка полученной информации и формирование сообщения
void ServerState::tryToMakeErrorExp() {
    if (!_isRatesStateInit || !_isValutesStateInit) return;

    _connectionMsg.clear();

    if (!_ratesState.internet || !_valutesState.internet)
        _connectionMsg = QString(tr("Проблема с подключением к серверу!"));
    else if (!_ratesState.cbr || !_valutesState.cbr)
        _connectionMsg = QString(tr("Проблема с подключением к Центральному банку России!"));
    else if (!_ratesState.data || !_valutesState.data)
        _connectionMsg = QString(tr("Проблема с получением данных с сервера!"));

    if (_connectionMsg.length() != 0) {
        if (!_ratesState.config || !_valutesState.config)
            _cacheMsg =
                QString(tr("Сохраненные данные не найдены.\nДля получения данных проверьте соединение с "
                           "Интернетом или попробуйте обновить позже."));
        else
            _cacheMsg =
                QString(tr("Найдены сохраненные данные.\nДля получения актуальных данных проверьте "
                           "соединение с Интернетом или попробуйте обновить позже."));

        emit errorMsgIsReady(_connectionMsg, _cacheMsg);
    }
}
