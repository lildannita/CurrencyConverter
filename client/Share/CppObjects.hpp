#pragma once

#include <QGuiApplication>
#include <QObject>

#include "ServerData/ExchangeRatesModel.hpp"
#include "ServerData/FavouritesModel.hpp"
#include "ServerData/ValuteInfoModel.hpp"
#include "Share/AppState.hpp"
#include "Share/ServerState.hpp"
#include "qqml.h"

class CppObjects final : public QObject {
    Q_OBJECT

    Q_PROPERTY(AppState *appState MEMBER _appState CONSTANT FINAL)
    Q_PROPERTY(ValuteInfoModel *valuteInfoModel MEMBER _valuteInfoModel CONSTANT FINAL)
    Q_PROPERTY(ExchangeRatesModel *exchangeRatesModel MEMBER _exchangeRatesModel CONSTANT FINAL)
    Q_PROPERTY(FavouritesModel *favouritesModel MEMBER _favouritesModel CONSTANT FINAL)
    Q_PROPERTY(ServerState *serverState MEMBER _serverState CONSTANT FINAL)

    QML_ELEMENT
    QML_SINGLETON

public:
    CppObjects(AppState &appState, ValuteInfoModel &valuteInfoModel, ExchangeRatesModel &exchangeRatesModel,
               FavouritesModel &favouritesModel, ServerState &serverState, QGuiApplication &app,
               QObject *parent = nullptr)
        : QObject{parent},
          _app(&app),
          _appState(&appState),
          _valuteInfoModel(&valuteInfoModel),
          _exchangeRatesModel(&exchangeRatesModel),
          _favouritesModel(&favouritesModel),
          _serverState(&serverState){};

    Q_INVOKABLE void copyToClipBoard(QString value);

private:
    QPointer<QGuiApplication> _app;
    QPointer<AppState> _appState;
    QPointer<ValuteInfoModel> _valuteInfoModel;
    QPointer<ExchangeRatesModel> _exchangeRatesModel;
    QPointer<FavouritesModel> _favouritesModel;
    QPointer<ServerState> _serverState;
};
