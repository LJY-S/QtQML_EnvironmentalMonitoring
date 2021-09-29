import QtQuick 2.9
import QtQuick.Controls 2.5


Pane{
    id: pane
    property alias labelFont: label.font
    property alias labelText: label.text
    property alias textFieldFont: textField.font
    property alias textFieldText: textField.text
    property alias textFieldColor: textField.color
    property alias textFieldWidth: textField.width
    property alias placeholderText: textField.placeholderText
    property alias readOnly: textField.readOnly  //默认情况下，输入enter或焦点改变，textField将改变到readOnly状态（为了提示用户信息已接收）。而当鼠标移动到textField上方时，又会改变回可编辑状态
    property alias readOnlyLock: textField.readOnlyLock  //锁定readOnly，锁定后，鼠标移动到textField上将不再改变只读属性
    property alias readOnlyTip:textField.readOnlyTip  //当受到鼠标单击，又为只读状态时，将会弹出的提示内容，用ToolTip实现
    property alias toolTipTimeOut:textField.toolTipTimeOut
    property alias elementSpacing: grid.spacing


    signal editingFinished;  //承接textField的editingFinished
    signal pressed;

    Grid{
        id: grid

        rows: 1
        verticalItemAlignment: Grid.AlignVCenter
        spacing: 16
        Label{
            id: label
            text: "label"
        }
        TextField{
            id: textField

            width: 200
            placeholderText: "hodler text"
            hoverEnabled: true
            selectByMouse: true  //可用鼠标进行文本选取
            focus: true

            property bool readOnlyLock: false
            property string readOnlyTip: "当前为只读状态，无法更改内容"  //当受到鼠标单击，又为只读状态时，将会弹出的提示内容，用ToolTip实现
            property int toolTipTimeOut: 3000

            onEditingFinished: {
                if(readOnlyLock == false)
                {
                    readOnly = true
                }
                pane.editingFinished();
            }
            onHoveredChanged: {
                if(hovered == true && readOnlyLock == false)
                    readOnly = false
            }
            onPressed: {
                if(readOnly == true)  //当受到鼠标单击，又为只读状态时，弹出提示
                {
                    ToolTip.show(readOnlyTip, toolTipTimeOut)
                }
                pane.pressed();
            }
        }
    }

}
