#include "ctfilehandler.h"

CtFileHandler::CtFileHandler(QObject *parent) : QObject(parent)
{

}

const QString &CtFileHandler::getSource() const
{
    return source;
}

void CtFileHandler::setSource(const QString &newSource)
{
    if (source == newSource)
        return;
    source = newSource;
    emit sourceChanged();
}

const QByteArray &CtFileHandler::getDataInMemory() const
{
    return dataInMemory;
}

void CtFileHandler::setDataInMemory(const QByteArray &newDataInMemory)
{
    if (dataInMemory == newDataInMemory)
        return;
    dataInMemory = newDataInMemory;
    emit dataInMemoryChanged();
}

const QString &CtFileHandler::getErrorStr() const
{
    return errorStr;
}

void CtFileHandler::setErrorStr(const QString &newErrorStr)
{
    if (errorStr == newErrorStr)
        return;
    errorStr = newErrorStr;
    emit errorStrChanged();
}

const QString &CtFileHandler::getTarget() const
{
    return target;
}

void CtFileHandler::setTarget(const QString &newTarget)
{
    if (target == newTarget)
        return;
    target = newTarget;
    emit targetChanged();
}

void CtFileHandler::funReadIntoMemory()
{
    errorStr = "";  //清空上次错误信息
    QFile file(source);
    if(!file.open(QIODevice::ReadOnly))
    {
        setErrorStr(file.errorString());
        file.close();
        return;
    }
    dataInMemory = file.readAll();
    if(dataInMemory.size() == 0)
    {
        setErrorStr("读入了空文件");
        file.close();
        return;
    }
    file.close();
    return;
}

void CtFileHandler::funWriteIntoFile()
{
    errorStr = "";  //清空上次错误信息
    QFile file(target);
    if(!file.open(QIODevice::WriteOnly))
    {
        setErrorStr(file.errorString());
        file.close();
        return;
    }
    file.write(dataInMemory);

    //写入空数据相当于清文件，故不需要报错
    file.close();
}
