--[[
Name = SettingCtrl.lua
Author = ѩ�»�
Vertion = 1.0
License = CC BY - NC - SA 4.0
Information = �ű����ڽ�����װ�ڸ�����������SettingƤ��
]]

TRAIL=1			-- ��¼��ǰҳ���ڵ�TREEλ��
PAGE=1			-- ��¼��ǰҳ��
LIST={}
CURRENTITEM=nil
TARGETCONFIG='#RootConfig#\\Setting'
FLAG={Visual=false}
LOADITEM=nil

function Initialize()
	GetConfig()
	local IncFolder=SKIN:MakePathAbsolute(SELF:GetOption('IncFolder'))
	dofile(IncFolder..'\\Setting\\AugmaListCtrl.lua')
	dofile(IncFolder..'\\Scripts\\Color_RGB_HSV.lua')
	dofile(IncFolder..'\\Scripts\\AugmaThemeColor.lua')
	-- ������ҳ��
	MakeAttributeTable(IncFolder..'\\Setting\\AugmaList')
	-- ��ʼ������
	SKIN:Bang('!CommandMeasure','MeasureScript','InitializeOver()',TARGETCONFIG)
end

function CloseSkin()
	if FLAG.Visual then
		local SkinWidth=SKIN:GetVariable('SkinWidth')
		local VisualWidth=math.floor(SkinWidth*0.3072+0.5)
		local BarWidth=SKIN:GetVariable('BarWidth')
		local BarGap=SKIN:GetVariable('BarGap')
		local BarCount=math.floor((VisualWidth+BarGap)/(BarWidth+BarGap))
		if BarCount%2~=1 then BarCount=BarCount+1 end
		VisualWidth=BarCount*(BarWidth+BarGap)-BarGap
		SKIN:Bang('!WriteKeyValue','Variables','BarCount',BarCount,'#@#Config\\Others\\Visualizer.inc')
		SKIN:Bang('!WriteKeyValue','Variables','BandsCount',BarCount+1,'#@#Config\\Others\\Visualizer.inc')
		SKIN:Bang('!WriteKeyValue','Variables','VisualWidth',VisualWidth,'#@#Config\\Others\\Visualizer.inc')
		SKIN:Bang('!WriteKeyValue','Variables','InitOver',0,'#RootConfigPath#Initialize\\Visualizer\\Visualizer Initialize.ini')
		SKIN:Bang('!ActivateConfig','#RootConfig#Initialize\\Visualizer','Visualizer Initialize.ini')
	end
	SKIN:Bang('!Refresh *')
	-- print('Setting Over!')
end

-- ������ȡ
function GetConfig()
	_STYLECOLOR=tostring(SELF:GetOption('ListStyle_Color'))
	_RANGESCROLL=tonumber(SELF:GetOption('ScrollHRange'))
	_COMPOSIZE=tostring(SKIN:GetVariable('ComponentSize'))
	-- UI Text Translate
	_TR_CurrentPage=tostring(SKIN:GetVariable('TR_CurrentPage'))
	_TR_MainTitle={}
	_TR_MainTitle[1]=tostring(SKIN:GetVariable('TR_MainTitleSystem'))
	_TR_MainTitle[2]=tostring(SKIN:GetVariable('TR_MainTitleComponents'))
	_TR_MainTitle[3]=tostring(SKIN:GetVariable('TR_MainTitleColor'))
	_TR_MainTitle[4]=tostring(SKIN:GetVariable('TR_MainTitleApplication'))
	_TR_MainTitle[5]=tostring(SKIN:GetVariable('TR_MainTitleOther'))
	_TR_MainTitle[6]=tostring(SKIN:GetVariable('TR_MainTitleAbout'))
end

-- ���ظ�����ҳ��
function LoadSettingPage(N,Pos)
	if N>=1 and N<=5 then
		SKIN:Bang('!SetOption','TitleBar','Color','Fill Color #ColorSetting#',TARGETCONFIG)
		SKIN:Bang('!SetOption','TitleBar','LeftMouseUpAction','!CommandMeasure MeasureScript MouseBack() "#CurrentConfig#"',TARGETCONFIG)
		SKIN:Bang('!UpdateMeter','TitleBar',TARGETCONFIG)
		SKIN:Bang('!HideMeterGroup','About',TARGETCONFIG)
		SKIN:Bang('!ShowMeter','ListCtrlRange',TARGETCONFIG)
		SKIN:Bang('!ShowMeter','Tab00',TARGETCONFIG)
		LOADITEM=N
		if Pos~=nil then
			TRAIL=LOGPOS[Pos]
		else
			TRAIL=1
		end
		MakeCurrentList()
		DrawList()
		DrawScroll()
	elseif N==6 then
		SKIN:Bang('!SetOption','TitleBar','Color','Fill Color #ColorSetting#',TARGETCONFIG)
		SKIN:Bang('!SetOption','TitleBar','LeftMouseUpAction','!CommandMeasure MeasureScript MouseBack() "#CurrentConfig#"',TARGETCONFIG)
		SKIN:Bang('!UpdateMeter','TitleBar',TARGETCONFIG)
		SKIN:Bang('!SetOption','TitleText','Text',_TR_CurrentPage.._TR_MainTitle[6],TARGETCONFIG)
		SKIN:Bang('!UpdateMeter','TitleText',TARGETCONFIG)
		SKIN:Bang('!ShowMeterGroup','About',TARGETCONFIG)
		LOADITEM=N
		SKIN:Bang('!Redraw',TARGETCONFIG)
	end
