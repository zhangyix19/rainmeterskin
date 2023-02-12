--[[
Name = Input.lua
Author = 雪月花
Vertion = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制SettingPanel皮肤的Input页面
]]

VARIABLE=nil
OPTION=nil
OPTIONPOST=''
DIVIDER=0

function InputReady()
	if VARIABLE~=nil and OPTION~=nil then
		SKIN:Bang('!SetOption','BGInput','Color','Fill Color #ColorSetting#')
		SKIN:Bang('!SetOption','InputTitle','FontColor','255,255,255')
		SKIN:Bang('!UpdateMeter','BGInput')
		SKIN:Bang('!UpdateMeter','InputTitle')
		SKIN:Bang('!Redraw')
		SKIN:Bang('!CommandMeasure','MeasureInput','ExecuteBatch 1')
	end
end

function InputOver(Str)
	local Measure=SKIN:GetMeasure('MeasureInput')
	local Value=Measure:GetStringValue()
	SKIN:Bang('!SetVariable',VARIABLE,Value)
	SKIN:Bang('!SetOption','PreviewText','Text',OPTION..Value..OPTIONPOST)
	SKIN:Bang('!SetOption','BGInput','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','InputTitle','FontColor','#ColorMain1#')
	SKIN:Bang('!UpdateMeter','BGInput')
	SKIN:Bang('!UpdateMeter','InputTitle')
	SKIN:Bang('!UpdateMeter','PreviewText')
	SKIN:Bang('!Redraw')
end

function InputDismiss()
	SKIN:Bang('!SetOption','BGInput','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','InputTitle','FontColor','#ColorMain1#')
	SKIN:Bang('!UpdateMeter','BGInput')
	SKIN:Bang('!UpdateMeter','InputTitle')
	SKIN:Bang('!Redraw')
end

function InputOK()
	if VARIABLE~=nil and OPTION~=nil then
		local Value=SKIN:GetVariable(VARIABLE)
		if DIVIDER~=0 then
			Value=tonumber(Value)*DIVIDER
		end
		SKIN:Bang('!SetVariable',VARIABLE,Value,'#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!CommandMeasure','MeasureScript','PanelBack_Input(true)','#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

function InputCancel()
	if VARIABLE~=nil and OPTION~=nil then
		SKIN:Bang('!CommandMeasure','MeasureScript','PanelBack_Input(false)','#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

--*************************************************

-- 接收主皮肤的指令，打开页面
function GetData(IfNumber,Option,Variable)
	OPTION=Option..' :#CRLF#'
	VARIABLE=Variable
	local Value=SKIN:GetVariable(VARIABLE)
	if DIVIDER~=0 then
		SKIN:Bang('!SetVariable',VARIABLE,tonumber(Value)/DIVIDER)
		SKIN:Bang('!SetOption','PreviewText','Text',OPTION..tonumber(Value)/DIVIDER..OPTIONPOST)
	else
		SKIN:Bang('!SetOption','PreviewText','Text',OPTION..Value..OPTIONPOST)
	end
	SKIN:Bang('!SetOption','MeasureInput','DefaultValue','#*'..VARIABLE..'*#')
	SKIN:Bang('!SetOption','MeasureInput','InputNumber',IfNumber)
	SKIN:Bang('!UpdateMeasure','MeasureInput')
	SKIN:Bang('!UpdateMeter','PreviewText')
	SKIN:Bang('!ShowMeterGroup','Initialize')
	SKIN:Bang('!Redraw')
end

function GetExtra(OptionPost,Divider)
	OPTIONPOST=OptionPost
	DIVIDER=Divider
end

