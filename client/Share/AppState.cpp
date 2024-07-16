#include "AppState.hpp"

#include <QTouchDevice>

// Проверка наличия сенсорного экрана
bool is_touch_screen_avaible() {
    bool result = false;
    const auto devices = QTouchDevice::devices();
    for (const auto &device : devices) {
        qInfo() << "touch device: " << device->name() << ", type: " << device->type();
        if (device->type() == QTouchDevice::TouchScreen) {
            result = true;
        }
    }
    qInfo() << "Has touch screen: " << result;
    return result;
}

AppState::AppState(QGuiApplication &app, QQmlApplicationEngine &engine, Config &config,
                   QObject *parent) noexcept
    : QObject(parent),
      hasTouchScreen_(is_touch_screen_avaible()),
      _app(&app),
      _engine(&engine),
      _config(&config),
      _saveLastRates(true),
      _askBeforeRemovingFav(true),
      _isRussianLanguage(true),
      _isAlternativeTheme(false) {
    _isTranslatorAvailible = _translator.load(":/i18n/client_en_US");
}

bool AppState::isLinux() noexcept {
#if defined(__linux__) && !(defined(__ANDROID__) || defined(ANDROID))
    return true;
#else
    return false;
#endif
}

bool AppState::isAndroid() noexcept {
#ifdef Q_OS_ANDROID
    return true;
#else
    return false;
#endif
}

// Получение последних настроек приложения
void AppState::getLastSettingsFromCache() {
    QMap<QString, bool> values;
    bool isConfigAvailiable = _config->checkConfigGeneralSettings();

    if (isConfigAvailiable) {
        values = _config->getAppState();

        _saveLastRates = values.value("saveLastRates");
        emit saveLastRatesChanged();
        _askBeforeRemovingFav = values.value("askBeforeRemovingFav");
        emit askBeforeRemovingFavChanged();
        _isRussianLanguage = values.value("isRussianLanguage");
        translateApp();
        emit isRussianLanguageChanged();
        _isAlternativeTheme = values.value("isAlternativeTheme");
        emit isAlternativeThemeChanged();
    } else {
        values.insert("saveLastRates", _saveLastRates);
        values.insert("askBeforeRemovingFav", _askBeforeRemovingFav);
        values.insert("isRussianLanguage", _isRussianLanguage);
        values.insert("isAlternativeTheme", _isAlternativeTheme);

        _config->initAppStateInConfig(values);
    }
}

// Установка последних выбранных валют в ini-файл
void AppState::setSaveLastRates(bool value) {
    _saveLastRates = value;
    _config->setAppStateValue("saveLastRates", _saveLastRates);
    emit saveLastRatesChanged();
}

// Установка настроек в ini-файл
void AppState::setAskBeforeRemovingFav(bool value) {
    _askBeforeRemovingFav = value;
    _config->setAppStateValue("askBeforeRemovingFav", _askBeforeRemovingFav);
    emit askBeforeRemovingFavChanged();
}

void AppState::setIsRussianLanguage(bool value) {
    if (!_isTranslatorAvailible) {
        _isRussianLanguage = true;
        return;
    }

    _isRussianLanguage = value;
    _config->setAppStateValue("isRussianLanguage", _isRussianLanguage);

    translateApp();

    emit isRussianLanguageChanged();
}

void AppState::translateApp() {
    if (_isRussianLanguage) {
        _app->removeTranslator(&_translator);
        _engine->retranslate();
    } else {
        _app->installTranslator(&_translator);
        _engine->retranslate();
    }
}

void AppState::setIsAlternativeTheme(bool value) {
    _isAlternativeTheme = value;
    _config->setAppStateValue("isAlternativeTheme", _isAlternativeTheme);
    emit isAlternativeThemeChanged();
}
