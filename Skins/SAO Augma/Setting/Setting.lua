--[[
Name = Setting.lua
Author = ѩ�»�
Vertion = 1.0
License = CC BY - NC - SA 4.0
Information = �ű����ڿ���SettingƤ��
]]

LOADITEM=0
TAGPOS=nil
IFRUNNING=false

--=================================================
-- ����ȫ�ֱ���
-- MOUSEPOS
-- SCROLL_H
-- SCROLL_Y
-- TITLETEXT
--=================================================

function Initialize()
	_STYLESCROLL=tostring(SELF:GetOption('ScrollStyle'))
	_RANGESCROLL=tonumber(SELF:GetOption('ScrollHRange'))
	-- UI Text Translate
	_TR_BackToPreviousPage=tostring(SKIN:GetVariable('TR_BackToPreviousPage'))
end

-- �ر�Ƥ��ʱִ��
function CloseSkin()
	SKIN:Bang('!DeactivateConfig','#CurrentConfig#\\CtrlSetting')
end

-- Ƥ���ռ���ʱִ�У�ѡ��Ӧչʾ��ҳ�棬���ؿ���Ƥ��
function SelectLoadItem(N,Pos)
	if IFRUNNING then return
	else
		LOADITEM=N
		TAGPOS=Pos
		IFRUNNING=true
		SKIN:Bang('!ActivateConfig','#CurrentConfig#\\CtrlSetting','Ctrl #ComponentSize#.ini')
	end
end

-- ����Ƥ����ʼ����ϣ�׼������ҳ��
function InitializeOver()
	LoadSetting(LOADITEM,TAGPOS)
end

-- ����������ԭ��ˢ����Ƥ��ʱִ�� (�л�������ɫ)
function RefreshOver(N)
	LOADITEM=N
	LoadSetting(LOADITEM)
end

-- ���������ҳ��
function LoadSetting(N,Pos)
	LOADITEM=N
	-- print('Setting Page '..N..' Is Loaded')
	if LOADITEM==0 then
		SKIN:Bang('!ShowMeterGroup','Main')
		SKIN:Bang('!Redraw')
	else
		-- ҳ�洦��
		SKIN:Bang('!HideMeterGroup','Main')
		SKIN:Bang('!ShowMeter','TitleBar')
		SKIN:Bang('!ShowMeter','TitleText')
		-- ���к���
		if Pos~=nil then
			SKIN:Bang('!CommandMeasure','MeasureScript','LoadSettingPage('..N..',"'..Pos..'")','#CurrentConfig#\\CtrlSetting')
		else
			SKIN:Bang('!CommandMeasure','MeasureScript','LoadSettingPage('..N..')','#CurrentConfig#\\CtrlSetting')
		end
	end
end

---------------------------------------------------
-- ����������
---------------------------------------------------

function DrawScroll()
	SKIN:Bang('!CommandMeasure','MeasureScript','DrawScroll()','#CurrentConfig#\\CtrlSetting')
end

-- ���ƹ�����
function SetScroll(H,Y)
	SCROLL_H=H
	SCROLL_Y=Y
	local Str=string.gsub(_STYLESCROLL,'*',H)
	SKIN:Bang('!SetOption','ScrollBar','Shape',Str)
	SKIN:Bang('!SetOption','ScrollBar','Y',Y..'r')
	SKIN:Bang('!UpdateMeter','ScrollBar')
	SKIN:Bang('!Redraw')
end

-- ȷ����ק������ʱ���λ��
function SetScrollDragStart(Pos)
	local Meter=SKIN:GetMeter('ScrollBar')
	MOUSEPOS=Pos+tonumber(Meter:GetY())
end

-- ��������ק��ʼ
function ScrollDrag(Pos)
	local Y=Pos-MOUSEPOS+SCROLL_Y
	Y=clamp(Y,_RANGESCROLL-SCROLL_H,0)
	SKIN:Bang('!SetOption','ScrollBar','Y',Y..'r')
	SKIN:Bang('!UpdateMeter ScrollBar')
	SKIN:Bang('!Redraw')
	SKIN:Bang('!CommandMeasure','MeasureScript','CalcScroll('..Y..')','#CurrentConfig#\\CtrlSetting')
end

---------------------------------------------------
-- ��궯��
---------------------------------------------------

