import QtQuick 2.7
import QtQuick.Window 2.2
import jia.qt.MyAD 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQml.StateMachine 1.0
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
import QtCharts 2.0
import QtQuick.Layouts 1.1
ApplicationWindow {
    visible: true
    id:mainWindow
    objectName:"rootObject"
    width: 900
    height: 600
    title: qsTr("AD COLLECTOR")
        menuBar:MenuBar {
        Menu {
            title: "文件"
            MenuItem { text: "  主页 "
                onTriggered: {
                    btn_welcome.clicked();
                }
            }
            MenuSeparator{}
            MenuItem { text: "  退出 "
                onTriggered: {
                    Qt.quit();
                }}
        }

        Menu {
            title: "编辑"
            MenuItem { text: "参数设置"
                onTriggered: {
                    btn_set.clicked();
                }
            }
            MenuSeparator{}
            MenuItem { text: "开始采样"
                onTriggered: {
                    btn_play.clicked();
                }
            }
            MenuItem { text: "暂停采样"
                onTriggered: {
                    btn_stop.clicked();
                }
            }
            MenuItem { text: "停止采样"
                onTriggered: {
                    btn_end.clicked();
                }
            }
        }
        Menu {
            title: "数据"
            MenuItem { text: "刷新图像"
                onTriggered: {
                    chartviewloader.item.refresh();
                }
            }
            MenuItem { text: "保存图像";
            }
            MenuSeparator{}
            MenuItem { text: "保存数据"
                onTriggered: {
                    outputviewloader.item.showSDial();
                }
            }
            MenuItem { text: "保存FFT数据"
                onTriggered: {
                    outputviewloader.item.showSDialFFT();
                }}
            MenuItem { text: "打开数据"
                onTriggered: {
                    outputviewloader.item.showODial();
                }
            }
            MenuItem { text: "打开FFT数据"
                onTriggered: {
                    outputviewloader.item.showODialFFT();
                }
            }
            MenuItem { text: "数据分析"
                onTriggered: {
                    btn_output.clicked();
                }
            }
        }
        Menu {
            title: "关于"
            MenuItem {
                text: "作品信息"
                onTriggered: {
                    aboutWindow.show();
                }
            }
        }
    }
        AboutWindow{
           id: aboutWindow
           visible: false
        }
    Connections{
        target: welcomeviewloader.item
        onAboutClick:{
            aboutWindow.visible=true;
        }
    }
        MessageDialog {
            id: messageDialog
            title: "。"
            text: "."
            onAccepted: {

            }
        }

    MainForm {
        id: mainForm1
        //color: "#8fbcf0"
        color: "#f4f4f4"
        border.width: 0
        anchors.fill: parent


        Component.onCompleted: {
        }

        MyAD{
            objectName: "myad"
            id:myad
        }

        StateMachine{
            id:statemachine
            initialState: endstate
            running: true

            State {
                id: endstate
                SignalTransition {
                    targetState: playstate
                    signal: btn_play.played
                }
                onEntered: {
                    console.log("endstate entered");
                    btn_stop.enabled=false;
                    btn_end.enabled=false;
                    btn_play.checked=false;
                    btn_stop.checked=false;
                    btn_end.checked=false;
                    myad.stop();
                    chartviewloader.item.end();
                    setviewloader.item.enable();
                }

                onExited: console.log("endstate exited")
            }
            State {
                id: playstate
                SignalTransition {
                    targetState: endstate
                    signal: btn_end.clicked
                }
                SignalTransition {
                    targetState: stopstate
                    signal: btn_stop.clicked
                }
                onEntered: {
                    console.log("playstate entered")
                    btn_stop.enabled=true;
                    btn_end.enabled=true;
                    btn_play.checked=true;
                    btn_stop.checked=false;
                    btn_end.checked=false;
                    myad.start();
                    chartviewloader.item.start();
                    setviewloader.item.disable();
                }
                onExited: console.log("playstate exited")
            }
            State {
                id: stopstate
                SignalTransition {
                    targetState: playstate
                    signal: btn_play.clicked
                }
                SignalTransition {
                    targetState: endstate
                    signal: btn_end.clicked
                }
                onEntered: {
                    console.log("stopstate entered")
                    btn_end.enabled=true;
                    btn_play.checked=false;
                    btn_stop.checked=true;
                    btn_end.checked=false;
                    myad.pause();
                    chartviewloader.item.stop();
                    setviewloader.item.disable();
                }
                onExited: console.log("stopstate exited")

            }
        }
        Rectangle{
            id:sidebar
            property int currentview: 0
            property int sidebarstate: 0
            z:20
            color:"#335dd1"
            gradient: Gradient {
                GradientStop {
                    position: 0.00;
                    color: "#07085e";
                }
                GradientStop {
                    position: 1.00;
                    color: "#4892e2";
                }
            }
            //color:"#4c8cc8" "#408be0"527ef7"#4892e2"
            clip:true
            width: 50
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 17
                color: "#80000000"
            }

            NumberAnimation
            {
                id:sidebarAnime0
                target: sidebar
                properties: "width"
                running:false
                from:50
                to:250
                easing.type: Easing.OutQuint;
                easing.amplitude: 2.0;
                easing.period: 1.5
                //loops: Animation.Infinite
                duration: 600
            }
            NumberAnimation
            {
                id:sidebarAnime1
                target: sidebar
                properties: "width"
                running:false
                from:250
                to:50
                easing.type: Easing.OutQuint;
                easing.amplitude: 2.0;
                easing.period: 1.5
                //loops: Animation.Infinite
                duration: 400
            }
            function sidebartoggle(){
                if(sidebarstate==0){
                    sidebarAnime0.start();
                    sidebarstate=1;
                    contentMask.enabled=true;
                }else{
                    sidebarAnime1.start();
                    sidebarstate=0;
                    contentMask.enabled=false;
                }
            }
            function changeview(btn){
                var btnlist=children;
                var loaderlist=loader.children;
                for(var i=1;i<5;i++){
                    if(btnlist[i]===btn){
                        btnlist[i].checked=true;
                        loaderlist[i-1].visible=true;
                        currentview=i;
                    }else{
                        btnlist[i].checked=false;
                        loaderlist[i-1].visible=false;
                    }

                }
                console.log(currentview);
            }
            Button {
                id: btn_main
                text:"main"
                clip:true
                anchors.top: parent.top
                height: 50
                width: parent.width
                style: ButtonStyle{
                    background: Rectangle {
                        color: "#00000000"
                        Rectangle{
                            anchors.fill: parent
                            color:"white"
                            opacity: control.hovered?0.2:0
                        }

                        Image {
                            fillMode: Image.PreserveAspectCrop ;mipmap:true
                            anchors.verticalCenter: parent.verticalCenter
                            x:12
                            width: 25
                            height: 25
                            source: "image/main.png"
                        }
                        Label{
                            id:lb_main
                            text: "AD COLLECTOR"
                            anchors.verticalCenter: parent.verticalCenter
                            x:80
                            font.pointSize: 9
                            font.bold: true
                            color: "white"
                        }
                    }
                    label: Label{

                    }
                }
                onClicked: {
                    sidebar.sidebartoggle();
                }


            }
            Button {
                id: btn_welcome
                checkable: true
                checked: true
                clip:true
                text:"首页"
                anchors.top: btn_main.bottom
                height: 50
                width: parent.width
                style: ButtonStyle{
                    background: Rectangle {
                        color: "#00000000"
                        Rectangle{
                            anchors.fill: parent
                            color:"white"
                            opacity: control.checked ? 0.3 : (control.hovered ?0.2:0)
                        }
                        Image {
                            id:img_home
                            fillMode: Image.PreserveAspectCrop ;mipmap:true
                            anchors.verticalCenter: parent.verticalCenter
                            x:12
                            width: 25
                            height: 25
                            source: "image/home.png"
                        }
                        Label{
                            id:lb_home
                            text: "首页"
                            anchors.verticalCenter: parent.verticalCenter
                            x:80
                            font.pointSize: 9
                            font.bold: true
                            color: "#f5f5f5"
                        }
                    }
                    label: Label{

                    }


                }
                onClicked: {
                    sidebar.changeview(this);
                }


            }

            Button {
                id:btn_set
                checkable: true
                clip:true
                text:"参数设置"
                anchors.top: btn_welcome.bottom
                height: 50
                width: parent.width
                style: ButtonStyle{
                    background: Rectangle {
                        color: "#00000000"
                        Rectangle{
                            anchors.fill: parent
                            color:"white"
                            opacity: control.checked ? 0.3 : (control.hovered ?0.2:0)
                        }
                        RotationAnimation
                        {
                            id:setAnime
                            target: img_set
                            running: control.hovered
                            from:0
                            to:360
                            direction: RotationAnimation.Clockwise
                            loops: Animation.Infinite
                            duration: 2000
                        }
                        Image {
                            id:img_set
                            fillMode: Image.PreserveAspectCrop ;mipmap:true
                            anchors.verticalCenter: parent.verticalCenter
                            x:12
                            width: 25
                            height: 25
                            source: "image/settings.png"
                        }
                        Label{
                            id:lb_set
                            text: "参数设置"
                            anchors.verticalCenter: parent.verticalCenter
                            x:80
                            font.pointSize: 9
                            font.bold: true
                            color: "#f5f5f5"
                        }
                    }
                    label: Label{

                    }
                }

                onClicked: {
                    sidebar.changeview(this);
                }
            }

            Button {
                id:btn_image
                checkable: true
                clip:true
                text:"图像"
                anchors.top: btn_set.bottom
                height: 50
                width: parent.width
                style: ButtonStyle{
                    background: Rectangle {
                        color: "#00000000"
                        Rectangle{
                            anchors.fill: parent
                            color:"white"
                            opacity: control.checked ? 0.3 : (control.hovered ?0.2:0)
                        }
                        NumberAnimation
                        {
                            id:imageAnime
                            target: mask_image
                            properties: "width"
                            running: control.hovered
                            from:0
                            to:25
                            easing.type: Easing.OutQuint;
                            easing.amplitude: 2.0;
                            easing.period: 1.5
                            loops: Animation.Infinite
                            duration: 2000
                        }
                        Rectangle{
                            id:mask_image
                            visible: control.hovered
                            clip: true
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#00000000"
                            x:12
                            width: 25
                            height: 25
                            Image {
                                id:img_imagecp
                                fillMode: Image.PreserveAspectCrop ;mipmap:true
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                width: 25
                                height: 25
                                source: "image/chart.png"
                            }
                        }
                        Image {
                            id:img_image
                            visible: !control.hovered ;mipmap:true
                            fillMode: Image.PreserveAspectCrop
                            anchors.verticalCenter: parent.verticalCenter
                            x:12
                            width: 25
                            height: 25
                            source: "image/chart.png"
                        }
                        Label{
                            id:lb_image
                            text: "采样图像"
                            anchors.verticalCenter: parent.verticalCenter
                            x:80
                            font.pointSize: 9
                            font.bold: true
                            color: "#f5f5f5"
                        }
                    }
                    label: Label{

                    }

                }
                onClicked: {
                    sidebar.changeview(this);
                }
            }

            Button {
                id:btn_output
                checkable: true
                clip:true
                text:"数据查看"
                anchors.top: btn_image.bottom
                height: 50
                width: parent.width
                style: ButtonStyle{
                    background: Rectangle {
                        color: "#00000000"
                        Rectangle{
                            anchors.fill: parent
                            color:"white"
                            opacity: control.checked ? 0.3 : (control.hovered ?0.2:0)
                        }
                        SequentialAnimation {
                            id: outputAnime
                            running: control.hovered
                            loops: Animation.Infinite
                            NumberAnimation {target: img_outputcp;properties: "width";to:28;duration: 300}
                            NumberAnimation { target: img_outputcp;properties: "width";to:22;duration: 600}
                            NumberAnimation { target: img_outputcp;properties: "width";to:25;duration: 300}
                        }

                        Item{
                            id:itm_output
                            anchors.verticalCenter: parent.verticalCenter
                            visible: control.hovered
                            x:12
                            width: 25
                            height: width
                            Image {
                                id:img_outputcp
                                fillMode: Image.PreserveAspectCrop ;mipmap:true
                                anchors.centerIn: parent
                                width: 25
                                height: width
                                source: "image/eye.png"
                            }
                        }
                        Image {
                            id:img_output
                            visible: !control.hovered
                            fillMode: Image.PreserveAspectCrop ;mipmap:true
                            anchors.verticalCenter: parent.verticalCenter
                            x:12
                            width: 25
                            height: width
                            source: "image/eye.png"
                        }
                        Label{
                            id:lb_output
                            text: "数据输出查看"
                            anchors.verticalCenter: parent.verticalCenter
                            x:80
                            font.pointSize: 9
                            font.bold: true
                            color: "#f5f5f5"
                        }
                    }
                    label: Label{

                    }
                }
                onClicked: {
                    sidebar.changeview(this);
                }

            }

            Button {
                id:btn_play
                checkable: true
                clip:true
                text:"运行"
                anchors.bottom: btn_stop.top
                height: 50
                width: parent.width
                signal played;
                onEnabledChanged:{
                    if(enabled==false)
                        checked=false;
                }
                onClicked: {
                    var stat=myad.start();
                    if(stat===0){
                        checked=true;
                        played();
                    }else if(stat===-1){
                        checked=false;
                        messageDialog.title="未找到设备！";
                        messageDialog.text="未找到设备！请检查板卡连接。";
                        messageDialog.icon=StandardIcon.Warning;
                        messageDialog.open();
                    }
                }
                style: ButtonStyle{
                    background: Rectangle {
                        color: "#00000000"
                        Rectangle{
                            anchors.fill: parent
                            color:"white"
                            opacity: control.checked ? 0.3 : (control.hovered ?0.2:0)
                        }
                        Image {
                            fillMode: Image.PreserveAspectCrop ;mipmap:true
                            anchors.verticalCenter: parent.verticalCenter
                            x:13
                            width: 23
                            height: 23
                            source: control.enabled?(control.checked?"image/played.png":"image/played.png"):"image/noplay.png"
                        }
                        Label{
                            id:lb_play
                            text: "开始采样"
                            anchors.verticalCenter: parent.verticalCenter
                            x:80
                            font.pointSize: 9
                            font.bold: true
                            color: "#f5f5f5"
                        }
                    }
                    label: Label{

                    }
                }
            }
            Button {
                id:btn_stop
                checkable: true
                clip:true
                //enabled: false
                text:"暂停"
                anchors.bottom: btn_end.top
                height: 50
                width: parent.width
                onEnabledChanged:{
                    if(enabled==false)
                        checked=false;
                }
                onClicked: {
                    checked=true;
                }
                style: ButtonStyle{
                    background: Rectangle {
                        color: "#00000000"
                        Rectangle{
                            anchors.fill: parent
                            color:"white"
                            opacity: control.checked ? 0.3 : (control.hovered ?0.2:0)
                        }
                        Image {
                            fillMode: Image.PreserveAspectCrop ;mipmap:true
                            anchors.verticalCenter: parent.verticalCenter
                            x:13
                            width: 23
                            height: 23
                            source: control.enabled?(control.checked?"image/stoped.png":"image/stoped.png"):"image/nostop.png"
                        }
                        Label{
                            id:lb_stop
                            text: "暂停"
                            anchors.verticalCenter: parent.verticalCenter
                            x:80
                            font.pointSize: 9
                            font.bold: true
                            color: "#f5f5f5"
                        }
                    }
                    label: Label{

                    }
                }

            }
            Button {
                id:btn_end
                text:"停止"
                clip:true
                anchors.bottom: parent.bottom
                height: 50
                width: parent.width
                onClicked: {
                    checked=true;
                }
                style: ButtonStyle{
                    background: Rectangle {
                        color: "#00000000"
                        Rectangle{
                            anchors.fill: parent
                            color:"white"
                            opacity: control.checked ? 0.3 : (control.hovered ?0.2:0)
                        }
                        Image {
                            fillMode: Image.PreserveAspectCrop ;mipmap:true
                            anchors.verticalCenter: parent.verticalCenter
                            x:14
                            width: 21
                            height: 21
                            source: control.enabled?(control.checked?"image/ended.png":"image/ended.png"):"image/noend.png"
                        }
                        Label{
                            id:lb_end
                            text: "停止运行"
                            anchors.verticalCenter: parent.verticalCenter
                            x:80
                            font.pointSize: 9
                            font.bold: true
                            color: "#f5f5f5"
                        }
                    }
                    label: Label{

                    }
                }
            }

        }


        Item{
            id:loader
            x:50
            width: parent.width-20
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            Loader{
                id:welcomeviewloader
                anchors.fill: parent
                visible: true
                source: "welcomeview.qml"
            }
            Loader{
                id:setviewloader
                anchors.fill: parent
                visible: false
                source: "setview.qml"
            }
            Loader{
                id:chartviewloader
                objectName: "chartviewloader"
                anchors.fill: parent
                visible: false
                source: "chartview.qml"
                signal countChanged(int count)
                signal gainChanged(int count)
                signal fftChanged(int count)
                signal chChanged(int stch,int endch)
                signal svChanged(int series,bool visible)
                signal seriesChanged(int chart,int channal)
                onCountChanged: {
                    item.count=count;
                    item.setxmax(count);
                }
                onGainChanged: {
                    item.setymax1(count);
                }
                onFftChanged: {
                    item.setymax2(count);
                }
                onChChanged: {
                    item.clearallseries();
                    item.resetseries(stch,endch);
                }
                onSvChanged: {
                    item.seriesvisible(series,visible)
                }
                onSeriesChanged: {
                    item.updateSeries(chart,channal)
                }

            }

            Loader{
                id:outputviewloader
                anchors.fill: parent
                visible: false
                source: "outputview.qml"
            }
            MouseArea{
                id:contentMask
                z:100
                anchors.fill: parent
                enabled: false
                onPressed: {
                    sidebar.sidebartoggle();
                    console.log("contentMask");

                }
            }
        }


    }

}



