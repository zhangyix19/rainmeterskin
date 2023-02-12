--[[
Name = Calendar.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Calendar皮肤
Source = 改自 SoLivC 的 LuaCon.lua 脚本，摘自皮肤 Elf Suit 
		 https://solivc.deviantart.com/art/Elf-Suit-470111456
		 http://solivc.lofter.com/post/240112_18632b5
]]


MonthDay={31,28,31,30,31,30,31,31,30,31,30,31}
MonthName={"January","February","March","April","May","June","July","August","September","October","November","December"}
Load={}
BG={}

function Initialize()
	GetVari()
	STtLT()
	BG[MODE]()
	Load[MODE]()
end

--日期更替时执行
function NextDay()
	STtLT()
	Load[MODE]()
end

--修改月份时执行
function ChangeMonth(Step)
	ChangeTime(Step)
	Load[MODE]()
	SKIN:Bang('!UpdateMeter BG')
	SKIN:Bang('!UpdateMeter MonthBG')
	SKIN:Bang('!Update')
end

---------------------------------------------------

--控制开启关闭选项菜单和切换模式
function MenuButton(X)
	if X=='Menu' then
		if IFMENU then
			IFMENU=false
			SKIN:Bang('!CommandMeasure MeasureAction  "Execute 4"')
		else
			IFMENU=true
			SKIN:Bang('!CommandMeasure MeasureAction  "Execute 3"')
		end
	elseif X=='Mode' then
		if IFMENU then
			IFMENU=false
			SKIN:Bang('!CommandMeasure MeasureAction  "Execute 4"')
		end
		if IFDOUBLE then
			IFDOUBLE=false
			SKIN:Bang('!SetOption','Opt1','Text','#TR_MenuCheckDoubleMonth#')
			SKIN:Bang('!UpdateMeter Opt1')
			ChangeMode('Single')
		else
			IFDOUBLE=true
			SKIN:Bang('!SetOption','Opt1','Text','#TR_MenuCheckSingleMonth#')
			SKIN:Bang('!UpdateMeter Opt1')
			ChangeMode('Double')
		end
	end
end

--切换月历模式时执行
function ChangeMode(M)
	if M~='Single' and M~='Double' then return
	else
		MODE=M
		BG['To'..M]()
		local ActNum=Load['To'..M]()
		SKIN:Bang('!UpdateMeterGroup Day1')
		SKIN:Bang('!UpdateMeterGroup Day2')
		SKIN:Bang('!CommandMeasure','MeasureAction','Execute '..ActNum)
	end
end

---------------------------------------------------

--获取变量
function GetVari()
	--月历模式
	MODE=tostring(SKIN:GetVariable('TypeCalendar'),'Single')
	IFMENU=false
	if MODE=='Single' then IFDOUBLE=false
	elseif MODE=='Double' then IFDOUBLE=true
	end
	--储存当天的节点编号、星期
	today={}
	--储存两个月份的月历底部超出的行数
	extend={}
	--月历行间距
	BREAK=SELF:GetOption('DayBreak')
	--第二月标题宽度
	FW=SELF:GetOption('FlagWidth')
	--选项菜单高度
	MH=SELF:GetOption('MenuHeight')
	local tab={
				--储存第一个月的参照点坐标
				M1='FirMonth',
				--储存第二个月的参照点坐标
				M2='SecMonth',
				--储存BG高度
				BGH='Height'
				}
	vari={DP1={},DP2={},M1={},M2={},BGH={}}
	for k,v in pairs(tab) do
		local Str=SELF:GetOption(v)
		local Pos=string.find(Str, "%|")
		vari[k].Single = string.sub(Str, 1, Pos-1) or ''
		vari[k].Double = string.sub(Str, Pos+1, -1) or ''
	end
	for i=1,2 do
		local Str=SELF:GetOption('Day'..i..'Pos')
		local Pos=string.find(Str, "%|")
		vari['DP'..i].X = string.sub(Str, 1, Pos-1) or ''
		vari['DP'..i].Y = string.sub(Str, Pos+1, -1) or ''
	end
	--获取月份标题
	local Str=SKIN:GetVariable('MonthName')
	if Str~=nil and Str~='' then
		local mn={}
		for a in string.gmatch(Str, '[^%|]+') do
			table.insert(mn, a)
		end
		if mn[12]~=nil then
			for i=1,12 do
				MonthName[i]=mn[i]
			end
		end
	end
