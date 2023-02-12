--[[
Name = Theme.lua
Author = ѩ�»�
Vertion = 1.0
License = CC BY - NC - SA 4.0
Information = �ű����ڿ���SettingPanelƤ����Themeҳ��
]]


COMPONENT=nil
COMPO_COLOR={}
COMPO_ALPHA=nil

GREY_REQUIRE=nil
S_REQUIRE=nil
V_REQUIRE=nil

NOW_H=nil
NOW_S=nil
NOW_V=nil
NOW_COLOR=nil
RECMD_COLOR=nil
SELECT_COLOR=nil
TEMP_COLOR=nil
IDX_CHANGECOLOR=nil
FLAG_CHANGETHEME=nil

IFDAY=nil
POS_MAINMASK=90
POS_COLORMASK=0

function Initialize()
	local IncFolder=SKIN:MakePathAbsolute(SELF:GetOption('IncFolder'))
	HUE_LENGTH=tonumber(SELF:GetOption('HueLength'))
	RANGE_MASKCOLOR=tonumber(SELF:GetOption('ColorMaskRange'))
	RANGE_MASKMAIN=tonumber(SELF:GetOption('MainMaskRange'))
	dofile(IncFolder..'\\Scripts\\AugmaThemeColor.lua')
	dofile(IncFolder..'\\Scripts\\Color_RGB_HSV.lua')
	GetMode()
end

-- ������ɫ
function FreeColor()
	SKIN:Bang('!HideMeterGroup','Theme')
	SKIN:Bang('!ShowMeterGroup','FreeBG')
	for i=1,#COMPO_COLOR do
		SKIN:Bang('!ShowMeterGroup','FreeColor'..i)
	end
	SKIN:Bang('!Redraw')
	POS_MAINMASK=90
	SKIN:Bang('!CommandMeasure','MeasureAction','Execute 1')
end

-- ������ɫ
function FreeBack()
	POS_MAINMASK=0
	SKIN:Bang('!ShowMeter','MainMask')
	SKIN:Bang('!CommandMeasure','MeasureAction','Execute 2')
end

-- ��������ɫ
function ChangeMainColor()
	FLAG_CHANGETHEME=true
	IDX_CHANGECOLOR=1
	TEMP_COLOR={}
	for i=1,#COMPO_COLOR do
		TEMP_COLOR[i]=COMPO_COLOR[i]
	end
	LoadColorPanel(1)
	SKIN:Bang('!Redraw')
	POS_COLORMASK=0
	SKIN:Bang('!ShowMeter','ColorMask')
	SKIN:Bang('!CommandMeasure','MeasureAction','Execute 3')
end

-- ���ĵ�����ɫ
function ChangeColor(N)
	FLAG_CHANGETHEME=false
	IDX_CHANGECOLOR=N
	TEMP_COLOR=COMPO_COLOR[N]
	LoadColorPanel(N)
	SKIN:Bang('!Redraw')
	POS_COLORMASK=0
	SKIN:Bang('!ShowMeter','ColorMask')
	SKIN:Bang('!CommandMeasure','MeasureAction','Execute 3')
end

-- ������ɫѡ��ҳ��
function LoadColorPanel(N)
	NOW_COLOR=COMPO_COLOR[N]
	GetRequire()
	NOW_H,NOW_S,NOW_V=rgb2hsv(SeperateRGB(COMPO_COLOR[N]))
	if NOW_S==0 and GREY_REQUIRE~=nil then
		RECMD_COLOR=GREY_REQUIRE..','..GREY_REQUIRE..','..GREY_REQUIRE
	else
		local R,G,B=hsv2rgb(NOW_H,S_REQUIRE or NOW_S,V_REQUIRE or NOW_V)
		RECMD_COLOR=R..','..G..','..B
	end
	if FLAG_CHANGETHEME then
		SELECT_COLOR=RECMD_COLOR
		SKIN:Bang('!SetOption','NowColor','LeftMouseUpAction','')
		SKIN:Bang('!SetOption','RecommandColor','LeftMouseUpAction','')
	else
		SELECT_COLOR=NOW_COLOR
		SKIN:Bang('!SetOption','NowColor','LeftMouseUpAction','[!CommandMeasure MeasureScript UseNowColor()]')
		SKIN:Bang('!SetOption','RecommandColor','LeftMouseUpAction','[!CommandMeasure MeasureScript UseRecommandColor()]')
	end
	UpdateHue()
	UpdateNowColor()
	UpdateRecommandColor()
	UpdateSelectColor()
