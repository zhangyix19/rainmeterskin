--[[
Name = Alarm.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Auxiliary皮肤的Alarm页面
]]

alarm={}
--[[
	alarm[i]={ID,Time,Type,IfDuplicate,IfEnable,DupDay}
]]
INDEX=1
set={DupDay={}}
--[[
	set={AlarmID,Hour,Min,Type,IfDuplicate,Tip,DupDay={[1]~[7]}}
]]

-- UI Text Translate
TR_AlarmType={}
TR_Week={}
TR_AlarmRepeat={}
TR_AlarmButton={}

function Initialize()
	GetConfig()
	MakeAlarmTable()
	DrawAlarmList()
end

function GetConfig()
	DEFAULTTIP=tostring(SELF:GetOption('DefaultTipText'))
	-- UI Text Translate
	TR_AlarmType.Alarm=SKIN:GetVariable('TR_AlarmTypeAlarm2')
	TR_AlarmType.Notice=SKIN:GetVariable('TR_AlarmTypeNotice2')
	TR_Week[1]=SKIN:GetVariable('TR_WeekMon')
	TR_Week[2]=SKIN:GetVariable('TR_WeekTue')
	TR_Week[3]=SKIN:GetVariable('TR_WeekWed')
	TR_Week[4]=SKIN:GetVariable('TR_WeekThur')
	TR_Week[5]=SKIN:GetVariable('TR_WeekFri')
	TR_Week[6]=SKIN:GetVariable('TR_WeekSat')
	TR_Week[7]=SKIN:GetVariable('TR_WeekSun')
	TR_AlarmRepeat.Once=SKIN:GetVariable('TR_AlarmRepeatOnce2')
	TR_AlarmRepeat.Everyday=SKIN:GetVariable('TR_AlarmRepeatEveryday2')
	TR_AlarmRepeat.Weekday=SKIN:GetVariable('TR_AlarmRepeatWeekday2')
	TR_AlarmRepeat.MonToSat=SKIN:GetVariable('TR_AlarmRepeatMonToSat2')
	TR_AlarmRepeat.Custom=SKIN:GetVariable('TR_AlarmRepeatCustom2')
	TR_AlarmButton.Add=SKIN:GetVariable('TR_AlarmButtonAdd')
	TR_AlarmButton.Edit=SKIN:GetVariable('TR_AlarmButtonEdit')
end

function SkinClose()
	SKIN:Bang('!Refresh','#RootConfig#\\Alarm Clock')
end

---------------------------------------------------
-- 解析变量数据
---------------------------------------------------

-- 为所有闹钟填入表
function MakeAlarmTable()
	local Idx=0
	local AlarmTab={}
	while (type(SKIN:GetVariable('AlarmTime'..Idx+1))~='nil' and SKIN:GetVariable('AlarmTime'..Idx+1)~='') do
		Idx=Idx+1
		table.insert(AlarmTab,GetAlarmItem(Idx))
	end
	-- 排序
	local SortTable={}
	for i=1,#AlarmTab do
		local j=#SortTable
		while(j>0 and AlarmTab[i].Time<AlarmTab[SortTable[j]].Time) do
			j=j-1
		end
		table.insert(SortTable,j+1,i)
	end
	for i=1,#SortTable do
		table.insert(alarm,AlarmTab[SortTable[i]])
	end
end

-- 获取每个闹钟的数据
function GetAlarmItem(N)
	local Data={ID=N}
	Data.Time=tonumber(SKIN:GetVariable('AlarmTime'..N))
	if not AssertTime(Data.Time,false) then
		ChangeVariable('AlarmTime'..N,9999)
		Data.Time=9999
	end
	Data.Type=tostring(SKIN:GetVariable('AlarmType'..N))
	if Data.Type~='Notice' and Data.Type~='Alarm' then
		ChangeVariable('AlarmType'..N,'Notice')
		Data.Type='Notice'
	end
	Data.IfEnable= AssertBoolean(tonumber(SKIN:GetVariable('AlarmEnable'..N)))
	Data.IfDuplicate = AssertBoolean(tonumber(SKIN:GetVariable('AlarmDuplicate'..N)))
	Data.DupDay=CalcDuplicateDay(tostring(SKIN:GetVariable('AlarmWeekday'..N)))
	if Data.DupDay==0 and Data.IfDuplicate then
		Data.IfDuplicate=false
		ChangeVariable('AlarmDuplicate'..N,0)
	end
	return Data
