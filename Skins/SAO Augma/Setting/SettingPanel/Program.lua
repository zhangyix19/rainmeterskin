--[[
Name = Program.lua
Author = 雪月花
Vertion = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制SettingPanel皮肤的Program页面
]]

OPTION=nil
VARIABLE=nil
TYPE=nil

function MouseOverButton()
	SKIN:Bang('!SetOption','ChooseText','FontColor','255,255,255')
	SKIN:Bang('!SetOption','ChooseButton','Color','Fill Color #ColorSetting#')
	SKIN:Bang('!UpdateMeter','ChooseText')
	SKIN:Bang('!UpdateMeter','ChooseButton')
	SKIN:Bang('!Redraw')
end

function MouseLeaveButton()
	SKIN:Bang('!SetOption','ChooseText','FontColor','#ColorMain1#')
	SKIN:Bang('!SetOption','ChooseButton','Color','Fill Color #ColorMain2#,45')
	SKIN:Bang('!UpdateMeter','ChooseText')
	SKIN:Bang('!UpdateMeter','ChooseButton')
	SKIN:Bang('!Redraw')
end

function InputReady()
	if VARIABLE~=nil then
		SKIN:Bang('!SetOption','BGText','Color','Fill Color #ColorSetting#')
		SKIN:Bang('!SetOption','ProgramText','FontColor','255,255,255')
		SKIN:Bang('!UpdateMeter','BGText')
		SKIN:Bang('!UpdateMeter','ProgramText')
		SKIN:Bang('!Redraw')
		SKIN:Bang('!CommandMeasure','MeasureInput','ExecuteBatch 1')
	end
end

function InputOver()
	local Measure=SKIN:GetMeasure('MeasureInput')
	local Value=Measure:GetStringValue()
	if Value~='' then
		if TYPE=='FOLDER' then
			SKIN:Bang('!SetOption','MeasureIcon','Path',Value)
		elseif TYPE=='FILE' then
			local Name,Dir=StripFile(Value)
			Name=Name or ''
			Dir=Dir or ''
			SKIN:Bang('!SetOption','MeasureIcon','Path',Dir)
			SKIN:Bang('!SetOption','MeasureIcon','WildcardSearch',Name)
		end
	end
	SKIN:Bang('!CommandMeasure','MeasureIcon','Update')
	SKIN:Bang('!SetVariable',VARIABLE,Value)
	SKIN:Bang('!SetOption','ProgramText','Text',OPTION..' :#CRLF#'..Value)
	SKIN:Bang('!SetOption','BGText','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','ProgramText','FontColor','#ColorMain3#')
	SKIN:Bang('!UpdateMeter','ProgramText')
	SKIN:Bang('!UpdateMeter','BGText')
	SKIN:Bang('!Redraw')
end

function InputDismiss()
	SKIN:Bang('!SetOption','BGText','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','ProgramText','FontColor','#ColorMain3#')
	SKIN:Bang('!UpdateMeter','ProgramText')
	SKIN:Bang('!UpdateMeter','BGText')
	SKIN:Bang('!Redraw')
end

function ChooseOver()
	local Measure=SKIN:GetMeasure('MeasureChoose')
	local Value=Measure:GetStringValue()
	if Value~='' then
		if TYPE=='FOLDER' then
			SKIN:Bang('!SetOption','MeasureIcon','Path',Value)
		elseif TYPE=='FILE' then
			local Name,Dir=StripFile(Value)
			Name=Name or ''
			Dir=Dir or ''
			SKIN:Bang('!SetOption','MeasureIcon','Path',Dir)
			SKIN:Bang('!SetOption','MeasureIcon','WildcardSearch',Name)
		end
	end
	SKIN:Bang('!CommandMeasure','MeasureIcon','Update')
	SKIN:Bang('!SetVariable',VARIABLE,Value)
	SKIN:Bang('!SetOption','ProgramText','Text',OPTION..' :#CRLF#'..Value)
	SKIN:Bang('!UpdateMeter','ProgramText')
	SKIN:Bang('!Redraw')
end

function OK()
	if VARIABLE~=nil then
		local Value=SKIN:GetVariable(VARIABLE)
		SKIN:Bang('!SetVariable',VARIABLE,Value,'#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!CommandMeasure','MeasureScript','PanelBack_Program(true)','#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

function Cancel()
	if VARIABLE~=nil then
		SKIN:Bang('!CommandMeasure','MeasureScript','PanelBack_Program(false)','#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

--*************************************************

-- 接收主皮肤的指令，打开页面
function GetData(Option,Variable,Type)
	OPTION=Option
	VARIABLE=Variable
	TYPE=Type
	SKIN:Bang('!SetOption','MeasureInput','DefaultValue','#*'..VARIABLE..'*#')
	SKIN:Bang('!UpdateMeasure','MeasureInput')
	local ProgramPath=SKIN:GetVariable(Variable)
	if ProgramPath~='' then
		if TYPE=='FOLDER' then
			SKIN:Bang('!SetOption','MeasureIcon','Path',ProgramPath)
			SKIN:Bang('!SetOption','ChooseButton','LeftMouseUpAction','[!CommandMeasure MeasureChoose "ChooseFolder 1"]')
		elseif TYPE=='FILE' then
			local Name,Dir=StripFile(ProgramPath)
			Name=Name or ''
			Dir=Dir or ''
			SKIN:Bang('!SetOption','MeasureIcon','Path',Dir)
			SKIN:Bang('!SetOption','MeasureIcon','WildcardSearch',Name)
			SKIN:Bang('!SetOption','MeasureIcon','ShowDotDot',0)
			SKIN:Bang('!SetOption','ChooseButton','LeftMouseUpAction','[!CommandMeasure MeasureChoose "ChooseFile 1"]')
		end
	end
	SKIN:Bang('!SetOption','MeasureIcon','Index',1)
	SKIN:Bang('!SetOption','MeasureIcon','Type','Icon')
	SKIN:Bang('!SetOption','MeasureIcon','IconPath','#@#Temp\\Icon.png')
	SKIN:Bang('!CommandMeasure','MeasureIcon','Update')
	SKIN:Bang('!SetOption','ProgramText','Text',OPTION..' :#CRLF#'..ProgramPath)
	SKIN:Bang('!UpdateMeter','ProgramText')
	SKIN:Bang('!UpdateMeter','ChooseButton')
	SKIN:Bang('!ShowMeterGroup','Initialize')
	SKIN:Bang('!Redraw')
end

-- 由路径获取文件名带后缀
function StripPath(Path)
	return string.match(Path, ".+\\([^\\]*%.%w+)$")
end

-- 由路径获取文件目录和文件名带后缀
function StripFile(Path)
	local Name=StripPath(Path)
	local Dir
	if Name~=nil then
		Dir=string.match(Path,'(.*)'..Name)
	end
	return Name,Dir
end

