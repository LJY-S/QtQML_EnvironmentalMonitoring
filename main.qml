import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebSockets 1.1
import CustomCmpnt 1.0

//ApplicationWindow {
//    id: id根窗口

//    width: 640
//    height: 480
//    visible: true
//    title: qsTr("Scroll")

//    Grid{
//        id: idGrid
//        anchors.centerIn: parent
//        spacing: 8

//        columns: 2
//        rows: 2
//        horizontalItemAlignment: Grid.AlignHCenter

//        Image {
//            id: idSourceImg
//            source: "./testSourceImg.png"
//        }

//        Image {
//            id: idTargetImg
//            source: "./testTargetImg.png"
//        }

//        Button{
//            text: "read"
//            onClicked: {
//                id文件处理对象.funReadIntoMemory()
//            }
//        }

//        Button{
//            text: "write"
//            onClicked: {
//                id文件处理对象.funWriteIntoFile()
//            }
//        }

//    }

//    Label{
//        text: "错误信息：" + id文件处理对象.errorStr
//        font.pixelSize: 32
//    }

//    CtFileHandler{
//        id: id文件处理对象
//        source: "testSourceImg.png"
//        target: "testTargetImg.png"
//    }

//}

ApplicationWindow {
    id: id根窗口

    width: 1000
    height: 480
    visible: true
    title: qsTr("Scroll")

    Item{
        id: id接口
        visible: false

        property double p温度: 0
        property double p湿度: 0
        property double p降雨量: 0
        property int p检测到降雨: 0
        property int p气压: 0
        property int p温度2: 0



        function fun从Xml数据处理对象刷新数据(){
            p温度 = idXml数据处理对象.getInfoDataValue("温度")
            p湿度 = idXml数据处理对象.getInfoDataValue("湿度")
            p降雨量 = idXml数据处理对象.getInfoDataValue("降雨量")
            p检测到降雨 = idXml数据处理对象.getInfoDataValue("检测到降雨")
            p气压 = idXml数据处理对象.getInfoDataValue("气压")
            p温度2 = idXml数据处理对象.getInfoDataValue("温度2")
        }

        //以下是状态相关函数，只应做函数操作与状态赋值，不应作普通赋值赋值
        function fun到未开启监听(){
            state = "未开启监听"
        }
        function fun到已开启监听但无连接(){
            state = "已开启监听但无连接"
        }
        function fun到已开启监听且有连接(){
            state = "已开启监听且有连接"
        }

        states:[
            State{
                name: "未开启监听"
                PropertyChanges {
                    target: id服务器
                    state: "未开启监听"
                }
                PropertyChanges {
                    target: id温湿度表
                    p移动开启: false
                }
                PropertyChanges {
                    target: id降雨量表
                    p移动开启: false
                }
                PropertyChanges {
                    target: id气压温度表
                    p移动开启: false
                }
            },
            State{
                name: "已开启监听但无连接"
                PropertyChanges {
                    target: id服务器
                    state: "已开启监听但无连接"
                }
                PropertyChanges {
                    target: id温湿度表
                    p移动开启: true
                }
                PropertyChanges {
                    target: id降雨量表
                    p移动开启: true
                }
                PropertyChanges {
                    target: id气压温度表
                    p移动开启: true
                }
            },
            State{
                name: "已开启监听且有连接"
                PropertyChanges {
                    target: id服务器
                    state: "已开启监听且有连接"
                }
                PropertyChanges {
                    target: id温湿度表
                    p移动开启: true
                }
                PropertyChanges {
                    target: id降雨量表
                    p移动开启: true
                }
                PropertyChanges {
                    target: id气压温度表
                    p移动开启: true
                }
            }
        ]
    }

    SwipeView {  //滑动界面
        id: idSwipeView
        anchors.fill: parent
        currentIndex: idCtDrawer.tabBar.currentIndex

        Item{  //服务器
            FnWSServer{
                id: id服务器
                anchors.centerIn: parent
                //defaultHost: "172.18.138.106"
                defaultHost: "127.0.0.1"
                defaultPort: "1999"

                onTextFromClientChanged: {
                    //通过idXml数据处理对象将xml数据写入文件，并从xml文件中提取各种信息
//                    idXml数据处理对象.writeAllTextData();
//                    idXml数据处理对象.readAllData();
                    id接口.fun从Xml数据处理对象刷新数据();
                }

                onSnClicked: {
                    textFromClient = idXml数据处理对象.textData
                    idXml数据处理对象.readAllData();
                    id接口.fun从Xml数据处理对象刷新数据();
                }

                onStateChanged: function(state){
                    switch(state){
                    case "未开启监听":{id接口.fun到未开启监听(); break;}
                    case "已开启监听但无连接":{id接口.fun到已开启监听但无连接(); break;}
                    case "已开启监听且有连接":{id接口.fun到已开启监听且有连接(); break;}
                    }
                }
            }
        }

        CtMovingChartView2{
            id: id温湿度表
            线1名: "温度"
            线1颜色: "red"
            点_新y1坐标: id接口.p温度
            线2名: "湿度"
            线2颜色: "deepskyblue"
            点_新y2坐标: id接口.p湿度
        }

        CtMovingChartView{
            id: id降雨量表
            点_新y坐标: id接口.p降雨量
            线名: "降雨量"
            线颜色: id接口.p检测到降雨 == 1? "aqua" : "white"
        }

        CtMovingChartView2{
            id: id气压温度表
            线1名: "气压"
            线1颜色: "white"
            y1轴_起始:300
            y1轴_初始跨度: 110000 - 300
            点_新y1坐标: id接口.p气压
            线2名: "温度"
            线2颜色: "red"
            点_新y2坐标: id接口.p温度2

        }

        WSClient{
            defaultUrl: "127.0.0.1:1999"
        }

    }

    CtDrawer{  //下方栏
        id: idCtDrawer
        tabBar.currentIndex: idSwipeView.currentIndex
    }

    CtXMLDataHandler{  //Xml数据处理对象
        id: idXml数据处理对象
        //source: "xmlData"  //读取来源
        target: "xmlData"  //存储目标
    }

    Component.onCompleted: {  //初始化窗口
        id接口.fun到未开启监听();
    }

}
