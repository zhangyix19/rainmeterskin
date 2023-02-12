--[[
Name = Alarm Clock.lua
Author = ѩ�»�
Version = 1.0
License = CC BY - NC - SA 4.0
Information = �ű����ڿ���Alarm ClockƤ��
]]

alarm={}
notice={}
delnotice={}
--[[
	alarm/notice/delnotice[i]={ID,Time,IfDuplicate}
]]

function Initialize()
	MTIME=SKIN:GetMeasure('MeasureTime')
	ALLOW=tonumber(SKIN:GetVariable('SendNotice'))~=0
	IFDEL=tonumber(SKIN:GetVariable('AlarmAutoDelNotice'))~=0
	MakeAlarmTable()
	SKIN:Bang('!UpdateMeasure','MeasureTime')
	IfTime()
end

function ChangeDay()
	alarm={}
	notice={}
	MakeAlarmTable()
	SKIN:Bang('!UpdateMeasure','MeasureTime')
	IfTime()
end

-- Ϊ���н������õ����������
function MakeAlarmTable()
	local Weekday=os.date('%w')
	local Idx=0
	local AlarmTab={}
	local NoticeTab={}
	while (type(SKIN:GetVariable('AlarmTime'..Idx+1))~='nil' and SKIN:GetVariable('AlarmTime'..Idx+1)~='') do
		Idx=Idx+1
		local Type,DataTab=GetAlarmItem(Idx,Weekday)
		if Type=='Notice' then table.insert(NoticeTab,DataTab)
		elseif Type=='Alarm' then table.insert(AlarmTab,DataTab)
		end
	end
	-- ����
	local SortTable={}
	for i=1,#AlarmTab do
		local j=#SortTable
		local IfEqual=false
		while(j>0 and AlarmTab[i].Time<=AlarmTab[SortTable[j]].Time) do
			if AlarmTab[i].Time==AlarmTab[SortTable[j]].Time then
				IfEqual=true
				if (not AlarmTab[SortTable[j]].IfDuplicate) and AlarmTab[i].IfDuplicate then
					SortTable[j]=i
				end
				break
			end
			j=j-1
		end
		if not IfEqual then
			table.insert(SortTable,j+1,i)
		end
	end
	for i=#SortTable,1,-1 do
		table.insert(alarm,AlarmTab[SortTable[i]])
	end
	SortTable={}
	for i=1,#NoticeTab do
		local j=#SortTable
		local IfEqual=false
		while(j>0 and NoticeTab[i].Time<=NoticeTab[SortTable[j]].Time) do
			if NoticeTab[i].Time==NoticeTab[SortTable[j]].Time then
				IfEqual=true
				if (not NoticeTab[SortTable[j]].IfDuplicate) and NoticeTab[i].IfDuplicate then
					SortTable[j]=i
				end
				break
			end
			j=j-1
		end
		if not IfEqual then
			table.insert(SortTable,j+1,i)
		end
	end
	for i=#SortTable,1,-1 do
		table.insert(notice,NoticeTab[SortTable[i]])
	end
end

-- ��ȡÿ�����ӵ����ݲ��ж��Ƿ�����Ч
function GetAlarmItem(N,Week)
	local Time=tonumber(SKIN:GetVariable('AlarmTime'..N))
	if not AssertTime(Time) then return end
	local Type=tostring(SKIN:GetVariable('AlarmType'..N))
	if Type~='Notice' and Type~='Alarm' then return end
	if not AssertBoolean(tonumber(SKIN:GetVariable('AlarmEnable'..N))) then return end
	local IfDuplicate = AssertBoolean(tonumber(SKIN:GetVariable('AlarmDuplicate'..N)))
	if IfDuplicate then
		local Weekday=tostring(SKIN:GetVariable('AlarmWeekday'..N))
		if Weekday==nil then return end
		if string.find(Weekday,Week)==nil then return end
	end
	local Data={ID=N,Time=Time,IfDuplicate=IfDuplicate}
	return Type,Data
end

-- �ж��Ƿ�����ʱ��
function IfTime()
	local Time=tonumber(MTIME:GetValue())
	local Idx=#alarm
	while (Idx>=1 and alarm[Idx].Time<Time) do
		alarm[Idx]=nil
		Idx=Idx-1
	end
	if Idx>0 and alarm[Idx].Time==Time then
		SendAlarm(Idx)
	end
	if not ALLOW then return end
	local Idx=#notice
	while (Idx>=1 and notice[Idx].Time<Time) do
		notice[Idx]=nil
		Idx=Idx-1
	end
	if Idx>0 and notice[Idx].Time==Time then
		SendNotice(Idx)
	end
	if not IFDEL then return end
	local Idx=#delnotice
	while (Idx>=1 and delnotice[Idx].Time<=Time) do
		SendDelNotice(Idx)
		Idx=Idx-1
	end
