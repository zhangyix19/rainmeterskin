--[[
Name = Launcher.lua
Author = 雪月花
Vertion = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制SettingPanel皮肤的Launcher页面
]]

FLAG_IFNEWDOCK=nil
FLAG_IFUSECOLOR=nil
FLAG_IFDISABLE=false
GROUP=nil
DOCKPRE=nil
DOCKNUM=nil
INDEX=nil
DEFAULT_S=0.7
DEFAULT_V=240/255
CONFIG_FILE=nil

function Initialize()
	local IncFolder=SKIN:MakePathAbsolute(SELF:GetOption('IncFolder'))
	dofile(IncFolder..'\\Scripts\\Color_RGB_HSV.lua')
	DEFAULTICON=SELF:GetOption('DefaultIcon')
	DEFAULTNAME=SELF:GetOption('DefaultName')
	DEFAULTPATH=SELF:GetOption('DefaultPath')
	DEFAULTCOLOR=SELF:GetOption('DefaultColor')
	HUE_LENGTH=SELF:GetOption('HueLength')
	-- UI Text Translate
	_TR_LauncherBackColor=SKIN:GetVariable('TR_LauncherBackColor')
	_TR_LauncherGroupTitle=SKIN:GetVariable('TR_LauncherGroupTitle')
end

function DragColor(Hue)
	local H=Clamp(Hue,0,360)
	local R,G,B=hsv2rgb(H,DEFAULT_S,DEFAULT_V)
	local Color=R..','..G..','..B
	SKIN:Bang('!SetOption','BGIcon','Color','Fill Color '..Color)
	SKIN:Bang('!UpdateMeter','BGIcon')
	SKIN:Bang('!SetOption','BGLine','Color','Stroke Color '..Color..',180')
	SKIN:Bang('!UpdateMeter','BGLine')
	SKIN:Bang('!Redraw')
end

function SetColor(Hue)
	local H=Clamp(Hue,0,360)
	local R,G,B=hsv2rgb(H,DEFAULT_S,DEFAULT_V)
	local Color=R..','..G..','..B
	SKIN:Bang('!SetOption','Color','Text',_TR_LauncherBackColor..Color)
	SKIN:Bang('!UpdateMeter','Color')
	SKIN:Bang('!SetOption','BGIcon','Color','Fill Color '..Color)
	SKIN:Bang('!UpdateMeter','BGIcon')
	SKIN:Bang('!SetOption','BGLine','Color','Stroke Color '..Color..',180')
	SKIN:Bang('!UpdateMeter','BGLine')
	SKIN:Bang('!SetOption','HueTri','X','-'..H/360*HUE_LENGTH..'r')
	SKIN:Bang('!UpdateMeter','HueTri')
	SKIN:Bang('!Redraw')
	ChangeVariable(DOCKPRE..'Color'..INDEX,Color,CONFIG_FILE)
end

function ChooseOver()
	local Measure=SKIN:GetMeasure('MeasureChoose')
	SKIN:Bang('!SetOption','MeasureChoose','ReturnValue','WholePath')
	SKIN:Bang('!UpdateMeasure','MeasureChoose')
	local Path=Measure:GetStringValue()
	SKIN:Bang('!SetOption','MeasureChoose','ReturnValue','Icon')
	SKIN:Bang('!UpdateMeasure','MeasureChoose')
	local Icon=Measure:GetStringValue()
	SKIN:Bang('!SetOption','MeasureChoose','ReturnValue','Name')
	SKIN:Bang('!UpdateMeasure','MeasureChoose')
	local Name=Measure:GetStringValue()
	SKIN:Bang('!SetOption','Path','Text',Path)
	SKIN:Bang('!UpdateMeter','Path')
	if not FLAG_IFUSECOLOR then
		SKIN:Bang('!SetOption','Name','Text',Name)
		if Icon~='' then
			SKIN:Bang('!SetOption','Icon','ImageName',Icon)
		end
		SKIN:Bang('!UpdateMeter','Name')
		SKIN:Bang('!UpdateMeter','Icon')
	end
	SKIN:Bang('!Redraw')
	if not FLAG_IFUSECOLOR then
		ChangeVariable(DOCKPRE..'Name'..INDEX,Name,CONFIG_FILE)
		ChangeVariable(DOCKPRE..'Icon'..INDEX,Icon,CONFIG_FILE)
	end
	ChangeVariable(DOCKPRE..'Path'..INDEX,Path,CONFIG_FILE)
	if FLAG_IFNEWDOCK then
		if INDEX==DOCKNUM then DOCKNUM=DOCKNUM+1 end
	end
	return 0;