end

-- ����͸����ǰ������
function InputAlphaReady()
	SKIN:Bang('!SetOption','MeasureInputAlpha','DefaultValue',COMPO_ALPHA)
	SKIN:Bang('!UpdateMeasure','MeasureInputAlpha')
	SKIN:Bang('!CommandMeasure','MeasureInputAlpha','ExecuteBatch 1')
end

-- ����������͸����
function InputAlpha(AlphaNum)
	COMPO_ALPHA=Clamp(AlphaNum,180,255)
	SKIN:Bang('!SetOption','AlphaText','Text',COMPO_ALPHA)
	SKIN:Bang('!UpdateMeter','AlphaText')
	SKIN:Bang('!SetVariable','CompoAlpha',COMPO_ALPHA)
	UpdatePreview()
	SKIN:Bang('!Redraw')
end

-- ������ɫǰ������
function InputColorReady()
	SKIN:Bang('!SetOption','MeasureInputColor','DefaultValue',SELECT_COLOR)
	SKIN:Bang('!UpdateMeasure','MeasureInputColor')
	SKIN:Bang('!CommandMeasure','MeasureInputColor','ExecuteBatch 1')
end

-- ������������ɫ
function InputColor(Str)
	local R,G,B=SeperateRGB(Str)
	if R==nil or G==nil or B==nil then return end
	NOW_COLOR=Str
	NOW_H,NOW_S,NOW_V=rgb2hsv(R,G,B)
	if NOW_S==0 and GREY_REQUIRE~=nil then
		RECMD_COLOR=GREY_REQUIRE..','..GREY_REQUIRE..','..GREY_REQUIRE
	else
		local R,G,B=hsv2rgb(NOW_H,S_REQUIRE or NOW_S,V_REQUIRE or NOW_V)
		RECMD_COLOR=R..','..G..','..B
	end
	SELECT_COLOR=FLAG_CHANGETHEME and RECMD_COLOR or NOW_COLOR
	UpdateHue()
	UpdateNowColor()
	UpdateRecommandColor()
	UpdateSelectColor()
	if not FLAG_CHANGETHEME then
		COMPO_COLOR[IDX_CHANGECOLOR]=SELECT_COLOR
		SKIN:Bang('!SetVariable','CompoColor_'..IDX_CHANGECOLOR,COMPO_COLOR[IDX_CHANGECOLOR])
	else
		SetThemeColor()
	end
	UpdatePreview()
	SKIN:Bang('!Redraw')
end

-- ��ק����Hue
function DragColorH(H)
	NOW_H=Clamp(H,0,360)
	local R,G,B=hsv2rgb(NOW_H,NOW_S,NOW_V)
	NOW_COLOR=R..','..G..','..B
	R,G,B=hsv2rgb(NOW_H,S_REQUIRE or NOW_S,V_REQUIRE or NOW_V)
	RECMD_COLOR=R..','..G..','..B
	UpdateHue()
	UpdateNowColor()
	UpdateRecommandColor()
	SKIN:Bang('!Redraw')
end

-- ��ק����Hue���
function SetColorH(H)
	NOW_H=Clamp(H,0,360)
	local R,G,B=hsv2rgb(NOW_H,NOW_S,NOW_V)
	NOW_COLOR=R..','..G..','..B
	R,G,B=hsv2rgb(NOW_H,S_REQUIRE or NOW_S,V_REQUIRE or NOW_V)
	RECMD_COLOR=R..','..G..','..B
	SELECT_COLOR=FLAG_CHANGETHEME and RECMD_COLOR or NOW_COLOR
	UpdateHue()
	UpdateNowColor()
	UpdateRecommandColor()
	UpdateSelectColor()
	if not FLAG_CHANGETHEME then
		COMPO_COLOR[IDX_CHANGECOLOR]=SELECT_COLOR
		SKIN:Bang('!SetVariable','CompoColor_'..IDX_CHANGECOLOR,COMPO_COLOR[IDX_CHANGECOLOR])
	else
		SetThemeColor()
	end
	UpdatePreview()
	SKIN:Bang('!Redraw')
