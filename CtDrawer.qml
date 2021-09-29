import QtQuick 2.15
import QtQuick.Controls 2.15

CtDrawerWithBtn{
    id: id根

    property alias tabBar: tabBar

    TabBar{
        id: tabBar
        anchors.fill: parent

        TabButton{
            id: id首按钮

            text: "服务器"
            font.pixelSize: 20
            Image {
                anchors.right: parent.right  //靠右
                anchors.verticalCenter: parent.verticalCenter  //水平居中

                source: "qrc:DrawerIcon/ServerIcon"

                Component.onCompleted: {
                    var 缩放系数 = (parent.height * 0.8) / sourceSize.height  //以高为参考，计算原图的高和宽要乘以多少系数，以适应大小
                    sourceSize.width *= 缩放系数
                    sourceSize.height *= 缩放系数
                }
            }
        }
        TabButton{
            text: "温湿度图"
            font.pixelSize: 20
            Image {
                anchors.right: parent.right  //靠右
                anchors.verticalCenter: parent.verticalCenter  //水平居中

                source: "qrc:DrawerIcon/ChartIcon"

                Component.onCompleted: {
                    var 缩放系数 = (parent.height * 0.8) / sourceSize.height  //以高为参考，计算原图的高和宽要乘以多少系数，以适应大小
                    sourceSize.width *= 缩放系数
                    sourceSize.height *= 缩放系数
                }
            }
        }
        TabButton{
            text: "降雨量图"
            font.pixelSize: 20
            Image {
                anchors.right: parent.right  //靠右
                anchors.verticalCenter: parent.verticalCenter  //水平居中

                source: "qrc:DrawerIcon/ChartIcon"

                Component.onCompleted: {
                    var 缩放系数 = (parent.height * 0.8) / sourceSize.height  //以高为参考，计算原图的高和宽要乘以多少系数，以适应大小
                    sourceSize.width *= 缩放系数
                    sourceSize.height *= 缩放系数
                }
            }
        }
        TabButton{
            text: "气压温度图"
            font.pixelSize: 20
            Image {
                anchors.right: parent.right  //靠右
                anchors.verticalCenter: parent.verticalCenter  //水平居中

                source: "qrc:DrawerIcon/ChartIcon"

                Component.onCompleted: {
                    var 缩放系数 = (parent.height * 0.8) / sourceSize.height  //以高为参考，计算原图的高和宽要乘以多少系数，以适应大小
                    sourceSize.width *= 缩放系数
                    sourceSize.height *= 缩放系数
                }
            }
        }
        TabButton{
            text: "测试客户端"
            font.pixelSize: 20
        }
    }



    Component.onCompleted: {
        侧边栏展开距离 = id首按钮.height
    }

}

/*
    ListView{
        anchors.fill: parent
        model: listmodel
        delegate: Component{  //左边为名称，右边为图片
            TabButton{
                id: idRec

                height: idLabel.height
                width: id根.侧边栏展开距离

                Label{
                    id: idLabel
                    anchors.left: idRec.left
                    text: model.name
                    font.pixelSize: 24
                }


                MouseArea{
                    anchors.fill: idRec
                    onClicked: {
                        print(idRec.width)
                    }
                }
            }
        }
    }
*/

