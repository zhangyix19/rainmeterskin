--[[
Name = Weather.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Weather皮肤
]]

function Initialize()
	ANI_TYPE=0
	ANI_MENU=0
	GetVari()
end

function Update()
	TempChange()
end

function GetVari()
	m0={}
	m1={}
	--简要模式切换至详情模式时过渡动画需要移动的项目的初值、终止
	local Item={'Title1','Title2','Spread','City','Icon_Y','Icon_W','Menu'}
	for k,v in pairs(Item) do
		local Str=SELF:GetOption(v)
		local Pos=string.find(Str, "%|")
		m0[v] = string.sub(Str, 1, Pos-1) or ''
		m1[v] = string.sub(Str, Pos+1, -1) or ''
	end
	local Str=SELF:GetOption('ForecastY')
	local Pos=string.find(Str, "%|")
	FORECAST_Y0 = string.sub(Str, 1, Pos-1) or ''
	FORECAST_Y1 = string.sub(Str, Pos+1, -1) or ''
	--温度变化图的纵向尺寸
	TEMPSCALE=SELF:GetOption('TempScale')
end

--控制过渡动画
function CtrlAni(X)
	if X=='Menu' then
		if ANI_MENU<=0 then
			SKIN:Bang('!ShowMeter MenuBottom')
			SKIN:Bang('!ShowMeter MenuBG')
			SKIN:Bang('!SetVariable','AniMenu',m0.Menu)
			SKIN:Bang('!UpdateMeter MenuBottom')
			SKIN:Bang('!UpdateMeter MenuBG')
			SKIN:Bang('!Redraw')
			SKIN:Bang('!CommandMeasure','MeasureAction','Execute 3')
		elseif ANI_MENU>=9 then
			SKIN:Bang('!HideMeter MenuBottom')
			SKIN:Bang('!HideMeterGroup Opt')
			SKIN:Bang('!SetVariable','AniMenu',m1.Menu)
			SKIN:Bang('!UpdateMeter MenuBG')
			SKIN:Bang('!Redraw')
			SKIN:Bang('!CommandMeasure','MeasureAction','Execute 4')
		end
	elseif X=='Type' then
		if ANI_MENU>=9 then
			SKIN:Bang('!HideMeter MenuBottom')
			SKIN:Bang('!HideMeterGroup Opt')
			SKIN:Bang('!SetVariable','AniMenu',m1.Menu)
			SKIN:Bang('!UpdateMeter MenuBG')
			SKIN:Bang('!Redraw')
			SKIN:Bang('!CommandMeasure','MeasureAction','Execute 4')
		end	
		if ANI_TYPE<=0 then
			SKIN:Bang('!SetOption','Opt1','Text','#TR_MenuCheckMain#')
			SKIN:Bang('!UpdateMeter Opt1')
			SKIN:Bang('!HideMeterGroup MainHide')
			SKIN:Bang('!SetOption','ForecastBG','Y',FORECAST_Y1)
			SKIN:Bang('!UpdateMeter ForecastBG')
			SKIN:Bang('!SetVariable','Ani1',m0.Title1)
			SKIN:Bang('!SetVariable','Ani2',m0.Title2)
			SKIN:Bang('!SetVariable','Ani3',m0.Spread)
			SKIN:Bang('!SetOption','CityBG','Y',m0.City)
			SKIN:Bang('!SetOption','MainIcon','Y',m0.Icon_Y)
			SKIN:Bang('!SetOption','MainIcon','W',m0.Icon_W)
			SKIN:Bang('!UpdateMeter BG')
			SKIN:Bang('!UpdateMeter CityBG')
			SKIN:Bang('!UpdateMeter MainIcon')
			SKIN:Bang('!Redraw')
			SKIN:Bang('!CommandMeasure','MeasureAction','Execute 1')
		elseif ANI_TYPE>=9 then
			SKIN:Bang('!SetOption','Opt1','Text','#TR_MenuCheckDetail#')
			SKIN:Bang('!UpdateMeter Opt1')
			SKIN:Bang('!HideMeterGroup Detail')
			SKIN:Bang('!SetOption','ForecastBG','Y',FORECAST_Y0)
			SKIN:Bang('!UpdateMeter ForecastBG')
			SKIN:Bang('!SetVariable','Ani1',m1.Title1)
			SKIN:Bang('!SetVariable','Ani2',m1.Title2)
			SKIN:Bang('!SetVariable','Ani3',m1.Spread)
			SKIN:Bang('!SetOption','CityBG','Y',m1.City)
			SKIN:Bang('!SetOption','MainIcon','Y',m1.Icon_Y)
			SKIN:Bang('!SetOption','MainIcon','W',m1.Icon_W)
			SKIN:Bang('!UpdateMeter BG')
			SKIN:Bang('!UpdateMeter CityBG')
			SKIN:Bang('!UpdateMeter MainIcon')
			SKIN:Bang('!Redraw')
			SKIN:Bang('!CommandMeasure','MeasureAction','Execute 2')
		end
	end
