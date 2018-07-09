TEMPLATE = app

QT += qml quick
QT += charts
CONFIG += c++11

SOURCES += main.cpp \
    myad.cpp \
    fft.cpp

RESOURCES += qml.qrc
RC_FILE=icon.rc
# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    icon.rc

HEADERS += \
    myad.h \
    fft.h
LIBS += -LE:\caocaocaocaocao\QT\chartmetarial1-hardware -lMP422E
