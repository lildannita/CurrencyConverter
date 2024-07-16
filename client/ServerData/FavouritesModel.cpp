#include "FavouritesModel.hpp"

FavouritesModel::FavouritesModel(Config &config, QObject *parent)
    : QAbstractListModel(parent), _config(&config), _isExchangeInit(false), _isExchangeFav(false) {}

int FavouritesModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) return 0;
    return _data.count();
}

QVariant FavouritesModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid()) return QVariant();

    const FavInfo &data = _data.at(index.row());
    switch (role) {
        case LeftCodeRole:
            return data.leftCode;
        case RightCodeRole:
            return data.rightCode;
        default:
            return QVariant();
    }
}

QHash<int, QByteArray> FavouritesModel::roleNames() const {
    static QHash<int, QByteArray> mapping{
        { LeftCodeRole, "leftCode" },
        { RightCodeRole, "rightCode" }
    };
    return mapping;
}

void FavouritesModel::setCurrentExchange(FavInfo currentExchange) {
    _currentExchange = currentExchange;
    _isExchangeInit = true;

    _isExchangeFav = _data.contains(_currentExchange);
    emit isExchangeFavChanged();
}

void FavouritesModel::getSavedData() {
    beginResetModel();
    _data = _config->getFavExchange();
    endResetModel();
}

void FavouritesModel::addFavValute() {
    if (!_isExchangeInit || _data.contains(_currentExchange)) return;

    beginInsertRows(QModelIndex(), _data.size(), _data.size());
    _data.append(_currentExchange);
    endInsertRows();

    _config->addFavExchange(_currentExchange, _data.size() - 1);

    _isExchangeFav = true;
    emit isExchangeFavChanged();
}

void FavouritesModel::deleteFavValute() {
    if (!_isExchangeInit || !_data.contains(_currentExchange)) return;

    int index = 0;
    for (int i = 0; i < _data.size(); i++)
        if (_data.at(i) == _currentExchange) {
            index = i;
            break;
        }

    beginRemoveRows(QModelIndex(), index, index);
    _data.remove(index);
    endRemoveRows();

    _config->deleteFavExchange(_data);

    _isExchangeFav = false;
    emit isExchangeFavChanged();
}

void FavouritesModel::deleteFavValute(QString leftCode, QString rightCode) {
    FavInfo delItem(leftCode, rightCode);
    if (!_data.contains(delItem)) return;

    int index = 0;
    for (int i = 0; i < _data.size(); i++)
        if (_data.at(i) == delItem) {
            index = i;
            break;
        }

    beginRemoveRows(QModelIndex(), index, index);
    _data.remove(index);
    endRemoveRows();

    _config->deleteFavExchange(_data);

    if (delItem == _currentExchange) {
        _isExchangeFav = false;
        emit isExchangeFavChanged();
    }
}
