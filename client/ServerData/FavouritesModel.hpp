#pragma once

#include <QAbstractListModel>
#include <QByteArray>
#include <QPointer>
#include <QString>
#include <QVector>

#include "Share/Config.hpp"

class FavouritesModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(bool isExchangeFav READ isExchangeFav NOTIFY isExchangeFavChanged FINAL)

signals:
    void isExchangeFavChanged();

public:
    enum Roles {
        LeftCodeRole = Qt::UserRole,
        RightCodeRole
    };

    FavouritesModel(Config& config, QObject* parent = nullptr);

    bool isExchangeFav() { return _isExchangeFav; }

    int rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void getSavedData();
    void setCurrentExchange(FavInfo currentExchange);

    Q_INVOKABLE void addFavValute();
    Q_INVOKABLE void deleteFavValute();
    Q_INVOKABLE void deleteFavValute(QString leftCode, QString rightCode);

private:
    QVector<FavInfo> _data;
    QPointer<Config> _config;
    FavInfo _currentExchange;
    bool _isExchangeInit;
    bool _isExchangeFav;
};
