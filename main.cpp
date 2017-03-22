#include <Magick++.h>

#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "unsplash.h"
#include "photo.h"

using namespace Magick;

int main(int argc, char *argv[])
{
    InitializeMagick(*argv);

    QGuiApplication app(argc, argv);

    // Use Flat UI style
    qputenv("QT_QUICK_CONTROLS_1_STYLE", "Flat");

    // Register C++ class in QML
    qmlRegisterType<Unsplash>("Unwallpaper", 1, 0, "Unsplash");
    qmlRegisterType<Photo>("Unwallpaper", 1, 0, "PhotoModel");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