end

--设置Lua内置时间为系统时间
function STtLT()
	timetable=os.date("*t")
	FebDays()
end

--计算Lua内置时间的二月份天数
function FebDays()
	if ( timetable.year % 100 == 0 and timetable.year % 400 == 0 ) or ( timetable.year % 100 ~= 0 and timetable.year % 4 == 0)then
		MonthDay[2]=29
	else
		MonthDay[2]=28
	end
end

--修改Lua内置月份
function ChangeTime(step)
	timetable.month=timetable.month+step
	if timetable.month <= 0 then
		timetable.month=12
		timetable.year=timetable.year-1
	else if timetable.month >12 then
			timetable.month=1
			timetable.year=timetable.year+1
		end
	end
end

--设置BG Single
BG.Single = function()
	SKIN:Bang('!SetVariable','Ani1',vari.M1.Single)
	SKIN:Bang('!SetOption','MonthBG','Y',vari.M2.Single)
	SKIN:Bang('!ShowMeterGroup Single')
	SKIN:Bang('!SetOption','Opt1','Text','#TR_MenuCheckDoubleMonth#')
end

--设置BG Double
BG.Double = function()
	SKIN:Bang('!SetVariable','Ani1',vari.M1.Double)
	SKIN:Bang('!ShowMeter Title')
	SKIN:Bang('!ShowMeterGroup SecMonth')
	SKIN:Bang('!SetOption','Opt1','Text','#TR_MenuCheckSingleMonth#')
end

--设置BG 转换至Double
BG.ToDouble = function()
	SKIN:Bang('!SetOption','MonthBG','Y',vari.M2.Double)
	SKIN:Bang('!HideMeterGroup Single')
	SKIN:Bang('!ShowMeter MonthBG')
	SKIN:Bang('!HideMeterGroup Day2')
end

--设置BG 转换至Single
BG.ToSingle = function()
	SKIN:Bang('!SetOption','MonthBG','Y',vari.M2.Single)
	SKIN:Bang('!HideMeterGroup Day2')
	SKIN:Bang('!HideMeter Title')
	SKIN:Bang('!HideMeter Month2')
end

--加载皮肤 Single
Load.Single = function()
	CleanCalendar(1)
	ClearToday()
	today[1]=nil
	today[2]=nil
	local weektable=MakeWeekTable(MonthDay[timetable.month])
	extend[1]=DrawCalendar(weektable,1,1)
	SetBGSingle(extend[1])
	MarkToday()
end

--加载皮肤 Double
Load.Double = function()
	CleanCalendar(1)
	CleanCalendar(2)
	ClearToday()
	today[1]=nil
	today[2]=nil
	local weektable=MakeWeekTable(MonthDay[timetable.month])
	extend[1]=DrawCalendar(weektable,1,1)
	ChangeTime(1)
	SetMonthDouble(extend[1])
	weektable=MakeWeekTable(MonthDay[timetable.month])
	if weektable[1]>=3 then
		extend[2]=DrawCalendar(weektable,2,0)
	else
		extend[2]=DrawCalendar(weektable,2,1)
	end
	ChangeTime(-1)
	SetBGDouble(extend[1]+extend[2])
	MarkToday()
end

--加载皮肤 转换至Double
Load.ToDouble = function()
	CleanCalendar(2)
	ClearToday()
	ChangeTime(1)
	SetMonthDouble(extend[1])
	local weektable=MakeWeekTable(MonthDay[timetable.month])
	if weektable[1]>=3 then
		extend[2]=DrawCalendar(weektable,2,0)
	else
		extend[2]=DrawCalendar(weektable,2,1)
	end
	ChangeTime(-1)
	SKIN:Bang('!SetOption','Title','Text',timetable.year..' '..MonthName[timetable.month])
	SKIN:Bang('!UpdateMeter Title')
	SKIN:Bang('!UpdateMeter Month2')
	return 1