end

-- 计算闹钟的重复日
function CalcDuplicateDay(Str)
	local TotalNum=0
	for i=1,6 do
		if string.find(Str,tostring(i))~=nil then
			TotalNum=TotalNum+math.pow(10,i-1)
		end
	end
	if string.find(Str,'0')~=nil then
		TotalNum=TotalNum+math.pow(10,6)
	end
	return TotalNum
end

---------------------------------------------------
-- 展示表
---------------------------------------------------

function DrawAlarmList()
	SKIN:Bang('!HideMeterGroup','Main')
	for i=1,5 do
		local Idx=INDEX+i-1
		if alarm[Idx]~=nil then
			SKIN:Bang('!ShowMeterGroup','Main0'..i)
			SKIN:Bang('!SetOption',i..'Time','Text',string.format("%02d:%02d",alarm[Idx].Time/100,alarm[Idx].Time%100))
			if alarm[Idx].IfEnable then
				SKIN:Bang('!SetOption',i..'Switch','Text','[\\xf205]')
				SKIN:Bang('!SetOption',i..'Time','FontColor','#ColorMain2#')
				SKIN:Bang('!SetOption',i..'Detail','FontColor','#ColorMain2#')
				SKIN:Bang('!SetOption',i..'Switch','FontColor','#ColorSetting#')
			else
				SKIN:Bang('!SetOption',i..'Switch','Text','[\\xf204]')
				SKIN:Bang('!SetOption',i..'Time','FontColor','#ColorMain3#,200')
				SKIN:Bang('!SetOption',i..'Detail','FontColor','#ColorMain3#,200')
				SKIN:Bang('!SetOption',i..'Switch','FontColor','#ColorMain3#,200')
			end
			SKIN:Bang('!SetOption',i..'Detail','Text',GetAlarmDetail(Idx))
			SKIN:Bang('!UpdateMeterGroup','Main0'..i)
		else break
		end
	end
	if #alarm>=INDEX+4 then
		SKIN:Bang('!ShowMeter','MainBottomTab')
		if #alarm>INDEX+4 then
			SKIN:Bang('!ShowMeter','NextFlag')
		end
	end
	if INDEX~=1 then
		SKIN:Bang('ShowMeter','PreFlag')
	end
	SKIN:Bang('!Redraw')
end

-- 排布闹钟详细信息文字
function GetAlarmDetail(N)
	if not alarm[N].IfDuplicate then
		return TR_AlarmType[alarm[N].Type]..' | '..TR_AlarmRepeat.Once
	else
		local Num=alarm[N].DupDay
		local StrTemp='1234567'
		if Num==1111111 then StrTemp=TR_AlarmRepeat.Everyday
		elseif Num==111111 then StrTemp=TR_AlarmRepeat.MonToSat
		elseif Num==11111 then StrTemp=TR_AlarmRepeat.Weekday
		else
			for i=1,7 do
				if Num%10==1 then
					local StrTemp2=string.gsub(StrTemp,tostring(i),TR_Week[i])
					StrTemp=StrTemp2
				else
					local StrTemp2=string.gsub(StrTemp,tostring(i),'')
					StrTemp=StrTemp2
				end
				Num=math.floor(Num/10)
			end
		end
		return TR_AlarmType[alarm[N].Type]..' | '..StrTemp
	end
end

-- 上一页
function PrePage()
	if #alarm<=5 then return
	else
		if INDEX==1 then return
		else
			INDEX=INDEX-1
			DrawAlarmList()
		end
	end
end

-- 下一页
function NextPage()
	if INDEX+4>=#alarm then return
	else
		INDEX=INDEX+1
		DrawAlarmList()
	end
end

---------------------------------------------------
-- 设置部分
---------------------------------------------------

