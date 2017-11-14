TARGET = dashboard
QT = quickcontrols2

SOURCES = main.cpp

CONFIG += link_pkgconfig
PKGCONFIG += libhomescreen qlibwindowmanager

RESOURCES += \
    dashboard.qrc \
    images/images.qrc

include(app.pri)
