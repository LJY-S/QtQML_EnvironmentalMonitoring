#ifndef CTFILEHANDLER_H
#define CTFILEHANDLER_H

#include <QObject>
#include <QFile>

class CtFileHandler : public QObject
{
    Q_OBJECT
public:
    explicit CtFileHandler(QObject *parent = nullptr);

    const QString &getSource() const;
    void setSource(const QString &newSource);

    const QByteArray &getDataInMemory() const;
    void setDataInMemory(const QByteArray &newDataInMemory);

    const QString &getErrorStr() const;
    void setErrorStr(const QString &newErrorStr);

    const QString &getTarget() const;
    void setTarget(const QString &newTarget);

signals:

    void sourceChanged();

    void dataInMemoryChanged();

    void errorStrChanged();

    void targetChanged();

private:
    QString source;  //要读取的源文件
    QString target;  //要写入的目标文件
    QByteArray dataInMemory;  //在内存中的数据
    QString errorStr;
    Q_PROPERTY(QString source READ getSource WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QByteArray dataInMemory READ getDataInMemory WRITE setDataInMemory NOTIFY dataInMemoryChanged)

    Q_PROPERTY(QString errorStr READ getErrorStr WRITE setErrorStr NOTIFY errorStrChanged)

    Q_PROPERTY(QString target READ getTarget WRITE setTarget NOTIFY targetChanged)

public slots:
    void funReadIntoMemory();
    void funWriteIntoFile();
};

#endif // CTFILEHANDLER_H
