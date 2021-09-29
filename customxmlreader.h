#ifndef CUSTOMXMLREADER_H
#define CUSTOMXMLREADER_H

#include <QObject>
#include <QtQml/qqmlregistration.h>
#include <QStack>
#include <QFile>
#include <QXmlStreamReader>
#include <QVariant>

class CustomXmlReader : public QObject
{
    Q_OBJECT

public:
    explicit CustomXmlReader(QObject *parent = nullptr);

    const QString &getSource() const;
    void setSource(const QString &newSource);

    const QString &getQueryStr() const;
    void setQueryStr(const QString &newQueryStr);

    const QStringList &getResult() const;
    void setResult(const QStringList &newResult);

    const QString &getErrorStr() const;
    void setErrorStr(const QString &newErrorStr);

    bool getErrorOccur() const;
    void setErrorOccur(bool newErrorOccur);

signals:

    void sourceChanged();

    void queryStrChanged();

    void resultChanged();

    void errorStrChanged();

    void errorOccurChanged();

private:
    QString source;
    QString queryStr;
    QStringList result;
    QString errorStr;
    bool errorOccur;
    Q_PROPERTY(QString source READ getSource WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString queryStr READ getQueryStr WRITE setQueryStr NOTIFY queryStrChanged)
    Q_PROPERTY(QStringList result READ getResult WRITE setResult NOTIFY resultChanged)
    Q_PROPERTY(QString errorStr READ getErrorStr WRITE setErrorStr NOTIFY errorStrChanged)
    Q_PROPERTY(bool errorOccur READ getErrorOccur WRITE setErrorOccur NOTIFY errorOccurChanged)

private slots:
    void setErrorOccurTrue();  //此槽函数被连接到"errorStrChanged"信号

public slots:
    void startRead();
//    bool errorIsEmpty();
    int resultCnt();
    QVariant getResult(int index);
    int maxResult();
};

#endif // CUSTOMXMLREADER_H
