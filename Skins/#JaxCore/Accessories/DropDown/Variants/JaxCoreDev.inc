[Variables]
Sec.W=(256*#Sec.S#)
; SaveKey=Fill

[Func]
MEasure=Script
ScriptFile=#@#Lua\Func.lua

; ---------------------------------------------------------------------------- ;
;                                    Content                                   ;
; ---------------------------------------------------------------------------- ;

[Generate Home Screen]
Meter=String
Y=(#Sec.P#)
LeftMouseUpAction=[!ActivateConfig "#JaxCore\Accessories\Gen\Home"][!DeactivateConfig]
MeterStyle=String:S
[Div:1]
Meter=Shape
MeterStyle=Div:S
[Show Welcome Screen]
Meter=String
LeftMouseUpAction=[!CommandMeasure Func "interactionBox('tour1')"]
MeterStyle=String:S
[Div:2]
Meter=Shape
MeterStyle=Div:S
[Show news popup]
Meter=String
LeftMouseUpAction=[!commandMeasure Func "startPopup('News', 'Left')" "#JaxCore\Main"]
MeterStyle=String:S
[Div:3]
Meter=Shape
MeterStyle=Div:S
[CoreGenerator]
Meter=String
LeftMouseUpAction=[!CommandMeasure Func "interactionBox('GenerateCorePage')"]
MeterStyle=String:S