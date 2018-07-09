#include "myad.h"
#include "fft.h"

myad::myad(QObject *parent) : QObject(parent),m_AdTimer(0),m_AdTimerInterval(100),stch(1),endch(1),
                               sample(1024),sammode(0),tdata(100),gain(0)
{
    qRegisterMetaType<QAbstractSeries*>();
    qRegisterMetaType<QAbstractAxis*>();
    dataUpdateState.fill(false,16);
    dataUpdateStateFFT.fill(false,16);
    for(int i(0);i<16;i++){
    m_points.append(QVector<QPointF>(1024));
    m_pointsFFT.append(QVector<QPointF>(1024));
    m_data.append(new (complex[4096]));
    m_dataFTT.append(new (complex[4096]));
    svisible.append(bool(false));
    }
    freq=10000/tdata;
}
myad::~myad(){

}
int myad::initHandle(){
#ifndef debugmode
    if(hDevice==INVALID_HANDLE_VALUE){
        hDevice=MP422E_OpenDevice(0); //创建设备驱动句柄，设备号为0
        if (hDevice==INVALID_HANDLE_VALUE) {
            qDebug()<<"no device found";
            return 1;
        }
        long state=MP422E_CAL(hDevice);
        if(state!=0){
            qDebug()<<"MP442E_CAL failed";return 1;
        }else{
            qDebug()<<"MP442E_CAL successed\n";
            return 0;
        }
    }
#endif
    return 0;
}

int myad::start(){
        if (m_AdTimer==0){
#ifndef debugmode
        long state;
        state=initHandle();
        if(state==1){return -1;}
        state=MP422E_AD(hDevice,stch-1,endch-1, gain,sidi,sammode,trsl, trpol, clksl,clkpol,tdata);
        if(state!=0){
            qDebug()<<"MP442E_AD failed";
            return 1;
        }else{
            qDebug()<<"MP442E_AD successed\n";
        }
#endif
        f.open("E://caocaocaocaocao/QT/chartmetarial1-hardware/output.text",std::ios::out);
        if (!f){qDebug()<<"f err!";return 0;}
        m_AdTimer=startTimer(m_AdTimerInterval);
    }
        return 0;
}
void myad::stop(){
    if (m_AdTimer>0){
        killTimer(m_AdTimer);
        m_AdTimer=0;
#ifndef debugmode
        //退出
        MP422E_StopAD(hDevice);
        MP422E_CloseDevice(hDevice);
        hDevice=INVALID_HANDLE_VALUE;
#endif
        f.close();
    }
}
void myad::pause(){
#ifndef debugmode
        MP422E_StopAD(hDevice);
#endif

}
void myad::timerEvent(QTimerEvent *event){
    static int count=0;
    if(event->timerId()==m_AdTimer){
        getRawData();
        updateDatas();
        FFTchange();
        if(count==8){
        analyze();
        analyzeFFT();
        }
        count=(count==8)?0:count+1;

    }else{
        QObject::timerEvent(event);
    }
}

