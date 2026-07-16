#include "system.h"
#include <QDateTime>
#include <QDebug>

System::System(QObject *parent)
    : QObject{parent}
    , m_carLocked(true)
    , m_outdoorTemperature(64)
    , m_userName("Monty")
    , m_currentTime("12:34am")
{
    m_currentTimeTimer = new QTimer(this);
    m_currentTimeTimer->setInterval(500);
    m_currentTimeTimer->setSingleShot(true);

    connect(m_currentTimeTimer, &QTimer::timeout, this, &System::currentTimeTimerTimeOut); //callback

    currentTimeTimerTimeOut();
}

bool System::carLocked() const
{
    return m_carLocked;
}

void System::setcarLocked(bool newCarLocked)
{
    if (m_carLocked == newCarLocked)
        return;
    m_carLocked = newCarLocked;
    emit carLockedChanged();
}

int System::outdoorTemperature() const
{
    return m_outdoorTemperature;
}

void System::setOutdoorTemperature(int newOutdoorTemperature)
{
    if (m_outdoorTemperature == newOutdoorTemperature)
        return;
    m_outdoorTemperature = newOutdoorTemperature;
    emit outdoorTemperatureChanged();
}

QString System::userName() const
{
    return m_userName;
}

void System::setUserName(const QString &newUserName)
{
    if (m_userName == newUserName)
        return;
    m_userName = newUserName;
    emit userNameChanged();
}

QString System::currentTime() const
{
    return m_currentTime;
}

void System::setCurrentTime(const QString &newCurrentTime)
{
    if (m_currentTime == newCurrentTime)
        return;
    m_currentTime = newCurrentTime;
    emit currentTimeChanged();
}

void System::currentTimeTimerTimeOut()
{
    QDateTime dateTime;
    QString currentTime = dateTime.currentDateTime().toString("HH:mm ap");
    //qDebug() << currentTime;
    setCurrentTime(currentTime);

    m_currentTimeTimer->start();
};
