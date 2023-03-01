
[NoCoverBG]
Meter=Image
ImageName=#IMG#NoCover
ImageAlpha=0
W=410
H=147

[Cover]
Meter=Image
MeasureName=Player
ImageTint=0,0,0,0
[BGCover]
Meter=Image
MeasureName=Player
MaskImageName=#IMG#BG
W=[NoCoverBG:W]
H=270
DynamicVariables=1
ImageCrop=((([Cover:W]-[Cover:H])>0?(([Cover:W]-[Cover:H])/2):0)+([NoCoverBG:W]*0.00/[NoCoverBG:W]*([Cover:H]<[Cover:W]?[Cover:H]:[Cover:W]))),((([Cover:H]-[Cover:W])>0?(([Cover:H]-[Cover:W])/2):0)+([NoCoverBG:W]*0.1/[NoCoverBG:W]*([Cover:H]<[Cover:W]?[Cover:H]:[Cover:W]))),(([Cover:H]<[Cover:W]?[Cover:H]:[Cover:W])*[BGCover:W]/[NoCoverBG:W]),(([Cover:H]<[Cover:W]?[Cover:H]:[Cover:W])*[BGCover:H]/[NoCoverBG:W])

[BG]
Meter=Image
ImageName=#IMG##CurrentSection#
ImageAlpha=180

[NoCover]
Meter=Image
ImageName=#IMG##CurrentSection#
MeterStyle=SCoverStyle
[RoundCover]
Meter=Image
MeasureName=Player
MeterStyle=SCoverStyle

[TextBG]
Meter=String
SolidColor=255,255,255,100
W=410
H=70
Y=196

[MeterTitle]
MeasureName=Title
Meter=String
MeterStyle=MusicInfoStyle
FontColor=#FontColor1#
FontSize=15
Y=212
[MeterArtist]
MeasureName=Artist
Meter=String
MeterStyle=MusicInfoStyle
FontColor=#FontColor2#
FontSize=11
Y=27r

[PlayPause]
Meter=Button
MeterStyle=MusicCtrlStyle
ButtonImage=#IMG#[State]
Y=148
X=([NoCoverBG:W]/2-60/2)
[Previous]
Meter=Button
MeterStyle=MusicCtrlStyle
Y=(148+40/3-2)
X=-35r
[Next]
Meter=Button
MeterStyle=MusicCtrlStyle
Y=(148+40/3-2)
X=([PlayPause:X]+55)

[ProgressBarBG]
Meter=String
SolidColor=230,230,230,200
MeterStyle=ProgressStyle
MouseScrollUpAction=[!CommandMeasure "Player" "Setposition +5"]
MouseScrollDownAction=[!CommandMeasure "Player" "Setposition -5"]
LeftMouseDownAction=[!Commandmeasure "Player" "Setposition $MouseX:%$"]
[ProgressBar]
Meter=Bar
MeasureName=Progress
MeterStyle=ProgressStyle
BarColor=221,94,94
BarOrientation=Horizontal

[MeterPosition]
Meter=STRING
MeterStyle=PDStyle
MeasureName=Position
X=20
[MeterDuration]
Meter=STRING
MeterStyle=PDStyle
MeasureName=Duration
StringAlign=Right
X=(410-20)

[Close]
Meter=Button
ButtonImage=#IMG##CurrentSection#
X=(410-24)
Y=8
LeftMouseUpAction=!DeactivateConfig #CurrentConfig#