end

-- ��ק����S��V
function DragColorSV(S,V)
	NOW_S=Clamp(S,0,1)
	NOW_V=Clamp(V,0,1)
	local R,G,B=hsv2rgb(NOW_H,NOW_S,NOW_V)
	NOW_COLOR=R..','..G..','..B
	if NOW_S==0 or NOW_V==0 and GREY_REQUIRE~=nil then
		RECMD_COLOR=GREY_REQUIRE..','..GREY_REQUIRE..','..GREY_REQUIRE
	else
		R,G,B=hsv2rgb(NOW_H,S_REQUIRE or NOW_S,V_REQUIRE or NOW_V)
		RECMD_COLOR=R..','..G..','..B
	end
	UpdateNowColor()
	UpdateRecommandColor()
	SKIN:Bang('!Redraw')
end

-- ��ק����S,V���
function SetColorSV(S,V)
	NOW_S=Clamp(S,0,1)
	NOW_V=Clamp(V,0,1)
	local R,G,B=hsv2rgb(NOW_H,NOW_S,NOW_V)
	NOW_COLOR=R..','..G..','..B
	if NOW_S==0 or NOW_V==0 and GREY_REQUIRE~=nil then
		RECMD_COLOR=GREY_REQUIRE..','..GREY_REQUIRE..','..GREY_REQUIRE
	else
		R,G,B=hsv2rgb(NOW_H,S_REQUIRE or NOW_S,V_REQUIRE or NOW_V)
		RECMD_COLOR=R..','..G..','..B
	end
	SELECT_COLOR=FLAG_CHANGETHEME and RECMD_COLOR or NOW_COLOR
	UpdateNowColor()
	UpdateRecommandColor()
	UpdateSelectColor()
	if not FLAG_CHANGETHEME then
		COMPO_COLOR[IDX_CHANGECOLOR]=SELECT_COLOR
		SKIN:Bang('!SetVariable','CompoColor_'..IDX_CHANGECOLOR,COMPO_COLOR[IDX_CHANGECOLOR])
	else
		SetThemeColor()
	end
	UpdatePreview()
	SKIN:Bang('!Redraw')
end

-- ѡ��ʹ�õ�ǰ��ɫ
function UseNowColor()
	SELECT_COLOR=NOW_COLOR
	COMPO_COLOR[IDX_CHANGECOLOR]=SELECT_COLOR
	SKIN:Bang('!SetVariable','CompoColor_'..IDX_CHANGECOLOR,COMPO_COLOR[IDX_CHANGECOLOR])
	UpdateSelectColor()
	UpdatePreview()
	SKIN:Bang('!Redraw')
end

-- ѡ��ʹ���Ƽ���ɫ
function UseRecommandColor()
	SELECT_COLOR=RECMD_COLOR
	COMPO_COLOR[IDX_CHANGECOLOR]=SELECT_COLOR
	SKIN:Bang('!SetVariable','CompoColor_'..IDX_CHANGECOLOR,COMPO_COLOR[IDX_CHANGECOLOR])
	UpdateSelectColor()
	UpdatePreview()
	SKIN:Bang('!Redraw')
end

