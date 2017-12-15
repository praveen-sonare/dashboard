TARGET = dashboard
QT = quick

HEADERS += \
    translator.h

SOURCES = main.cpp \
    translator.cpp

CONFIG += link_pkgconfig
PKGCONFIG += libhomescreen qlibwindowmanager

RESOURCES += \
    dashboard.qrc \
    images/images.qrc

include(app.pri)

LANGUAGES = ja_JP fr_FR zh_CN
include(translations.pri)