end

function ChooseIcon()
	local Measure=SKIN:GetMeasure('MeasureChoose')
	SKIN:Bang('!SetOption','MeasureChoose','ReturnValue','Icon')
	SKIN:Bang('!UpdateMeasure','MeasureChoose')
	local Icon=Measure:GetStringValue()
	if Icon~='' then
		SKIN:Bang('!SetOption','Icon','ImageName',Icon)
	end
	SKIN:Bang('!UpdateMeter','Icon')
	SKIN:Bang('!Redraw')
	ChangeVariable(DOCKPRE..'Icon'..INDEX,Icon,CONFIG_FILE)
end

function InputColorReady()
	SKIN:Bang('!SetOption','MeasureInputColor','DefaultValue','#'..DOCKPRE..'Color'..INDEX..'#')
	SKIN:Bang('!UpdateMeasure','MeasureInputColor')
	SKIN:Bang('!CommandMeasure','MeasureInputColor','ExecuteBatch 1')
end

function InputColorOver()
	local Measure=SKIN:GetMeasure('MeasureInputColor')
	local Color=Measure:GetStringValue()
	local R,G,B=SeperateRGB(Color)
	if R==nil or G==nil or B==nil then return end
	local H,S,V=rgb2hsv(R,G,B)
	SKIN:Bang('!SetOption','Color','Text',_TR_LauncherBackColor..Color)
	SKIN:Bang('!UpdateMeter','Color')
	SKIN:Bang('!SetOption','BGIcon','Color','Fill Color '..Color)
	SKIN:Bang('!UpdateMeter','BGIcon')
	SKIN:Bang('!SetOption','BGLine','Color','Stroke Color '..Color..',180')
	SKIN:Bang('!UpdateMeter','BGLine')
	SKIN:Bang('!SetOption','HueTri','X','-'..H/360*HUE_LENGTH..'r')
	SKIN:Bang('!UpdateMeter','HueTri')
	SKIN:Bang('!Redraw')
	ChangeVariable(DOCKPRE..'Color'..INDEX,Color,CONFIG_FILE)
end

function InputPathReady()
	SKIN:Bang('!SetOption','MeasureInputPath','DefaultValue','#'..DOCKPRE..'Path'..INDEX..'#')
	SKIN:Bang('!UpdateMeasure','MeasureInputPath')
	SKIN:Bang('!CommandMeasure','MeasureInputPath','ExecuteBatch 1')
end

function InputPathOver()
	local Measure=SKIN:GetMeasure('MeasureInputPath')
	local Path=Measure:GetStringValue()
	SKIN:Bang('!SetOption','Path','Text',Path)
	SKIN:Bang('!UpdateMeter','Path')
	SKIN:Bang('!Redraw')
	ChangeVariable(DOCKPRE..'Path'..INDEX,Path,CONFIG_FILE)
end

function InputNameReady()
	SKIN:Bang('!SetOption','MeasureInputName','DefaultValue','#'..DOCKPRE..'Name'..INDEX..'#')
	SKIN:Bang('!UpdateMeasure','MeasureInputName')
	SKIN:Bang('!CommandMeasure','MeasureInputName','ExecuteBatch 1')
end

function InputNameOver()
	local Measure=SKIN:GetMeasure('MeasureInputName')
	local Name=Measure:GetStringValue()
	if Name=='' then Name=DEFAULTNAME end
	SKIN:Bang('!SetOption','Name','Text',Name)
	SKIN:Bang('!UpdateMeter','Name')
	SKIN:Bang('!Redraw')
	ChangeVariable(DOCKPRE..'Name'..INDEX,Name,CONFIG_FILE)
	if FLAG_IFNEWDOCK then
		if INDEX==DOCKNUM then DOCKNUM=DOCKNUM+1 end
	end
