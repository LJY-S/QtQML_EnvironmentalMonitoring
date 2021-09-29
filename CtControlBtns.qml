import QtQuick 2.15
import QtQuick.Controls 2.15

Item{
    id: id根

    signal leftClicked;
    signal upClicked;
    signal rightClicked;
    signal downClicked;
    signal plusClicked;
    signal minusClicked;

    height: 64
    width: height / 3 * 4

    Button{
        id: id上按钮
        anchors.left: id根.left
        anchors.leftMargin: height
        anchors.top: id根.top

        height:id根.height / 3
        width: height
        text: "↑"
        font.pixelSize: height / 2
        font.bold: true

        autoRepeat: true
    }
    Button{
        id: id下按钮
        anchors.left: id根.left
        anchors.leftMargin: height
        anchors.top: id根.top
        anchors.topMargin: height * 2

        height:id根.height / 3
        width: height
        text: "↓"
        font.pixelSize: height / 2
        font.bold: true

        autoRepeat: true
    }
    Button{
        id: id左按钮
        anchors.left: id根.left
        anchors.top: id根.top
        anchors.topMargin: height

        height:id根.height / 3
        width: height
        text: "←"
        font.pixelSize: height / 2
        font.bold: true

        autoRepeat: true
    }
    Button{
        id: id右按钮
        anchors.left: id根.left
        anchors.leftMargin: 2 * height
        anchors.top: id根.top
        anchors.topMargin: height

        height:id根.height / 3
        width: height
        text: "→"
        font.pixelSize: height / 2
        font.bold: true

        autoRepeat: true
    }
    Button{
        id: id加按钮
        anchors.left: id根.left
        anchors.leftMargin: 3 * height
        anchors.top: id根.top

        height:id根.height / 3
        width: height
        text: "+"
        font.pixelSize: height / 2
        font.bold: true

        autoRepeat: true
    }
    Button{
        id: id减按钮
        anchors.left: id根.left
        anchors.leftMargin: 3 * height
        anchors.top: id根.top
        anchors.topMargin: 2 * height

        height:id根.height / 3
        width: height
        text: "-"
        font.pixelSize: height / 2
        font.bold: true

        autoRepeat: true
    }

    Component.onCompleted: {
        id上按钮.clicked.connect(upClicked)
        id下按钮.clicked.connect(downClicked)
        id左按钮.clicked.connect(leftClicked)
        id右按钮.clicked.connect(rightClicked)
        id加按钮.clicked.connect(plusClicked)
        id减按钮.clicked.connect(minusClicked)
    }
}
