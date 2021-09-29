import QtQuick 2.15
import QtQuick.Controls 2.15

Item{
    id: id根
    default property alias 侧边栏内容: id侧边栏.contentData

    property alias 侧边栏展开距离: id接口.侧边栏展开距离

    state: "关闭"

    Item{
        id: id接口
        property int 侧边栏展开距离: 0.3 * Overlay.overlay.height


        //以下是状态相关函数（一般只进行操作和状态赋值，而不进行普通赋值）
        function fun到关闭(){
            id根.state = "关闭";
            id侧边栏.close();
        }
        function fun到打开(){
            id根.state = "打开";
            id侧边栏.open();
        }
        function fun自动选择状态(){
            switch(id根.state){
            case "打开":{fun到关闭(); break;}
            case "关闭":{fun到打开(); break;}
            }
        }
    }

    Drawer{
        id: id侧边栏
//        width:  id接口.侧边栏展开距离
//        height: Overlay.overlay.height
        width: Overlay.overlay.width
        height: id接口.侧边栏展开距离
        edge: Qt.BottomEdge

        onClosed: {
            id接口.fun到关闭()
        }

    }

    Button{
        id: id侧边栏按钮

//        y: id侧边栏.y + (id侧边栏.height - height) / 2  //垂直居中
//        x: id接口.侧边栏展开距离 * id侧边栏.position  //在侧边栏右边界外
        y: (Overlay.overlay.height - height) - id接口.侧边栏展开距离 * id侧边栏.position  //在侧边栏上边界外
        x: id侧边栏.x + (id侧边栏.width - width) / 2  //水平居中
//        width: 30
//        height: id侧边栏.height * 0.2
        width: id侧边栏.width * 0.2
        height: 30
        padding: 8
        text: "︿"
        font.bold: true

        onClicked: {
            id接口.fun自动选择状态()
        }
    }

   states: [
       State {
           name: "打开"
           PropertyChanges {
               target: id侧边栏按钮
               text: "﹀"
           }
       },
       State {
           name: "关闭"
           PropertyChanges {
               target: id侧边栏按钮
               text: "︿"
           }
       }
   ]
}