end

function InputItemReady()
	SKIN:Bang('!SetOption','BGItem','Color','Fill Color #ColorSetting#')
	SKIN:Bang('!SetOption','ItemTitle','FontColor','255,255,255')
	SKIN:Bang('!UpdateMeter','BGItem')
	SKIN:Bang('!UpdateMeter','ItemTitle')
	SKIN:Bang('!Redraw')
	SKIN:Bang('!SetOption','MeasureInputItem','DefaultValue',INDEX)
	SKIN:Bang('!UpdateMeasure','MeasureInputItem')
	SKIN:Bang('!CommandMeasure','MeasureInputItem','ExecuteBatch 1')
end

function InputItemOver()
	local Measure=SKIN:GetMeasure('MeasureInputItem')
	local Index=tonumber(Measure:GetStringValue())
	SKIN:Bang('!SetOption','BGItem','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','ItemTitle','FontColor','#ColorMain1#')
	SKIN:Bang('!UpdateMeter','BGItem')
	SKIN:Bang('!UpdateMeter','ItemTitle')
	if Index==nil then SKIN:Bang('!Redraw') return
	elseif Index>DOCKNUM then INDEX=DOCKNUM
	elseif Index>=1 then INDEX=math.floor(Index)
	else SKIN:Bang('!Redraw') return end
	LoadDock()
end

function InputItemDismiss()
	SKIN:Bang('!SetOption','BGItem','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','ItemTitle','FontColor','#ColorMain1#')
	SKIN:Bang('!UpdateMeter','BGItem')
	SKIN:Bang('!UpdateMeter','ItemTitle')
	SKIN:Bang('!Redraw')
end

function InputGroupReady()
	SKIN:Bang('!SetOption','BGGroup','Color','Fill Color #ColorSetting#')
	SKIN:Bang('!SetOption','GroupTitle','FontColor','255,255,255')
	SKIN:Bang('!UpdateMeter','BGGroup')
	SKIN:Bang('!UpdateMeter','GroupTitle')
	SKIN:Bang('!Redraw')
	SKIN:Bang('!SetOption','MeasureInputGroup','DefaultValue','#Group'..GROUP..'#')
	SKIN:Bang('!UpdateMeasure','MeasureInputGroup')
	SKIN:Bang('!CommandMeasure','MeasureInputGroup','ExecuteBatch 1')
end

function InputGroupOver()
	local Measure=SKIN:GetMeasure('MeasureInputGroup')
	local Value=Measure:GetStringValue()
	SKIN:Bang('!SetOption','GroupText','Text',Value)
	SKIN:Bang('!UpdateMeter','GroupText')
	ChangeVariable('Group'..GROUP,Value,'#@#Config\\Launcher\\Launcher.inc')
	if Value=='' then
		FLAG_IFDISABLE=true
		INDEX=1
		SKIN:Bang('!HideMeterGroup','Dock')
		SKIN:Bang('!HideMeterGroup','Hue')
		SKIN:Bang('!HideMeterGroup','RightButton')
		SKIN:Bang('!HideMeter','BGIcon')
		SKIN:Bang('!HideMeter','Name')
		SKIN:Bang('!ShowMeterGroup','Disable')
	else
		FLAG_IFDISABLE=false
		SKIN:Bang('!HideMeterGroup','Disable')
		SKIN:Bang('!ShowMeterGroup','Dock')
		SKIN:Bang('!ShowMeterGroup','RightButton')
		if FLAG_IFUSECOLOR then
			SKIN:Bang('!ShowMeterGroup','Hue')
			SKIN:Bang('!ShowMeter','BGIcon')
		else
			SKIN:Bang('!ShowMeter','Name')
		end
	end
	SKIN:Bang('!SetOption','BGGroup','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','GroupTitle','FontColor','#ColorMain1#')
	SKIN:Bang('!UpdateMeter','BGGroup')
	SKIN:Bang('!UpdateMeter','GroupTitle')
	SKIN:Bang('!Redraw')
