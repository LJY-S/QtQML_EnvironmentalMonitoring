import QtQuick 2.9
import QtQuick.Controls 2.5
import QtCharts 2.3
import CustomCmpnt 1.0

ChartView{
    id:id根

    property alias 移动间隔_毫秒: id定时器.interval
    property alias p移动开启: id接口.p移动开启

    //关于x轴的属性，初始示例为：x轴每单位是1秒，3000毫秒移动一次，故每次移动0.5格。x轴一开始显示60个单位的数据（即1分钟）
    property alias x轴_移动间隔_毫秒: id接口.x轴_移动间隔_毫秒  //表示隔多少毫秒移动一次
    property alias x轴_单位大小_毫秒: id接口.x轴_单位时间_毫秒 //表示x轴1单位等于多少秒
    property alias x轴_步进: id接口.x轴_步进  //由 移动间隔_毫秒/单位时间_毫秒 得出，表示每次移动前进多少个单位
    property alias x轴_初始跨度: id接口.x轴_初始跨度  //表示x轴一开始显示多少个单位

    //关于y轴的属性
    property alias y轴_初始跨度: id接口.y轴_初始跨度

    //关于线属性
    property alias 线名: id线.name
    property alias 线颜色: id线.color

    //关于点属性
    property alias 点_新y坐标: id接口.点_新y坐标  //下一个点的y坐标，直接由外部给出

    Item{
        id: id接口
        visible: false

        property int 缩放倍数: 0  //缩放倍数
        property bool p移动开启: false

        //关于x轴的属性，初始示例为：x轴每单位是1秒，1秒移动一次，故每次移动1/1=1格。x轴一开始显示15个单位的数据，即1秒*15=15秒的数据
        //示例2：x轴每单位是5秒，3秒移动一次，故每次移动3/5=0.6格。x轴一开始显示12个单位的数据，即5秒*12=60秒，即x轴一开始显示60秒内的数据
        property alias x轴_移动间隔_毫秒: id定时器.interval  //表示隔多少毫秒移动一次
        property int x轴_单位时间_毫秒: 1000  //表示x轴1单位等于多少秒
        property double x轴_步进: 移动间隔_毫秒 / x轴_单位时间_毫秒  //由 移动间隔_毫秒/单位时间_毫秒 得出，表示每次移动前进多少个单位
        property int x轴_初始跨度: 15  //表示x轴一开始显示多少个单位

        //关于y轴的属性
        property int y轴_初始跨度: 100

        //关于点属性
        property double 点_x坐标: 0  //当前最新的一个点的x坐标，用于与步进计算新的点x坐标
        property double 点_新y坐标: 0  //下一个点的y坐标，直接由外部给出

        function fun定时器触发(){
            //每触发一次，新加一个点，新点x坐标由步进得出，y坐标由外部给出
            点_x坐标 += x轴_步进
            id线.append(点_x坐标, 点_新y坐标)

            //当新家的点在图表之外，图表才进行移动，右边界移动到当前点的x坐标。由于要保持x轴显示单位数量，所以先把当前x轴的长度存下来
            if(点_x坐标 > idx轴.max)
            {
                var x轴长度 = idx轴.max - idx轴.min
                idx轴.max = 点_x坐标;
                idx轴.min = 点_x坐标 - x轴长度;
            }
        }

        onP移动开启Changed: {
            //设置错误弹出是否可见，当图表运行时自动消失
            if(p移动开启)
            {
                id错误信息弹出.visible = false
            }
            else
            {
                id错误信息弹出.visible = true
            }
        }
    }

    antialiasing: true
    dropShadowEnabled: true
    theme: ChartView.ChartThemeDark
    animationOptions: ChartView.SeriesAnimations

    Label{  //缩放倍数标签
        //右上角对齐
        anchors.top: id根.top; anchors.topMargin: 16
        anchors.right: id根.right; anchors.rightMargin: 18

        text: "缩放倍数：" + id接口.缩放倍数;
    }

    ValueAxis{  //x轴
        id: idx轴
        min: 0
        max: id接口.x轴_初始跨度
        tickCount: 10
        //tickType: ValueAxis.TicksDynamic
        //tickAnchor: 0
        //tickInterval: ((max - min) / (10 * id接口.x轴_步进)).toFixed(0) * id接口.x轴_步进  //设xlenght = max - min，a为步进，若每x个步进画一条线，使得最后取整为10条线。则有：xlenght / ax = 10，解得x = xlenght / 10a，取整后再乘以步进，使得每条线都穿过点
        labelFormat: "%d"
    }

    ValueAxis{  //y轴
        id:idy轴
        min: 0
        max: id接口.y轴_初始跨度
        labelFormat: "%.1f"  // 保留1位小数
    }

    LineSeries {  //线系列
        id:id线

        name: "未命名"
        axisX: idx轴
        axisY: idy轴
        pointsVisible: true
        pointLabelsVisible: true
        color: "white"
        width: 3
        pointLabelsFormat: "@yPoint"
        pointLabelsFont{pixelSize: 12}

        Component.onCompleted: {
            append(0, 0);
        }
    }

    Timer{  //定时器，用于图图表循环移动
        id: id定时器
        interval: 1000
        repeat: true
        running: id接口.p移动开启

        onTriggered: {
            id接口.fun定时器触发()
        }
    }

    Button{  //popUp弹出按钮
        id: idPopUp弹出按钮

        anchors.top: id根.top
        anchors.topMargin: 12
        anchors.left: id根.left
        anchors.leftMargin: 16
        text: "控制盘"

        Keys.onPressed: {
            print("t")
        }

        onClicked: {
            idPopup.open()
        }
        Popup{
            id: idPopup
            width: height / 3 * 4 + 8
            height: 120
            padding: 0

            CtControlBtns{
                anchors.centerIn: parent
                height: parent . height

                onUpClicked: {
                    id根.scrollUp(16)
                }
                onDownClicked: {
                    id根.scrollDown(16)
                }
                onLeftClicked: {
                    id根.scrollLeft(16)
                }
                onRightClicked: {
                    id根.scrollRight(16)
                }
                onPlusClicked: {
                    id根.zoom(1.1)
                }
                onMinusClicked: {
                    id根.zoom(0.9)
                }
            }
        }
    }

    Button{  //复位按钮
        anchors.left: idPopUp弹出按钮.right
        anchors.leftMargin: 4
        anchors.top: id根.top
        anchors.topMargin: 12
        text: " 复位"

        onClicked: {
            zoomReset()
        }
    }

    CtPopup{  //错误信息弹出
        id: id错误信息弹出
        p文本: "图表停止，可能是服务器未收到连接"
    }
}
