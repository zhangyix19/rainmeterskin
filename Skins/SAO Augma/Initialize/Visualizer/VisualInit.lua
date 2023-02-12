--[[
Name = VisualInit.lua
Author = ѩ�»�
Version = 1.0
License = CC BY - NC - SA 4.0
Information = �ű����ڿ���Visualizer InitializeƤ��
]]

function Initialize()
	local InitFlag=tonumber(SKIN:GetVariable('InitOver'))
	if InitFlag~=0 then
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#') return
	else
		SKIN:Bang('!CommandMeasure','FactoryBars','Factory()')
		SKIN:Bang('!CommandMeasure','FactoryBands','Factory()')
		SKIN:Bang('!CommandMeasure','FactorySmooth','Factory()')
		SKIN:Bang('!WriteKeyValue','Variables','InitOver',1,'#CurrentPath#Visualizer Initialize.ini')
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

