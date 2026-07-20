#ifndef APPCONTROLLER_H
#define APPCONTROLLER_H

#include <QObject>
#include "../Models/AppTypes.h"

class AppController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(AppTypes::App currentApp READ currentApp NOTIFY currentAppChanged FINAL)
public:


    explicit AppController(QObject *parent = nullptr);

    AppTypes::App currentApp() const;

    Q_INVOKABLE void selectApp(AppTypes::App app);

signals:

    void currentAppChanged();
private:
    AppTypes::App m_currentApp;
};

#endif // APPCONTROLLER_H
