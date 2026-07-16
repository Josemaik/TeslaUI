#ifndef SYSTEM_H
#define SYSTEM_H

#include <QObject>
#include <QTimer>

class System : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool carLocked READ carLocked WRITE setcarLocked NOTIFY carLockedChanged)
    Q_PROPERTY(int outdoorTemperature READ outdoorTemperature WRITE setOutdoorTemperature NOTIFY outdoorTemperatureChanged)
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged FINAL)
    Q_PROPERTY(QString currentTime READ currentTime WRITE setCurrentTime NOTIFY currentTimeChanged FINAL)

public:
    explicit System(QObject *parent = nullptr);

    bool carLocked() const;

    int outdoorTemperature() const;

    QString userName() const;

    QString currentTime() const;

public slots:
    Q_INVOKABLE void setcarLocked(bool newCarLocked);

    void setOutdoorTemperature(int newOutdoorTemperature);

    void setUserName(const QString &newUserName);

    void setCurrentTime(const QString &newCurrentTime);

    void currentTimeTimerTimeOut();


signals:
    void carLockedChanged();
    void outdoorTemperatureChanged();

    void userNameChanged();

    void currentTimeChanged();

private:
    bool m_carLocked;
    int m_outdoorTemperature;
    QString m_userName;
    QString m_currentTime;
    QTimer* m_currentTimeTimer;
};

#endif // SYSTEM_H
