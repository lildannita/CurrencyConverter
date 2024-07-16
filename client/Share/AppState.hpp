#pragma once

#include "Share/Config.hpp"

#include <QGuiApplication>
#include <QObject>
#include <QPointer>
#include <QQmlApplicationEngine>
#include <QTranslator>

class AppState final : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isLinux READ isLinux CONSTANT FINAL)
    Q_PROPERTY(bool isAndroid READ isAndroid CONSTANT FINAL)
    Q_PROPERTY(bool saveLastRates READ saveLastRates NOTIFY saveLastRatesChanged)
    Q_PROPERTY(bool askBeforeRemovingFav READ askBeforeRemovingFav NOTIFY askBeforeRemovingFavChanged)
    Q_PROPERTY(bool isRussianLanguage READ isRussianLanguage NOTIFY isRussianLanguageChanged)
    Q_PROPERTY(bool isAlternativeTheme READ isAlternativeTheme NOTIFY isAlternativeThemeChanged)

signals:
    void saveLastRatesChanged();
    void askBeforeRemovingFavChanged();
    void isRussianLanguageChanged();
    void isAlternativeThemeChanged();

public:
    AppState(QGuiApplication &app, QQmlApplicationEngine &engine, Config &config,
             QObject *parent = nullptr) noexcept;
    static bool isLinux() noexcept;
    static bool isAndroid() noexcept;

    bool saveLastRates() { return _saveLastRates; }
    bool askBeforeRemovingFav() { return _askBeforeRemovingFav; }
    bool isRussianLanguage() { return _isRussianLanguage; }
    bool isAlternativeTheme() { return _isAlternativeTheme; }

    Q_INVOKABLE void setSaveLastRates(bool value);
    Q_INVOKABLE void setAskBeforeRemovingFav(bool value);
    Q_INVOKABLE void setIsRussianLanguage(bool value);
    Q_INVOKABLE void setIsAlternativeTheme(bool value);

    void getLastSettingsFromCache();

private:
    const bool hasTouchScreen_;

    QPointer<QGuiApplication> _app;
    QPointer<QQmlApplicationEngine> _engine;
    QPointer<Config> _config;
    QTranslator _translator;

    void translateApp();
    bool _isTranslatorAvailible;

    bool _saveLastRates;
    bool _askBeforeRemovingFav;
    bool _isRussianLanguage;
    bool _isAlternativeTheme;
};
