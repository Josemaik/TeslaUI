#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <Controllers/system.h>
#include <Controllers/hvachandler.h>
#include <Controllers/audiocontroller.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    System systemHandler;

    HVACHandler driverHVACHandler;
    HVACHandler passengerHVACHandler;

    AudioController audioController;

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    QQmlContext* context(engine.rootContext());
    context->setContextProperty( "systemHandler", &systemHandler);
    context->setContextProperty( "driverHVAC", &driverHVACHandler);
    context->setContextProperty( "passengerHVAC", &passengerHVACHandler);
    context->setContextProperty( "audioController", &audioController);

    engine.loadFromModule("TeslaUI", "Main");

    return QCoreApplication::exec();
}
