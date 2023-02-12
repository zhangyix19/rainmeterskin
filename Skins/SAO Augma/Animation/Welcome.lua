--[[
Name = Welcome.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Welcome皮肤
]]

function IfFirstTime()
	if tonumber(SKIN:GetVariable('InitializeOver'))==0 then
		ActivateConfig()
		SKIN:Bang('!WriteKeyValue','Variables','InitializeOver','1')
	end
	SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
end

function ActivateConfig()
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\Bottom','Bottom.ini')
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\Top','Top.ini')
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\Main','Main Starter.ini')
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\Recycle','Recycle.ini')
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Background\\Option','Option.ini')
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Notice','NoticeSetPosition #ComponentSize#.ini')
	local SkinWidth=tonumber(SKIN:GetVariable('SkinWidth'))
	if SkinWidth~=nil then
		SKIN:Bang('!Move',SkinWidth*0.78125,SkinWidth*0.05625,'#RootConfig#\\Notice')
	end
	SKIN:Bang('!ActivateConfig','#RootConfig#\\MusicPlayer\\Left Info','Position Initialize.ini')
	SKIN:Bang('!ActivateConfig','#RootConfig#\\MusicPlayer\\Right Info','Position Initialize.ini')
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Center Processing','Processing.ini')
end

