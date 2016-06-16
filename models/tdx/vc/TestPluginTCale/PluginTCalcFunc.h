#ifndef __PLUGIN_TCALC_FUNC
#define __PLUGIN_TCALC_FUNC
#pragma pack(push,1) 

//����(���ݸ���,���,����a,����b,����c)
typedef void(*pPluginFUNC)(int,float*,char*,char*,int);

typedef struct tagPluginTCalcFuncInfo
{
	unsigned short		nFuncMark;//�������
	pPluginFUNC			pCallFunc;//������ַ
}PluginTCalcFuncInfo;

typedef BOOL(*pRegisterPluginFUNC)(PluginTCalcFuncInfo**);  

#pragma pack(pop)
#endif
