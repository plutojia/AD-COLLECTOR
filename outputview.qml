import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0
import jia.qt.MyAD 1.0
Item {
    function showSDial(){
    saveDialog.open();
    }
    function showSDialFFT(){
    saveDialogFFT.open();
    }
    function showODial(){
    openDialog.open();
    }
    function showODialFFT(){
    openDialogFFT.open();
    }

    FileDialog {
          id: saveDialog
          title: "选择数据保存路径"
          folder: shortcuts.desktop
          nameFilters:["Text files (*.txt)", "All files (*)" ]
          selectExisting:false
          onAccepted: {
              if(saveDialog.fileUrl){
              myad.saveToFile(saveDialog.fileUrl);
              }
          }
          onRejected: {

          }
      }
    FileDialog {
          id: saveDialogFFT
          title: "选择FFT数据保存路径"
          folder: shortcuts.desktop
          nameFilters:["Text files (*.txt)", "All files (*)" ]
          selectExisting:false
          onAccepted: {
              if(saveDialogFFT.fileUrl){
              myad.saveToFileFFT(saveDialogFFT.fileUrl);
              }
          }
          onRejected: {

          }
      }
    FileDialog {
          id: openDialog
          title: "选择数据路径"
          folder: shortcuts.desktop
          nameFilters:["Text files (*.txt)", "All files (*)" ]
          selectExisting:true
          onAccepted: {
              if(openDialog.fileUrl){
              myad.openFile(openDialog.fileUrl);
              }
          }
          onRejected: {

          }
      }
    FileDialog {
          id: openDialogFFT
          title: "选择FFT数据路径"
          folder: shortcuts.desktop
          nameFilters:["Text files (*.txt)", "All files (*)" ]
          selectExisting:true
          onAccepted: {
              if(openDialogFFT.fileUrl){
              myad.openFileFFT(openDialogFFT.fileUrl);
              }
          }
          onRejected: {

          }
      }

    Frame{
        id:frame1
        width: parent.width*0.9
        height: parent.height*0.6
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
            text:"AD输出"
            y:parent.height*0.03
            font.pixelSize:15
        }
        Label{
            text:"原始数据："
            x:parent.width*0.06
            y:parent.height*0.13
        }
        Loader{
            id:tmb1
            anchors.horizontalCenter: btn1.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: 200
            sourceComponent: mTumbler
        }
        Connections{
            target: tmb1.item
            onCurrentIndexChanged:{
                myad.setOTch(tmb1.item.currentIndex+1);
            }
        }

        Loader{
            id:btn1
            x:parent.width*0.05
            anchors.bottom: btn2.top
            anchors.bottomMargin: 5
            width: tmb1.width
            height: 20
            sourceComponent: mButton
            Component.onCompleted: {item.text="保存";}
        }
        Connections{
            target: btn1.item
            onClicked:{
                saveDialog.open();
            }
        }
        Loader{
            id:btn2
            x:parent.width*0.05
            anchors.bottom: flb1.bottom
            width: tmb1.width
            height: 20
            sourceComponent: mButton
            Component.onCompleted: {item.text="打开";}
        }
        Connections{
            target: btn2.item
            onClicked:{
                openDialog.open();
            }
        }
        Flickable {
            id:flb1
            x:parent.width*0.14
            y:parent.height*0.12
            width: parent.width*0.3
            height: parent.height*0.85
            TextArea.flickable: TextArea{
                    objectName:"outputText"
                    wrapMode: TextArea.Wrap
                    visible: true
                    background: Rectangle{
                        border.width: 2
                        border.color: "#6092e2"
                    }
                    signal unpdate(string txt);
                    onUnpdate: {
                        text=txt;
                    }
                }
            ScrollBar.vertical: ScrollBar { }
        }



        Label{
            text:"FFT数据:"
            x:parent.width*0.53
            y:parent.height*0.13
        }
        Loader{
            id:tmb2
            anchors.horizontalCenter: btn3.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: 200
            sourceComponent: mTumbler
        }
        Connections{
            target: tmb2.item
            onCurrentIndexChanged:{
                myad.setOTchFFT(tmb2.item.currentIndex+1);
            }
        }
        Loader{
            id:btn3
            x:parent.width*0.52
            anchors.bottom: btn4.top
            anchors.bottomMargin: 5
            width: tmb2.width
            height: 20
            sourceComponent: mButton
            Component.onCompleted: {item.text="保存";}
        }
        Connections{
            target: btn3.item
            onClicked:{
                saveDialogFFT.open();
            }
        }
        Loader{
            id:btn4
            x:parent.width*0.52
            anchors.bottom: flb2.bottom
            width: tmb2.width
            height: 20
            sourceComponent: mButton
            Component.onCompleted: {item.text="打开";}
        }
        Connections{
            target: btn4.item
            onClicked:{
                openDialogFFT.open();
            }
        }
        Flickable {
            id:flb2
            x:parent.width*0.62
            y:parent.height*0.12
            width: parent.width*0.3
            height: parent.height*0.85
            TextArea.flickable: TextArea{
                    objectName:"outputTextFFT"
                    wrapMode: TextArea.Wrap
                    visible: true
                    background: Rectangle{
                        border.width: 2
                        border.color: "#6092e2"
                    }
                    signal unpdate(string txt);
                    onUnpdate: {
                        text=txt;
                    }
                }
            ScrollBar.vertical: ScrollBar { }
        }


    }
    Frame{
        width: parent.width*0.9
        height: parent.height*0.31
        y:parent.height*0.66
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
            text:"DA输出"
            y:parent.height*0.03
            font.pixelSize:15
        }
    }
    Component{
        id:mTumbler

        Tumbler {
            id: control
            model: 16
            visibleItemCount: 5
            wheelEnabled:true

            background: Item {
                Rectangle {
                    opacity: control.enabled ? 0.2 : 0.1
                    border.color: "#000000"
                    width: parent.width
                    height: 1
                    anchors.top: parent.top
                }

                Rectangle {
                    opacity: control.enabled ? 0.2 : 0.1
                    border.color: "#000000"
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                }
            }

            delegate: Text {
                text: qsTr("channel %1").arg(modelData + 1)
                font: control.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                opacity: 1.0 - Math.abs(Tumbler.displacement) / (visibleItemCount / 2)
            }

            Rectangle {
                anchors.horizontalCenter: control.horizontalCenter
                y: control.height * 0.4
                width: 60
                height: 1
                color: "#6092e2"
            }

            Rectangle {
                anchors.horizontalCenter: control.horizontalCenter
                y: control.height * 0.6
                width: 60
                height: 1
                color: "#6092e2"
            }
            MouseArea{
                id:ma1
                anchors.fill: parent
                acceptedButtons: Qt.MidButton
                z:20
                onWheel: {
                    if(wheel.angleDelta.y<0){
                        control.currentIndex+=1;
                    }else{
                        control.currentIndex-=1;
                    }
                }
            }

        }
    }
    Component{
        id:mButton

    Button {
          id: control
          text: qsTr("Button")

          contentItem: Text {
              text: control.text
              font: control.font
              opacity: enabled ? 1.0 : 0.8
              color: control.down ? "#6092e2" : "#335dd1"
              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter
              elide: Text.ElideRight
          }

          background: Rectangle {
              implicitWidth: 100
              implicitHeight: 40
              opacity: enabled ? 1 : 0.8
              border.color: control.down ? "#6092e2" : "#335dd1"
              border.width: 1
              radius: 2
          }
      }
    }
}
