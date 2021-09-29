import QtQuick 2.9
import QtQuick.Controls 2.2
import QtWebSockets 1.1

Frame{
    id: root

    property alias defaultUrl: urlLbTF.textFieldText

    function sendMsg(msg){
        if(webSocket.status == WebSocket.Open)
        {
            webSocket.sendTextMessage(msg);
            sentMsgLbTF.textFieldColor = "springgreen"
        }
        else
        {
            ToolTip.show(sentMsgLbTF.readOnlyTip, sentMsgLbTF.toolTipTimeOut)
        }
    }

    states:[  //状态，用于改变组件是否可视
        State{
            name: "open"
            when: webSocket.status == WebSocket.Open
            PropertyChanges {
                target: sentMsgLbTF
                visible: true
            }
            PropertyChanges {
                target: sentMsgBtn
                visible: true
            }
        },

        State{
            name: "not open"
            when: webSocket.status != WebSocket.Open
            PropertyChanges {
                target: sentMsgLbTF
                visible: false
            }
            PropertyChanges {
                target: sentMsgBtn
                visible: false
            }
        }

    ]

    Grid{
        id: mainGrid
        columns: 1
        anchors.centerIn: parent
        horizontalItemAlignment: Grid.AlignHCenter
        spacing: 16

        Grid{  //显示客户端信息
            columns: 1

            CtLabelTextField{  //显示示例：url: ws://localhost:1999
                id: urlLbTF

                labelText: "url:"
                placeholderText: "url为空，请输入url"
                textFieldText: "ws://localhost:1999"  //设定url默认值
                readOnlyTip: "开始链接或链接已建立，此时无法改变url"  //设置当内容为readOnly而又受到单击时，要显示的内容，以ToolTip实现
            }
            Label{  //显示示例：状态：false。此状态标签将会被webSocket根据webSocket的状态改变标签颜色
                id: statusLb
                text: "状态：" + webSocket.statusStr
            }
            Label{
                text: "接收到的数据：" + webSocket.msgReceived
            }
            Label{
                id: errorLb
                text: "错误信息：" + webSocket.errorString;
            }
        }

        Switch{  //链接开关
            id: swch
            text: "开关连接"

            onCheckedChanged: {
                switch(checked)
                {
                case true:{
                    webSocket.active = true;
                    urlLbTF.readOnlyLock = true  //当开关打开，证明开始链接，此时不应再改变url
                    urlLbTF.readOnly = true  //保证readOnly为true
                    break;
                }
                case false:{
                    webSocket.active = false;
                    urlLbTF.readOnlyLock = false //当开关关闭，证明链接断开，则可以关闭lock，并将url设置回可编辑
                    urlLbTF.readOnly = false  //开关关闭，url变为可编辑状态
                    break;
                }
                }
            }
        }

        CtLabelTextField{  //显示示例：发送数据：
            id: sentMsgLbTF

            labelText: "信息发送:"
            placeholderText: "发送内容为空，请输入"
            textFieldText: "客户端发送测试"  //设定url默认值
            readOnlyTip: "客户端未链接，无法发送数据"  //设置当内容为readOnly而又受到单击时，要显示的内容，以ToolTip实现
            onPressed: {
                textFieldColor = "white"
            }
        }

        Button{  //发送数据按钮
            id: sentMsgBtn

            text: "发送"
            onClicked: sendMsg(sentMsgLbTF.textFieldText)
        }

        WebSocket {
           id: webSocket
           url: urlLbTF.textFieldText  // url表示目标的地址、端口、path和query这些，如 ws://localhost:1999
           //active: true // active表示开启这个连接，默认为false

           property string msgReceived: ""  //缓存接收到的信息（因为WebSocket类不提供）
           property string statusStr: statusToStr(status)  //将status枚举转换成str方便外部读取与显示

           function statusToStr(status){  //此函数将status枚举转换成str方便外部读取与显示
               switch(status){
               case WebSocket.Connecting:{return "Connecting"}
                  case WebSocket.Open:{return "Open"}
                  case WebSocket.Closing:{return "Closing"}
                  case WebSocket.Closed:{return "Closed"}
                  case WebSocket.Error:{return "Error"}
                  default:statusStr = undefined
               }
           }

           onStatusChanged: {
                                // 监听socket状态变化
                                switch(status)
                                {
                                    case WebSocket.Open:{
                                        // Open状态表示连接已经打开
                                        statusLb.color = "springgreen";
                                        break;
                                    }
                                    case WebSocket.Error:{
                                        statusLb.color = "red";
                                        errorLb.color = "red"
                                        swch.checked = false
                                        break;
                                    }
                                    case WebSocket.Connecting:{  //可以将此当做重新连接的，将上次的链接造成的影响重新初始化的状态
                                        statusLb.color = "deepskyblue";
                                        msgReceived = ""  //清空上次链接的数据接收缓存
                                        errorLb.color = "white"
                                        //不必清空错误信息，它会被WebSocket类自动清空
                                        break;
                                    }
                                    case WebSocket.Closing:{
                                        statusLb.color = "deepskyblue";
                                        break;
                                    }
                                    case WebSocket.Closed:{
                                        statusLb.color = "white";
                                        break;
                                    }
                                }
                            }

           onTextMessageReceived: {
              msgReceived = message
           }
           onBinaryMessageReceived: {
                msgReceived = message
           }
        }
    }
}

/*
        Label{
            id: label

            property string message: ""



            text: "url：" + webSocket.url
            + "\n是否激活：" + webSocket.active
            + "\n状态：" + statusToStr(webSocket.status)
            + "\n接收数据监听：" + message
            + "\n错误信息：" + webSocket.errorString

            Rectangle{
                anchors.centerIn: parent
                width: parent.width + 16
                height: parent.height + 16
                color: "white"
                //gradient: 10
                radius: 8
                opacity: 0.32
            }
        }
*/

/*
        ListView{
            id:lstV

            model: ListModel{
                ListElement{name: "url"
                    data: "webSocket.url"}
                ListElement{name: "是否激活"; data: webSocket.active}
                ListElement{name: "状态"; data: webSocket.statusStr}
                ListElement{name: "接收数据监听"; data: webSocket.msgReceived}
                ListElement{name: "是否激活"; data: webSocket.active}
            }

            delegate: Component{
                Label{
                    text: model.name + ":" + model.data
                }
            }
        }
*/
