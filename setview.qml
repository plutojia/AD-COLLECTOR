import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.1
import jia.qt.MyAD 1.0
Item {
    function setArgs(){
//myad::setArgs(int stch, int endch, int gain, int sammode, int tdata, int sample)
        var stch=mstch.item.value;
        var endch=mendch.item.value;
        var tdata=mtdata.item.value;
        var gain=bg1.checkedButton.value;
        var sample=bg2.checkedButton.value;
        var sammode=msammode.item.currentIndex
        if(sammode===1){
            if(tdata<100)tdata=100;
            mtdata.item.value=100;
        }
        myad.setArgs(stch,endch,gain,sammode,tdata,sample);
    }
    function loadArgs(){
        mstch.item.value=myad.getStch();
        mendch.item.value=myad.getEndch();
        mtdata.item.value=myad.getTdata();
        msammode.item.currentIndex=myad.getSammode();
        for(var i in bg1.buttons){
            if(bg1.buttons[i].value===myad.getGain()){
                bg1.buttons[i].checked=true;
            }
        }
        for(i in bg2.buttons){
            if(bg2.buttons[i].value===myad.getSample()){
                bg2.buttons[i].checked=true;
            }
        }

    }
    function enable(){
        frame1.enabled=true;
    }
    function disable(){
        frame1.enabled=false;
    }
    Frame{
        id:frame1
        width: parent.width*0.9
        height: parent.height*0.64
        y:parent.height*0.03
        anchors.horizontalCenter:parent.horizontalCenter
        background: Rectangle {
            width: parent.width
            height: parent.height
            color: "white"
            border.color: "#335dd1"
            radius: 3
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                color: "gray"
                horizontalOffset: 1
                verticalOffset: 1
                radius: 8.0
                samples: 1
            }
        }

        Label{
            anchors.horizontalCenter: parent.horizontalCenter
            text:"采集参数"
            y:parent.height*0.03
            font.pixelSize:15
        }

        Label {y:parent.height*0.17;x:parent.width*0.03;text: qsTr("起始通道");}
        Loader{
            id:mstch;
            y:parent.height*0.13;x:parent.width*0.1;
            onLoaded: {
                item.from=1;item.to=16;
            }
            sourceComponent: mSpinBox
        }
        Label {y:parent.height*0.17;x:parent.width*0.34;text: qsTr("终止通道");}
        Loader{
            id:mendch;
            y:parent.height*0.13;x:parent.width*0.41;
            onLoaded: {
                item.from=1;item.to=16;
            }
            sourceComponent: mSpinBox
        }
        Label {y:parent.height*0.17;x:parent.width*0.65;text: qsTr("采样频率");}
        Loader{
            id:mtdata;
            y:parent.height*0.13;x:parent.width*0.72;
            onLoaded: {
                item.from=25;item.to=65535;item.value=100;
            }
            sourceComponent: mSpinBox
        }

        Label {y:parent.height*0.4;x:parent.width*0.03;text: qsTr("增益设置");}
        ButtonGroup {
              id:bg1;
          }
        Column{
            id:mgain;y:parent.height*0.36;x:parent.width*0.11;
            Loader{onLoaded: {item.value=0;item.text="-10V~+10V";item.checked=true;item.ButtonGroup.group=bg1;} sourceComponent: mRadio}
            Loader{onLoaded: {item.value=1;item.text="-5V~+5V";item.ButtonGroup.group=bg1;} sourceComponent: mRadio}
            Loader{onLoaded: {item.value=2;item.text="-2.5V~+2.5V";item.ButtonGroup.group=bg1;} sourceComponent: mRadio}
            Loader{onLoaded: {item.value=3;item.text="-1.25V~+1.25V";item.ButtonGroup.group=bg1;} sourceComponent: mRadio}
            }
        Label {y:parent.height*0.4;x:parent.width*0.34;text: qsTr("样本点数");}
        ButtonGroup {
              id:bg2;
          }
        Column{
            id:msample;
            y:parent.height*0.36;x:parent.width*0.42;
            Loader{onLoaded: {item.value=256;item.text="8-256";item.ButtonGroup.group=bg2;} sourceComponent: mRadio}
            Loader{onLoaded: {item.value=512;item.text="9-512";item.ButtonGroup.group=bg2;} sourceComponent: mRadio}
            Loader{onLoaded: {item.value=1024;item.text="10-1024";item.checked=true;item.ButtonGroup.group=bg2;} sourceComponent: mRadio}
            Loader{onLoaded: {item.value=2048;item.text="11-2048";item.ButtonGroup.group=bg2;} sourceComponent: mRadio}
        }
        Label {y:parent.height*0.4;x:parent.width*0.65;text: qsTr("采样模式");}
        Loader{
            id:msammode;
            y:parent.height*0.36;x:parent.width*0.73;
            onLoaded: {
                item.model=["normal", "sh"];
            }
            sourceComponent: mComboBox
        }

        Button{
            x:parent.width*0.7
            y:parent.height*0.85
            text: "保存设置"
            onClicked: setArgs();
        }
        Button{
            x:parent.width*0.85
            y:parent.height*0.85
            text: "恢复参数"
            onClicked:loadArgs();
        }

    }

    Frame{
        width: parent.width*0.9
        height: parent.height*0.27
        y:parent.height*0.71
        anchors.horizontalCenter:parent.horizontalCenter
        background: Rectangle {
            width: parent.width
            height: parent.height
            color: "white"
            border.color: "#335dd1"
            radius: 3
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                color: "gray"
                horizontalOffset: 1
                verticalOffset: 1
                radius: 8.0
                samples: 1
            }
        }
        Label{
            anchors.horizontalCenter: parent.horizontalCenter
            text:"显示通道选择"
            y:parent.height*0.03
            font.pixelSize:15
        }
        GridLayout {
            y:parent.height*0.22
            rows:2
            columns: 8
            columnSpacing : (parent.width-52*8)/7
            Loader{onLoaded: {item.text=qsTr("CH1");item.value=1;item.checked=true;}  sourceComponent: mCheckBox}
            Loader{onLoaded: {item.text=qsTr("CH2");item.value=2;}  sourceComponent: mCheckBox}
            Loader{onLoaded: {item.text=qsTr("CH3");item.value=3;}  sourceComponent: mCheckBox}
            Loader{onLoaded: {item.text=qsTr("CH4");item.value=4;}  sourceComponent: mCheckBox}
            Loader{onLoaded: {item.text=qsTr("CH5");item.value=5;}  sourceComponent: mCheckBox}
            Loader{onLoaded: {item.text=qsTr("CH6");item.value=6;}  sourceComponent: mCheckBox}
            Loader{onLoaded: {item.text=qsTr("CH7");item.value=7;}  sourceComponent: mCheckBox}
            Loader{onLoaded: {item.text=qsTr("CH8");item.value=8;}  sourceComponent: mCheckBox}
            Loader{onLoaded: {item.text=qsTr("CH9");item.value=9;}  sourceComponent: mCheckBox}
            Loader{onLoaded: {item.text=qsTr("CH10");item.value=10;}  sourceComponent: mCheckBox}
            Loader{onLoaded: {item.text=qsTr("CH11");item.value=11;}  sourceComponent: mCheckBox}
            Loader{onLoaded: {item.text=qsTr("CH12");item.value=12;}  sourceComponent: mCheckBox}
            Loader{onLoaded: {item.text=qsTr("CH13");item.value=13;}  sourceComponent: mCheckBox}
            Loader{onLoaded: {item.text=qsTr("CH14");item.value=14;}  sourceComponent: mCheckBox}
            Loader{onLoaded: {item.text=qsTr("CH15");item.value=15;}  sourceComponent: mCheckBox}
            Loader{onLoaded: {item.text=qsTr("CH16");item.value=16;}  sourceComponent: mCheckBox}
        }

    }




    Component{
        id:mComboBox
        ComboBox {
            id: control
            model: ["First", "Second", "Third"]
            delegate: ItemDelegate {
                width: control.width
                text: modelData
                font.weight: control.currentIndex === index ? Font.DemiBold : Font.Normal
                highlighted: control.highlightedIndex == index
            }

            indicator: Canvas {
                id:indicator
                x: control.width - width - control.rightPadding
                y: control.topPadding + (control.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: control
                    onPressedChanged: indicator.requestPaint()
                }

                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = control.pressed ? "#6092e2" : "#335dd1";
                    context.fill();
                }
            }

            contentItem: Text {
                text: control.displayText
                font: control.font
                color: control.pressed ? "#6092e2" : "#335dd1"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 40
                border.color: control.pressed ? "#6092e2" : "#335dd1"
                border.width: control.visualFocus ? 2 : 1
                radius: 2
            }
        }

    }



    Component{
        id:mCheckBox

        CheckBox {
            id: control
            text: qsTr("CheckBox")
            checked: false
            property int value
            indicator: Rectangle {
                implicitWidth: 26
                implicitHeight: 26
                x: control.leftPadding
                y: parent.height / 2 - height / 2
                radius: 3
                border.color: control.down ? "#6092e2" : "#335dd1"

                Rectangle {
                    width: 14
                    height: 14
                    x: 6
                    y: 6
                    radius: 2
                    color: control.down ? "#6092e2" : "#335dd1"
                    visible: control.checked
                }
            }

            contentItem: Label {
                text: control.text
                font: control.font
                opacity: enabled ? 1.0 : 0.3
                color: control.down ? "#000000" : "#000000"

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                leftPadding: 8+control.spacing//control.indicator.width+control.spacing
            }
            onCheckedChanged: {
                myad.seriesvisible(value,checked);
            }
        }
    }

    Component{
        id:mSpinBox
        SpinBox {
            id: control
            value: 0
            editable: true

            contentItem: TextInput {
                z: 2
                text: control.textFromValue(control.value, control.locale)

                font: control.font
                color: "#6092e2"
                selectionColor: "#6092e2"
                selectedTextColor: "#ffffff"
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter

                readOnly: !control.editable
                validator: control.validator
                inputMethodHints: Qt.ImhFormattedNumbersOnly
            }

            up.indicator: Rectangle {
                x: control.mirrored ? 0 : parent.width - width
                height: parent.height
                implicitWidth: 40
                implicitHeight: 40
                color: up.pressed ? "#e4e4e4" : "#f6f6f6"
                border.color: enabled ? "#6092e2" : "#bdbebf"

                Text {
                    text: "+"
                    font.pixelSize: control.font.pixelSize * 2
                    color: "#6092e2"
                    anchors.fill: parent
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            down.indicator: Rectangle {
                x: control.mirrored ? parent.width - width : 0
                height: parent.height
                implicitWidth: 40
                implicitHeight: 40
                color: down.pressed ? "#e4e4e4" : "#f6f6f6"
                border.color: enabled ? "#6092e2" : "#bdbebf"

                Text {
                    text: "-"
                    font.pixelSize: control.font.pixelSize * 2
                    color: "#6092e2"
                    anchors.fill: parent
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            background: Rectangle {
                implicitWidth: 140
                border.color: "#bdbebf"
            }
        }
    }

    Component{
        id:mRadio
        RadioButton {
            id: control
            text: qsTr("RadioButton")
            checked: false
            property int value
            indicator: Rectangle {
                implicitWidth: 26
                implicitHeight: 26
                x: control.leftPadding
                y: parent.height / 2 - height / 2
                radius: 13
                border.color: control.down ? "#6092e2" : "#335dd1"
                opacity: enabled ? 1.0 : 1
                Rectangle {
                    width: 14
                    height: 14
                    x: 6
                    y: 6
                    radius: 7
                    color: control.down ? "#6092e2" : "#335dd1"
                    visible: control.checked
                }
            }

            contentItem: Label {
                text: control.text
                font: control.font
                opacity: enabled ? 1.0 :1
                color: control.down ? "#6092e2" : "#335dd1"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                leftPadding: control.indicator.width + control.spacing
            }
        }
    }
}