void myad::setRoot(QObject* rootobject){
    root=rootobject;
    outputText=root->findChild<QObject*>("outputText");
    outputTextFFT=root->findChild<QObject*>("outputTextFFT");
    chart1=root->findChild<QObject*>("chart1");
    chart2=root->findChild<QObject*>("chart2");
    chartviewloader=root->findChild<QObject*>("chartviewloader");
    if(!outputText) qDebug()<<"outputText ont found";
    if(!outputTextFFT) qDebug()<<"outputTextFFT ont found";
    if(!chart1) qDebug()<<"chart1 ont found";
    if(!chart2) qDebug()<<"chart2 ont found";
    if(!chartviewloader) qDebug()<<"chartviewloader ont found";
}
int myad::setArgs(int stch, int endch, int gain, int sammode, int tdata, int sample){
    this->stch=stch;
    this->endch=endch;
    this->gain=gain;
    this->sammode=sammode;
    this->tdata=tdata;
    this->sample=sample;
    freq=10000/(tdata*(endch-stch+1));
    if(this->sammode==1){
        if(this->tdata<100)this->tdata=100;
        freq=10000/tdata;
    }
    QMetaObject::invokeMethod(chartviewloader,"countChanged",Q_ARG(int,sample));
    QMetaObject::invokeMethod(chartviewloader,"gainChanged",Q_ARG(int,gain));
    QMetaObject::invokeMethod(chartviewloader,"chChanged",Q_ARG(int,stch),Q_ARG(int,endch));
    qDebug()<<"stch"<<this->stch<<"endch"<<this->endch<<"gain"<<this->gain<<"sammode"<<this->sammode<<"tdata"<<this->tdata<<"sample"<<this->sample<<"sidi"<<this->sidi<<"trsl"<<this->trsl<<"trpol"<<this->trpol;
    return 0;
}
int myad::setOTch(int ch){
    outputTextch=ch;
    if (m_AdTimer==0){
        analyze();
    }
}
int myad::setOTchFFT(int ch){
    outputTextchFFT=ch;
    if (m_AdTimer==0){
        analyzeFFT();
        }
}


int myad::seriesvisible(int series,bool visible){
    svisible[series-1]=visible;
    if((series>stch-1)&&(series<endch+1)){
        QMetaObject::invokeMethod(chartviewloader,"svChanged",Q_ARG(int,series),Q_ARG(bool,visible));
        dataUpdateState[series-1]=true;
        dataUpdateStateFFT[series-1]=true;
    }
    return 0;
}

int myad::updateSeries(QAbstractSeries *series,int channel,int force){
    if(svisible.at(channel-1)==false){
        return 2;
    }
    if (dataUpdateState[channel-1]==false&&force==0){
        qDebug()<<"data not Update";
        return 1;
    }
    if (series) {
        QLineSeries *xySeries = static_cast<QLineSeries *>(series);

        xySeries->replace(m_points[channel-1]);
    }else{
        qDebug()<<"series is unavailale";
        return -1;
    }
    dataUpdateState[channel-1]=false;
    qDebug()<<"series updated";
    return 0;
}

int myad::updateSeriesFFT(QAbstractSeries *series,int channel,int force){
    if(svisible[channel-1]==false){
        return 2;
    }
    if (dataUpdateStateFFT[channel-1]==false&&force==0){
        qDebug()<<"dataFFT not Update";
        return 1;
    }
    if (series) {
        QLineSeries *xySeries = static_cast<QLineSeries *>(series);

        xySeries->replace(m_pointsFFT[channel-1]);
    }else{
        qDebug()<<"seriesFFT is unavailale";
        return -1;
    }
    dataUpdateStateFFT[channel-1]=false;
    qDebug()<<"seriesFFT updated";
    return 0;
}

int myad::getRawData(){
    int readlen;
#ifdef debugmode
    readlen=4096;
    generateRawData(0,stch,endch,4096);
#else
    int bufflen=0;
    long state;
    bufflen=MP422E_Poll(hDevice);
    if (bufflen<0){
        qDebug()<<"data overflow(MP422E_Poll)";
        state=1;
    }
    if (bufflen>1000000) bufflen=1000000;
    int tmp=bufflen%(endch-stch+1);
    bufflen-=tmp;
    readlen=MP422E_Read(hDevice,bufflen,newdata);
    if (readlen<0){
        qDebug()<<"data overflow(MP422E_Read)";
        state=1;
    }
    for(int i=0;i<readlen;i++){
        rawdata[i]=MP422E_ADV(gain,newdata[i]);
    }
#endif
//    for(int i=0;i<readlen;i++){
//    f<<"rawdata["<<i<<"]:"<<rawdata[i]<<"\n";
//    }
//    return 0;
}