-- 开启闹钟设置面板
function SetOpen(N)
	SKIN:Bang('!HideMeterGroup','MainBG')
	SKIN:Bang('!ShowMeterGroup','Set')
	-- 将所设置的闹钟项目写入set表临时存储
	set.AlarmID=N
	if N==0 then
		set.Hour=(tonumber(os.date('%H'))+1)%24
		set.Min=tonumber(os.date('%M'))
		set.Type='Notice'
		set.IfDuplicate=false
		set.Tip=''
		for i=1,7 do
			set.DupDay[i] = i<=5
		end
		SKIN:Bang('!SetOption','SetOKText','Text',TR_AlarmButton.Add)
	else
		set.Hour,set.Min=SeparateTime(alarm[N].Time)
		set.Type=alarm[N].Type
		set.IfDuplicate=alarm[N].IfDuplicate
		set.Tip=tostring(SKIN:GetVariable('AlarmTip'..alarm[N].ID))
		local Num=alarm[N].DupDay
		for i=1,7 do
			set.DupDay[i] = Num%10~=0
			Num=math.floor(Num/10)
		end
		SKIN:Bang('!SetOption','SetOKText','Text',TR_AlarmButton.Edit)
	end
	-- 设置各项的显示值
	SKIN:Bang('!SetOption','SetHour','Text',string.format("%02d",set.Hour))
	SKIN:Bang('!SetOption','SetMin','Text',string.format("%02d",set.Min))
	SKIN:Bang('!SetOption','Set01Val','Text',TR_AlarmType[set.Type])
	local IfCus=false
	if not set.IfDuplicate then
		SKIN:Bang('!SetOption','Set02Val','Text',TR_AlarmRepeat.Once)
	else
		local ResNum=0
		for i=1,7 do
			ResNum=ResNum+math.pow(10,i-1)*(set.DupDay[i] and 1 or 0)
		end
		if ResNum==1111111 then
			SKIN:Bang('!SetOption','Set02Val','Text',TR_AlarmRepeat.Everyday)
		elseif ResNum==111111 then
			SKIN:Bang('!SetOption','Set02Val','Text',TR_AlarmRepeat.MonToSat)
		elseif ResNum==11111 then
			SKIN:Bang('!SetOption','Set02Val','Text',TR_AlarmRepeat.Weekday)
		else
			SKIN:Bang('!SetOption','Set02Val','Text',TR_AlarmRepeat.Custom)
			IfCus=true
		end
	end
	if set.Tip~=nil and set.Tip ~='' then
		SKIN:Bang('!SetOption','SetTipVal','Text',set.Tip)
	else
		SKIN:Bang('!SetOption','SetTipVal','Text',DEFAULTTIP)
	end
	SKIN:Bang('!UpdateMeterGroup','Set')
	if IfCus then
		DrawCustomDupDay()
	else
		SKIN:Bang('!Redraw')
	end
end

-- 绘制重复类型部分Meter
function DrawCustomDupDay()
	SKIN:Bang('!ShowMeterGroup','CusDup')
	for i=1,7 do
		if set.DupDay[i] then
			SKIN:Bang('!SetOption','Week'..i..'B','Color','Fill Color #ColorSetting#')
			SKIN:Bang('!SetOption','Week'..i..'T','FontColor','255,255,255')
		else
			SKIN:Bang('!SetOption','Week'..i..'B','Color','Fill Color #ColorMain3#,20')
			SKIN:Bang('!SetOption','Week'..i..'T','FontColor','#ColorMain2#')
		end
	end
	SKIN:Bang('!UpdateMeterGroup','CusDup')
	SKIN:Bang('!Redraw')
end

---------------------------------------------------
-- 鼠标动作
---------------------------------------------------

function MainOpenSet(N)
	SetOpen(INDEX+N-1)
end

function MainToggleEnable(N)
	local Idx=INDEX+N-1
	if alarm[Idx].IfEnable then
		ChangeVariable('AlarmEnable'..alarm[Idx].ID,0)
		alarm[Idx].IfEnable=false
		SKIN:Bang('!SetOption',N..'Switch','Text','[\\xf204]')
		SKIN:Bang('!SetOption',N..'Time','FontColor','#ColorMain3#,200')
		SKIN:Bang('!SetOption',N..'Detail','FontColor','#ColorMain3#,200')
		SKIN:Bang('!SetOption',N..'Switch','FontColor','#ColorMain3#,200')
		SKIN:Bang('!UpdateMeterGroup','Main0'..N)
		SKIN:Bang('!Redraw')
	else
		local Check1=AssertTime(alarm[Idx].Time,true)
		local Check2=not AssertBoolean(alarm[Idx].IfDuplicate) or (alarm[Idx].DupDay>0)
		if Check1 and Check2 then
			ChangeVariable('AlarmEnable'..alarm[Idx].ID,1)
			alarm[Idx].IfEnable=true
		SKIN:Bang('!SetOption',N..'Switch','Text','[\\xf205]')
		SKIN:Bang('!SetOption',N..'Time','FontColor','#ColorMain2#')
		SKIN:Bang('!SetOption',N..'Detail','FontColor','#ColorMain2#')
		SKIN:Bang('!SetOption',N..'Switch','FontColor','#ColorSetting#')
		SKIN:Bang('!UpdateMeterGroup','Main0'..N)
		SKIN:Bang('!Redraw')
		else
			SetOpen(Idx)
		end
	end