end

-- ��������ָ��
function SendAlarm(N)
	local Tip
	local Temp=tostring(SKIN:GetVariable('AlarmTip'..alarm[N].ID))
	if Temp~=nil and Temp~='' then
		Tip=Tipsub(Temp,string.format("%02d:%02d",alarm[N].Time/100,alarm[N].Time%100))
	else
		Tip=Tipsub(tostring(SKIN:GetVariable('AlarmDefaultText')),string.format("%02d:%02d",alarm[N].Time/100,alarm[N].Time%100))
	end
	SKIN:Bang('!ActivateConfig','#CurrentConfig#\\Message','Alarm Message #ComponentSize#.ini')
	SKIN:Bang('!CommandMeasure','MeasureScript','GetMessage("'..Tip..'")','#CurrentConfig#\\Message')
	-- �����ظ����ӣ��ر�����
	if not alarm[N].IfDuplicate then
		SKIN:Bang('!WriteKeyValue','Variables','AlarmEnable'..alarm[N].ID,0,'#@#Config\\Others\\Alarm Clock.inc')
		SKIN:Bang('!SetVariable','AlarmEnable'..alarm[N].ID,0)
	end
	-- �Ӷ������Ƴ�
	alarm[N]=nil
end

-- ��������֪ͨ
function SendNotice(N)
	local Color=tostring(SKIN:GetVariable('ColorAlarm'))
	local Tip
	local Temp=tostring(SKIN:GetVariable('AlarmTip'..notice[N].ID))
	if Temp~=nil and Temp~='' then
		Tip=Tipsub(Temp,string.format("%02d:%02d",notice[N].Time/100,notice[N].Time%100))
	else
		Tip=Tipsub(tostring(SKIN:GetVariable('AlarmDefaultText')),string.format("%02d:%02d",notice[N].Time/100,notice[N].Time%100))
	end
	SKIN:Bang(
			'!CommandMeasure','MeasureScript',
			'Notice('..notice[N].ID..',"'..Color..'","Font Awesome 5 Free Solid","[\\\\xf0f3]","'..Tip..'","Alarm Clock")',
			'#RootConfig#\\Notice'
			)
	-- �����Ŀ��֪ͨɾ������
	if IFDEL then
		AddDelNotice(N)
	end
	-- �����ظ����ӣ��ر�����
	if not notice[N].IfDuplicate then
		SKIN:Bang('!WriteKeyValue','Variables','AlarmEnable'..notice[N].ID,0,'#@#Config\\Others\\Alarm Clock.inc')
		SKIN:Bang('!SetVariable','AlarmEnable'..notice[N].ID,0)
	end
	-- �Ӷ������Ƴ�
	notice[N]=nil
end

-- ����ǰ���Ӽ���֪ͨ��ֹ����
function AddDelNotice(N)
	local Hour,Min=SeparateTime(notice[N].Time)
	Hour,Min=AddingTime(Hour,Min,tonumber(SKIN:GetVariable('AlarmStayTime')))
	table.insert(delnotice,1,notice[N])
	delnotice[1].Time=Hour*100+Min
end

-- ����������ֹ֪ͨ
function SendDelNotice(N)
	SKIN:Bang(
			'!CommandMeasure','MeasureScript',
			'DelNotice('..delnotice[N].ID..',"Alarm Clock",false)',
			'#RootConfig#\\Notice'
			)
	-- �Ӷ������Ƴ�
	delnotice[N]=nil
end

--����֪ͨɾ������ź�
function NoticeDelOver(Index,IfAction)
end

--����֪ͨδ�������ź�
function NoticeNotAccept(Index)
end

--*************************************************

-- �ж�һ�����������ݶ�Ӧ���
function AssertBoolean(Num)
	if Num==nil then return false
	else
		return Num~=0
	end
end

-- �ж�һ�������������Ƿ�Ϊʱ���ʽ
function AssertTime(Time)
	if Time==nil then return false end
	local Hour,Min=SeparateTime(Time)
	if Hour==nil or Hour<0 or Hour>=24 then return false end
	if Min==nil or math.floor(Min)~=Min or Min<0 or Min>=60 then return false end
	return true
end

--����ʱ��Ϊʱ����
function SeparateTime(Time)
	local Min=Time%100
	local Hour=math.floor(Time/100)
	return Hour,Min
end

-- ʱ�����
function AddingTime(Hour,Min,MinAdd)
	Min=Min+MinAdd
	if Min>=60 then
		Hour=math.floor(Min/60)
		Min=Min%60
	end
	if Hour>=24 then
		Hour=Hour%24
	end
	return Hour,Min
end

-- �滻�ַ����е�*
function Tipsub(Tip,Str)
	return (string.gsub(Tip,'%*',Str))
end