end

function Ani(N)
	local Pos={}
	ANI_TYPE=ANI_TYPE+N
	if tonumber(N)>0 then
		for k,v in pairs(m0) do
			Pos[k]=m0[k]-math.sin(math.rad(ANI_TYPE))*(m0[k]-m1[k])
		end
	else
		for k,v in pairs(m0) do
			Pos[k]=m1[k]+math.sin(math.rad(90-ANI_TYPE))*(m0[k]-m1[k])
		end
	end
	if Pos.Title1>=Pos.Title2 then
		Pos.Title2=Pos.Title1
	end
	SKIN:Bang('!SetVariable','Ani1',Pos.Title1)
	SKIN:Bang('!SetVariable','Ani2',Pos.Title2)
	SKIN:Bang('!SetVariable','Ani3',Pos.Spread)
	SKIN:Bang('!SetOption','CityBG','Y',Pos.City)
	SKIN:Bang('!SetOption','MainIcon','Y',Pos.Icon_Y)
	SKIN:Bang('!SetOption','MainIcon','W',Pos.Icon_W)
	SKIN:Bang('!UpdateMeasure MeasureAction')
	SKIN:Bang('!UpdateMeter BG')
	SKIN:Bang('!UpdateMeter CityBG')
	SKIN:Bang('!UpdateMeter MainIcon')
	SKIN:Bang('!Redraw')
end

function AniMenu(N)
	local Pos
	ANI_MENU=ANI_MENU+N
	if tonumber(N)>0 then
		Pos=m0.Menu-math.sin(math.rad(ANI_MENU))*(m0.Menu-m1.Menu)
	else
		Pos=m1.Menu+math.sin(math.rad(90-ANI_MENU))*(m0.Menu-m1.Menu)
	end
	SKIN:Bang('!SetVariable','AniMenu',Pos)
	SKIN:Bang('!UpdateMeasure MeasureAction')
	SKIN:Bang('!UpdateMeter MenuBG')
	SKIN:Bang('!Redraw')
end

--控制温度变化图
function TempChange()
	local Data,Pos=CalcTemp()
	DrawTemp(Data,Pos)
end

--计算温度变化图
function CalcTemp()
	local Data={}
	local Max,Min
	local Flag=true
	for i=0,2 do
		local measure=SKIN:GetMeasure('MWHigh_'..i)
		local Num=tonumber(measure:GetStringValue())
		Data[i+1]=Num
		if Num==nil or Num=='' then
			Flag=false
		else
			if Max==nil or Max<Num then	Max=Num end
			if Min==nil or Min>Num then Min=Num end
		end
		local measure=SKIN:GetMeasure('MWLow_'..i)
		local Num=tonumber(measure:GetStringValue())
		Data[i+4]=Num
		if Num==nil or Num=='' then
			Flag=false
		else
			if Max==nil or Max<Num then	Max=Num end
			if Min==nil or Min>Num then Min=Num end
		end
	end
	if Max==nil or Min==nil then Max=1 Min=0 end
	Max=math.ceil(Max*1.2-Min*0.2)
	Min=math.floor(Min*1.2-Max*0.2)
	if not Flag then
		local Mid1=math.floor(TEMPSCALE/3+0.5)
		local Mid2=math.floor(TEMPSCALE*2/3+0.5)
		for j=1,3 do
			Data[j]=Mid1
		end
		for j=4,6 do
			Data[j]=Mid2
		end
	else
		for i=1,6 do
			Data[i]=math.floor((Max-Data[i])/(Max-Min)*TEMPSCALE+0.5)
		end
	end
	--化为相对坐标
	local Pos={}
	for i=6,5,-1 do
		Pos[i]=Data[i]-Data[i-1]-5
	end
	for i=4,2,-1 do
		Pos[i]=Data[i]-Data[i-1]+5
	end
	Pos[1]=Data[1]
	return Data,Pos
