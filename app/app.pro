TARGET = dashboard
QT = quick aglextras

HEADERS += \
    translator.h

SOURCES = main.cpp \
    translator.cpp

CONFIG += link_pkgconfig
PKGCONFIG += qtappfw-signal-composer

CONFIG(release, debug|release) {
    QMAKE_POST_LINK = $(STRIP) --strip-unneeded $(TARGET)
}

RESOURCES += \
    dashboard.qrc \
    images/images.qrc

include(app.pri)

LANGUAGES = ja_JP fr_FR zh_CN
include(translations.pri)
