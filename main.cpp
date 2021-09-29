#include <QApplication>
#include <QQmlApplicationEngine>
#include "ctxmldatahandler.h"
#include "customfilereader.h"
#include "ctfilehandler.h"


int main(int argc, char *argv[])
{
    //注册QML类型
    //qmlRegisterType<CustomFileReader>("CustomCmpnt", 1, 0, "CustomFileReader");
    qmlRegisterType<CtXMLDataHandler>("CustomCmpnt", 1, 0, "CtXMLDataHandler");
    qmlRegisterType<CtFileHandler>("CustomCmpnt", 1, 0, "CtFileHandler");

    #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    #endif

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();

    return 0;
}


