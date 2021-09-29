#include "ctxmldatahandler.h"


CtXMLDataHandler::CtXMLDataHandler(QObject *parent) : QObject(parent)
{
    setTarget("xmlData");
    setSource("D:/QtWork/build-PjTest-Desktop_Qt_6_2_0_MinGW_64_bit-Debug/xmlData");
    infoData["温度"] = "0";
    infoData["湿度"] = "0";
    infoData["降雨量"] = "0";
    infoData["检测到降雨"] = "0";
    infoData["气压"] = "0";
    infoData["温度2"] = "0";

    readAllTextData();
    qDebug() << "OK"   ;

}

const QString &CtXMLDataHandler::getErrorStr() const
{
    return errorStr;
}

void CtXMLDataHandler::setErrorStr(const QString &newErrorStr)
{
    if (errorStr == newErrorStr)
        return;
    errorStr = newErrorStr;
    emit errorStrChanged();
}

const QString &CtXMLDataHandler::getTarget() const
{
    return target;
}

void CtXMLDataHandler::setTarget(const QString &newTarget)
{
    if (target == newTarget)
        return;
    target = newTarget;
    emit targetChanged();
}

const QString &CtXMLDataHandler::getSource() const
{
    return source;
}

void CtXMLDataHandler::setSource(const QString &newSource)
{
    if (source == newSource)
        return;
    source = newSource;
    emit sourceChanged();
}

const QString &CtXMLDataHandler::getTextData() const
{
    return textData;
}

void CtXMLDataHandler::setTextData(const QString &newTextData)
{
    if (textData == newTextData)
        return;
    textData = newTextData;
    emit textDataChanged();
}

QString CtXMLDataHandler::getInfoDataValue(QString Key)
{
    return infoData.value(Key);
}

void CtXMLDataHandler::setInfoData(QString key, QString value)
{
    infoData[key] = value;

    return;
}




void CtXMLDataHandler::writeAllData()
{
    //打开文件或返回错误
    QFile xmlFile(getTarget());
    if(!xmlFile.open(QFile::WriteOnly))
    {
        setErrorStr(xmlFile.errorString());
    }

    //开始写XML数据
    QXmlStreamWriter outStream(&xmlFile);
    outStream.setAutoFormatting(true); //自动设置格式
    outStream.writeStartDocument();  //写入首行XML说明
    outStream.writeStartElement("DataPackge");  //写入根标签


    //先写infoData数据
    outStream.writeStartElement("infoData");
    QHash<QString, QString>::iterator it;
    for(it = infoData.begin(); it != infoData.end(); it++)
    {
        outStream.writeTextElement("", it.key(), it.value());
    }
    outStream.writeEndElement();

    outStream.writeEndElement();  //关闭根标签
    outStream.writeEndDocument();  //文件结束
    xmlFile.close();  //关闭文件
}

void CtXMLDataHandler::readAllData()
{
    CustomXmlReader reader;
    reader.setSource(source);

    //先读取infoData
    QString queryPrefix = "/DataPackge/infoData/";  //会和key组成完整的query
    QHash<QString, QString>::iterator it;
    for(it = infoData.begin(); it != infoData.end(); it++)
    {
        reader.setQueryStr(queryPrefix + it.key());
        reader.startRead();
        if(reader.getErrorStr() != "")  //出错处理
        {
            setErrorStr(reader.getErrorStr());
            return;
        }
        else  //正常情况下读入值
        {
            infoData[it.key()] = reader.getResult().front();  //由于xml文件中可能存在多个符合要求的结果，但这是不应该出现的。这里取第一个结果
        }
    }

}

void CtXMLDataHandler::readAllTextData()
{
    //打开文件或返回错误，只读
    QFile sourceFile(getSource());
    if(!sourceFile.open(QFile::ReadOnly))
    {
        setErrorStr(sourceFile.errorString());
    }

    //用文本流读取所有数据
    QTextStream inStream(&sourceFile);
    setTextData(inStream.readAll());

    //检查内容，如果读取数据为空，报错
    if(textData == "")
    {
        setErrorStr("读取所有文本内容时，得到结果为空，请检查textData成员");
        return;
    }

    sourceFile.close();
    return;
}

void CtXMLDataHandler::writeAllTextData()
{
    //先检查要写入的数据是否为空，若为空，报错
    if(textData == "")
    {
        setErrorStr("写入所有文本内容时，没有数据用于写入，请检查textData成员");
        return;
    }

    //打开文件或返回错误，只写
    QFile targetFile(getTarget());
    if(!targetFile.open(QFile::WriteOnly))
    {
        setErrorStr(targetFile.errorString());
    }

    //用文本流写入
    QTextStream outStream(&targetFile);
    outStream << textData;

    targetFile.close();
    return;
}
