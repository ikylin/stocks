#include "stdafx.h"
#include "TCalcFuncSets.h"

#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
//生成的dll及相关依赖dll请拷贝到通达信安装目录的T0002/dlls/下面,再在公式管理器进行绑定

void gen_singnal_data(char* filename, char* code, int barno, int opt){
	FILE *fp=fopen(filename,"a+");
	if(fp==NULL) return;
	fprintf(fp,"%s|%d|%d",code,barno,opt);
	fclose(fp);
}

int vspf(char *buffer, char *fmt, ...)
{
	va_list argptr;
	int cnt;

	va_start(argptr, fmt);
	cnt = vsprintf(buffer, fmt, argptr);
	va_end(argptr);

	return(cnt);
}

void gen_singnal_cmd(char* filename, char* exepro, char* code, int barno, int opt){
	char cmdstr[80];
	char fnstr[80];
	
	vspf(fnstr, "%s-%s-%d.log", filename, code, barno);
	FILE *fp=fopen(fnstr,"r+");
	if(fp==NULL){
		vspf(cmdstr, "%s %s %d %d", exepro, code, barno, opt);
		printf(cmdstr);
		//system(cmdstr);
		WinExec(cmdstr,SW_NORMAL);
		gen_singnal_data(fnstr,code,barno,opt);
	}else{
		fclose(fp);
	}
}

void TestPlugin1(int DataLen,float* pfOUT, char* exepro, char* code, int barno)
{
	//for(int i=0;i<DataLen;i++)
	//	pfOUT[i]=i;

	//system("cmd");
	//WinExec("cmd",SW_NORMAL);
	gen_singnal_cmd("3", exepro, code, barno, 1);
}

//void TestPlugin2(int DataLen,float* pfOUT,char* filename, char* sound, char* exepro, char* code, int barno, int opt)
void TestPlugin2(int DataLen,float* pfOUT, char* exepro, char* code, int barno)
{
	//for(int i=0;i<DataLen;i++)
	//{
	//	pfOUT[i]=pfINa[i]+pfINb[i]+pfINc[i];
	//	pfOUT[i]=pfOUT[i]/3;
	//}
	system("F:\\new_tdx\\T0002\\dlls\\town.mid");
	gen_singnal_cmd("3", exepro, code, barno, 1);
}


//加载的函数
PluginTCalcFuncInfo g_CalcFuncSets[] = 
{
	{1,(pPluginFUNC)&TestPlugin1},
	{2,(pPluginFUNC)&TestPlugin2},
	{0,NULL},
};

//导出给TCalc的注册函数
BOOL RegisterTdxFunc(PluginTCalcFuncInfo** pFun)
{
	if(*pFun==NULL)
	{
		(*pFun)=g_CalcFuncSets;
		return TRUE;
	}
	return FALSE;
}