-- ��ɫ�������
function ColorTakeEffect()
	if FLAG_CHANGETHEME then
		SKIN:Bang('!SetOption','MainColor','Color','Fill Color '..COMPO_COLOR[1])
		SKIN:Bang('!UpdateMeter','MainColor')
		for i=1,#COMPO_COLOR do
			SKIN:Bang('!SetOption','FreeColor'..i,'Color','Fill Color '..COMPO_COLOR[i])
		end
		SKIN:Bang('!UpdateMeterGroup','FreeBlock')
		SKIN:Bang('!ShowMeterGroup','Theme')
	else
		SKIN:Bang('!SetOption','FreeColor'..IDX_CHANGECOLOR,'Color','Fill Color '..COMPO_COLOR[IDX_CHANGECOLOR])
		SKIN:Bang('!UpdateMeter','FreeColor'..IDX_CHANGECOLOR)
		if IDX_CHANGECOLOR==1 then
			SKIN:Bang('!SetOption','MainColor','Color','Fill Color '..COMPO_COLOR[1])
			SKIN:Bang('!UpdateMeter','MainColor')
		end
		for i=1,#COMPO_COLOR do
			SKIN:Bang('!ShowMeterGroup','FreeColor'..i)
		end
		SKIN:Bang('!ShowMeterGroup','FreeBG')
	end
	if COMPO_ALPHA~=nil then
		SKIN:Bang('!ShowMeterGroup','Alpha')
	end
	SKIN:Bang('!HideMeterGroup','ColorPanel')
	SKIN:Bang('!Redraw')
	GREY_REQUIRE=nil
	S_REQUIRE=nil
	V_REQUIRE=nil
	NOW_H=nil
	NOW_S=nil
	NOW_V=nil
	NOW_COLOR=nil
	RECMD_COLOR=nil
	SELECT_COLOR=nil
	TEMP_COLOR=nil
	IDX_CHANGECOLOR=nil
	FLAG_CHANGETHEME=nil
	POS_COLORMASK=90
	SKIN:Bang('!CommandMeasure','MeasureAction','Execute 4')
end

-- ��ɫȡ������
function ColorNotTakeEffect()
	if FLAG_CHANGETHEME then
		for i=1,#COMPO_COLOR do
			COMPO_COLOR[i]=TEMP_COLOR[i]
			SKIN:Bang('!SetVariable','CompoColor_'..i,COMPO_COLOR[i])
		end
		SKIN:Bang('!SetOption','MainColor','Color','Fill Color '..COMPO_COLOR[1])
		SKIN:Bang('!UpdateMeter','MainColor')
		SKIN:Bang('!ShowMeterGroup','Theme')
	else
		COMPO_COLOR[IDX_CHANGECOLOR]=TEMP_COLOR
		SKIN:Bang('!SetVariable','CompoColor_'..IDX_CHANGECOLOR,COMPO_COLOR[IDX_CHANGECOLOR])
		SKIN:Bang('!SetOption','FreeColor'..IDX_CHANGECOLOR,'Color','Fill Color '..COMPO_COLOR[IDX_CHANGECOLOR])
		SKIN:Bang('!UpdateMeter','FreeColor'..IDX_CHANGECOLOR)
		for i=1,#COMPO_COLOR do
			SKIN:Bang('!ShowMeterGroup','FreeColor'..i)
		end
		SKIN:Bang('!ShowMeterGroup','FreeBG')
	end
	UpdatePreview()
	if COMPO_ALPHA~=nil then
		SKIN:Bang('!ShowMeterGroup','Alpha')
	end
	SKIN:Bang('!HideMeterGroup','ColorPanel')
	SKIN:Bang('!Redraw')
	GREY_REQUIRE=nil
	S_REQUIRE=nil
	V_REQUIRE=nil
	NOW_H=nil
	NOW_S=nil
	NOW_V=nil
	NOW_COLOR=nil
	RECMD_COLOR=nil
	SELECT_COLOR=nil
	TEMP_COLOR=nil
	IDX_CHANGECOLOR=nil
	FLAG_CHANGETHEME=nil
	POS_COLORMASK=90
	SKIN:Bang('!CommandMeasure','MeasureAction','Execute 4')
end

---------------------------------------------------

