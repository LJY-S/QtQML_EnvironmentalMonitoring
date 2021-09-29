#include "customxmlreader.h"

CustomXmlReader::CustomXmlReader(QObject *parent) : QObject(parent)
{
    //连接自身的setErrorOccurTrue槽函数到"errorStrChanged"信号
    connect(this, &CustomXmlReader::errorStrChanged, this, &CustomXmlReader::setErrorOccurTrue);
}

const QString &CustomXmlReader::getSource() const
{
    return source;
}

void CustomXmlReader::setSource(const QString &newSource)
{
    if (source == newSource)
        return;
    source = newSource;
    emit sourceChanged();
}

const QString &CustomXmlReader::getQueryStr() const
{
    return queryStr;
}

void CustomXmlReader::setQueryStr(const QString &newQueryStr)
{
    if (queryStr == newQueryStr)
        return;
    queryStr = newQueryStr;
    emit queryStrChanged();
}

const QStringList &CustomXmlReader::getResult() const
{
    return result;
}

void CustomXmlReader::setResult(const QStringList &newResult)
{
    if (result == newResult)
        return;
    result = newResult;
    emit resultChanged();
}

const QString &CustomXmlReader::getErrorStr() const
{
    return errorStr;
}

void CustomXmlReader::setErrorStr(const QString &newErrorStr)
{
    if (errorStr == newErrorStr)
        return;
    errorStr = newErrorStr;
    emit errorStrChanged();
}

bool CustomXmlReader::getErrorOccur() const
{
    return errorOccur;
}

void CustomXmlReader::setErrorOccur(bool newErrorOccur)
{
    if (errorOccur == newErrorOccur)
        return;
    errorOccur = newErrorOccur;
    emit errorOccurChanged();
}

void CustomXmlReader::setErrorOccurTrue()
{
    //此槽函数被连接到"errorStrChanged"信号，使得一旦有错误信息则更改errorOccur值
    setErrorOccur(true);
}

void CustomXmlReader::startRead()
{
    //所需类成员数据与解释：source
    //source：xml文件地址
    //queryStr：请求（串形式），标记目标元素，指目标数据在怎样的标签层次之下
    //errorStr：错误信息
    //result：QStringList类型，输出读取结果
    if(queryStr.isEmpty())
    {
        setErrorStr("请求串(queryStr)为空，请赋值请求串(queryStr)再申请读取文件");
        return;
    }
    errorStr = "";  //清空上次的错误信息，直接赋值不发出属性changed信号
    result.clear();  //清空上次的结果

    //处理传入参数：请求串，用List表示请求列表
    QStringList queryList = queryStr.split('/', Qt::SkipEmptyParts);  //将str格式的请求转换为List，忽略空字段，例："a/b//c" ->(QList("a", "b", "c"))
    //qDebug() << queryList;
    if(queryList.front() == queryStr)
    {
        //若List的第一个元素与queryStr完全相同，则请求串格式错误，无法读到“/”分隔符
        setErrorStr("请求串格式错误：请求串转换为list时，第一个元素与请求串完全相同，请至少带有一个“/”分隔符");
        return;
    }

    //开始处理xml文件
    QStack<QString> queryCurrt;  //用于 读取文档时 分析当前的标签所属的层次
    QFile testFile(source);  //选择xml文件，带有冒号表示此文件在qrc（qt资源文件）
    if (!testFile.open(QIODevice::ReadOnly | QIODevice::Text))  //打开方式：只读，text
    {
         setErrorStr(testFile.errorString());
         return;
    }
    QXmlStreamReader testReader(&testFile);  //建立xml读入流
    while (!testReader.atEnd())  //循环读入直到末尾
    {
        QXmlStreamReader::TokenType tkTyp = testReader.readNext(); //读入下一个，并记录读入的标签类型
        switch (tkTyp) {
        case QXmlStreamReader::StartElement:{  //当为元素开始标签
            QString elmtName = testReader.name().toString();
            if(queryCurrt.size() != queryList.size())  //如果当前层次数量大小 不等于 请求标签列表大小
            {
                if(queryList[queryCurrt.size()] == elmtName)  //通过当层次数量大小得到请求列表中的下一个请求标签，若读到的标签与下一个标签相同，则推入当前层次，并且break（下一个循环读取下一个标签）
                {
                    queryCurrt.push(elmtName);
                    break;
                }
                else  //如果读到的标签与下一个请求标签 不同
                {
                    //则直接忽略 读到的标签 与其孩子，brak并进行下一个循环。
                    //（执行完下面的readElementText函数后，当前标签会变为 执行前读到的标签 的 结束标签，则下一循环再readNext后，直接跳到下一个开始标签（不会读到结束标签），但标签所属的层次不变）
                    testReader.readElementText(QXmlStreamReader::SkipChildElements);
                    break;
                }
            }
            else  //如果当前层次数量大小 等于 请求标签列表大小
            {
                //等于的情况下，仍然进入到此处的开始标签处理，证明此处的目标元素所含的不是内容，仍然是标签，则继续在当前所属层次下进行跳转
                //（执行完下面的readElementText函数后，当前标签会变为 执行前读到的标签 的 结束标签，则下一循环再readNext后，跳到下一个开始标签（不会读到结束标签），但标签所属的层次不变）
                testReader.readElementText(QXmlStreamReader::SkipChildElements);
                break;
            }
        }
        case QXmlStreamReader::EndElement:{  //当为元素结束标签
            //遇到结束标签，当前层次结束，出栈，返回上一层次
            queryCurrt.pop();
            break;
        }
        case QXmlStreamReader::Characters:{  //当为元素内容
            if(!testReader.isWhitespace())  //当不为回车与空格，才为真正所需数据
            {
                result.push_back(testReader.text().toString());
                emit resultChanged();
            }
            break;
        }
        default:
            break;
        }

        if (testReader.error())
        {
            int errorLine = testReader.lineNumber();
            int errorColumn = testReader.columnNumber();
            int errorCrtOfs = testReader.characterOffset();
            errorStr = "错误信息: " + testReader.errorString() + "\n"
                     + "位置：行" + QString::number(errorLine) + "  列" + QString::number(errorColumn) + "  字符位移" + QString::number(errorCrtOfs);
            emit errorStrChanged();
            return;
        }
    }

    testFile.close();

    return;
}

//bool CustomXmlReader::errorIsEmpty()
//{
//    return errorStr.isEmpty();
//}

int CustomXmlReader::resultCnt()
{
    return result.count();
}

QVariant CustomXmlReader::getResult(int index)
{
    if(index > result.count() - 1)
    {
        setErrorStr("取result内容时出错：索引（index)超出范围");
        return QVariant();
    }
    else
    {
        return result[index];
    }
}

int CustomXmlReader::maxResult()
{
    if(result.count() == 0)
    {
        return 0;
    }

    QList<int> tmp;
    for(const QString &item: result)
    {
        tmp.append(item.toInt());
    }

    return *std::max_element(std::begin(tmp), std::end(tmp));
}
