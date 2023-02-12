--[[
Name = Image.lua
Author = 雪月花
Vertion = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制SettingPanel皮肤的Image页面
]]

VARIABLE=nil

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
		SKIN:Bang('!SetOption','ImageText','FontColor','255,255,255')
		SKIN:Bang('!UpdateMeter','BGText')
		SKIN:Bang('!UpdateMeter','ImageText')
		SKIN:Bang('!Redraw')
		SKIN:Bang('!CommandMeasure','MeasureInput','ExecuteBatch 1')
	end
end

function InputOver()
	local Measure=SKIN:GetMeasure('MeasureInput')
	local Value=Measure:GetStringValue()
	local ImageName=StripPath(Value)
	SKIN:Bang('!SetVariable',VARIABLE,Value)
	SKIN:Bang('!SetOption','Image','ImageName',Value)
	SKIN:Bang('!SetOption','ImageText','Text',ImageName)
	SKIN:Bang('!SetOption','BGText','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','ImageText','FontColor','#ColorMain3#')
	SKIN:Bang('!UpdateMeter','Image')
	SKIN:Bang('!UpdateMeter','ImageText')
	SKIN:Bang('!UpdateMeter','BGText')
	SKIN:Bang('!Redraw')
end

function InputDismiss()
	SKIN:Bang('!SetOption','BGText','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','ImageText','FontColor','#ColorMain3#')
	SKIN:Bang('!UpdateMeter','ImageText')
	SKIN:Bang('!UpdateMeter','BGText')
	SKIN:Bang('!Redraw')
end

function ChooseOver(Name)
	local Measure=SKIN:GetMeasure('MeasureChoose')
	local Value=Measure:GetStringValue()
	local ImageName=Name
	SKIN:Bang('!SetVariable',VARIABLE,Value)
	SKIN:Bang('!SetOption','Image','ImageName',Value)
	SKIN:Bang('!SetOption','ImageText','Text',ImageName)
	SKIN:Bang('!UpdateMeter','Image')
	SKIN:Bang('!UpdateMeter','ImageText')
	SKIN:Bang('!Redraw')
end

function OK()
	if VARIABLE~=nil then
		local Value=SKIN:GetVariable(VARIABLE)
		SKIN:Bang('!SetVariable',VARIABLE,Value,'#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!CommandMeasure','MeasureScript','PanelBack_Image(true)','#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

function Cancel()
	if VARIABLE~=nil then
		SKIN:Bang('!CommandMeasure','MeasureScript','PanelBack_Image(false)','#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

--*************************************************

-- 接收主皮肤的指令，打开页面
function GetData(Option,Variable)
	VARIABLE=Variable
	SKIN:Bang('!SetOption','Title','Text',Option)
	SKIN:Bang('!UpdateMeter','Title')
	SKIN:Bang('!SetOption','MeasureInput','DefaultValue','#*'..VARIABLE..'*#')
	SKIN:Bang('!UpdateMeasure','MeasureInput')
	local ImagePath=SKIN:GetVariable(Variable)
	local ImageName=StripPath(ImagePath)
	SKIN:Bang('!SetOption','Image','ImageName',ImagePath)
	SKIN:Bang('!SetOption','ImageText','Text',ImageName)
	SKIN:Bang('!UpdateMeter','Image')
	SKIN:Bang('!UpdateMeter','ImageText')
	SKIN:Bang('!ShowMeterGroup','Initialize')
	SKIN:Bang('!Redraw')
end

--由路径获取文件名带后缀
function StripPath(Path)
	return string.match(Path, ".+\\([^\\]*%.%w+)$")
end
 
