--[[
Name = FolderView.lua
Author = ѩ�»�
Version = 1.0
License = CC BY - NC - SA 4.0
Information = �ű����ڿ���FolderViewƤ��
]]

function Initialize()
	EXT=tostring(SKIN:GetVariable('ViewExtensions'))
	RANGE_MENU=tonumber(SELF:GetOption('MenuHeight'))
	ANI_MENU=0
end

--FileView��ȡ��Ϻ�ִ��
function ViewReady()
	local Measure=SKIN:GetMeasure('mView')
	SetFolderName(Measure:GetStringValue())
	IfFolder()
end

--��ȡ�������ļ�����
function SetFolderName(P)
	local FolderName=StripPath(P)
	SKIN:Bang('!SetOption','Title','Text',FolderName)
end

--�ж���Ŀ�Ƿ�Ϊ�ļ��в�����ͼ��
function IfFolder()
	for i=1,7 do
		local Measure=SKIN:GetMeasure('mType'..i)
		local T=Measure:GetStringValue()
		Measure=SKIN:GetMeasure('mName'..i)
		local N=Measure:GetStringValue()
		local Icon=''
		if N~='' and T=='' then
			Icon='[\\xf07b]'
			SKIN:Bang('!SetOption',i,'LeftMouseDoubleClickAction','[!CommandMeasure mName'..i..' FollowPath][!UpdateMeasure mView]')
		else
			SKIN:Bang('!SetOption',i,'LeftMouseDoubleClickAction','[!CommandMeasure mName'..i..' Open]')
		end
		SKIN:Bang('!SetOption',i..'I','Text',Icon)
	end
	SKIN:Bang('!UpdateMeterGroup Files')
	SKIN:Bang('Redraw')
end

--�򿪵�ǰ�ļ���
function OpenFolder()
	local Measure=SKIN:GetMeasure('mView')
	local Path=Measure:GetStringValue()
	SKIN:Bang('["'..Path..'"]')
end

--�ı���չ��ɸѡ
function ChangeExtensions()
	local Measure=SKIN:GetMeasure('MeasureInput')
	EXT=Measure:GetStringValue()
	local Measure=SKIN:GetMeasure('mView')
	local Path=Measure:GetStringValue()
	SKIN:Bang('!SetOption','mView','Extensions',EXT)
	if Path ~= nil and Path ~= '' then
		SKIN:Bang('!SetOption','mView','Path',Path)
	end
	SKIN:Bang('!SetOption','Extensions','Text',EXT)
	SKIN:Bang('!CommandMeasure mView Update')
	SKIN:Bang('!UpdateMeasure mView')
	SKIN:Bang('!UpdateMeter Extensions')
end

--��¼��չ��
function WriteExtensions()
	local Default=tostring(SKIN:GetVariable('ViewExtensions'))
	if EXT~=Default then
		SKIN:Bang('!WriteKeyValue','Variables','ViewExtensions',EXT,'#@#Config\\Setting.inc')
	end
end

---------------------------------------------------

--���Ʋ˵���������
function CtrlAniMenu()
	if ANI_MENU<=0 then
		SKIN:Bang('!ShowMeter MenuBottom')
		SKIN:Bang('!SetVariable','MenuH_Ani',0)
		SKIN:Bang('!UpdateMeter MenuBottom')
		SKIN:Bang('!Redraw')
		SKIN:Bang('!CommandMeasure MeasureAction "Execute 1"')
	elseif ANI_MENU>=90 then
		SKIN:Bang('!HideMeterGroup Menu')
		SKIN:Bang('!SetVariable','MenuH_Ani',RANGE_MENU)
		SKIN:Bang('!UpdateMeter MenuBottom')
		SKIN:Bang('!Redraw')
		SKIN:Bang('!CommandMeasure MeasureAction "Execute 2"')
	end
end

function AniMenu(N)
	local Pos
	ANI_MENU=ANI_MENU+N
	if tonumber(N)>0 then
		Pos=RANGE_MENU *(math.sin(math.rad(ANI_MENU)))
	else
		Pos=RANGE_MENU - RANGE_MENU *(math.sin(math.rad(90 - ANI_MENU)))
	end
	SKIN:Bang('!SetVariable','MenuH_Ani',Pos)
	SKIN:Bang('!UpdateMeter MenuBottom')
	SKIN:Bang('!UpdateMeasure MeasureAction')
	SKIN:Bang('!Redraw')
end	

--*************************************************

--��·����ȡ�ļ���
function StripPath(Path)
    local Tab={}
	for Str in string.gmatch(Path,'[^\\]+') do
		table.insert(Tab,Str)
	end
	return Tab[#Tab]
end