end

-- ������ҳ
function BackToMainPage()
	SKIN:Bang('!HideMeterGroup','List',TARGETCONFIG)
	SKIN:Bang('!HideMeterGroup','About',TARGETCONFIG)
	SKIN:Bang('!ShowMeterGroup','Main',TARGETCONFIG)
	SKIN:Bang('!HideMeter','ListCtrlRange',TARGETCONFIG)
	SKIN:Bang('!SetOption','TitleBar','Color','Fill Color #ColorMain3#,100',TARGETCONFIG)
	SKIN:Bang('!SetOption','TitleBar','LeftMouseUpAction','!CommandMeasure MeasureScript InputReady()',TARGETCONFIG)
	SKIN:Bang('!UpdateMeter','TitleBar',TARGETCONFIG)
	SKIN:Bang('!Redraw',TARGETCONFIG)
end

-- ȫ������ɫ���(�л���ɫ\��ɫģʽ)
function ChangeAllColor(IfDay)
	local Mode=nil
	if IfDay then
		Mode='Day'
		ChangeVariable('ColorMain1','255,255,255','#@#Config\\Style.inc')
		ChangeVariable('ColorMain2','0,0,0','#@#Config\\Style.inc')
		ChangeVariable('ColorMain3','117,117,117','#@#Config\\Style.inc')
		ChangeVariable('ColorSetting','200,50,180','#@#Config\\Style.inc')
			SKIN:Bang('!WriteKeyValue','Variables','ColorMain1','255,255,255','#@#Config\\Style.inc')
			SKIN:Bang('!WriteKeyValue','Variables','ColorMain2','0,0,0','#@#Config\\Style.inc')
			SKIN:Bang('!WriteKeyValue','Variables','ColorMain3','117,117,117','#@#Config\\Style.inc')
			SKIN:Bang('!WriteKeyValue','Variables','ColorSetting','200,50,180','#@#Config\\Style.inc')
	else
		Mode='Night'
		ChangeVariable('ColorMain1','0,0,0','#@#Config\\Style.inc')
		ChangeVariable('ColorMain2','255,255,255','#@#Config\\Style.inc')
		ChangeVariable('ColorMain3','189,189,189','#@#Config\\Style.inc')
		ChangeVariable('ColorSetting','160,0,130','#@#Config\\Style.inc')
			SKIN:Bang('!WriteKeyValue','Variables','ColorMain1','0,0,0','#@#Config\\Style.inc')
			SKIN:Bang('!WriteKeyValue','Variables','ColorMain2','255,255,255','#@#Config\\Style.inc')
			SKIN:Bang('!WriteKeyValue','Variables','ColorMain3','189,189,189','#@#Config\\Style.inc')
			SKIN:Bang('!WriteKeyValue','Variables','ColorSetting','160,0,130','#@#Config\\Style.inc')
	end
	for k,v in pairs(ATTR_COLOR) do
		local MainH,MainS,MainV=rgb2hsv(SeperateRGB(SKIN:GetVariable(ATTR_COLOR[k].Color[1])))
		if MainS==0 then
			for i=1,#ATTR_COLOR[k].Color do
				local TargetColor
				if ATTR_COLOR[k][Mode][i].Grey~=nil then
					TargetColor=ATTR_COLOR[k][Mode][i].Grey..','..ATTR_COLOR[k][Mode][i].Grey..','..ATTR_COLOR[k][Mode][i].Grey
				else
					local R,G,B=hsv2rgb(MainH,MainS,1-MainV)
					TargetColor=R..','..G..','..B
				end
				ChangeVariable(ATTR_COLOR[k].Color[i],TargetColor,'#@#Config\\Style.inc')
			end
		else
			for i=1,#ATTR_COLOR[k].Color do
				if ATTR_COLOR[k][Mode][i].V~=nil then
					local NowH=MainH+(ATTR_COLOR[k][Mode][i].H or 0)
					local NowS=ATTR_COLOR[k][Mode][i].S or MainS
					local NowV=ATTR_COLOR[k][Mode][i].V
					local R,G,B=hsv2rgb(NowH,NowS,NowV)
					local TargetColor=R..','..G..','..B
					ChangeVariable(ATTR_COLOR[k].Color[i],TargetColor,'#@#Config\\Style.inc')
				end
			end
		end
	end
end

--*************************************************

function ChangeVariable(Variable,Value,File)
	if Value~=nil then
		SKIN:Bang('!SetVariable',Variable,Value)
	end
	WriteVariable(Variable,Value,File)
end

function WriteVariable(Variable,Value,File)
	if Value==nil then Value=SKIN:GetVariable(Variable) end
	-- print(Variable,Value,File)
	SKIN:Bang('!WriteKeyValue','Variables',Variable,Value,File)
end