-- ��������ڱ�ͷʱִ��
function MouseOverTitle()
	local Meter=SKIN:GetMeter('TitleText')
	TITLETEXT=Meter:GetOption('Text')
	SKIN:Bang('!SetOption','TitleText','Text',_TR_BackToPreviousPage)
	SKIN:Bang('!UpdateMeter','TitleText')
	SKIN:Bang('!Redraw')
end

-- ����뿪��ͷʱִ��
function MouseLeaveTitle()
	local Meter=SKIN:GetMeter('TitleText')
	if Meter:GetOption('Text')~=_TR_BackToPreviousPage then
		TITLETEXT=Meter:GetOption('Text')
	end
	SKIN:Bang('!SetOption','TitleText','Text',TITLETEXT)
	SKIN:Bang('!UpdateMeter','TitleText')
	SKIN:Bang('!Redraw')
end

-- �����������ҳ��Ŀʱִ��
function MouseOverMain(N)
	SKIN:Bang('!SetOption','MainTab0'..N-1,'MeterStyle','Style_CTab_3')
	SKIN:Bang('!SetOption','MainTab0'..N,'MeterStyle','Style_CTab_2')
	SKIN:Bang('!UpdateMeter','MainTab0'..N-1)
	SKIN:Bang('!UpdateMeter','MainTab0'..N)
	SKIN:Bang('!Redraw')
end

-- ����뿪��ҳ��Ŀʱִ��
function MouseLeaveMain(N)
	SKIN:Bang('!SetOption','MainTab0'..N-1,'MeterStyle','Style_CTab_1')
	SKIN:Bang('!SetOption','MainTab0'..N,'MeterStyle','Style_CTab_1')
	SKIN:Bang('!UpdateMeter','MainTab0'..N-1)
	SKIN:Bang('!UpdateMeter','MainTab0'..N)
	SKIN:Bang('!Redraw')
end

-- ����������б���Ŀʱִ��
function MouseOverList(N)
	SKIN:Bang('!SetOption','Tab0'..N-1,'MeterStyle','Style_Tab_3')
	SKIN:Bang('!SetOption','Tab0'..N,'MeterStyle','Style_Tab_2')
	SKIN:Bang('!UpdateMeter','Tab0'..N-1)
	SKIN:Bang('!UpdateMeter','Tab0'..N)
	SKIN:Bang('!Redraw')
end

-- ����뿪�б���Ŀʱִ��
function MouseLeaveList(N)
	SKIN:Bang('!SetOption','Tab0'..N-1,'MeterStyle','Style_Tab_1')
	SKIN:Bang('!SetOption','Tab0'..N,'MeterStyle','Style_Tab_1')
	SKIN:Bang('!UpdateMeter','Tab0'..N-1)
	SKIN:Bang('!UpdateMeter','Tab0'..N)
	SKIN:Bang('!Redraw')
end

-- �����������ʱִ��
function InputReady()
	SKIN:Bang('!SetOption','TitleBar','Color','Fill Color #ColorSetting#')
	SKIN:Bang('!SetOption','SearchIcon','FontColor','255,255,255')
	SKIN:Bang('!UpdateMeter','TitleBar')
	SKIN:Bang('!UpdateMeter','SearchIcon')
	SKIN:Bang('!Redraw')
	SKIN:Bang('!CommandMeasure','MeasureInput','ExecuteBatch 1')
end

function InputOver()
	local Measure=SKIN:GetMeasure('MeasureInput')
	local Value=Measure:GetStringValue()
	SKIN:Bang('!SetOption','TitleBar','Color','Fill Color #ColorMain3#,100')
	SKIN:Bang('!SetOption','SearchIcon','FontColor','#ColorMain2#')
	SKIN:Bang('!UpdateMeter','TitleBar')
	SKIN:Bang('!UpdateMeter','SearchIcon')
	SKIN:Bang('!Redraw')
	SKIN:Bang('!CommandMeasure','MeasureScript',"SearchTree('"..Value.."')",'#CurrentConfig#\\CtrlSetting')
end

function InputDismiss()
	SKIN:Bang('!SetOption','TitleBar','Color','Fill Color #ColorMain3#,100')
	SKIN:Bang('!SetOption','SearchIcon','FontColor','#ColorMain2#')
	SKIN:Bang('!UpdateMeter','TitleBar')
	SKIN:Bang('!UpdateMeter','SearchIcon')
	SKIN:Bang('!Redraw')
end

--*************************************************

function clamp(N,Max,Min)
	if N<Min then return Min end
	if N>Max then return Max end
	return N
end


