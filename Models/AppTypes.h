#ifndef APPTYPES_H
#define APPTYPES_H

#include <QObject>
#include <cstdint>

class AppTypes : public QObject
{
    Q_OBJECT
public:
    enum App : uint8_t{
        Map = 0,
        Spotify = 1,
        Phone = 2,
        Camera = 3,
        Theater = 4,
        Arcade = 5
    };
    Q_ENUM(App)
};

#endif // APPTYPES_H
