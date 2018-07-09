//opem MP422E
extern "C" HANDLE __declspec(dllimport)  __stdcall MP422E_OpenDevice(__int32 dev_num);
//close device
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_CloseDevice(HANDLE hDevice);


//********************************************
//get board info
//model or type in *bStr
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_Info(HANDLE hDevice,char *modle);



//----------------------------EEPROM------------------------------------------
//read  32byte , buffer must great 256
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_EEPROM_Read(HANDLE hDevice,unsigned char *rbuf);

//write length=32
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_EEPROM_Write(HANDLE hDevice, unsigned char *wbuf);

extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_EEPROM_S_Read(HANDLE hDevice,unsigned char *rbuf);

//write length=32
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_EEPROM_S_Write(HANDLE hDevice, unsigned char *wbuf);


//---------------------------------------------------------------------------------------------
//AD
//sammode=0 normal scan AD mode/ =1 SH -burst mode
//trsl: =0 soft /=1 trig
//trpol:=0 rising edge / =1 falling edge
//clksl=0 inner adclk / =1 out clk
//clkpol=0 rsining edge / =1 falling edge
//tdata:=50-65535 , AD cycle=0.1uS * tdata
//gain: 0-3 via 10/5/2.5/1.25V, 4-7 via B10/B5/B2.5/B1.25V
//sidi=1 di input
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_AD(HANDLE hDevice,
														   __int32 stch,__int32 endch,__int32 gain,__int32 sidi,
														   __int32 sammode,__int32 trsl,__int32 trpol,__int32 clksl,__int32 clkpol,
														   __int32 tdata);

extern "C" __int32 __declspec(dllexport)  __stdcall MP422E_CAL(HANDLE hDevice);

//------------------------------------------------------------------------------------------
//polling if end of ad
// if fifo full return -1, else return read length, max length=512K word or =524288 words
// *fdata's length must >=524288
// return -1, fifo error of full, >=0 real read data length
//rdlen: user set data length to readm addata's size must > rdlen
//       rdlen>= MP422E_Poll's return value
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_Read(HANDLE hDevice,__int32 rdlen,__int32 *addata);

//polling state
//<0 fifo over error
//>=0 sam data length for user read
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_Poll(HANDLE hDevice);



//stop
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_StopAD(HANDLE hDevice1);


//convert data to voltage at mV
extern "C" double __declspec(dllimport) __stdcall MP422E_ADV(__int32 adg,__int32 addata);


//DI
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_DI(HANDLE hDevice1);
//DO
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_DO(HANDLE hDevice1,__int32 data);

//-----------------------------------------------------------------------------------------------------
//DA
//set da out range
//g=0 10V / =1 B10v
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_DA_Mode(HANDLE hDevice,__int32 dag0,__int32 dag1);
//set da data , data=0-4095
 //dach=0,1 sel DA channel 0,1
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_DA(HANDLE hDevice,__int32 dach,__int32 dadata);



//---------------------------------------------------------------------------------------------------------
//run or start cnt ch
//cdata: initla cnt data
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_CNT_Run(HANDLE hDevice, __int32 cntch, __int32 cdata);
//read data: cnt data cdata / timer data tdata
//return: <0 error / =0 cnt not over / =1 cnt over
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_CNT_Read(HANDLE hDevice, __int32 cntch,__int32 *cdata, __int32 *tdata);

///start pout and set out eb
//pch =0,1
//pmode: 0 PWM mode / 1 single pulse mode
//PWM mode: pdata0 cycle / padat1 high wideth
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_PRun(HANDLE hDevice,__int32 pch, __int32 pmode,__int32 pdata0, __int32 pdata1);
//return out state, =1 out =1 / =0 out =0
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_PState(HANDLE hDevice,__int32 pch);
//stop pch and enable DO ch recover
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_PEnd(HANDLE hDevice,__int32 pch);
//set pulse out  data
extern "C" __int32 __declspec(dllexport)  __stdcall MP422E_PSetData(HANDLE hDevice,__int32 pch,__int32 pdata0, __int32 pdata1);





///////////////////////////////////////////////////////////////////////////////////////////////////////////
//profetional function
//read 8bit in by adress=adr
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_inb(HANDLE hDevice,__int32 adr);
//write 8bit data by adress=adr
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_outb(HANDLE hDevice1,__int32 adr,__int32 data);


extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_BulkRead(HANDLE hDevice1,unsigned char *bdata,__int32 rdl);
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_ResetUSB(HANDLE hDevice1);

extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_RDCAL(HANDLE hDevice,unsigned __int32 *caldata);
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_WRCAL(HANDLE hDevice,unsigned __int32 *caldata);
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_WRUBUF(HANDLE hDevice,unsigned char *caldata);
extern "C" __int32 __declspec(dllimport)  __stdcall MP422E_RDUBUF(HANDLE hDevice,unsigned char *caldata);

extern "C" __int32 __declspec(dllimport) __stdcall MP422E_KFIFORD(HANDLE hDevice, __int32 rdl , UCHAR *mdata);
extern "C" __int32 __declspec(dllimport) __stdcall MP422E_KFIFOWR(HANDLE hDevice, __int32 wl , UCHAR *mdata);
extern "C" __int32 __declspec(dllimport) __stdcall MP422E_KFIFOPOLL(HANDLE hDevice, __int32 *kfifolen, __int32 *kfifoff, __int32 *kfifost);
extern "C" __int32 __declspec(dllimport) __stdcall MP422E_KFIFORESET(HANDLE hDevice);

extern "C" __int32 __declspec(dllimport) __stdcall MP422E_EEPROM_CWR(HANDLE hDevice,__int32 adr, __int32 len , unsigned char *wdata);
extern "C" __int32 __declspec(dllimport) __stdcall MP422E_EEPROM_CRD(HANDLE hDevice,__int32 adr, __int32 len , unsigned char *rdata);

