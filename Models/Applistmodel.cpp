#include "Applistmodel.h"

AppListModel::AppListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    initializeApps();
}

void AppListModel::initializeApps()
{
    // Lo rellenaremos después
    m_apps = {
            {
                AppTypes::App::Spotify,
                "Spotify",
                "qrc:/assets/spotifyIcon.png",
                "../Apps/SpotifyView.qml"
            },
            {
                AppTypes::App::Phone,
                "Phone",
                "qrc:/assets/phoneIcon.png",
                "../Apps/PhoneListView.qml"
            },
            {
                AppTypes::App::Map,
                "Map",
                "qrc:/assets/MapIcon.png",
                "../Apps/MapView.qml"
            },
            {
                AppTypes::App::Camera,
                "Camera",
                "qrc:/assets/cameraIcon.png",
                "../Apps/CameraView.qml"
            },
            {
                AppTypes::App::Theater,
                "Theater",
                "qrc:/assets/MultimediaIcon.png",
                "../Apps/TheaterView.qml"
            },
            {
                AppTypes::App::Arcade,
                "Arcade",
                "qrc:/assets/arcadeIcon.jpg",
                "../Apps/ArcadeView.qml"
            }
        };
}

int AppListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_apps.size();
}

QVariant AppListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return {};

    const AppInfo &app = m_apps[index.row()];

    switch (role)
    {
    case TypeRole:
        return QVariant::fromValue(app.type);

    case NameRole:
        return app.name;

    case IconRole:
        return app.icon;

    case QmlPathRole:
        return app.qmlPath;

    default:
        return {};
    }
}

QString AppListModel::qmlPath(AppTypes::App app) const
{
    for (const AppInfo &info : m_apps)
    {
        if (info.type == app)
        {
            return info.qmlPath;
        }
    }

    return {};
}

QHash<int, QByteArray> AppListModel::roleNames() const
{
    return {
        { TypeRole, "type" },
        { NameRole, "name" },
        { IconRole, "icon" },
        { QmlPathRole, "qmlPath" }
    };
}