end

function AddAlarm()
	SetOpen(0)
end

function InputHourReady(Pos)
	SKIN:Bang('!SetOption','MeasureInput','X',Pos)
	SKIN:Bang('!SetOption','MeasureInput','StringAlign','Right')
	SKIN:Bang('!SetOption','MeasureInput','DefaultValue',string.format("%02d",set.Hour))
	SKIN:Bang('!UpdateMeasure','MeasureInput')
	SKIN:Bang('!CommandMeasure','MeasureInput','ExecuteBatch 1')
end

function InputHourOver(Num)
	if Num~=nil and Num>=0 and Num<24 then
		set.Hour=Num
		SKIN:Bang('!SetOption','SetHour','Text',string.format("%02d",set.Hour))
		SKIN:Bang('!UpdateMeter','SetHour')
		SKIN:Bang('!Redraw')
	end
end

function HourPlus()
	set.Hour=(set.Hour+1)%24
	SKIN:Bang('!SetOption','SetHour','Text',string.format("%02d",set.Hour))
	SKIN:Bang('!UpdateMeter','SetHour')
	SKIN:Bang('!Redraw')
end

function HourMinus()
	set.Hour=(set.Hour+23)%24
	SKIN:Bang('!SetOption','SetHour','Text',string.format("%02d",set.Hour))
	SKIN:Bang('!UpdateMeter','SetHour')
	SKIN:Bang('!Redraw')
end

function InputMinReady(Pos)
	SKIN:Bang('!SetOption','MeasureInput','X',Pos)
	SKIN:Bang('!SetOption','MeasureInput','StringAlign','Left')
	SKIN:Bang('!SetOption','MeasureInput','DefaultValue',string.format("%02d",set.Min))
	SKIN:Bang('!UpdateMeasure','MeasureInput')
	SKIN:Bang('!CommandMeasure','MeasureInput','ExecuteBatch 2')
end

function InputMinOver(Num)
	if Num~=nil and Num>=0 and Num<60 then
		set.Min=Num
		SKIN:Bang('!SetOption','SetMin','Text',string.format("%02d",set.Min))
		SKIN:Bang('!UpdateMeter','SetMin')
		SKIN:Bang('!Redraw')
	end
end

function MinPlus()
	set.Min=(set.Min+1)%60
	SKIN:Bang('!SetOption','SetMin','Text',string.format("%02d",set.Min))
	SKIN:Bang('!UpdateMeter','SetMin')
	SKIN:Bang('!Redraw')
end

function MinMinus()
	set.Min=(set.Min+59)%60
	SKIN:Bang('!SetOption','SetMin','Text',string.format("%02d",set.Min))
	SKIN:Bang('!UpdateMeter','SetMin')
	SKIN:Bang('!Redraw')
end

function InputTipReady()
	SKIN:Bang('!SetOption','MeasureInputTip','DefaultValue',set.Tip)
	SKIN:Bang('!UpdateMeasure','MeasureInputTip')
	SKIN:Bang('!CommandMeasure','MeasureInputTip','ExecuteBatch 1')
end

function InputTipOver()
	local Measure=SKIN:GetMeasure('MeasureInputTip')
	local Value=Measure:GetStringValue()
	set.Tip=Value
	if set.Tip~=nil and set.Tip~='' then
		SKIN:Bang('!SetOption','SetTipVal','Text',set.Tip)
	else
		SKIN:Bang('!SetOption','SetTipVal','Text',DEFAULTTIP)
	end
	SKIN:Bang('!UpdateMeter','SetTipVal')
	SKIN:Bang('!Redraw')
