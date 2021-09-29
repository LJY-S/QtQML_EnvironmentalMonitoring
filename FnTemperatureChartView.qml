import QtQuick 2.9
import QtQuick.Controls 2.5
import QtCharts 2.3
import CustomCmpnt 1.0

Item{
    id:root

    property alias 下一个y坐标: id接口.下一个y坐标
    property alias 下一个y2坐标: id接口.下一个y2坐标
    property alias running: id接口.running
    property alias lineName:lines.name

    state: "stop"

    Item{
        visible: false
        id: id接口

        property double 下一个y坐标: 0
        property double 下一个y2坐标: 0
        property alias running: tm.running
    }

//    CustomFileReader{
//        id: cstFileRder
//        source: "./test"
//    }

    ChartView{
        id:cv
        property int zoomIndex: 0

        anchors.fill: parent
        antialiasing: true
        dropShadowEnabled: true
        theme: ChartView.ChartThemeDark
        animationOptions: ChartView.SeriesAnimations
        focus: true

        Label{  //缩放倍数标签
            x:18
            y:16
            text: "缩放倍数：" + parent.zoomIndex;
        }

        ValueAxis{  //x轴
            id:xAxis
            min: 0
            max: 10
            tickCount: 11
            labelFormat: "%d"
        }

        ValueAxis{  //y轴
            id:yAxis
            min: 0
            max: 100
            labelFormat: "%.1f"  // 保留1位小数
        }

        LineSeries {  //线系列
            id:lines

            name: "温度"
            axisX: xAxis
            axisY: yAxis
            pointsVisible: true
            pointLabelsVisible: true
            color: "deeppink"
            width: 3
            pointLabelsFormat: "@yPoint"
            pointLabelsFont{pixelSize: 16}
            pointLabelsColor: "#e2e1e4"
        }

        LineSeries {  //线系列
            id:id湿度线

            name: "湿度"
            axisX: xAxis
            axisY: yAxis
            pointsVisible: true
            pointLabelsVisible: true
            color: "aqua"
            width: 3
            pointLabelsFormat: "@yPoint"
            pointLabelsFont{pixelSize: 16}
        }

        Timer{  //定时器
            id:tm
            interval: 500
            repeat: true
            running: false

            property double 步进: interval / 1000 //interval单位为毫秒，/1000 则x每改变一次，增加inteerval秒
            property double 当前x: 0

            onTriggered: {
                当前x += 步进

                if(当前x > xAxis.max)
                {
                    xAxis.min = 当前x - 10;
                    xAxis.max = 当前x;
                }
                //cstFileRder.startRead();
                //lines.append(cv.timeClickCnt + 1, parseFloat(cstFileRder.dataReadIn).toFixed(1));
                lines.append(当前x + 步进, id接口.下一个y坐标.toFixed(1));
                id湿度线.append(当前x + 步进, id接口.下一个y2坐标.toFixed(1));

                if(lines.count > 1024)  //当点数量大于1024，清理内存
                {
                    cv.animationOptions = ChartView.NoAnimation
                    lines.removePoints(0, 1013);
                    cv.animationOptions = ChartView.SeriesAnimations
                }
            }
        }

        MouseArea{  //鼠标区域
            anchors.fill: parent
            onWheel: {
                if(wheel.modifiers & Qt.ControlModifier){
                    if(wheel.angleDelta.y < 0)
                    {
                        cv.zoomIndex--;
                        parent.zoomOut();
                    }
                    else
                    {
                        cv.zoomIndex++;
                        parent.zoomIn();
                    }
                    lines.width = 3 + cv.zoomIndex;
                    lines.pointLabelsFont.pixelSize = 16 + 4*cv.zoomIndex;
                }
            }
        }
    }

//    Keys.onUpPressed: cv.scrollUp(16);
//    Keys.onDownPressed: cv.scrollDown(16);
//    Keys.onLeftPressed: cv.scrollLeft(16);
//    Keys.onRightPressed: cv.scrollRight(16);

    Label{
        id: id图表运行停止标签

        anchors.right: root.right
        anchors.rightMargin: 16
        anchors.top: root.top
        anchors.topMargin: 16

        visible: false
        text: "图表运行停止，可能是服务器未接收到客户端连接"
        color: "red"
        font.pixelSize: 16
        font.bold: true
    }

    states:[
        State {
            name: "stop"
            PropertyChanges {
                target: id接口
                running: false
            }
            PropertyChanges {
                target: id图表运行停止标签
                visible: true
            }
        },
        State {
            name: "running"
            PropertyChanges {
                target: id接口
                running: true
            }
            PropertyChanges {
                target: id图表运行停止标签
                visible: false
            }
        }
    ]
}
