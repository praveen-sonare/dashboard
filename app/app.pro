TEMPLATE = app
TARGET = dashboard
QT = qml quick
CONFIG += c++11 link_pkgconfig

PKGCONFIG += qtappfw-vehicle-signals

HEADERS += \
    translator.h

SOURCES = \
    main.cpp \
    translator.cpp

RESOURCES += \
    dashboard.qrc \
    images/images.qrc

LANGUAGES = ja_JP fr_FR zh_CN ko_KR
include(translations.pri)

target.path = /usr/bin
target.files += $${OUT_PWD}/$${TARGET}
target.CONFIG = no_check_exist executable

INSTALLS += target
