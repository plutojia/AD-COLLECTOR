#include <QApplication>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QMetaObject>
#include <QDebug>
#include <QVariant>
#include <QVector>
#include "myad.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<myad>("jia.qt.MyAD",1,0,"MyAD");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    QObject *root=NULL;
    QList<QObject*> rootObjects=engine.rootObjects();
    for(int i=0;i<rootObjects.size();i++){
        if(rootObjects.at(i)->objectName()=="rootObject"){
            root=rootObjects.at(i);
            qDebug()<<"root getted";
            break;
        }
    }
    myad *ad=root->findChild<myad*>("myad");
    ad->setRoot(root);
    return app.exec();
}
