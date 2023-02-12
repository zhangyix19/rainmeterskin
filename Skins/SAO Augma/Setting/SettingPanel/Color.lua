--[[
Name = Color.lua
Author = 雪月花
Vertion = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制SettingPanel皮肤的Color页面
]]

VARIABLE=nil

SELECT_H=nil
SELECT_S=nil
SELECT_V=nil
SELECT_COLOR=nil

function Initialize()
	local IncFolder=SKIN:MakePathAbsolute(SELF:GetOption('IncFolder'))
	HUE_LENGTH=tonumber(SELF:GetOption('HueLength'))
	dofile(IncFolder..'\\Scripts\\Color_RGB_HSV.lua')
end

-- 输入前的设置
function InputColorReady()
	SKIN:Bang('!SetOption','MeasureInput','DefaultValue',SELECT_COLOR)
	SKIN:Bang('!UpdateMeasure','MeasureInput')
	SKIN:Bang('!CommandMeasure','MeasureInput','ExecuteBatch 1')
end

-- 输入以设置颜色
function InputColor(Str)
	local R,G,B=SeperateRGB(Str)
	if R==nil or G==nil or B==nil then return end
	SELECT_COLOR=Str
	SKIN:Bang('!SetOption','SelectColor','Stroke','Stroke Color '..SELECT_COLOR)
	SKIN:Bang('!SetOption','SelectText','Text',SELECT_COLOR)
	SKIN:Bang('!UpdateMeterGroup','Select')
	SELECT_H,SELECT_S,SELECT_V=rgb2hsv(R,G,B)
	SKIN:Bang('!SetOption','HueTri','Y','-'..SELECT_H/360*HUE_LENGTH..'r')
	SKIN:Bang('!UpdateMeter','HueTri')
	local R,G,B=hsv2rgb(SELECT_H,1,1)
	SKIN:Bang('!SetOption','Box2','SolidColor',R..','..G..','..B)
	SKIN:Bang('!SetOption','Box2','SolidColor2',R..','..G..','..B..',0')
	SKIN:Bang('!UpdateMeter','Box2')
	SKIN:Bang('!Redraw')
end

-- 拖拽设置Hue
function DragColorH(H)
	SELECT_H=Clamp(H,0,360)
	local R,G,B=hsv2rgb(SELECT_H,SELECT_S,SELECT_V)
	SELECT_COLOR=R..','..G..','..B
	SKIN:Bang('!SetOption','SelectColor','Stroke','Stroke Color '..SELECT_COLOR)
	SKIN:Bang('!SetOption','SelectText','Text',SELECT_COLOR)
	SKIN:Bang('!UpdateMeterGroup','Select')
	SKIN:Bang('!Redraw')
end

-- 拖拽设置Hue完毕
function SetColorH(H)
	SELECT_H=Clamp(H,0,360)
	local Y=SELECT_H/360*HUE_LENGTH
	SKIN:Bang('!SetOption','HueTri','Y','-'..Y..'r')
	SKIN:Bang('!UpdateMeter','HueTri')
	local R,G,B=hsv2rgb(SELECT_H,1,1)
	SKIN:Bang('!SetOption','Box2','SolidColor',R..','..G..','..B)
	SKIN:Bang('!SetOption','Box2','SolidColor2',R..','..G..','..B..',0')
	SKIN:Bang('!UpdateMeter','Box2')
	local R,G,B=hsv2rgb(SELECT_H,SELECT_S,SELECT_V)
	SELECT_COLOR=R..','..G..','..B
	SKIN:Bang('!SetOption','SelectColor','Stroke','Stroke Color '..SELECT_COLOR)
	SKIN:Bang('!SetOption','SelectText','Text',SELECT_COLOR)
	SKIN:Bang('!UpdateMeterGroup','Select')
	SKIN:Bang('!Redraw')
end

-- 拖拽设置Saturation和Value过程
function DragColorSV(S,V)
	local Ss=Clamp(S,0,1)
	local Vv=Clamp(V,0,1)
	local R,G,B=hsv2rgb(SELECT_H,Ss,Vv)
	local ColorStr=R..','..G..','..B
	SKIN:Bang('!SetOption','SelectColor','Stroke','Stroke Color '..ColorStr)
	SKIN:Bang('!SetOption','SelectText','Text',ColorStr)
	SKIN:Bang('!UpdateMeterGroup','Select')
	SKIN:Bang('!Redraw')
end

-- 拖拽完毕，设置颜色
function SetColorSV(S,V)
	SELECT_S=Clamp(S,0,1)
	SELECT_V=Clamp(V,0,1)
	local R,G,B=hsv2rgb(SELECT_H,SELECT_S,SELECT_V)
	SELECT_COLOR=R..','..G..','..B
	SKIN:Bang('!SetOption','SelectColor','Stroke','Stroke Color '..SELECT_COLOR)
	SKIN:Bang('!SetOption','SelectText','Text',SELECT_COLOR)
	SKIN:Bang('!UpdateMeterGroup','Select')
	SKIN:Bang('!Redraw')
end

---------------------------------------------------

-- 确认更改
function OK()
	if VARIABLE~=nil then
		SKIN:Bang('!SetVariable',VARIABLE,SELECT_COLOR,'#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!CommandMeasure','MeasureScript','PanelBack_Color(true)','#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

-- 取消更改
function Cancel()
	if VARIABLE~=nil then
		SKIN:Bang('!CommandMeasure','MeasureScript','PanelBack_Color(false)','#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

--*************************************************

-- 接收主皮肤的指令，打开页面
function GetData(Option,Variable)
	VARIABLE=Variable
	SELECT_COLOR=SKIN:GetVariable(VARIABLE)
	if SELECT_COLOR=='' then
		SELECT_COLOR='255,0,0'
	end
	SKIN:Bang('!SetOption','Title','Text',Option)
	SKIN:Bang('!UpdateMeter','Title')
	SKIN:Bang('!SetOption','SelectColor','Stroke','Stroke Color '..SELECT_COLOR)
	SKIN:Bang('!SetOption','SelectText','Text',SELECT_COLOR)
	SKIN:Bang('!UpdateMeterGroup','Select')
	SELECT_H,SELECT_S,SELECT_V=rgb2hsv(SeperateRGB(SELECT_COLOR))
	SKIN:Bang('!SetOption','HueTri','Y','-'..SELECT_H/360*HUE_LENGTH..'r')
	SKIN:Bang('!UpdateMeter','HueTri')
	local R,G,B=hsv2rgb(SELECT_H,1,1)
	SKIN:Bang('!SetOption','Box2','SolidColor',R..','..G..','..B)
	SKIN:Bang('!SetOption','Box2','SolidColor2',R..','..G..','..B..',0')
	SKIN:Bang('!UpdateMeter','Box2')
	SKIN:Bang('!ShowMeterGroup','Initialize')
	SKIN:Bang('!Redraw')
end