end

function SetOpenTypePanel()
	SKIN:Bang('!HideMeterGroup','SetBottom')
	SKIN:Bang('!ShowMeter','PanelBG')
	SKIN:Bang('!ShowMeterGroup','PanelType')
	SKIN:Bang('!Redraw')
end

function PanelSetAlarmType(TypeStr)
	if TypeStr=='Notice' or TypeStr=='Alarm' then
		set.Type=TypeStr
	end
	SKIN:Bang('!HideMeterGroup','Panel')
	SKIN:Bang('!ShowMeterGroup','SetBottom')
	SKIN:Bang('!SetOption','Set01Val','Text',TR_AlarmType[set.Type])
	SKIN:Bang('!UpdateMeter','Set01Val')
	SKIN:Bang('!Redraw')
end

function SetOpenDupPanel()
	SKIN:Bang('!HideMeterGroup','SetBottom')
	SKIN:Bang('!ShowMeter','PanelBG')
	SKIN:Bang('!ShowMeterGroup','PanelDup')
	SKIN:Bang('!Redraw')
end

function PanelSetAlarmDup(FlagNum)
	SKIN:Bang('!HideMeterGroup','Panel')
	SKIN:Bang('!ShowMeterGroup','SetBottom')
	if FlagNum==4 then
		set.IfDuplicate=true
		SKIN:Bang('!SetOption','Set02Val','Text',TR_AlarmRepeat.Custom)
		SKIN:Bang('!UpdateMeter','Set02Val')
		DrawCustomDupDay()
	else
		SKIN:Bang('!HideMeterGroup','CusDup')
		if FlagNum==0 then
			set.IfDuplicate=false
			SKIN:Bang('!SetOption','Set02Val','Text',TR_AlarmRepeat.Once)
		else set.IfDuplicate=true
			if FlagNum==1 then
				SKIN:Bang('!SetOption','Set02Val','Text',TR_AlarmRepeat.Everyday)
				for i=1,7 do
					set.DupDay[i]=true
				end
			elseif FlagNum==2 then
				SKIN:Bang('!SetOption','Set02Val','Text',TR_AlarmRepeat.Weekday)
				for i=1,7 do
					set.DupDay[i] = i<=5
				end
			elseif FlagNum==3 then
				SKIN:Bang('!SetOption','Set02Val','Text',TR_AlarmRepeat.MonToSat)
				for i=1,7 do
					set.DupDay[i] = i<=6
				end
			end
		end
		SKIN:Bang('!UpdateMeter','Set02Val')
		SKIN:Bang('!Redraw')
	end
end

function SetToggleDupWeek(N)
	if not set.DupDay[N] then
		set.DupDay[N]=true
		SKIN:Bang('!SetOption','Week'..N..'B','Color','Fill Color #ColorSetting#')
		SKIN:Bang('!SetOption','Week'..N..'T','FontColor','255,255,255')
	else
		set.DupDay[N]=false
		SKIN:Bang('!SetOption','Week'..N..'B','Color','Fill Color #ColorMain3#,20')
		SKIN:Bang('!SetOption','Week'..N..'T','FontColor','#ColorMain2#')
	end
	SKIN:Bang('!UpdateMeter','Week'..N..'B')
	SKIN:Bang('!UpdateMeter','Week'..N..'T')
	SKIN:Bang('!Redraw')
end

