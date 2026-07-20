#include "appcontroller.h"


AppController::AppController(QObject *parent)
    : QObject{parent}
    ,m_currentApp(AppTypes::App::Map)
{

}

void AppController::selectApp(AppTypes::App app)
{
    if(m_currentApp == app)
        return;

    m_currentApp = app;
    emit currentAppChanged();
}


AppTypes::App AppController::currentApp() const
{
    return m_currentApp;
}