int myad::updateDatas(){
    int sumCh=endch-stch+1;
    for (int i(0); i < sample;i++){
        for (int j(stch-1); j < endch; j++){
            struct complex a={rawdata[i*sumCh+j]/1000.0,0.0};
            m_data[j][i]=a;
        }
    }

    for (int j(stch-1); j < endch; j++){
        QVector<QPointF> points;
        points.reserve(sample);
        for (int i(0); i < sample; i++){
            points.append(QPointF(i, m_data[j][i].real));
        }
        m_points.replace(j,points);
        qDebug()<<points.count();
        dataUpdateState[j]=true;
    }
    qDebug()<<"data updated";
    return 0;
}
void myad::analyze(int mode){
    double max=0;
    int mx=0;
    double min=0;
    int mn=0;
    double average=0;//幅度
    QString result;
    for(int i(0);i<sample;i++){
        if (max<m_points[outputTextch-1][i].y()){
            max=m_points[outputTextch-1][i].y();
            mx=i;
        }
        if (min>m_points[outputTextch-1][i].y()){
            min=m_points[outputTextch-1][i].y();
            mn=i;
        }
        average+=m_points[outputTextch-1][i].y();
    }
    average/=sample;

    result+="信号"+QString::number(outputTextch)+":\n"+
            "最大值:"+QString::number(max)+" 值最大点："+QString::number(mx+1)+
            "\n最小值:"+QString::number(min)+" 值最小点："+QString::number(mn+1)+
            "\n信号均值:"+QString::number(average)+"\n"+
            "部分数据(完整数据请保存后查看)：\n";
    int step=(mode==0?sample/50:1);
    for(int i(0);i<sample;i+=step){
        result+="点"+QString::number(i+1)+":"+
                QString::number(m_points[outputTextch-1][i].y())+"  "+
                QString::number(0.0)+"\n";
    }

    QMetaObject::invokeMethod(outputText,"unpdate",Q_ARG(QString,result));
    return;
}
void myad::analyzeFFT(int mode){

    double max=0;
    int mx=0;
    double amplitude;//幅度
    double phase;
    QString result;
    for(int i(3);i<sample;i++){
        if (max<m_pointsFFT[outputTextchFFT-1][i].y()){
            max=m_pointsFFT[outputTextchFFT-1][i].y();
            mx=i;
        }
    }
    FFTMax=max;
    double maxzhi=m_pointsFFT[outputTextchFFT-1][0].y();
    double amplitudezhi=maxzhi/sample;
    signalFreq=float(mx+1)*freq/sample;
    phase=atan2(m_data[outputTextchFFT-1][mx].imag,m_data[outputTextchFFT-1][mx].real);
    amplitude=FFTMax*2/sample;
    result+="信号"+QString::number(outputTextchFFT)+"FFT:\n"+
            "最大模值:"+QString::number(FFTMax)+" 模值最大点："+QString::number(mx+1)+
            "\n直流模值:"+QString::number(maxzhi)+" 直流幅度："+QString::number(amplitudezhi)+
            "\n信号频率:"+QString::number(signalFreq)+" 信号幅度:"+QString::number(amplitude)+
            " 信号相位:"+QString::number(phase)+"\n"+
            "部分数据(完整数据请保存后查看)：\n";
    int step=(mode==0?sample/50:1);
    for(int i(0);i<sample;i+=step){
        result+="点"+QString::number(i+1)+":"+
                QString::number(m_data[outputTextchFFT-1][i].real)+"  "+
                QString::number(m_data[outputTextchFFT-1][i].imag)+"\n";
    }

    QMetaObject::invokeMethod(outputTextFFT,"unpdate",Q_ARG(QString,result));
    return;
}
int myad::saveToFile(QString address){
    std::string add=address.toStdString().substr(8,-1);
    qDebug()<<add.c_str();
    ftext.open(add,std::ios::out);
    if (!ftext){
        qDebug()<<"f err!";
        return -1;
    }
    ftext.setf(std::ios::fixed, std::ios::floatfield);
    ftext.precision(4);
    double max=0;
    int mx=0;
    double min=0;
    int mn=0;
    double average=0;//幅度
    for(int i(0);i<sample;i++){
        if (max<m_points[outputTextch-1][i].y()){
            max=m_points[outputTextch-1][i].y();
            mx=i;
        }
        if (min>m_points[outputTextch-1][i].y()){
            min=m_points[outputTextch-1][i].y();
            mn=i;
        }
        average+=m_points[outputTextch-1][i].y();
    }
    average/=sample;

    ftext<<"信号"<<outputTextch<<":\n";
    ftext<<"最大值:"<<max<<" 值最大点："<<mx+1;
    ftext<<"\n最小值:"<<min<<" 值最小点："<<mn+1;
    ftext<<"\n信号均值:"<<average<<"\n";
    ftext<<"完整数据：\n";
    for(int i(0);i<sample;i+=1){
        ftext<<"点"<<i+1<<":";
        ftext<<m_points[outputTextch-1][i].y()<<"  ";
        ftext<<0.0<<"\n";
    }

    ftext.close();
    return 0;
}
int myad::saveToFileFFT(QString address){
    std::string add=address.toStdString().substr(8,-1);
    qDebug()<<add.c_str();
    ftext.open(add,std::ios::out);
    if (!ftext){
        qDebug()<<"f err!";
        return -1;
    }
    ftext.setf(std::ios::fixed, std::ios::floatfield);
    ftext.precision(4);
    double max=0;
    int mx=0;
    double amplitude;//幅度
    double phase;
    for(int i(3);i<sample;i++){
        if (max<m_pointsFFT[outputTextchFFT-1][i].y()){
            max=m_pointsFFT[outputTextchFFT-1][i].y();
            mx=i;
        }
    }
    FFTMax=max;
    double maxzhi=m_pointsFFT[outputTextchFFT-1][0].y();
    double amplitudezhi=maxzhi/sample;
    signalFreq=float(mx+1)*freq/sample;
    phase=atan2(m_data[outputTextchFFT-1][mx].imag,m_data[outputTextchFFT-1][mx].real);
    amplitude=FFTMax*2/sample;

    ftext<<"信号"<<outputTextchFFT<<"FFT:\n";
    ftext<<"最大模值:"<<FFTMax<<" 模值最大点："<<mx+1;
    ftext<<"\n直流模值:"<<maxzhi<<" 直流幅度："<<amplitudezhi;
    ftext<<"\n信号频率:"<<signalFreq<<" 信号幅度:"<<amplitude;
    ftext<<" 信号相位:"<<phase<<"\n";
    ftext<<"完整数据：\n";
    for(int i(0);i<sample;i+=1){
        ftext<<"点"<<i+1<<":";
        ftext<<m_data[outputTextchFFT-1][i].real<<"  ";
        ftext<<m_data[outputTextchFFT-1][i].imag<<"\n";
    }
    ftext.close();
    return 0;
}
int myad::openFile(QString address){
    std::string add=address.toStdString().substr(8,-1);
    qDebug()<<add.c_str();
    ftext.open(add,std::ios::in);
    if (!ftext){
        qDebug()<<"f err!";
        return -1;
    }
    ftext.seekg(0, ftext.end);
    int length = ftext.tellg();
    ftext.seekg(0, ftext.beg);
    char * buffer = new char [length];

    qDebug() << "Reading " << length << " characters... ";

    ftext.read(buffer,length);
    QString content(buffer);

    QRegExp rx("点\\d+:(-?\\d+\\.\\d+)\\s+(-?\\d+\\.\\d+)");
    int pos = 0;
    int count=0;
    while (((pos = rx.indexIn(content, pos)) != -1)&&(count<sample)) {
        pos += rx.matchedLength();
        m_data[outputTextch-1][count].real=rx.cap(1).toFloat();
        //qDebug()<<rx.cap(1)<<" "<<rx.cap(1).toFloat();
        m_data[outputTextch-1][count].imag=rx.cap(2).toFloat();
        count++;
    }
    QVector<QPointF> points;
    points.reserve(sample);
    for (int i(0); i < count; i++){
        points.append(QPointF(i, m_data[outputTextch-1][i].real));
    }
    for (int i(count); i < sample; i++){
        points.append(QPointF(i, 0));
    }
    m_points.replace(outputTextch-1,points);
    qDebug()<<points.count();
    dataUpdateState[outputTextch-1]=true;
    QMetaObject::invokeMethod(chartviewloader,"seriesChanged",Q_ARG(int,1),Q_ARG(int,outputTextch));
    ftext.close();
    analyze(1);
    return 0;
}
int myad::openFileFFT(QString address){
    std::string add=address.toStdString().substr(8,-1);
    qDebug()<<add.c_str();
    ftext.open(add,std::ios::in);
    if (!ftext){
        qDebug()<<"f err!";
        return -1;
    }
    ftext.seekg(0, ftext.end);
    int length = ftext.tellg();
    ftext.seekg(0, ftext.beg);
    char * buffer = new char [length];

    qDebug() << "Reading " << length << " characters... ";

    ftext.read(buffer,length);
    QString content(buffer);

    QRegExp rx("点\\d+:(-?\\d+\\.\\d+)\\s+(-?\\d+\\.\\d+)");
    int pos = 0;
    int count=0;
    while (((pos = rx.indexIn(content, pos)) != -1)&&(count<sample)) {
        pos += rx.matchedLength();
        m_data[outputTextchFFT-1][count].real=rx.cap(1).toFloat();
        //qDebug()<<rx.cap(1)<<" "<<rx.cap(1).toFloat();
        m_data[outputTextchFFT-1][count].imag=rx.cap(2).toFloat();
        count++;
    }
    QVector<QPointF> points;
    points.reserve(sample);
    for (int i(0); i < count; i++){
        points.append(QPointF(i, m_data[outputTextchFFT-1][i].real));
    }
    for (int i(count); i < sample; i++){
        points.append(QPointF(i, 0));
    }
    m_pointsFFT.replace(outputTextchFFT-1,points);
    qDebug()<<points.count();
    dataUpdateStateFFT[outputTextchFFT-1]=true;
    QMetaObject::invokeMethod(chartviewloader,"seriesChanged",Q_ARG(int,2),Q_ARG(int,outputTextchFFT));
    ftext.close();
    analyzeFFT(1);
    return 0;
}
void myad::generateRawData(int type, int stch,int endch ,int count)
{
    // count 总点数
    int sumCh=endch-stch+1;
    for (int i(0),ch(stch); i < count*sumCh; i++,ch++){
        if(ch>endch) {ch=stch;}
        switch (type) {
        case 0:
            rawdata[i]=500*ch*(qSin(PI*2*10/freq*int(i/sumCh))+ 0.5 + (qreal) rand() / (qreal) RAND_MAX);
            break;
        case 1:
            // linear data
            rawdata[i]=500*ch*pow(-1,round(int(i/sumCh)*10/(freq/2)));
            break;
        case 2:
            rawdata[i]=4000;
            break;
        default:
            // unknown, do nothing
            break;
        }
    }
    qDebug()<<"raw data generated";
}

void myad::FFTchange(){
    for (int i(stch-1); i < endch; i++){
        fft(sample, m_data[i]);     //进行FFT处理
    }
    for (int j(stch-1); j < endch; j++){
        QVector<QPointF> points;
        points.reserve(sample);
        for (int i(0); i < sample; i++){
            points.append(QPointF(i,sqrtf(m_data[j][i].real*m_data[j][i].real+m_data[j][i].imag*m_data[j][i].imag)));
        }
        m_pointsFFT.replace(j,points);
        qDebug()<<points.count();
        dataUpdateStateFFT[j]=true;
    }
    qDebug()<<"dataFFT updated";
}




