QT += quick network gui svg

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        ServerData/FavouritesModel.cpp \
        ServerData/ServerRequests.cpp \
        ServerData/ValuteInfoModel.cpp \
        ServerData/ExchangeRatesModel.cpp \
        Share/Config.cpp \
        Share/CppObjects.cpp \
        Share/AppState.cpp \
        Share/ServerState.cpp \
        main.cpp

RESOURCES += \
        qml.qrc \
        Resources/resources.qrc

TRANSLATIONS += \
    client_en_US.ts
CONFIG += lrelease
CONFIG += embed_translations

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += .

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    ServerData/FavouritesModel.hpp \
    ServerData/ValuteInfoModel.hpp \
    ServerData/ExchangeRatesModel.hpp \
    Share/Config.hpp \
    Share/CppObjects.hpp \
    Share/AppState.hpp \
    ServerData/ServerInfo.hpp \
    ServerData/ServerRequests.hpp \
    Share/ServerState.hpp

