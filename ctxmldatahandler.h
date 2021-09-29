#ifndef CTXMLDATAHANDLER_H
#define CTXMLDATAHANDLER_H

#include<QObject>
#include<QHash>
#include<QXmlStreamWriter>
#include<QFile>
#include"customxmlreader.h"

class CtXMLDataHandler : public QObject
{
    Q_OBJECT
public:
    explicit CtXMLDataHandler(QObject *parent = nullptr);

    const QString &getErrorStr() const;
    void setErrorStr(const QString &newErrorStr);

    const QString &getTarget() const;
    void setTarget(const QString &newTarget);

    const QString &getSource() const;
    void setSource(const QString &newSource);

    const QString &getTextData() const;
    void setTextData(const QString &newTextData);

signals:

    void errorStrChanged();

    void targetChanged();

    void sourceChanged();

    void textDataChanged();

private:
    QHash<QString, QString> infoData;  //由XML文件读取来的键值对
    QString errorStr;  //错误信息
    QString target;  //XML写入目标
    QString source;  //XML读取目标
    QString textData; //文件文本数据

    Q_PROPERTY(QString errorStr READ getErrorStr WRITE setErrorStr NOTIFY errorStrChanged)

    Q_PROPERTY(QString target READ getTarget WRITE setTarget NOTIFY targetChanged)

    Q_PROPERTY(QString source READ getSource WRITE setSource NOTIFY sourceChanged)

    Q_PROPERTY(QString textData READ getTextData WRITE setTextData NOTIFY textDataChanged)

public slots:
    QString getInfoDataValue(QString Key);
    void setInfoData(QString key, QString value);
    void writeAllData();
    void readAllData();
    void readAllTextData();
    void writeAllTextData();
};

#endif // CTXMLDATAHANDLER_H
