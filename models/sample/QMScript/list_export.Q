[General]
SyntaxVersion=2
BeginHotkey=121
BeginHotkeyMod=4
PauseHotkey=0
PauseHotkeyMod=0
StopHotkey=122
StopHotkeyMod=4
RunOnce=1
EnableWindow=
MacroID=c5133627-cff9-48cb-b86e-2624aaf645f8
Description=listexport
Enable=1
AutoRun=0
[Repeat]
Type=0
Number=1
[SetupUI]
Type=2
QUI=
[Relative]
SetupOCXFile=
[Comment]

[Script]


Text = Plugin.File.ReadFileEx("D:\dev\fx\zzg\dl.txt")
dim MyArray
MyArray = Split(Text, "|")
If UBound(MyArray)>=0 Then
   i=0
   For UBound(MyArray)
       
		MoveTo 379, 33
		Delay 100
		RightDown 1
		Delay 100
		RightClick 1
		MoveTo 431, 111
		Delay 100
		LeftDown 1
		Delay 100
		LeftDown 1
		Delay 100
		LeftClick 1
		Delay 100
		LeftUp 1
		
		ColsArray = Split(Cstr(MyArray(i)), "/")
		
		MoveTo 654, 339
		Delay 100
		LeftClick 1
		Delay 100
		LeftUp 1
		Delay 100
		SayString Cstr(ColsArray(0))
		
		MoveTo 688, 341
		Delay 100
		LeftClick 1
		MoveTo 689, 341
		Delay 100
		SayString Cstr(ColsArray(1))
		
		MoveTo 712, 341
		Delay 100
		LeftClick 1
		Delay 100
		SayString Cstr(ColsArray(2))


       /*
       If UBound(ColsArray)>=0 Then
   			j=0
   			For UBound(ColsArray)
       			Delay 100
				Msgbox Cstr(ColsArray(j))
       			Delay 100
       			j=j+1
   			Next
		End If
		Msgbox Cstr(ColsArray(j))
		*/	

		MoveTo 645, 420
		Delay 100
		LeftClick 1
		
		
		//KeyPress "[", 1
		Delay 50000
	
		MoveTo 454, 94
		Delay 100
		LeftClick 1
		KeyPress "3", 1
		Delay 100
		KeyPress "4", 1
		Delay 100
		KeyPress "Enter", 1
		Delay 100
		MoveTo 619, 287
		Delay 100
		LeftClick 1
		Delay 100
		MoveTo 627, 374
		Delay 100
		LeftClick 1
		Delay 100
		MoveTo 746, 468
		Delay 100
		LeftClick 1
		Delay 1000
		MoveTo 753, 423
		Delay 100
		LeftClick 1
		Delay 100
		

       i=i+1
   Next
End If