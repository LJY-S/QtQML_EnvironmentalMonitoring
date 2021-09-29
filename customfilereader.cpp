#include "customfilereader.h"

CustomFileReader::CustomFileReader(QObject *parent) : QObject(parent)
{
    //连接自身的setErrorOccurTrue槽函数到"errorStrChanged"信号
    connect(this, &CustomFileReader::errorStrChanged, this, &CustomFileReader::setErrorOccurTrue);
}

const QString &CustomFileReader::getSource() const
{
    return source;
}

void CustomFileReader::setSource(const QString &newSource)
{
    if (source == newSource)
        return;
    source = newSource;
    emit sourceChanged();
}

const QString &CustomFileReader::getDataReadIn() const
{
    return dataReadIn;
}

void CustomFileReader::setDataReadIn(const QString &newDataReadIn)
{
    if (dataReadIn == newDataReadIn)
        return;
    dataReadIn = newDataReadIn;
    emit dataReadInChanged();
}

const QString &CustomFileReader::getErrorStr() const
{
    return errorStr;
}

void CustomFileReader::setErrorStr(const QString &newErrorStr)
{
    if (errorStr == newErrorStr)
        return;
    errorStr = newErrorStr;
    emit errorStrChanged();
}

bool CustomFileReader::getErrorOccur() const
{
    return errorOccur;
}

void CustomFileReader::setErrorOccur(bool newErrorOccur)
{
    if (errorOccur == newErrorOccur)
        return;
    errorOccur = newErrorOccur;
    emit errorOccurChanged();
}

void CustomFileReader::setErrorOccurTrue()
{
    //此槽函数被连接到"errorStrChanged"信号，使得一旦有错误信息则更改errorOccur值
    setErrorOccur(true);
}

void CustomFileReader::startRead()
{
    dataReadIn = "";
    if(source.isEmpty())
    {
        setErrorStr("源路径串（source）为空，请先赋值源路径串");
        return;
    }
    QFile sourceFile(source);  //选择文件，带有冒号表示此文件在qrc（qt资源文件）
    if (!sourceFile.open(QIODevice::ReadOnly | QIODevice::Text))  //打开方式：只读，text
    {
         setErrorStr(sourceFile.errorString());
         return;
    }
    QTextStream readStrm(&sourceFile);
    readStrm >> dataReadIn;
    if(dataReadIn.isEmpty())
    {
        setErrorStr("读取了空白文件，没有获得数据，dataReadIn为空");
        return;
    }
    else
    {
        emit dataReadInChanged();
        return;
    }
}
