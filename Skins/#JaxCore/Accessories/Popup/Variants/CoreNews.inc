; ---------------------------------------------------------------------------- ;
;                                   Functions                                  ;
; ---------------------------------------------------------------------------- ;
; ---------------------------------------------------------------------------- ;
;                                    Content                                   ;
; ---------------------------------------------------------------------------- ;
[Image]
ImageName=Variants\Splash\#Sec.Arg1#.png


[Title]
Meter=String
Text=Get to know about S-Hub!
X=(#SEc.W#/2)
StringAlign=Center
MeterStyle=Sec.String:S | Style.Title:S

[Description.1]
Meter=String
Text=▶️ Check it what S-Hub is at jaxcore.app/s-hub!#CRLF#▶️ The first beta test for S-Hub will be live next weekend on our Discord server!
X=(#SEc.W#/2)
StringAlign=Center
Inlinepattern=jaxcore.app/s-hub|first beta test for S-Hub
MeterStyle=Sec.String:S | Style.Description:S




[DA:]
Meter=Shape
X=(#Sec.W#/2-(#Sec.BottomWidth#*3+#Sec.P#)/2)
Y=(#Sec.H#-#Sec.P#-#SEc.BottomHeight#)
Colorover=84, 235, 131
Colorleave=399F59
LeftMouseUpAction=["https://jaxcore.app/s-hub/"]
meterStyle=BottomBox:S | FalseStyleDesk
[DA:String]
Meter=String
StringAlign=CenterCenter
Text=Check it out
MeterStyle=Sec.String:S | BottomText:S
[Core:]
Meter=Shape
; X=(#Sec.W#/2-(#Sec.BottomWidth#*2+#Sec.P#/2)/2)
; Y=(#Sec.H#-#Sec.P#-#SEc.BottomHeight#)
; LeftMouseUpAction=[!WriteKeyvalue Variables Skin.Name """YourMixer""" "#@#SecVar.inc"][!WriteKeyvalue Variables Skin.Set_Page "Info" "#@#SecVar.inc"][!ActivateConfig "#JaxCore\Main" "Settings.ini"][!DeactivateConfig]
LeftMouseUpAction=[!DeactivateConfig]
meterStyle=BottomBox:S | FalseStyleDesk
[Core:String]
Meter=String
StringAlign=CenterCenter
Text=Got it!
MeterStyle=Sec.String:S | BottomText:S
[DiscordServer:]
Meter=Shape
ColorLeave=88, 101, 242,150
ColorOver=88, 101, 242
LeftMouseUpAction=["https://discord.gg/JmgehPSDD6"]
meterStyle=BottomBox:S | FalseStyleDesk
[DiscordServer:String]
Meter=String
StringAlign=CenterCenter
Text=Join the Discord
MeterStyle=Sec.String:S | BottomText:S