-- 确定修改\添加闹钟
function SetOK()
	local Idx
	if set.AlarmID==0 then
		Idx=#alarm+1
	else
		Idx=alarm[set.AlarmID].ID
	end
	-- 修改变量
	ChangeVariable('AlarmTime'..Idx,string.format("%02d%02d",set.Hour,set.Min))
	ChangeVariable('AlarmType'..Idx,set.Type)
	ChangeVariable('AlarmTip'..Idx,set.Tip)
	local TempStr=set.DupDay[7] and '0' or ''
	for i=1,6 do
		local Temp1=set.DupDay[i] and tostring(i) or ''
		local Temp2=TempStr..Temp1
		TempStr=Temp2
	end
	if TempStr=='' then
		ChangeVariable('AlarmDuplicate'..Idx,0)
		ChangeVariable('AlarmWeekday'..Idx,TempStr)
		set.IfDuplicate=false
	else
		ChangeVariable('AlarmDuplicate'..Idx,set.IfDuplicate and 1 or 0)
		ChangeVariable('AlarmWeekday'..Idx,TempStr)
	end
	ChangeVariable('AlarmEnable'..Idx,1)
	local DupNum=0
	for i=1,7 do
		DupNum=DupNum+math.pow(10,i-1)*(set.DupDay[i] and 1 or 0)
	end
	local DataTab={
		ID=Idx, Time=set.Hour*100+set.Min, Type=set.Type,
		IfDuplicate=set.IfDuplicate, IfEnable=true,
		DupDay=DupNum
		}
	-- 排序
	InsertAlarm(set.AlarmID,DataTab)
	-- 处理Meter
	SKIN:Bang('!HideMeterGroup','Set')
	SKIN:Bang('!HideMeterGroup','CusDup')
	SKIN:Bang('!ShowMeter','TitleBarBack')
	SKIN:Bang('!ShowMeter','TitleBarAdd')
	DrawAlarmList()
end

-- 沿顺序插入新增闹钟\闹钟重新排序
function InsertAlarm(AlarmID,DataTab)
	if AlarmID~=0 and alarm[AlarmID].Time==DataTab.Time then
		alarm[AlarmID]=DataTab
	else
		if AlarmID~=0 then
			table.remove(alarm,AlarmID)
		end
		local i=#alarm
		while(i>0 and DataTab.Time<alarm[i].Time) do
			i=i-1
		end
		table.insert(alarm,i+1,DataTab)
	end
end

-- 删除闹钟
function SetDelete()
	if set.AlarmID~=0 then
		local Idx=alarm[set.AlarmID].ID
		for i=Idx,#alarm do
			ChangeVariable('AlarmTime'..i,SKIN:GetVariable('AlarmTime'..i+1) or '')
			ChangeVariable('AlarmType'..i,SKIN:GetVariable('AlarmType'..i+1) or '')
			ChangeVariable('AlarmTip'..i,SKIN:GetVariable('AlarmTip'..i+1) or '')
			ChangeVariable('AlarmDuplicate'..i,SKIN:GetVariable('AlarmDuplicate'..i+1) or '')
			ChangeVariable('AlarmWeekday'..i,SKIN:GetVariable('AlarmWeekday'..i+1) or '')
			ChangeVariable('AlarmEnable'..i,SKIN:GetVariable('AlarmEnable'..i+1) or '')
		end
		table.remove(alarm,set.AlarmID)
		for i=1,#alarm do
			if alarm[i].ID>Idx then
				alarm[i].ID=alarm[i].ID-1
			end
		end
	end
	SKIN:Bang('!HideMeterGroup','Set')
	SKIN:Bang('!HideMeterGroup','CusDup')
	SKIN:Bang('!ShowMeter','TitleBarBack')
	SKIN:Bang('!ShowMeter','TitleBarAdd')
	DrawAlarmList()
end

--*************************************************

-- 判断一个数字类数据对应真假
function AssertBoolean(Num)
	if Num==nil then return false
	else
		return Num~=0
	end
end

-- 判断一个数字类数据是否为时间格式
function AssertTime(Time,IfCheckLimit)
	if Time==nil then return false end
	local Hour,Min=SeparateTime(Time)
	if Hour==nil or Hour<0 then return false end
	if Min==nil or math.floor(Min)~=Min or Min<0 then return false end
	if IfCheckLimit then
		if Hour>=24 then return false end
		if Min>=60 then return false end
	end
	return true
end

--划分时间为时、分
function SeparateTime(Time)
	local Min=Time%100
	local Hour=math.floor(Time/100)
	return Hour,Min
end

-- 时间相加
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

-- 替换字符串中的*
function Tipsub(Tip,Str)
	return (string.gsub(Tip,'%*',Str))
end

-- 更改变量（特定配置文件）
function ChangeVariable(Variable,Value)
	if Value~=nil then
		SKIN:Bang('!SetVariable',Variable,Value)
	end
	WriteVariable(Variable,Value)
end

function WriteVariable(Variable,Value)
	if Value==nil then Value=SKIN:GetVariable(Variable) end
	SKIN:Bang('!WriteKeyValue','Variables',Variable,Value,'#@#Config\\Others\\Alarm Clock.inc')
end