end

--加载皮肤 转换至Single
Load.ToSingle = function()
	ClearToday()
	if today[1]~= nil then
		local Group=math.floor(tonumber(today[1])/100)
		if Group==2 then
			today[1]=nil
			today[2]=nil
		end
	end
	SKIN:Bang('!SetOption','Year','Text',timetable.year)
	SKIN:Bang('!SetOption','Month1','Text',MonthName[timetable.month])
	SKIN:Bang('!UpdateMeterGroup Single')
	return 2
end

--计算日历，输出星期表weektable
function MakeWeekTable(Md)
	local tab={}
	for i=1,Md,1 do
		tab[i]=CalcWeek(timetable.year,timetable.month,i)
	end
	return tab
end

--计算给定时间的星期
function CalcWeek(Y,M,D)
	local C=string.sub(Y,1,2)
	local Ye=string.sub(Y,3,4)
	if M<3 then
		M=M+12
		Ye=Ye-1
	end
	return (math.fmod((Ye+math.floor(Ye/4)+math.floor(C/4)-2*C+math.floor(26*(M+1)/10)+D-1),7)+7)%7
end

--初始化日历
function CleanCalendar(Group)
	SKIN:Bang('!SetOptionGroup','Day'..Group,'Text','')
end

--清除当天标记
function ClearToday()
	if today[1]~= nil then
		local NumberColor={[0]="#ColorCalenSun#,240","#ColorMain2#,240","#ColorMain2#,240","#ColorMain2#,240","#ColorMain2#,240","#ColorMain2#,240","#ColorCalendar#,240"}
		SKIN:Bang('!SetOption',today[1],'FontColor',NumberColor[today[2]])
		SKIN:Bang('!HideMeter Today')
	end
end

--绘制日历
function DrawCalendar(tab,Group,Line)
	local CurrentMonth=tonumber(os.date("%Y"))*100+tonumber(os.date("%m"))
	local CurrentDay=tonumber(os.date("%d"))
	if timetable.year*100+timetable.month==CurrentMonth then
		for i=1,#tab,1 do
			if tab[i]==0 and i~=1 then
				Line=Line+1
			end
			SKIN:Bang('!SetOption',Group..Line..tab[i],'Text',i)
			--记录当天的节点编号
			if i==CurrentDay then
				today[1]=Group..Line..tab[i]
				today[2]=tab[i]
			end
		end
	else
		for i=1,#tab,1 do
			if tab[i]==0 and i~=1 then
				Line=Line+1
			end
			SKIN:Bang('!SetOption',Group..Line..tab[i],'Text',i)
		end
	end
	return Line-4
end

--调整BG Single
function SetBGSingle(ExL)
	--调整BG大小
	local Length=vari.BGH.Single+BREAK*ExL
	SKIN:Bang('!SetVariable','Ani2',Length)
	--标记标题
	SKIN:Bang('!SetOption','Year','Text',timetable.year)
	SKIN:Bang('!SetOption','Month1','Text',MonthName[timetable.month])
end

function SetMonthDouble(ExL)
	--调整第二月份标签的位置
	local Pos=vari.M2.Double+BREAK*ExL
	SKIN:Bang('!SetOption','MonthBG','Y',Pos)
	SKIN:Bang('!SetOption','Month2','Text',MonthName[timetable.month])
end

--调整BG Double
function SetBGDouble(ExL)
	--调整BG大小
	local Length=vari.BGH.Double+BREAK*ExL
	SKIN:Bang('!SetVariable','Ani2',Length)
	--标记标题
	SKIN:Bang('!SetOption','Title','Text',timetable.year..' '..MonthName[timetable.month])
end

