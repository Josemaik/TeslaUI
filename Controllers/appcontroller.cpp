#include "appcontroller.h"


AppController::AppController(QObject *parent)
    : QObject{parent}
    ,m_currentApp(Map)
{

}

void AppController::selectApp(App app)
{
    if(m_currentApp == app)
        return;

    m_currentApp = app;
    emit currentAppChanged();
}

AppController::App AppController::currentApp() const
{
    return m_currentApp;
}
