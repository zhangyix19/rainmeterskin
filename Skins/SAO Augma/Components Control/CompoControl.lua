--[[
Name = CompoControl.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Components Control皮肤
]]

composhow={}
compomeasure={'mWeather','mCalendar','mPicture','mSystem','mFolderView','mSchedule','mPower','mCircleLauncher'}
compoproperty={
Name={
	'Weather','Calendar','Picture','System',
	'Folder View','Schedule & Note','Power','Circle Launcher'
	},
Font={
	'Font Awesome 5 Free Solid','Font Awesome 5 Free Solid','Font Awesome 5 Free Regular','Font Awesome 5 Free Solid',
	'Font Awesome 5 Free Solid','Font Awesome 5 Free Solid','Font Awesome 5 Free Solid','Font Awesome 5 Free Solid'
	},
Icon={
	'[\\xf6c4]','[\\xf073]','[\\xf302]','[\\xf109]',
	'[\\xf07c]','[\\xf46d]','[\\xf011]','[\\xf360]'
	},
Color={
	'#ColorWeather2#','#ColorCalendar3#','#ColorPicture#','#ColorSystem#',
	'#ColorView#','#ColorSchedule#','#ColorPower#','220,200,33'
	},
File={
	'Weather #ComponentSize#.ini','Calendar #ComponentSize#.ini','Picture #ComponentSize#.ini','System #ComponentSize# #TypeSystem#.ini',
	'FolderView #ComponentSize#.ini','Schedule #ComponentSize#.ini','Power #ComponentSize#.ini','Circle Launcher #ComponentSize#.ini'
	}}

function Initialize()
	local SkinWidth=tonumber(SKIN:GetVariable('SkinWidth'))
	CENTER=math.floor(SkinWidth*0.5+0.5)
	RADIUS=math.floor(SkinWidth*0.04167+0.5)
	SKIN:Bang('!UpdateMeasureGroup MActive')
end

-- 加载皮肤时运行
function Load()
	-- 获取部件加载信息
	local Idx=0
	for i=1,#compomeasure do
		local Measure=SKIN:GetMeasure(compomeasure[i])
		if tonumber(Measure:GetValue())<0 then
			Idx=Idx+1
			composhow[Idx]=i
		end
	end
	COMPONUM=Idx
	SetPosition()
	SetIcon()
end

-- 设置位置
function SetPosition()
	for i=1,COMPONUM do
		local XPos=CENTER+RADIUS*(2*i-COMPONUM-2)
		SKIN:Bang('!SetOption','Bottom'..i,'X',XPos)
		SKIN:Bang('!ShowMeter',i)
		SKIN:Bang('!ShowMeter Icon'..i)
	end
	for i=COMPONUM+1,#compomeasure do
		SKIN:Bang('!HideMeter',i)
		SKIN:Bang('!HideMeter Icon'..i)
	end
end

-- 设置图标
function SetIcon()
	for i=1,COMPONUM do
		SKIN:Bang('!SetOption','Icon'..i,'FontFace',compoproperty.Font[composhow[i]])
		SKIN:Bang('!SetOption','Icon'..i,'FontColor',compoproperty.Color[composhow[i]])
		SKIN:Bang('!SetOption','Icon'..i,'Text',compoproperty.Icon[composhow[i]])
	end
end

-- 鼠标悬浮于图标时操作
function MouseOver(N)
	SKIN:Bang('!SetOption','Icon'..N,'FontSize','#SizeCompo_F2#')
	SKIN:Bang('!UpdateMeter Icon'..N)
	SKIN:Bang('!ShowMeter Bottom'..N)
	if composhow[N]~=nil then
		SKIN:Bang('!SetOption','Title','Text',compoproperty.Name[composhow[N]])
		SKIN:Bang('!SetOption','Title','FontColor',compoproperty.Color[composhow[N]])
		SKIN:Bang('!ShowMeter Title')
		SKIN:Bang('!UpdateMeter Title')
	end
	SKIN:Bang('!Redraw')
end

-- 鼠标离开图标时操作
function MouseLeave(N)
	SKIN:Bang('!SetOption','Icon'..N,'FontSize','#SizeCompo_F1#')
	SKIN:Bang('!UpdateMeter Icon'..N)
	SKIN:Bang('!HideMeter Bottom'..N)
	SKIN:Bang('!HideMeter Title')
	SKIN:Bang('!Redraw')
end

-- 鼠标点击图标时操作
function MouseClick(N)
	local Measure=SKIN:GetMeasure(compomeasure[composhow[N]])
	local Config=tostring(Measure:GetOption('ConfigName'))
	-- 处理特殊部件的加载要求
	if compomeasure[composhow[N]]=='mSchedule' then
		SKIN:Bang('!DeactivateConfig',Config..'\\ScheduleNotice')
	end
	SKIN:Bang('!ActivateConfig',Config,compoproperty.File[composhow[N]])
	SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
end