end

function InputGroupDismiss()
	SKIN:Bang('!SetOption','BGGroup','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','GroupTitle','FontColor','#ColorMain1#')
	SKIN:Bang('!UpdateMeter','BGGroup')
	SKIN:Bang('!UpdateMeter','GroupTitle')
	SKIN:Bang('!Redraw')
end

function PrePage()
	if FLAG_IFDISABLE then return
	else
		INDEX=INDEX-1
		if INDEX<1 then INDEX=DOCKNUM end
		LoadDock()
	end
end

function NextPage()
	if FLAG_IFDISABLE then return
	else
		INDEX=INDEX+1
		if INDEX>DOCKNUM then INDEX=1 end
		LoadDock()
	end
end

-- 该应用与前一号应用交换，当前序号减1
-- 不调用LoadDock
function MoveUp()
	if INDEX<=1 then return end
	-- Icon
	local TempPre=SKIN:GetVariable(DOCKPRE..'Icon'..INDEX-1,'')
	ChangeVariable(DOCKPRE..'Icon'..INDEX-1,SKIN:GetVariable(DOCKPRE..'Icon'..INDEX,''),CONFIG_FILE)
	ChangeVariable(DOCKPRE..'Icon'..INDEX,TempPre,CONFIG_FILE)
	-- Path
	TempPre=SKIN:GetVariable(DOCKPRE..'Path'..INDEX-1,'')
	ChangeVariable(DOCKPRE..'Path'..INDEX-1,SKIN:GetVariable(DOCKPRE..'Path'..INDEX,''),CONFIG_FILE)
	ChangeVariable(DOCKPRE..'Path'..INDEX,TempPre,CONFIG_FILE)
	-- Name & Color
	if FLAG_IFUSECOLOR then
		TempPre=SKIN:GetVariable(DOCKPRE..'Color'..INDEX-1,'')
		ChangeVariable(DOCKPRE..'Color'..INDEX-1,SKIN:GetVariable(DOCKPRE..'Color'..INDEX,''),CONFIG_FILE)
		ChangeVariable(DOCKPRE..'Color'..INDEX,TempPre,CONFIG_FILE)
	else
		TempPre=SKIN:GetVariable(DOCKPRE..'Name'..INDEX-1,'')
		ChangeVariable(DOCKPRE..'Name'..INDEX-1,SKIN:GetVariable(DOCKPRE..'Name'..INDEX,''),CONFIG_FILE)
		ChangeVariable(DOCKPRE..'Name'..INDEX,TempPre,CONFIG_FILE)
	end
	INDEX=INDEX-1
	if INDEX<10 then
		SKIN:Bang('!SetOption','ItemTitle','Text','0'..INDEX)
	else
		SKIN:Bang('!SetOption','ItemTitle','Text',INDEX)
	end
	SKIN:Bang('!UpdateMeter','ItemTitle')
	SKIN:Bang('!Redraw')
end

