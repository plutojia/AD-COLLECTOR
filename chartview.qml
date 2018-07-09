import QtQuick 2.0
import QtQuick.Controls 1.4
import QtCharts 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import jia.qt.MyAD 1.0
Item {
    property int count: 256
    property int gain: 10
    property int sample: 1024
    property int stch: 1
    property int endch: 1
    function clearallseries(){
        chart1.removeAllSeries();
        chart2.removeAllSeries();
    }
    function resetseries(st,end){
        stch=st;
        endch=end;
        for(var i=stch;i<endch+1;i++){
        var series1 = chart1.createSeries(ChartView.SeriesTypeLine, "channel"+i,axisX1, axisY1);
        series1.useOpenGL = true;
        var series2 = chart2.createSeries(ChartView.SeriesTypeLine, "channel"+i,axisX2, axisY2);
        series2.useOpenGL = true;
        }
        if(stch<endch){
            chart1.legend.visible=true;
            chart2.legend.visible=true;
        }else{
            chart1.legend.visible=false;
            chart2.legend.visible=false;
        }
    }
    function seriesvisible(series,visible){
        chart1.removeSeries(chart1.series("channel"+series));
        var series1 = chart1.createSeries(ChartView.SeriesTypeLine, "channel"+series,axisX1, axisY1);
        series1.useOpenGL = true;
        chart1.series("channel"+series).visible=visible;
        if(visible===true){
        myad.updateSeries(chart1.series("channel"+series),series);
        }
        chart2.removeSeries(chart2.series("channel"+series));
        var series2 = chart2.createSeries(ChartView.SeriesTypeLine, "channel"+series,axisX2, axisY2);
        series2.useOpenGL = true;
        chart2.series("channel"+series).visible=visible;
        if(visible===true){
        myad.updateSeriesFFT(chart2.series("channel"+series),series);
        }
    }
    function updateSeries(chart,channal){
        if(chart===1){
        myad.updateSeries(chart1.series("channel"+channal),channal,1);
        }else if(chart===2){
        myad.updateSeriesFFT(chart2.series("channel"+channal),channal,1);
        }
    }
    function refresh(){
        clearallseries();
        resetseries(stch,endch);
        for(var i=stch;i<=endch;i++){
            updateSeries(1,i);
            updateSeries(2,i);
        }
    }
    function setxmax(max){
        sample=max;
        chart1.axisX().max=max;
        chart2.axisX().max=max;
    }
    function setymax1(max){
        switch(max){
        case 0:gain=10;break;
        case 1:gain=5;break;
        case 2:gain=2.5;break;
        case 3:gain=1.25;break;
        }
        chart1.axisY().max=gain;
        chart1.axisY().min=-gain;
    }
    function setymax2(max){
        chart2.axisY().max=max;
        chart2.axisY().min=-max;
    }
    function start(){
        if(timer1.running==false){
        timer1.start();
        }
    }
    function stop(){
        if(timer1.running==true){
            timer1.stop();
        }
    }
    function end(){
        timer1.stop();

    }

    Timer{
        id:timer1
        running: false
        interval: 200
        repeat: true
        onTriggered: {
            for(var i=stch;i<endch+1;i++){
            myad.updateSeries(chart1.series("channel"+i),i);
            myad.updateSeriesFFT(chart2.series("channel"+i),i);

            }
        }
    }

    ChartView {
        objectName:"chart1"
        title: "采样波形"
        anchors.top: parent.top
        x: (parent.width - width) / 2
        width:parent.width*0.9
        height: parent.height*0.5
        legend.visible: false
        legend.alignment:Qt.AlignBottom
        antialiasing: true
        id:chart1
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            color: "gray"
            horizontalOffset: 1
            verticalOffset: 1
            radius: 8.0
            samples: 1
        }
        ValueAxis {
            id: axisX1
            min: 0
            max: 1024
            tickCount: 8
        }

        ValueAxis {
            id: axisY1
            min: -10
            max: 10
            tickCount:6
        }

        Component.onCompleted: {
            var series1 = chart1.createSeries(ChartView.SeriesTypeLine, "channel1",axisX1, axisY1);
            series1.useOpenGL = true;
        }

    }
    ChartView {
        objectName:"chart2"
        title: "变换后波形"
        anchors.top: chart1.bottom
        x: (parent.width - width) / 2
        width:parent.width*0.9
        height: parent.height*0.5
        legend.visible: false
        legend.alignment:Qt.AlignBottom
        antialiasing: true
        id:chart2
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            color:"gray"
            horizontalOffset: 1
            verticalOffset: 1
            radius: 8.0
            samples: 1
        }
        ValueAxis {
            objectName:"axisX2"
            id: axisX2
            min: 0
            max: 1024
            tickCount: 8
        }

        ValueAxis {
            id: axisY2
            min: -1000
            max: 1000
            tickCount:6
        }
        Component.onCompleted: {
            var series2 = chart2.createSeries(ChartView.SeriesTypeLine, "channel1",axisX2, axisY2);
            series2.useOpenGL = true;
        }
    }
    MouseArea{
        id:ma1
        anchors.fill: chart1
        acceptedButtons: Qt.RightButton
        onPressed: {
            if(ma1.pressedButtons & Qt.RightButton){
                console.log("sbsdaaaaaa");
                chart1.axisX().max=sample;
                chart1.axisX().min=0;
            }
        }
        onWheel: {
            var wx=wheel.x;
            var length=chart1.axisX().max-chart1.axisX().min

            if(wheel.angleDelta.y<0){
                chart1.axisX().max+=length*0.1*(1-wheel.x/width);
                chart1.axisX().min-=length*0.1*(wheel.x/width);
            }else{
                chart1.axisX().max-=length*0.1*(1-wheel.x/width);
                chart1.axisX().min+=length*0.1*(wheel.x/width);
            }
        }
    }
    MouseArea{
        id:ma2
        anchors.fill: chart2
        acceptedButtons: Qt.RightButton
        onPressed: {
            if(ma2.pressedButtons & Qt.RightButton){
                chart2.axisY().max=1000;
                chart2.axisY().min=-1000;
            }
        }

        onWheel: {
            if(wheel.angleDelta.y<0){
                chart2.axisY().max+=chart2.axisY().max*0.3;
                chart2.axisY().min+=chart2.axisY().min*0.3;
            }else{
                chart2.axisY().max-=chart2.axisY().max*0.3;
                chart2.axisY().min-=chart2.axisY().min*0.3;
            }
        }
    }

}