--标记当天
function MarkToday(ExL)
	if today[1]==nil then return
	else
		local Mark=tonumber(today[1])
		local Group=math.floor(Mark/100)
		local Line=math.floor((Mark-Group*100)/10)
		local Day=today[2]
		local XPos=vari['DP'..Group].X+Day*BREAK
		local ExtendLine
		if Group==2 then
			ExtendLine=(Line-1+extend[1])*BREAK
		elseif Group==1 then
			ExtendLine=(Line-1)*BREAK
		else return end
		local YPos=vari['M'..Group][MODE]+vari['DP'..Group].Y+ExtendLine
		SKIN:Bang('!SetOption','Today','X',XPos)
		SKIN:Bang('!SetOption','Today','Y',YPos)
		SKIN:Bang('!ShowMeter Today')
		SKIN:Bang('!SetOption',today[1],'FontColor','#ColorMain1#,240')
	end
end

---------------------------------------------------

--控制模式变为双月历时的过渡动画
function ModeToDoubleAni(N)
	if tonumber(N)~=nil then ANI_MODE=tonumber(N)
	else ANI_MODE=ANI_MODE+10
	end
	--第一月份参考点位置、第二月份底高度、第二月份宽度由过渡动画来实现
	local Move1=vari.M1.Single-(vari.M1.Single-vari.M1.Double)*math.sin(math.rad(ANI_MODE))
	local Move2=vari.BGH.Single+BREAK*extend[1]+(vari.BGH.Double+BREAK*extend[2]-vari.BGH.Single)*math.sin(math.rad(ANI_MODE))
	local Move3=FW*math.sin(math.rad(ANI_MODE))
	SKIN:Bang('!SetVariable','Ani1',Move1)
	SKIN:Bang('!SetVariable','Ani2',Move2)
	SKIN:Bang('!SetVariable','Ani3',Move3)
	SKIN:Bang('!UpdateMeterGroup Ani')
	SKIN:Bang('!UpdateMeasure MeasureAction')
	SKIN:Bang('!Redraw')
end

--控制模式变为双月历时的过渡动画
function ModeToSingleAni(N)
	if tonumber(N)~=nil then ANI_MODE=tonumber(N)
	else ANI_MODE=ANI_MODE+10
	end
	--第一月份参考点位置、第二月份底高度、第二月份宽度由过渡动画来实现
	local Move1=vari.M1.Double+(vari.M1.Single-vari.M1.Double)*math.sin(math.rad(ANI_MODE))
	local Move2=vari.BGH.Double+BREAK*(extend[1]+extend[2])-(vari.BGH.Double+BREAK*extend[2]-vari.BGH.Single)*math.sin(math.rad(ANI_MODE))
	local Move3=FW-FW*math.sin(math.rad(ANI_MODE))
	SKIN:Bang('!SetVariable','Ani1',Move1)
	SKIN:Bang('!SetVariable','Ani2',Move2)
	SKIN:Bang('!SetVariable','Ani3',Move3)
	SKIN:Bang('!UpdateMeterGroup Ani')
	SKIN:Bang('!UpdateMeasure MeasureAction')
	SKIN:Bang('!Redraw')
end

--控制展开选项菜单时的过渡动画
function MenuOnAni(N)
	if tonumber(N)~=nil then ANI_MENU=tonumber(N)
	else ANI_MENU=ANI_MENU+10
	end
	local Move=MH*math.sin(math.rad(ANI_MENU))
	SKIN:Bang('!SetVariable','AniMenu',Move)
	SKIN:Bang('!UpdateMeter MenuBG')
	SKIN:Bang('!UpdateMeasure MeasureAction')
	SKIN:Bang('!Redraw')
end

--控制收起选项菜单时的过渡动画
function MenuOffAni(N)
	if tonumber(N)~=nil then ANI_MENU=tonumber(N)
	else ANI_MENU=ANI_MENU+10
	end
	local Move=MH-MH*math.sin(math.rad(ANI_MENU))
	SKIN:Bang('!SetVariable','AniMenu',Move)
	SKIN:Bang('!UpdateMeter MenuBG')
	SKIN:Bang('!UpdateMeasure MeasureAction')
	SKIN:Bang('!Redraw')
end