-- ����ȷ�ϸ���
function OK()
	if COMPONENT~=nil then
		for i=1,#ATTR_COLOR[COMPONENT].Color do
			SKIN:Bang('!SetVariable',ATTR_COLOR[COMPONENT].Color[i],COMPO_COLOR[i],'#RootConfig#\\Setting\\CtrlSetting')
		end
		if ATTR_COLOR[COMPONENT].Alpha~=nil then
			SKIN:Bang('!SetVariable',ATTR_COLOR[COMPONENT].Alpha,COMPO_ALPHA,'#RootConfig#\\Setting\\CtrlSetting')
		end
		SKIN:Bang('!CommandMeasure','MeasureScript','PanelBack_Theme(true)','#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

-- ����ȡ������
function Cancel()
	if COMPONENT~=nil then
		SKIN:Bang('!CommandMeasure','MeasureScript','PanelBack_Theme(false)','#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

-- ������Ƥ����ָ���ҳ��
function GetData(CompoName)
	COMPONENT=CompoName
	for i=1,#ATTR_COLOR[COMPONENT].Color do
		COMPO_COLOR[i]=tostring(SKIN:GetVariable(ATTR_COLOR[COMPONENT].Color[i]))
		SKIN:Bang('!SetVariable','CompoColor_'..i,COMPO_COLOR[i])
	end
	if ATTR_COLOR[COMPONENT].Alpha~=nil then
		COMPO_ALPHA=tonumber(SKIN:GetVariable(ATTR_COLOR[COMPONENT].Alpha))
		SKIN:Bang('!SetVariable','CompoAlpha',COMPO_ALPHA)
	end
	UpdatePreview()
	-- ͸���Ȳ���
	if COMPO_ALPHA~=nil then
		SKIN:Bang('!SetOption','AlphaText','Text',COMPO_ALPHA)
		SKIN:Bang('!UpdateMeter','AlphaText')
		SKIN:Bang('!ShowMeterGroup','Alpha')
	end
	-- ��ɫɫ�鲿��
	SKIN:Bang('!SetOption','MainColor','Color','Fill Color '..COMPO_COLOR[1])
	SKIN:Bang('!UpdateMeter','MainColor')
	for i=1,#COMPO_COLOR do
		SKIN:Bang('!SetOption','FreeColor'..i,'Color','Fill Color '..COMPO_COLOR[i])
	end
	SKIN:Bang('!UpdateMeterGroup','FreeBlock')
	
	SKIN:Bang('!ShowMeterGroup','Initialize')
	SKIN:Bang('!Redraw')
end

---------------------------------------------------

function ToggleMainMaskAnima(IfToHide)
	local Pos
	if IfToHide then
		POS_MAINMASK=POS_MAINMASK-10
		Pos=RANGE_MASKMAIN*(1-math.sin(math.rad(90-POS_MAINMASK)))
	else
		POS_MAINMASK=POS_MAINMASK+10
		Pos=RANGE_MASKMAIN*math.sin(math.rad(POS_MAINMASK))
	end
	SKIN:Bang('!SetOption','MainMask','W',Pos)
	SKIN:Bang('!UpdateMeter','MainMask')
	SKIN:Bang('!UpdateMeasure','MeasureAction')
	SKIN:Bang('!Redraw')
end

function ToggleColorMaskAnima(IfToHide)
	local Pos
	if IfToHide then
		POS_COLORMASK=POS_COLORMASK-10
		Pos=RANGE_MASKCOLOR*(1-math.sin(math.rad(90-POS_COLORMASK)))
	else
		POS_COLORMASK=POS_COLORMASK+10
		Pos=RANGE_MASKCOLOR*math.sin(math.rad(POS_COLORMASK))
	end
	SKIN:Bang('!SetOption','ColorMask','H',Pos)
	SKIN:Bang('!UpdateMeter','ColorMask')
	SKIN:Bang('!UpdateMeasure','MeasureAction')
	SKIN:Bang('!Redraw')
end

---------------------------------------------------

-- ��ȡ��ǰΪ��ɫģʽ\��ɫģʽ
function GetMode()
	local Main1=tostring(SKIN:GetVariable('ColorMain1'))
	local Main2=tostring(SKIN:GetVariable('ColorMain2'))
	if Main1=='0,0,0' and Main2=='255,255,255' then
		IFDAY=false
	else
		IFDAY=true
	end
end

function GetRequire()
	if IFDAY then
		S_REQUIRE=ATTR_COLOR[COMPONENT].Day[IDX_CHANGECOLOR].S
		V_REQUIRE=ATTR_COLOR[COMPONENT].Day[IDX_CHANGECOLOR].V
		GREY_REQUIRE=ATTR_COLOR[COMPONENT].Day[IDX_CHANGECOLOR].Grey
	else
		S_REQUIRE=ATTR_COLOR[COMPONENT].Night[IDX_CHANGECOLOR].S
		V_REQUIRE=ATTR_COLOR[COMPONENT].Night[IDX_CHANGECOLOR].V
		GREY_REQUIRE=ATTR_COLOR[COMPONENT].Night[IDX_CHANGECOLOR].Grey
	end
end

function UpdateHue()
	local Y=NOW_H/360*HUE_LENGTH
	SKIN:Bang('!SetOption','HueTri','Y','-'..Y..'r')
	SKIN:Bang('!UpdateMeter','HueTri')
	local R,G,B=hsv2rgb(NOW_H,1,1)
	SKIN:Bang('!SetOption','Box2','SolidColor',R..','..G..','..B)
	SKIN:Bang('!SetOption','Box2','SolidColor2',R..','..G..','..B..',0')
	SKIN:Bang('!UpdateMeter','Box2')
end

function UpdateNowColor()
	SKIN:Bang('!SetOption','NowColor','Stroke','Stroke Color '..NOW_COLOR)
	SKIN:Bang('!SetOption','NowText','Text',NOW_COLOR)
	SKIN:Bang('!UpdateMeterGroup','Now')
end

function UpdateRecommandColor()
	SKIN:Bang('!SetOption','RecommandColor','Stroke','Stroke Color '..RECMD_COLOR)
	SKIN:Bang('!SetOption','RecommandText','Text',RECMD_COLOR)
	SKIN:Bang('!UpdateMeterGroup','Recommand')
end

function UpdateSelectColor()
	SKIN:Bang('!SetOption','SelectColor','Stroke','Stroke Color '..SELECT_COLOR)
	SKIN:Bang('!SetOption','SelectText','Text',SELECT_COLOR)
	SKIN:Bang('!UpdateMeterGroup','Select')
end

function UpdatePreview()
	SKIN:Bang('!SetOptionGroup',COMPONENT..'Prev','AntiAlias',1)
	SKIN:Bang('!ShowMeterGroup',COMPONENT..'Prev')
	SKIN:Bang('!UpdateMeterGroup',COMPONENT..'Prev')
end

function SetThemeColor()
	COMPO_COLOR[1]=SELECT_COLOR
	SKIN:Bang('!SetVariable','CompoColor_'..1,COMPO_COLOR[1])
	for i=2,#COMPO_COLOR do
		local ReqH,ReqS,ReqV,ReqGrey
		if IFDAY then
			ReqH=ATTR_COLOR[COMPONENT].Day[i].H
			ReqS=ATTR_COLOR[COMPONENT].Day[i].S
			ReqV=ATTR_COLOR[COMPONENT].Day[i].V
			ReqGrey=ATTR_COLOR[COMPONENT].Day[i].Grey
		else
			ReqH=ATTR_COLOR[COMPONENT].Night[i].H
			ReqS=ATTR_COLOR[COMPONENT].Night[i].S
			ReqV=ATTR_COLOR[COMPONENT].Night[i].V
			ReqGrey=ATTR_COLOR[COMPONENT].Night[i].Grey
		end
		if ReqGrey~=nil then
			if NOW_S==0 or NOW_V==0 then
				COMPO_COLOR[i]=ReqGrey..','..ReqGrey..','..ReqGrey
			else
				local R,G,B=hsv2rgb(NOW_H+ReqH,ReqS,ReqV)
				COMPO_COLOR[i]=R..','..G..','..B
			end
			SKIN:Bang('!SetVariable','CompoColor_'..i,COMPO_COLOR[i])
		end
	end
end

