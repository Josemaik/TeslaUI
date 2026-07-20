#ifndef APPLISTMODEL_H
#define APPLISTMODEL_H

#include <QAbstractListModel>
#include <QVector>

#include "AppInfo.h"


class AppListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles
   {
       TypeRole = Qt::UserRole,
       NameRole,
       IconRole,
       QmlPathRole
   };

   explicit AppListModel(QObject *parent = nullptr);

   int rowCount(const QModelIndex &parent = QModelIndex()) const override;

   QVariant data(const QModelIndex &index,
                 int role = Qt::DisplayRole) const override;

   Q_INVOKABLE QString qmlPath(AppTypes::App app) const;
protected:

    QHash<int, QByteArray> roleNames() const override;
private:

    void initializeApps();

    QVector<AppInfo> m_apps;
};

#endif // APPLISTMODEL_H
