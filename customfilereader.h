#ifndef CUSTOMFILEREADER_H
#define CUSTOMFILEREADER_H

#include <QObject>
#include <QFile>
#include <QTextStream>

class CustomFileReader : public QObject
{
    Q_OBJECT
public:
    explicit CustomFileReader(QObject *parent = nullptr);

    const QString &getSource() const;
    void setSource(const QString &newSource);

    const QString &getDataReadIn() const;
    void setDataReadIn(const QString &newDataReadIn);

    const QString &getErrorStr() const;
    void setErrorStr(const QString &newErrorStr);

    bool getErrorOccur() const;

    void setErrorOccur(bool newErrorOccur);

signals:

    void sourceChanged();

    void dataReadInChanged();

    void errorStrChanged();

    void errorOccurChanged();

private:
    QString source;
    QString dataReadIn;
    QString errorStr;
    bool errorOccur;
    Q_PROPERTY(QString source READ getSource WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString dataReadIn READ getDataReadIn WRITE setDataReadIn NOTIFY dataReadInChanged)
    Q_PROPERTY(QString errorStr READ getErrorStr WRITE setErrorStr NOTIFY errorStrChanged)

    Q_PROPERTY(bool errorOccur READ getErrorOccur WRITE setErrorOccur NOTIFY errorOccurChanged)

private slots:
    void setErrorOccurTrue();  //此槽函数被连接到"errorStrChanged"信号

public slots:
    void startRead();
};

#endif // CUSTOMFILEREADER_H
