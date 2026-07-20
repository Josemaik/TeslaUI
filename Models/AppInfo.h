#ifndef APPINFO_H
#define APPINFO_H

#include <QString>
#include "AppTypes.h"

struct AppInfo
{
    AppTypes::App type;

    QString name;

    QString icon;

    QString qmlPath;
};


#endif // APPINFO_H

