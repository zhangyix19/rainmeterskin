[Variables]
Page.Items.P=(20*[Set.S])
Page.Items.H=(350*[Set.S])
Page.Items.Name.H=(40*[Set.S])
Page.Items.Content.P=(20*[Set.S])

; ---------------------------------------------------------------------------- ;
;                                  MeterStyles                                 ;
; ---------------------------------------------------------------------------- ;
[Item.Shape:S]
X=(20*[Set.S])
Y=(40*[SEt.S])r
Shape=Rectangle 0,0,(#Set.W#-#Set.P#),(50*[SEt.S]),(2*[Set.S]) | StrokeWidth 0 | Extend Fill
Fill=Fill Color #Set.Sec_Color#
Stroke=Stroke Color #Set.Ter_Color#
MouseOverAction=[!SetOption #CURRENTSECTION# Fill "Fill Color #Set.Ter_Color#"][!SetOption #CURRENTSECTION# Stroke "Stroke Color #Set.Subtext_Color#,50"][!UpdateMeter #CURRENTSECTION#][!Redraw]
MouseLeaveAction=[!SetOption #CURRENTSECTION# Fill "Fill Color #Set.Sec_Color#"][!SetOption #CURRENTSECTION# Stroke "Stroke Color #Set.Ter_Color#"][!UpdateMeter #CURRENTSECTION#][!Redraw]
DynamicVariables=1
Container=#Sec.Container#
[Item.StringIcon:S]
X=(50*[Set.S]/2)r
Y=(50*[Set.S]/2)r
FontSize=((16*[SEt.S]))
StringAlign=leftCenter
FontFace=Material Icons Round
Container=#Sec.Container#
[Item.String:S]
X=(#Set.P#/2)R
Y=r
W=(#Set.W#-#Set.P#-85*[SEt.S])
ClipString=2
StringAlign=LeftCenter
Container=#Sec.Container#

[Product.Shape:S]
Shape=Rectangle 0,0,((#Set.W#-#HomePage.P#*2-#Page.Items.P#*2)/3),#Page.Items.H#,(#Set.R#) | StrokeWidth (2*[Set.S]) | Extend Fill | Stroke LinearGradient Gradient
Shape2=Rectangle ((#Set.W#-#HomePage.P#*2-#Page.Items.P#*2)/3-#Page.Items.Content.P#),(#Page.Items.H#-#Page.Items.Content.P#*3-#Page.Items.Name.H#+#Page.Items.Content.P#*2),(-100*[Set.S]),(30*[Set.S]),(15*[Set.S]) | StrokeWidth 0 | Fill Color #Set.Positive_Color#
Gradient=45 | #Set.Ter_Color# ; 0 | #Set.Subtext_Color# ; 1
Fill=Fill Color #Set.Sec_Color#
MouseOverAction=[!SetOption #CURRENTSECTION# Fill "Fill Color #Set.Ter_Color#"][!UpdateMeter #CURRENTSECTION#][!Redraw]
MouseLeaveAction=[!SetOption #CURRENTSECTION# Fill "Fill Color #Set.Sec_Color#"][!UpdateMeter #CURRENTSECTION#][!Redraw]
LeftMouseUpAction=["https://ko-fi.com/jaxoriginals/shop"]
DynamicVariables=1
Container=#Sec.Container#
[Product.Shape:New]
Gradient=45 | #SEt.Accent_Color# ; 1 | #Set.Accent_color_2# ;0
[Product.Image:S]
X=(#Page.Items.Content.P#)r
Y=(#Page.Items.Content.P#)r
W=((#Set.W#-#HomePage.P#*2-#Page.Items.P#*2)/3-#Page.Items.Content.P#*2)
H=(#Page.Items.H#-#Page.Items.Content.P#*3-#Page.Items.Name.H#)
ImageName=#ROOTCONFIGPATH#CoreShell\Home\Assets\Page2\[&Func:trim('#CURRENTSECTION#', '.Image', '')].png
MaskImageName=#ROOTCONFIGPATH#CoreShell\Home\Assets\Page2\Mask.png
DynamicVariables=1
Container=#Sec.Container#
[Product.String:S]
X=r
Y=(#Page.Items.Content.P#)R
W=((#Set.W#-#HomePage.P#*2-#Page.Items.P#*2)/3-#Page.Items.Content.P#*2-100*[Set.S])
FontWeight=650
FontSize=(20*[Set.S])
ClipString=1
InlinePattern= for .*$
InlineSetting=Size | (10*[Set.S])
InlinePattern2= for .*$
InlineSetting2=Weight | 400
Container=#Sec.Container#
[Product.Price.String:S]
X=((#Set.W#-#HomePage.P#*2-#Page.Items.P#*2)/3-#Page.Items.Content.P#*2-50*[Set.S])r
Y=(15*[Set.S])r
Text=Free+
StringAlign=CenterCenter
FontColor=#Set.Pri_Color#
FontWeight=600

[List.Header.String:S]
FontSize=(16*[Set.S])
[List.Header.Shape:S]
X=r
Y=(#Page.Items.P#/2)R
Shape=Line 0,0,(#Set.W#-#HomePage.P#*2),0 | StrokeWidth (2*[Set.S]) | Stroke Color #set.Ter_Color# | StrokeStartCap Round | StrokeEndCap Round
DynamicVariables=1
Container=#Sec.Container#

; ---------------------------------------------------------------------------- ;
;                                      New                                     ;
; ---------------------------------------------------------------------------- ;

[NewOnStock.Header.String]
Meter=String
Text=Fresh in stock
X=(#HomePage.P#)
Y=(110*[Set.S]+#Scroll#)
MeterStyle=Set.String:S | List.Header.String:S
[NewOnStock.Header.Shape]
Meter=Shape
MeterStyle=List.Header.Shape:S

; ----------------------------------- List ----------------------------------- ;

[VeklMixer.Shape]
Meter=Shape
X=r
Y=(#Page.Items.P#)R
LeftMouseUpAction=["https://ko-fi.com/s/f06be1d398"]
MeterStyle=Product.Shape:S | Product.Shape:New
[VeklMixer.Image]
Meter=Image
MeterStyle=Product.Image:S
[VeklMixer.String]
Meter=String
Text="Vekl for YourMixer"
MeterStyle=Set.String:S | Product.String:S
[VeklMixer.Price.String]
Meter=String
MeterStyle=Set.String:S | Product.Price.String:S

[SleekFlyouts.Shape]
Meter=Shape
X=(#HomePage.P#+((#Set.W#-#HomePage.P#*2-#Page.Items.P#*2)/3)+#Page.Items.P#)
Y=([VeklMixer.Shape:Y]-[BC:Y])
LeftMouseUpAction=["https://ko-fi.com/s/da32a5e6d2"]
MeterStyle=Product.Shape:S | Product.Shape:New
[SleekFlyouts.Image]
Meter=Image
MeterStyle=Product.Image:S
[SleekFlyouts.String]
Meter=String
Text="Sleek for YourFlyouts"
MeterStyle=Set.String:S | Product.String:S
[SleekFlyouts.Price.String]
Meter=String
MeterStyle=Set.String:S | Product.Price.String:S

[VeklFlyouts.Shape]
Meter=Shape
X=(#HomePage.P#+((#Set.W#-#HomePage.P#*2-#Page.Items.P#*2)/3)*2+#Page.Items.P#*2)
Y=([VeklMixer.Shape:Y]-[BC:Y])
LeftMouseUpAction=["https://ko-fi.com/s/749a882821"]
MeterStyle=Product.Shape:S | Product.Shape:New
[VeklFlyouts.Image]
Meter=Image
MeterStyle=Product.Image:S
[VeklFlyouts.String]
Meter=String
Text="Vekl for YourFlyouts"
MeterStyle=Set.String:S | Product.String:S
[VeklFlyouts.Price.String]
Meter=String
MeterStyle=Set.String:S | Product.Price.String:S

; ---------------------------------------------------------------------------- ;
;                                      New                                     ;
; ---------------------------------------------------------------------------- ;

[Hot.Header.String]
Meter=String
Text=Hot
X=(#HomePage.P#)
Y=(#Page.Items.P#+#Page.Items.Content.P#*2)R
MeterStyle=Set.String:S | List.Header.String:S
[Hot.Header.Shape]
Meter=Shape
MeterStyle=List.Header.Shape:S

; ----------------------------------- List ----------------------------------- ;

[VeklValli.Shape]
Meter=Shape
X=r
Y=(#Page.Items.P#)R
LeftMouseUpAction=["https://ko-fi.com/s/e4ba7e5dd1"]
MeterStyle=Product.Shape:S
[VeklValli.Image]
Meter=Image
MeterStyle=Product.Image:S
[VeklValli.String]
Meter=String
Text="Vekl for ValliStart"
MeterStyle=Set.String:S | Product.String:S
[VeklValli.Price.String]
Meter=String
Text="$3+"
MeterStyle=Set.String:S | Product.Price.String:S