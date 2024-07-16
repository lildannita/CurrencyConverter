#pragma once

#include <QAbstractListModel>
#include <QByteArray>
#include <QDateTime>
#include <QMap>
#include <QPointer>
#include <QString>
#include <QVariant>
#include <QVector>
#include <QtNetwork/QNetworkAccessManager>

#include "FavouritesModel.hpp"
#include "ServerInfo.hpp"
#include "Share/AppState.hpp"
#include "Share/Config.hpp"
#include "Share/ServerState.hpp"

class ValuteInfoModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(QString time READ time NOTIFY timeChanged FINAL)
    Q_PROPERTY(bool loadingDone READ loadingDone NOTIFY loadingDoneChanged FINAL)

signals:
    void timeChanged();
    void loadingDoneChanged();
    void lastChosenValutesSetFromCache(bool isFromInit, bool isToInit);
    void valutesSetFromFavList();

public:
    enum Roles {
        AbbreviationRole = Qt::UserRole,
        SymbolRole,
        NameRole,
        EngNameRole,
        IdRole,
        ImgPathRole
    };

    ValuteInfoModel(Config &config, AppState &appState, ServerState &serverState,
                    FavouritesModel &favouritesModel, QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    bool loadingDone() { return _loadingDone; }
    QString time() { return _time; }

    Q_INVOKABLE void sendServerRequest();
    Q_INVOKABLE void sortDataByRequest(QString request);
    Q_INVOKABLE void backToOriginalData();

    Q_INVOKABLE QString getImgPathOfFavouriteValute(QString valCode);
    Q_INVOKABLE void searchValuteById(QString request, bool isFromVal);
    Q_INVOKABLE QString getImgPathOfSearchedValute(bool isFromVal);
    Q_INVOKABLE QString getAbbrOfSearchedValute(bool isFromVal);
    Q_INVOKABLE void swapValutes();

    Q_INVOKABLE void setFavValutes(QString leftCode, QString rightCode);

private slots:
    void getDataFromServer();

private:
    QMap<QString, QVariant> _serverData;
    ServerInfo _connection;
    BaseData _base;
    QVector<ValData> _data;
    QVector<ValData> _originalData;
    ValData _fromValute;
    bool _isFromInit;
    ValData _toValute;
    bool _isToInit;
    QString _time;

    QNetworkAccessManager *_manager;
    bool _loadingDone;

    QString getIconPath(const QString &code);
    void searchValuteByCode(QString request, bool isFromVal);
    void searchValute(QString request, bool isFromVal, bool isCode);
    QString _defaultIconPath;

    QPointer<Config> _config;
    QPointer<AppState> _appState;
    QPointer<ServerState> _serverState;
    QPointer<FavouritesModel> _favouriteModel;
    void getDataFromCache();
    void initLastChoices();
};
