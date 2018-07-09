import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
Window{
    id:aboutWindow
    title:"关于AD collector"
    //flags:"Dialog"
    color: "#f4f4f4"
    maximumHeight : 450
    maximumWidth : 300
    minimumHeight : 450
    minimumWidth : 300
    Image {
        id:img_home
        fillMode: Image.PreserveAspectCrop ;mipmap:true
        anchors.horizontalCenter : parent.horizontalCenter
        y:40
        width: 110
        height:110
        source: "image/ICONbig.png"
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            color:"#80000000"
            horizontalOffset: 2
            verticalOffset: 2
            radius: 8.0
            samples: 8
        }
    }
    Label{
        y:165
        anchors.horizontalCenter : parent.horizontalCenter
        text:"AD collecter 1.0.0"
        font.bold: true
        font.pixelSize: 17
    }
    Label{
        y:205
        x:20
        width:parent.width-40
        wrapMode: Text.WrapAnywhere
        lineHeight:1.4
        text:"Based on Qt 5.7.0 (MSVC 2013, 32 bit)
Built on May 12 2017 01:04:04
Copyright 2017-? Jiang Zemin All rights reserved.
作者：2014211406班 赵嘉 王树义
本程序提供对MP442E板卡进行AD采样等操作，仅供学习和参考
最终解释权归江泽民所有
"
    }
    Button{
        id:control
        anchors.horizontalCenter : parent.horizontalCenter
        y:385
        width:70
        height: 35
        text: "close"
        font.pixelSize: 14
        contentItem: Text {
                  text: control.text
                  font: control.font
                  opacity: enabled ? 1.0 : 0.3
                  color: control.down ? "#6092e2" : "#335dd1"
                  horizontalAlignment: Text.AlignHCenter
                  verticalAlignment: Text.AlignVCenter
                  elide: Text.ElideRight
              }

              background: Rectangle {
                  implicitWidth: 60
                  implicitHeight: 30
                  color:control.hovered?"#fcfcfc":"#f5f5f5"
                  border.color: control.down ? "#6092e2" : "#335dd1"
                  border.width: control.hovered?3:1
                  radius: 5
              }

        onClicked: {
            aboutWindow.hide();
        }
    }

}
