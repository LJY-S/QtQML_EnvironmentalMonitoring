import QtQuick 2.9
import QtQuick.Controls 2.5
import QtWebSockets 1.1

//Pane{
    Grid{
        id: id根

        property alias defaultHost: id接口.defaultHost
        property alias defaultPort: id接口.defaultPort
        property alias textFromClient: id接口.textFromClient

        signal snClientConnected;
        signal snClicked;

        columns: 1
        horizontalItemAlignment: Grid.AlignHCenter

        Item{
            id: id接口

            property string defaultHost: "127.0.0.1"  //默认host
            property string defaultPort: "1999"  //默认port
            property string textFromClient: ""  //存储客户端发来的信息
            property WebSocket 客户端链接: null  //存储接收到的客户端链接
            property int msgCnt: 0  //存储接收到信息的次数

            signal snTextMessageReceived(string message);  //接收到信息发出信号

            onSnTextMessageReceived: function(message){  //处理客户端发来的文本信息
                msgCnt++;
                textFromClient = message
                msgLb.color = "springgreen" 
            }
        }

        Grid{  //显示服务器信息
            columns: 1

            Grid{ //编辑与显示url，以host和port分别显示
                CtLabelTextField{  //显示host
                    id: hostLbTF

                    textFieldWidth: 150
                    labelText: "host:"
                    placeholderText: "host为空，请输入"
                    textFieldText: defaultHost  //设定url默认值，为127.0.0.1，即localhost
                    readOnlyTip: "服务器已启动，此时无法改变url"  //设置当内容为readOnly而又受到单击时，要显示的内容，以ToolTip实现
                }
                CtLabelTextField{  //显示port
                    id: portLbTF

                    textFieldWidth: 50
                    labelText: "port:"
                    placeholderText: "port为空，请输入"
                    textFieldText: defaultPort  //设定port默认值
                    readOnlyTip: "服务器已启动，此时无法改变port"  //设置当内容为readOnly而又受到单击时，要显示的内容，以ToolTip实现
                }
            }
            Label{  //直接显示url
                text: "url: " + wSS.url
            }
            Label{  //显示服务器名
                text: "服务器名：" + wSS.name
            }
            Label{  //显示监听是否开启。此状态标签将会被webSocket根据webSocket的状态改变标签颜色
                id: listenLb
                text: "监听开启：" + wSS.listen
            }
            Label{  //显示接收到的信息
                id: msgLb
                text: {
                    if(wSS.clientConnected)//当WebSocketServer有收到客户端链接
                    {
                        return "接收到的信息：" + id接口.textFromClient
                    }
                    else
                    {
                        return "接收到的信息：" + "未连接客户端"
                    }
                }
            }
            Label{  //显示错误信息
                id: errorLb
                text: "错误信息：" + wSS.errorString
            }
        }

        Switch{  //监听开关
            id: swch
            text: "监听开关"

            onCheckedChanged: {
                id根.snClicked();
                switch(checked)
                {
                case true:{
                    wSS.listen = true;
                    hostLbTF.readOnlyLock = true  //当开关打开，证明开始链接，此时不应再改变url的host
                    hostLbTF.readOnly = true  //保证readOnly为true
                    portLbTF.readOnlyLock = true  //url的port同上
                    portLbTF.readOnly = true
                    id根.state = "已开启监听但无连接"
                    break;
                }
                case false:{
                    wSS.listen = false;
                    hostLbTF.readOnlyLock = false //当开关关闭，证明链接断开，则可以关闭lock，并将url的host设置回可编辑
                    hostLbTF.readOnly = false  //开关关闭，url的host变为可编辑状态
                    portLbTF.readOnlyLock = false //port同上
                    portLbTF.readOnly = false
                    id根.state = "未开启监听"
                    break;
                }
                }
            }
        }

        WebSocketServer {
           id: wSS

//           function  comingMsgReceived(message){  //处理客户端发来的文本信息
//               textFromClient = message
//               msgLb.color = "springgreen"
//           }

           host: hostLbTF.textFieldText //服务器host，默认值为127.0.0.1
           port: portLbTF.textFieldText  //监听的端口号，范围必须为0-65535.
           //listen: true  // 是否开启监听
           //accept: true  //当accept为true，且当listen也为true时，服务器会接收从客户端过来的链接。若设置为false，过来的链接会被拒绝。默认值为true
           name: "testServer"  //http握手阶段服务器使用的名字
           //(只读)url:  // url表示次服务器的的地址、端口、path和query。客户端WebSocket可以连接到的服务器url。url使用ws://模式（开头），包括服务器侦听的端口和服务器的主机地址


           onClientConnected:(webSocket)=>{  //当收到客户端链接，将链接对象存下来，并将对象的信号进行绑定
                                 id接口.客户端链接 = webSocket
                                 webSocket.textMessageReceived.connect(id接口.snTextMessageReceived);
                                 id根.state = "已开启监听且有连接"
                             }

           onListenChanged: {  //检查客户端状态，改变显示数据
               if(wSS.listen == true)
               {
                   listenLb.color = "springgreen"
               }
               else
               {
                   listenLb.color = "white"
                   msgLb.color = "white"
               }
           }
        }

        Component.onCompleted: {  //暴露内部信号
            wSS.clientConnected.connect(snClientConnected);
        }

        states:[
            State{
                name: "已开启监听但无连接"
            },
            State{
                name: "未开启监听"
            },
            State{
                name: "已开启监听且有连接"
            }
        ]

    }
//}
