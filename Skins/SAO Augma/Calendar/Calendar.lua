--[[
Name = Calendar.lua
Author = ѩ�»�
Version = 1.0
License = CC BY - NC - SA 4.0
Information = �ű����ڿ���CalendarƤ��
Source = ���� SoLivC �� LuaCon.lua �ű���ժ��Ƥ�� Elf Suit 
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

--���ڸ���ʱִ��
function NextDay()
	STtLT()
	Load[MODE]()
end

--�޸��·�ʱִ��
function ChangeMonth(Step)
	ChangeTime(Step)
	Load[MODE]()
	SKIN:Bang('!UpdateMeter BG')
	SKIN:Bang('!UpdateMeter MonthBG')
	SKIN:Bang('!Update')
end

---------------------------------------------------

--���ƿ����ر�ѡ��˵����л�ģʽ
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

--�л�����ģʽʱִ��
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

--��ȡ����
function GetVari()
	--����ģʽ
	MODE=tostring(SKIN:GetVariable('TypeCalendar'),'Single')
	IFMENU=false
	if MODE=='Single' then IFDOUBLE=false
	elseif MODE=='Double' then IFDOUBLE=true
	end
	--���浱��Ľڵ��š�����
	today={}
	--���������·ݵ������ײ�����������
	extend={}
	--�����м��
	BREAK=SELF:GetOption('DayBreak')
	--�ڶ��±�����
	FW=SELF:GetOption('FlagWidth')
	--ѡ��˵��߶�
	MH=SELF:GetOption('MenuHeight')
	local tab={
				--�����һ���µĲ��յ�����
				M1='FirMonth',
				--����ڶ����µĲ��յ�����
				M2='SecMonth',
				--����BG�߶�
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
	--��ȡ�·ݱ���
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

--����Lua����ʱ��Ϊϵͳʱ��
function STtLT()
	timetable=os.date("*t")
	FebDays()
end

--����Lua����ʱ��Ķ��·�����
function FebDays()
	if ( timetable.year % 100 == 0 and timetable.year % 400 == 0 ) or ( timetable.year % 100 ~= 0 and timetable.year % 4 == 0)then
		MonthDay[2]=29
	else
		MonthDay[2]=28
	end
end

--�޸�Lua�����·�
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

--����BG Single
BG.Single = function()
	SKIN:Bang('!SetVariable','Ani1',vari.M1.Single)
	SKIN:Bang('!SetOption','MonthBG','Y',vari.M2.Single)
	SKIN:Bang('!ShowMeterGroup Single')
	SKIN:Bang('!SetOption','Opt1','Text','#TR_MenuCheckDoubleMonth#')
end

--����BG Double
BG.Double = function()
	SKIN:Bang('!SetVariable','Ani1',vari.M1.Double)
	SKIN:Bang('!ShowMeter Title')
	SKIN:Bang('!ShowMeterGroup SecMonth')
	SKIN:Bang('!SetOption','Opt1','Text','#TR_MenuCheckSingleMonth#')
end

--����BG ת����Double
BG.ToDouble = function()
	SKIN:Bang('!SetOption','MonthBG','Y',vari.M2.Double)
	SKIN:Bang('!HideMeterGroup Single')
	SKIN:Bang('!ShowMeter MonthBG')
	SKIN:Bang('!HideMeterGroup Day2')
end

--����BG ת����Single
BG.ToSingle = function()
	SKIN:Bang('!SetOption','MonthBG','Y',vari.M2.Single)
	SKIN:Bang('!HideMeterGroup Day2')
	SKIN:Bang('!HideMeter Title')
	SKIN:Bang('!HideMeter Month2')
end

--����Ƥ�� Single
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

--����Ƥ�� Double
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

--����Ƥ�� ת����Double
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

--����Ƥ�� ת����Single
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

--����������������ڱ�weektable
function MakeWeekTable(Md)
	local tab={}
	for i=1,Md,1 do
		tab[i]=CalcWeek(timetable.year,timetable.month,i)
	end
	return tab
end

--�������ʱ�������
function CalcWeek(Y,M,D)
	local C=string.sub(Y,1,2)
	local Ye=string.sub(Y,3,4)
	if M<3 then
		M=M+12
		Ye=Ye-1
	end
	return (math.fmod((Ye+math.floor(Ye/4)+math.floor(C/4)-2*C+math.floor(26*(M+1)/10)+D-1),7)+7)%7
end

--��ʼ������
function CleanCalendar(Group)
	SKIN:Bang('!SetOptionGroup','Day'..Group,'Text','')
end

--���������
function ClearToday()
	if today[1]~= nil then
		local NumberColor={[0]="#ColorCalenSun#,240","#ColorMain2#,240","#ColorMain2#,240","#ColorMain2#,240","#ColorMain2#,240","#ColorMain2#,240","#ColorCalendar#,240"}
		SKIN:Bang('!SetOption',today[1],'FontColor',NumberColor[today[2]])
		SKIN:Bang('!HideMeter Today')
	end
end

--��������
function DrawCalendar(tab,Group,Line)
	local CurrentMonth=tonumber(os.date("%Y"))*100+tonumber(os.date("%m"))
	local CurrentDay=tonumber(os.date("%d"))
	if timetable.year*100+timetable.month==CurrentMonth then
		for i=1,#tab,1 do
			if tab[i]==0 and i~=1 then
				Line=Line+1
			end
			SKIN:Bang('!SetOption',Group..Line..tab[i],'Text',i)
			--��¼����Ľڵ���
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

--����BG Single
function SetBGSingle(ExL)
	--����BG��С
	local Length=vari.BGH.Single+BREAK*ExL
	SKIN:Bang('!SetVariable','Ani2',Length)
	--��Ǳ���
	SKIN:Bang('!SetOption','Year','Text',timetable.year)
	SKIN:Bang('!SetOption','Month1','Text',MonthName[timetable.month])
end

function SetMonthDouble(ExL)
	--�����ڶ��·ݱ�ǩ��λ��
	local Pos=vari.M2.Double+BREAK*ExL
	SKIN:Bang('!SetOption','MonthBG','Y',Pos)
	SKIN:Bang('!SetOption','Month2','Text',MonthName[timetable.month])
end

--����BG Double
function SetBGDouble(ExL)
	--����BG��С
	local Length=vari.BGH.Double+BREAK*ExL
	SKIN:Bang('!SetVariable','Ani2',Length)
	--��Ǳ���
	SKIN:Bang('!SetOption','Title','Text',timetable.year..' '..MonthName[timetable.month])
end

--��ǵ���
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

--����ģʽ��Ϊ˫����ʱ�Ĺ��ɶ���
function ModeToDoubleAni(N)
	if tonumber(N)~=nil then ANI_MODE=tonumber(N)
	else ANI_MODE=ANI_MODE+10
	end
	--��һ�·ݲο���λ�á��ڶ��·ݵ׸߶ȡ��ڶ��·ݿ���ɹ��ɶ�����ʵ��
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

--����ģʽ��Ϊ˫����ʱ�Ĺ��ɶ���
function ModeToSingleAni(N)
	if tonumber(N)~=nil then ANI_MODE=tonumber(N)
	else ANI_MODE=ANI_MODE+10
	end
	--��һ�·ݲο���λ�á��ڶ��·ݵ׸߶ȡ��ڶ��·ݿ���ɹ��ɶ�����ʵ��
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

--����չ��ѡ��˵�ʱ�Ĺ��ɶ���
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

--��������ѡ��˵�ʱ�Ĺ��ɶ���
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

