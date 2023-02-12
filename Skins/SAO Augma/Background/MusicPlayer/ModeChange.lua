--[[
Name = ModeChange.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Background\MusicPlayer皮肤，负责切换Background模式
]]

function Initialize()
	mP=SKIN:GetMeasure('mPlayer')
	FLAG=false
	TYPE=tonumber(SKIN:GetVariable('TypeMusic'))
end

function ModeInitial()
	local Player=tonumber(mP:GetValue())
	if Player==nil then
		Error()
		return
	else
		if Player==0 then
			SKIN:Bang('#PlayerOpen#')
		end
		Ordinal()
	end
end

function Ordinal()
	FLAG=true
	SKIN:Bang('!DeactivateConfig','#RootConfig#\\Background\\Main')
	SKIN:Bang('!Hide','#RootConfig#\\Center Processing')
	SKIN:Bang('!HideGroup','AugmaComp')
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\Top','Top Ordinal.ini')
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\Rotator','Ordinal Rotator.ini')
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\Bottom','Bottom Ordinal.ini')
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\MusicPlayer\\PlayerControl','PlayerControl.ini')
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\MusicPlayer\\PlayerProcess','PlayerProcess.ini')
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\MusicPlayer\\PlayerVisualizer','PlayerVisualizer.ini')
	if TYPE>0 then
		SKIN:Bang('!ActivateConfig','#RootConfig#\\MusicPlayer\\Left Info','Infomation #ComponentSize#.ini')
		SKIN:Bang('!ActivateConfig','#RootConfig#\\MusicPlayer\\Right Info','Infomation #ComponentSize#.ini')
		if TYPE>1 then
			print(TYPE)
		end
	end
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\Wallpaper','Wallpaper.ini')
end

function Augma()
	if not FLAG then return
	else
		if TYPE>0 then
			SKIN:Bang('!DeactivateConfig','#RootConfig#\\MusicPlayer\\Left Info')
			SKIN:Bang('!DeactivateConfig','#RootConfig#\\MusicPlayer\\Right Info')
			if TYPE>1 then
				print(TYPE)
			end
		end
		SKIN:Bang('!DeactivateConfig','#RootConfig#\\Background\\Wallpaper')
		SKIN:Bang('!DeactivateConfig','#RootConfig#\\Background\\MusicPlayer\\PlayerControl')
		SKIN:Bang('!DeactivateConfig','#RootConfig#\\Background\\MusicPlayer\\PlayerProcess')
		SKIN:Bang('!DeactivateConfig','#RootConfig#\\Background\\MusicPlayer\\PlayerVisualizer')
		SKIN:Bang('!DeactivateConfig','#RootConfig#\\Background\\Rotator')
		SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\Top','Top.ini')
		SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\Bottom','Bottom.ini')
		SKIN:Bang('!ShowGroup','AugmaComp')
		SKIN:Bang('!Show','#RootConfig#\\Center Processing')
		SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\Main','Main Starter.ini')
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

function Error()
	error('Cannot Get The Value Of Measure [mPlayer]')
	SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
end

