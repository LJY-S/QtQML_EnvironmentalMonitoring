import QtQuick 2.15
import QtQuick.Controls 2.15

Item{
    id: id根

    property alias p文本: id错误信息文本.text
    property alias p字体大小: id错误信息文本.font.pixelSize

    z: 1  //覆盖默认层
    anchors.fill: parent  //覆盖父组件

    Rectangle{  //错误信息弹出，半透明白屏幕覆盖屏幕覆盖
        id: id错误信息弹出
        anchors.fill: parent
        visible: true
        color: "#80FFFFFF"  //半透明白色

        Rectangle{  //错误文本背景
            width: id错误信息文本.width + 16
            height: id错误信息文本.height + 16
            radius: 8
            gradient: 76
            anchors.centerIn: parent
            Label{
                id: id错误信息文本
                anchors.centerIn: parent
                text: "错误文本"
                font.pixelSize: 32
            }
        }

        RoundButton{  //关闭按钮
            id: id关闭按钮
            anchors.top: id错误信息文本.parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.rightMargin: 12
            width: 64
            height: 64
            text: "X"
            font.pixelSize: width / 2
            font.bold: true

            onClicked: {
                id根.visible = false
            }
        }
    }
}

