#include <QGuiApplication>
#include <QLocale>
#include <QQmlApplicationEngine>
#include <QResource>
#include <QTranslator>
#include <QtSvg>

#include "ServerData/ExchangeRatesModel.hpp"
#include "ServerData/ValuteInfoModel.hpp"
#include "Share/AppState.hpp"
#include "Share/Config.hpp"
#include "Share/CppObjects.hpp"
#include "Share/ServerState.hpp"

int main(int argc, char *argv[]) {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    // Использование улучшенного рендеринга компонентов интерфейса
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    // Информационные "пометки" приложения
    QCoreApplication::setApplicationName("Converter");
    QCoreApplication::setApplicationVersion("v1.0.0");
    QCoreApplication::setOrganizationName("dg");
    QCoreApplication::setOrganizationDomain("ru");

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    Config config;
    ServerState serverState(config);

    AppState appState(app, engine, config);
    appState.getLastSettingsFromCache();

    FavouritesModel favouritesModel(config);
    favouritesModel.getSavedData();

    ValuteInfoModel valuteInfoModel(config, appState, serverState, favouritesModel);
    valuteInfoModel.sendServerRequest();

    ExchangeRatesModel exchangeRatesModel(config, appState, serverState);
    exchangeRatesModel.sendServerRequest();

    CppObjects cppObjects(appState, valuteInfoModel, exchangeRatesModel, favouritesModel, serverState, app);

    int appStart = EXIT_SUCCESS;

    static CppObjects *singleton_cppObjects = &cppObjects;
    {
        // Передача коллекции классов в QML
        qmlRegisterSingletonType<CppObjects>("ValCppObjects", 1, 0, "CppObjects",
            [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
                Q_UNUSED(engine)
                Q_UNUSED(scriptEngine)
                QQmlEngine::setObjectOwnership(singleton_cppObjects, QQmlEngine::CppOwnership);
                return singleton_cppObjects;
        });

        // Добавление к объекту приложения пути к элементам интерфейса
        engine.addImportPath(QStringLiteral("qrc:/"));
        const QUrl url(QStringLiteral("qrc:/MainWindow.qml"));

        // Обработка сигнала создания и подключения объекта интерфейса к объекту приложения
        QObject::connect(
            &engine, &QQmlApplicationEngine::objectCreated, &app,
            [url](QObject *obj, const QUrl &objUrl) {
                if (obj == nullptr && url == objUrl) {
                    qWarning("Some problem with qml");
                    QCoreApplication::exit(EXIT_FAILURE);
                }
            },
            Qt::QueuedConnection);

        engine.load(url);
        appStart = app.exec();
    }

    return appStart;
}
