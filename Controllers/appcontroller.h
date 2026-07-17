#ifndef APPCONTROLLER_H
#define APPCONTROLLER_H

#include <QObject>

class AppController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(App currentApp READ currentApp NOTIFY currentAppChanged FINAL)
public:
    enum App {
        Map,
        Spotify,
        Phone,
        Camera,
        Theater,
        Arcade
    };
    Q_ENUM(App)

    explicit AppController(QObject *parent = nullptr);

    App currentApp() const;

    Q_INVOKABLE void selectApp(App app);

signals:

    void currentAppChanged();
private:
    App m_currentApp;
};

#endif // APPCONTROLLER_H
