import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
Item {
    property int subwidth:title.width*0.21
    property int subspace:(title.width-subwidth*4)/3
    signal aboutClick;
    Rectangle{
        id:title
        color:"#335dd1"
        //color:"#4c8cc8" "#408be0"527ef7"07085e"4892e2
        width: height*3
        height: parent.height*0.4
        x: (parent.width - width) / 2
        y:parent.height*0.05
        radius: 7
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 8.0
            samples: 17
            color: "#80000000"
        }
        Image{
            anchors.fill:parent
            source: "image/title.png"
        }
        Label{
        }
    }
    Button{
        id:sub1
        width: subwidth
        height: width
        x: title.x
        y:parent.height*0.55
        hoverEnabled:true
        background: Rectangle{
            anchors.fill: parent
            color:"#335dd1"
            //color:"#4c8cc8" "#408be0"527ef7
            radius: 2
        }
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 8.0
            samples: 17
            color: "#80000000"
        }
        Label{
            z:20;visible:parent.hovered
            id:lb_sub1
            background:  Rectangle{
                opacity:0.8
                color: "#ffffff"
                anchors.fill: parent
            }
            text:"<p>采用<i>MP422E</i> A/D板</p>"
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            anchors.fill: parent
            x:80
            font.pointSize: 14
            font.bold: true
            color: "#3333aa"
        }
        Image{
            anchors.fill:parent
            source: "image/sub1.png"
        }
    }
    Button{
        id:sub2
        width: subwidth
        height: width
        x: sub1.x+subspace+subwidth
        y:parent.height*0.55
        hoverEnabled:true
        background: Rectangle{
            anchors.fill: parent
            color:"#335dd1"
            //color:"#4c8cc8" "#408be0"527ef7
            radius: 2
        }
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 8.0
            samples: 17
            color: "#80000000"
        }
        Label{
            z:20;visible:parent.hovered
            id:lb_sub2
            background:  Rectangle{
                opacity:0.8
                color: "white"
                anchors.fill: parent
            }
            text:"<p>快速傅里叶变换</p>"
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            anchors.fill: parent
            x:80
            font.pointSize: 14
            font.bold: true
            color: "#3333aa"
        }
        Image{
            anchors.fill:parent
            source: "image/sub2.png"
        }
    }
    Button{
        id:sub3
        width: subwidth
        height: width
        x: sub2.x+subspace+subwidth
        y:parent.height*0.55
        hoverEnabled:true
        background: Rectangle{
            anchors.fill: parent
            color:"#335dd1"
            //color:"#4c8cc8" "#408be0"527ef7
            radius: 2
        }
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 8.0
            samples: 17
            color: "#80000000"
        }
        Label{
            z:20;visible:parent.hovered
            id:lb_sub3
            background:  Rectangle{
                opacity:0.8
                color: "white"
                anchors.fill: parent
            }
            text:"<p>图形化数据处理</p>"
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            anchors.fill: parent
            x:80
            font.pointSize: 14
            font.bold: true
            color: "#3333aa"
        }
        Image{
            anchors.fill:parent
            source: "image/sub3.png"
        }
    }
    Button{
        id:sub4
        width: subwidth
        height: width
        x: title.x+title.width-width
        y:parent.height*0.55
        hoverEnabled:true
        background: Rectangle{
            anchors.fill: parent
            color:"#335dd1"
            //color:"#4c8cc8" "#408be0"527ef7
            radius: 2
        }
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 8.0
            samples: 17
            color: "#80000000"
        }
        Label{
            z:20;visible:parent.hovered
            id:lb_sub4
            background:  Rectangle{
                opacity:0.8
                color: "white"
                anchors.fill: parent
            }
            text:"<p>作者：<br/><br/>2014211857-赵嘉<br/>2014211858-王树义</p>"
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            anchors.fill: parent
            x:80
            font.pointSize: 13
            font.bold: true
            color: "#3333aa"
        }
        Image{
            anchors.fill:parent
            source: "image/sub4.png"
        }
        onClicked: parent.aboutClick();
    }
}
