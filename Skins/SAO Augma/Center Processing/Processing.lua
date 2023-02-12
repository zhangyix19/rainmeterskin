--[[
Name = Processing.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于主题内指令处理中心
]]

function Initialize()
	_mLauncher=SKIN:GetMeasure('mLauncher')
	_mPlayer=SKIN:GetMeasure('mPlayer')
	_mCompoCtrl=SKIN:GetMeasure('mCompoCtrl')

	list={Font={},Color={},Text={}}
	measure={}
	
	measure[1]=SKIN:GetMeasure('mNotice')
	list.Font[1]='Font Awesome 5 Free Solid'
	list.Color[1]=tostring(SKIN:GetVariable('ColorSystem'))
	list.Text[1]='f02c'
	
	measure[2]=SKIN:GetMeasure('mAlarm')
	list.Font[2]='Font Awesome 5 Free Solid'
	list.Color[2]=tostring(SKIN:GetVariable('ColorAlarm'))
	list.Text[2]='f0f3'
	
	measure[3]=SKIN:GetMeasure('mSchedule')
	list.Font[3]='Font Awesome 5 Free Solid'
	list.Color[3]=tostring(SKIN:GetVariable('ColorSchedule'))
	list.Text[3]='f007'
	
	SKIN:Bang('!Update')
	InitialCheck()
end

function Update()
	CheckActive()
end

function CheckActive()
	local Idx=0
	local Total=0
	for i=1,#measure do
		Total=Total+1
		if measure[i]~=nil then
			if tonumber(measure[i]:GetValue())>0 then
				Idx=Idx+1
				SetModule(Idx,i)
			end
		end
	end
	for i=Idx+1,Total do
		SKIN:Bang('!HideMeterGroup','M'..i)
	end
end

function SetModule(Index,Label)
	SKIN:Bang('!SetOption','BG'..Index,'Color','Fill Color '..list.Color[Label]..',#AlphaModule#')
	SKIN:Bang('!SetOption','Icon'..Index,'FontFace',list.Font[Label])
	SKIN:Bang('!SetOption','Icon'..Index,'Text','[\\x'..list.Text[Label]..']')
	SKIN:Bang('!ShowMeterGroup','M'..Index)
end

function InitialCheck()
	if tonumber(SKIN:GetVariable('SendNotice'))~=0 then
		if tonumber(measure[1]:GetValue())<0 then
			SKIN:Bang('!ActivateConfig','#RootConfig#\\Notice','Notice #ComponentSize#.ini')
		end
	else
		if tonumber(measure[1]:GetValue())>0 then
			SKIN:Bang('!DeactivateConfig','#RootConfig#\\Notice')
		end
	end
	if tonumber(SKIN:GetVariable('UseAlarm'))~=0 then
		if tonumber(measure[2]:GetValue())<0 then
			SKIN:Bang('!ActivateConfig','#RootConfig#\\Alarm Clock','Alarm Clock.ini')
		end
	else
		if tonumber(measure[2]:GetValue())>0 then
			SKIN:Bang('!DeactivateConfig','#RootConfig#\\Alarm Clock')
		end
	end
end

---------------------------------------------------

function ToggleCompoCtrl()
	SKIN:Bang('!UpdateMeasureGroup MeasureCompo')
	local AcCompoCtrl=tonumber(_mCompoCtrl:GetValue())
	if AcCompoCtrl==0 then
		error('Cannot get infomation on Skins')
		return
	elseif AcCompoCtrl==-1 then
		if tonumber(_mLauncher:GetValue())>0 or tonumber(_mPlayer:GetValue())>0 then return
		else
			SKIN:Bang('!ActivateConfig','#RootConfig#\\Components Control','Control.ini')
		end
	elseif AcCompoCtrl==1 then
		SKIN:Bang('!DeactivateConfig','#RootConfig#\\Components Control')
	end
end

function OpenSetting(N,Pos)
	SKIN:Bang('!UpdateMeasureGroup MeasureCompo')
	if tonumber(_mLauncher:GetValue())>0 or tonumber(_mPlayer:GetValue())>0 or tonumber(_mCompoCtrl:GetValue())>0 then return
	else
		SKIN:Bang('!ActivateConfig','#RootConfig#\\Setting','Setting #ComponentSize#.ini')
		if Pos==nil then
			SKIN:Bang('!CommandMeasure','MeasureScript','SelectLoadItem('..N..')','#RootConfig#\\Setting')
		else
			SKIN:Bang('!CommandMeasure','MeasureScript',"SelectLoadItem("..N..",'"..Pos.."')",'#RootConfig#\\Setting')
		end
	end
end

function OpenSettingLauncher()
	SKIN:Bang('!DeactivateConfig','#RootConfig#\\Launcher')
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Setting','Setting #ComponentSize#.ini')
	SKIN:Bang('!CommandMeasure','MeasureScript',"SelectLoadItem(4,'MainLauncher')",'#RootConfig#\\Setting')
end

function ToggleLauncher()
	SKIN:Bang('!UpdateMeasureGroup','MeasureCompo')
	if tonumber(_mLauncher:GetValue())>0 then
		SKIN:Bang('!DeactivateConfig','#RootConfig#\\Launcher')
	elseif tonumber(_mCompoCtrl:GetValue())>0 then return
	else
		SKIN:Bang('!ActivateConfig','#RootConfig#\\Launcher','Launcher #ComponentSize#.ini')
	end
end

function OpenMusic()
	SKIN:Bang('!UpdateMeasureGroup','MeasureCompo')
	if tonumber(_mLauncher:GetValue())>0 or tonumber(_mCompoCtrl:GetValue())>0 then return
	else
		SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\MusicPlayer','Mode.ini')
	end
end

