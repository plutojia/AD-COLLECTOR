#ifndef MYAD_H
#define MYAD_H
//#define PI 3.14159265358979323846
#define debugmode
#include "windows.h"
#include "MP422E.h"
#include <fstream>
#include <random>
#include <sstream>
#include <string>
#include <QObject>
#include <QMetaObject>
#include <QDebug>
#include <QVariant>
#include <QVector>
#include <QtCore/QtMath>
#include "fft.h"

#include <QtCharts/QAbstractSeries>
#include <QtCharts/QChart>
#include <QtCharts/QLineSeries>

//using namespace std;
QT_CHARTS_USE_NAMESPACE
Q_DECLARE_METATYPE(QAbstractSeries *)
Q_DECLARE_METATYPE(QAbstractAxis *)

class myad : public QObject
{
    Q_OBJECT
public:
    explicit myad(QObject *parent = 0);
    ~myad();
signals:

public slots:
    int start();
    void pause();
    void stop();
public:
    Q_INVOKABLE void setRoot(QObject* rootobject);
    Q_INVOKABLE int updateSeries(QAbstractSeries *series,int channel=1,int force=0);
    Q_INVOKABLE int updateSeriesFFT(QAbstractSeries *series,int channel=1,int force=0);
    Q_INVOKABLE int seriesvisible(int series,bool visible);
    Q_INVOKABLE int setArgs(int stch,int endch,int gain,int sammode,int tdata,int sample);
    Q_INVOKABLE int setOTch(int ch);
    Q_INVOKABLE int setOTchFFT(int ch);
    Q_INVOKABLE int getStch(){return stch;}
    Q_INVOKABLE int getEndch(){return endch;}
    Q_INVOKABLE int getGain(){return gain;}
    Q_INVOKABLE int getSammode(){return sammode;}
    Q_INVOKABLE int getTdata(){return tdata;}
    Q_INVOKABLE int getSample(){return sample;}
    Q_INVOKABLE int saveToFile(QString address);
    Q_INVOKABLE int saveToFileFFT(QString address);
    Q_INVOKABLE int openFile(QString address);
    Q_INVOKABLE int openFileFFT(QString address);
    Q_INVOKABLE int initHandle();
    int getRawData();
    int updateDatas();
    void FFTchange();
    void analyze(int mode=0);
    void analyzeFFT(int mode=0);
    void generateData(int type, int stch,int endch ,int eachCount);
    void generateRawData(int type, int stch,int endch ,int count);
protected:
    void timerEvent(QTimerEvent *event);
private:
    HANDLE hDevice=INVALID_HANDLE_VALUE;  //硬件操作句柄
    int stch;
    int endch;
    int gain;
    int sammode;
    int tdata;
    int sample;
    int sidi=0;
    int trsl=0;
    int trpol=0;
    int clksl=0;
    int clkpol=0;


    int outputTextch=1;
    int outputTextchFFT=1;
    float freq;      //采样频率
    float signalFreq=0;//信号频率
    float signalMax=0;
    float FFTMax=0;
    int m_AdTimer;
    int m_AdTimerInterval;
    int newdata[1000000];
    double rawdata[1000000];

    std::ofstream f;
    std::fstream ftext;
    QObject *root=NULL;
    QObject *outputText=NULL;
    QObject *outputTextFFT=NULL;
    QObject *chart1=NULL;
    QObject *chart2=NULL;
    QObject *chartviewloader=NULL;
    std::random_device rd;
    QVector<bool>svisible;
    QVector<complex* > m_data;
    QVector<complex* > m_dataFTT;
    QVector<QVector<QPointF> > m_points;
    QVector<QVector<QPointF> > m_pointsFFT;
    QVector<bool>dataUpdateState;
    QVector<bool>dataUpdateStateFFT;


};

#endif // MYAD_H
