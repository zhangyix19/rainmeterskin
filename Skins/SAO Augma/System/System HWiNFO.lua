--[[
Name = System Windows.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制System皮肤的HWiNFO部分
]]

function Initialize()
	Check()
	RANGE_MENU=tonumber(SELF:GetOption('MenuHeight'))
	ANI_MENU=0
	SetGPU()
	local Title=tostring(SKIN:GetVariable('SystemTitle'))
	if Title~=nil and Title ~='' then
		SKIN:Bang('!SetOption','Title','Text',Title)
	else
		SKIN:Bang('!SetOption Title Text System')
	end
end

function Check()
	local Type=SKIN:GetVariable('TypeSystem')
	if Type=='HWiNFO' then return
	elseif Type=='Windows' then
		local Size=SKIN:GetVariable('ComponentSize')
		SKIN:Bang('!ActivateConfig','#CurrentConfig#','System '..Size..' Windows.ini')
	else
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

--控制菜单弹出动画
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

function SetGPU()
	local GPUMode=(tonumber(SKIN:GetVariable('Sys_GPUOpt_IfDisabled'))~=0)
	if GPUMode then
		local GPUPos=SeparateNum(SELF:GetOption('GPUPos'))
		SKIN:Bang('!SetOption','GPUBar','Y',GPUPos[1])
		SKIN:Bang('!SetOption','GPUTempBar','Y',GPUPos[2])
	end
end

--*************************************************

--分割数据
function SeparateNum(String)
    local Tab={}
	for Str in string.gmatch(String,'[^|]+') do
		table.insert(Tab,tonumber(Str))
	end
	return Tab
end

