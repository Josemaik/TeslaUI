#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlEngine>

#include <Controllers/system.h>
#include <Controllers/hvachandler.h>
#include <Controllers/audiocontroller.h>
#include <Controllers/appcontroller.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    System systemHandler;

    HVACHandler driverHVACHandler;
    HVACHandler passengerHVACHandler;

    AudioController audioController;
    AppController appController;

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    qmlRegisterUncreatableType<AppController>(
        "TeslaUI", 1, 0,
        "AppController",
        "Enum only");

    QQmlContext* context(engine.rootContext());
    context->setContextProperty( "systemHandler", &systemHandler);
    context->setContextProperty( "driverHVAC", &driverHVACHandler);
    context->setContextProperty( "passengerHVAC", &passengerHVACHandler);
    context->setContextProperty( "audioController", &audioController);
    context->setContextProperty( "appController", &appController);

    engine.loadFromModule("TeslaUI", "Main");

    return QCoreApplication::exec();
}