-- 该应用与后一号应用交换，当前序号加1
-- 不调用LoadDock
function MoveDown()
	if INDEX+1>=DOCKNUM then return end
	-- Icon
	local TempNext=SKIN:GetVariable(DOCKPRE..'Icon'..INDEX+1,'')
	ChangeVariable(DOCKPRE..'Icon'..INDEX+1,SKIN:GetVariable(DOCKPRE..'Icon'..INDEX,''),CONFIG_FILE)
	ChangeVariable(DOCKPRE..'Icon'..INDEX,TempNext,CONFIG_FILE)
	-- Path
	TempNext=SKIN:GetVariable(DOCKPRE..'Path'..INDEX+1,'')
	ChangeVariable(DOCKPRE..'Path'..INDEX+1,SKIN:GetVariable(DOCKPRE..'Path'..INDEX,''),CONFIG_FILE)
	ChangeVariable(DOCKPRE..'Path'..INDEX,TempNext,CONFIG_FILE)
	-- Name & Color
	if FLAG_IFUSECOLOR then
		TempNext=SKIN:GetVariable(DOCKPRE..'Color'..INDEX+1,'')
		ChangeVariable(DOCKPRE..'Color'..INDEX+1,SKIN:GetVariable(DOCKPRE..'Color'..INDEX,''),CONFIG_FILE)
		ChangeVariable(DOCKPRE..'Color'..INDEX,TempNext,CONFIG_FILE)
	else
		TempNext=SKIN:GetVariable(DOCKPRE..'Name'..INDEX+1,'')
		ChangeVariable(DOCKPRE..'Name'..INDEX+1,SKIN:GetVariable(DOCKPRE..'Name'..INDEX,''),CONFIG_FILE)
		ChangeVariable(DOCKPRE..'Name'..INDEX,TempNext,CONFIG_FILE)
	end
	INDEX=INDEX+1
	if INDEX<10 then
		SKIN:Bang('!SetOption','ItemTitle','Text','0'..INDEX)
	else
		SKIN:Bang('!SetOption','ItemTitle','Text',INDEX)
	end
	SKIN:Bang('!UpdateMeter','ItemTitle')
	SKIN:Bang('!Redraw')
end

-- 删除该应用，当前序号不变
function DeleteItem()
	if INDEX>=DOCKNUM then return end
	for i=INDEX,DOCKNUM-1 do
		if FLAG_IFUSECOLOR then
			ChangeVariable(DOCKPRE..'Color'..i,SKIN:GetVariable(DOCKPRE..'Color'..i+1,''),CONFIG_FILE)
		else
			ChangeVariable(DOCKPRE..'Name'..i,SKIN:GetVariable(DOCKPRE..'Name'..i+1,''),CONFIG_FILE)
		end
		ChangeVariable(DOCKPRE..'Icon'..i,SKIN:GetVariable(DOCKPRE..'Icon'..i+1,''),CONFIG_FILE)
		ChangeVariable(DOCKPRE..'Path'..i,SKIN:GetVariable(DOCKPRE..'Path'..i+1,''),CONFIG_FILE)
	end
	DOCKNUM=DOCKNUM-1
	LoadDock()
end

--*************************************************

-- 确认更改并返回
function OK()
	if GROUP~=nil then
		local Value=SKIN:GetVariable('Group'..GROUP)
		SKIN:Bang('!SetVariable','Group'..GROUP,Value,'#RootConfig#\\Setting\\CtrlSetting')
	end
	SKIN:Bang('!CommandMeasure','MeasureScript','PanelBack_Launcher()','#RootConfig#\\Setting\\CtrlSetting')
	SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
end

