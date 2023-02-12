--[[
Name = Initialize.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Initialize皮肤
]]

SCREEN_STANDARD={768,900,1050,1080,1200,2160,2400,2880}
COMPONENT_SIZE={{'M',1920}}

function Initialize()
	local InitializeOver=tonumber(SKIN:GetVariable('InitializeOver'))
	if Initialize==nil or InitializeOver~=0 then
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
		return
	end
	if GetScreenSize() then
		Load()
	else
		local Scale=SCREENHEIGHT/1080
		SKIN:Bang('!Move',(SCREENWIDTH-600*Scale)/2,(SCREENHEIGHT-250*Scale)/2)
		SKIN:Bang('!SetVariable','Scale',Scale)
		SKIN:Bang('!SetOptionGroup','String','TransformationMatrix',Scale..';0;0;'..Scale..';0;0')
		SKIN:Bang('!SetOptionGroup','Shape','AntiAlias',1)
		SKIN:Bang('!ShowMeterGroup','Notice')
		SKIN:Bang('!Update')
	end
end

function Load()
	GetSkinWidth()
	CalcFontSize()
	MakeVisualizer()
	ActivateConfig()
end

--获取屏幕分辨率
function GetScreenSize()
	SCREENWIDTH=tonumber(SKIN:GetVariable('ScreenAreaWidth'))
	SCREENHEIGHT=tonumber(SKIN:GetVariable('ScreenAreaHeight'))
	local Flag=0
	for i=1,#SCREEN_STANDARD do
		if SCREENHEIGHT==SCREEN_STANDARD[i] then break
		else
			Flag=Flag+1
		end
	end
	if Flag==#SCREEN_STANDARD then
		return false
	else
		return true
	end
end

--计算SkinWidth，并给出相应的ComponentSize型号
function GetSkinWidth()
	--计算SkinWidth
	local Scale=SCREENHEIGHT/SCREENWIDTH
	if Scale>0.56 then
		SKINWIDTH=SCREENWIDTH
	else
		SKINWIDTH=math.ceil(SCREENHEIGHT*16/9)
	end
	--计算ComponentSize
	local Idx=#COMPONENT_SIZE
	for i=1,#COMPONENT_SIZE do
		if COMPONENT_SIZE[i][2]>SKINWIDTH then
			Idx=math.max(i-1,1)
			break
		end
	end
	COMPOSIZE=COMPONENT_SIZE[Idx][1]
	SKIN:Bang('!WriteKeyValue','Variables','SkinWidth',SKINWIDTH,'#@#Config\\Setting.inc')
	SKIN:Bang('!WriteKeyValue','Variables','CompunentSize',COMPOSIZE,'#@#Config\\Setting.inc')
end

--计算各字体字号与偏移量，并记录于Size.inc中
function CalcFontSize()
	if SKINWIDTH==1920 then return
	else
		local Scale=SKINWIDTH/1920
		local Path=SELF:GetOption('SizeFile')
		local File=io.open(Path,"r")
		if not File then return end
		local Variables={}
		for l in File:lines() do
			if l~=nil and l~='' then
				local _,_,Key,Value=string.find(l,'(.*)=(.*)')
				Variables[Key]=tonumber(Value)
			end
		end
		File:close()
		for k,v in pairs(Variables) do
			SKIN:Bang('!WriteKeyValue','Variables',k,math.floor(v*Scale+0.5),'#@#Config\\Size.inc')
		end
	end
end

function MakeVisualizer()
	if SKINWIDTH==1920 then return
	else
		local Scale=SKINWIDTH/1920
		local VisualWidth=math.floor(SKINWIDTH*0.3072+0.5)
		local BarWidth=math.floor(Scale*8+0.3)
		local BarGap=BarWidth
		local BarCount=math.floor((VisualWidth+BarGap)/(BarWidth+BarGap))
		if BarCount%2~=1 then BarCount=BarCount+1 end
		VisualWidth=BarCount*(BarWidth+BarGap)-BarGap
		local BarSize=math.floor(Scale*100)
		SKIN:Bang('!WriteKeyValue','Variables','BarCount',BarCount,'#@#Config\\Others\\Visualizer.inc')
		SKIN:Bang('!WriteKeyValue','Variables','BarWidth',BarWidth,'#@#Config\\Others\\Visualizer.inc')
		SKIN:Bang('!WriteKeyValue','Variables','BarGap',BarGap,'#@#Config\\Others\\Visualizer.inc')
		SKIN:Bang('!WriteKeyValue','Variables','BandsCount',BarCount+1,'#@#Config\\Others\\Visualizer.inc')
		SKIN:Bang('!WriteKeyValue','Variables','BarSize',BarSize,'#@#Config\\Others\\Visualizer.inc')
		SKIN:Bang('!WriteKeyValue','Variables','VisualWidth',VisualWidth,'#@#Config\\Others\\Visualizer.inc')
		SKIN:Bang('!WriteKeyValue','Variables','InitOver',0,'#CurrentPath#Visualizer\\Visualizer Initialize.ini')
		SKIN:Bang('!ActivateConfig','#CurrentConfig#\\Visualizer','Visualizer Initialize.ini')
	end
end

function ActivateConfig()
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Initialize\\Guide','Guide '..COMPOSIZE..'.ini')
	SKIN:Bang('!WriteKeyValue','Variables','InitializeOver','1')
	SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
end