end

--绘制温度变化图
function DrawTemp(Data,Pos)
	for i=1,3 do
		SKIN:Bang('!SetOption','HighPoint_'..i-1,'Y',Pos[i]..'r')
		SKIN:Bang('!SetOption','LowPoint_'..i-1,'Y',Pos[i+3]..'r')
	end
	SKIN:Bang('!SetOption','TempLine','Shape','Line 64,'..Data[1]..',160,'..Data[2]..'|Extend LineExtend')
	SKIN:Bang('!SetOption','TempLine','Shape2','Line 160,'..Data[2]..',256,'..Data[3]..'|Extend LineExtend')
	SKIN:Bang('!SetOption','TempLine','Shape3','Line 64,'..Data[4]..',160,'..Data[5]..'|Extend LineExtend')
	SKIN:Bang('!SetOption','TempLine','Shape4','Line 160,'..Data[5]..',256,'..Data[6]..'|Extend LineExtend')
	SKIN:Bang('!UpdateMeterGroup TempPoint')
end

--控制鼠标悬浮于预报部分时的高亮
function Over(N)
	SKIN:Bang('!SetOption','HighPoint_'..N,'PointColor','Fill Color #ColorMain2#,230')
	SKIN:Bang('!SetOption','HighPoint_'..N,'PointScale','Scale 1.2,1.2')
	SKIN:Bang('!SetOption','LowPoint_'..N,'PointColor','Fill Color #ColorMain2#,230')
	SKIN:Bang('!SetOption','LowPoint_'..N,'PointScale','Scale 1.2,1.2')
	SKIN:Bang('!SetOption','HighTemp_'..N,'FontColor','#ColorMain2#')
	SKIN:Bang('!SetOption','LowTemp_'..N,'FontColor','#ColorMain2#')
	SKIN:Bang('!SetOption','ForecastTitle_'..N,'FontColor','#ColorMain2#')
	SKIN:Bang('!SetOption','ForecastIcon_'..N,'ImageTint','#ColorMain2#')
	SKIN:Bang('!UpdateMeterGroup F'..N)
	SKIN:Bang('!Redraw')
end

--控制鼠标离开预报部分时的取消高亮
function Leave(N)
	SKIN:Bang('!SetOption','HighPoint_'..N,'PointColor','Fill Color #ColorMain3#,230')
	SKIN:Bang('!SetOption','HighPoint_'..N,'PointScale','Scale 1.0,1.0')
	SKIN:Bang('!SetOption','LowPoint_'..N,'PointColor','Fill Color #ColorMain3#,230')
	SKIN:Bang('!SetOption','LowPoint_'..N,'PointScale','Scale 1.0,1.0')
	SKIN:Bang('!SetOption','HighTemp_'..N,'FontColor','#ColorMain3#')
	SKIN:Bang('!SetOption','LowTemp_'..N,'FontColor','#ColorMain3#')
	SKIN:Bang('!SetOption','ForecastTitle_'..N,'FontColor','#ColorMain3#')
	SKIN:Bang('!SetOption','ForecastIcon_'..N,'ImageTint','#ColorMain3#,230')
	SKIN:Bang('!UpdateMeterGroup F'..N)
	SKIN:Bang('!Redraw')
end