-- 接收主皮肤的指令，打开页面
function GetData(Group)
	-- 鉴别各组
	if string.sub(Group,1,5)=='Group' then
		GROUP=tonumber(string.sub(Group,6,-1))
		DOCKPRE='G'..GROUP
		FLAG_IFNEWDOCK=true
		FLAG_IFUSECOLOR=false
		CONFIG_FILE='#@#Config\\Launcher\\Group'..GROUP..'.inc'
		SKIN:Bang('!SetOption','GroupTitle','Text',_TR_LauncherGroupTitle..' 0'..GROUP)
		SKIN:Bang('!UpdateMeter','GroupTitle')
		local GroupName=SKIN:GetVariable('Group'..GROUP)
		SKIN:Bang('!SetOption','GroupText','Text',GroupName)
		SKIN:Bang('!ShowMeter','GroupText')
		SKIN:Bang('!UpdateMeter','GroupText')
		if GroupName=='' then FLAG_IFDISABLE=true end
	elseif Group=='Circle' then
		DOCKPRE='Circle'
		FLAG_IFNEWDOCK=false
		FLAG_IFUSECOLOR=true
		DOCKNUM=9
		CONFIG_FILE='#@#Config\\Launcher\\Circle Launcher.inc'
		local Len=tonumber(SELF:GetOption('GroupLength'))
		SKIN:Bang('!SetOption','BGGroup','Shape3','Rectangle 0,0,'..Len..',50|Extend TitleStroke,TitleColor')
		SKIN:Bang('!SetOption','GroupTitle','Text','Circle Launcher')
		SKIN:Bang('!SetOption','GroupTitle','X',0.5*Len..'r')
		SKIN:Bang('!UpdateMeter','BGGroup')
		SKIN:Bang('!UpdateMeter','GroupTitle')
	else
		OK()
		return
	end
	-- 显示DOCK页面
	if FLAG_IFDISABLE then
		SKIN:Bang('!ShowMeterGroup','Disable')
	else
		SKIN:Bang('!ShowMeterGroup','Dock')
		if FLAG_IFUSECOLOR then
			SKIN:Bang('!ShowMeterGroup','Hue')
			SKIN:Bang('!ShowMeter','BGIcon')
		else
			SKIN:Bang('!ShowMeter','Name')
		end
	end
	SKIN:Bang('!ShowMeterGroup','Initialize')
	if FLAG_IFNEWDOCK then
		SKIN:Bang('!ShowMeterGroup','RightButton')
		-- 当允许无限新增DOCK时，查询当前DOCK总数
		local Idx=0
		while (type(SKIN:GetVariable(DOCKPRE..'Name'..Idx+1))~='nil' and SKIN:GetVariable(DOCKPRE..'Name'..Idx+1)~='') do
			Idx=Idx+1
		end
		-- DOCKNUM为DOCK总数+1，包含了一个新建项
		DOCKNUM=Idx+1
	end
	INDEX=1
	LoadDock()
end

-- 加载当前的DOCK
function LoadDock()
	if INDEX<10 then
		SKIN:Bang('!SetOption','ItemTitle','Text','0'..INDEX)
	else
		SKIN:Bang('!SetOption','ItemTitle','Text',INDEX)
	end
	local Icon=SKIN:GetVariable(DOCKPRE..'Icon'..INDEX)
	if Icon==nil or Icon=='' then Icon=DEFAULTICON end
	SKIN:Bang('!SetOption','Icon','ImageName',Icon)
	local Path=SKIN:GetVariable(DOCKPRE..'Path'..INDEX)
	if Path==nil or Path=='' then Path=DEFAULTPATH end
	SKIN:Bang('!SetOption','Path','Text',Path)
	if FLAG_IFUSECOLOR then
		local Color=SKIN:GetVariable(DOCKPRE..'Color'..INDEX)
		if Color==nil or Color=='' then Color=DEFAULTCOLOR end
		SKIN:Bang('!SetOption','Color','Text',_TR_LauncherBackColor..Color)
		SKIN:Bang('!UpdateMeter','Color')
		SKIN:Bang('!SetOption','BGIcon','Color','Fill Color '..Color)
		SKIN:Bang('!UpdateMeter','BGIcon')
		SKIN:Bang('!SetOption','BGLine','Color','Stroke Color '..Color..',180')
		SKIN:Bang('!UpdateMeter','BGLine')
		local H,S,V=rgb2hsv(SeperateRGB(Color))
		SKIN:Bang('!SetOption','HueTri','X','-'..H/360*HUE_LENGTH..'r')
		SKIN:Bang('!UpdateMeter','HueTri')
	else
		local Name=SKIN:GetVariable(DOCKPRE..'Name'..INDEX)
		if Name==nil or Name=='' then Name=DEFAULTNAME end
		SKIN:Bang('!SetOption','Name','Text',Name)
		SKIN:Bang('!UpdateMeter','Name')
	end
	SKIN:Bang('!UpdateMeterGroup','Dock')
	SKIN:Bang('!Redraw')
end

function ChangeVariable(Variable,Value,File)
	if Value~=nil then
		SKIN:Bang('!SetVariable',Variable,Value)
	end
	WriteVariable(Variable,Value,File)
end

function WriteVariable(Variable,Value,File)
	if Value==nil then Value=SKIN:GetVariable(Variable) end
	SKIN:Bang('!WriteKeyValue','Variables',Variable,Value,File)
end

