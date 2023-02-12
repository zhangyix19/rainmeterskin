--[[
Name = ScheduleNotice.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制ScheduleNotice皮肤进行通知操作
]]

function Initialize()
	ALLOW=tonumber(SKIN:GetVariable('SendNotice'))~=0
	if not ALLOW then
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
		return
	else
		MTIME=SKIN:GetMeasure('MeasureTime')
	end
end

function ChangeDay()
	SKIN:Bang('!EnableMeasureGroup FileView')
	SKIN:Bang('!Update')
	SKIN:Bang('!CommandMeasure mLogFolder "Update"')
end

-- 由[mLogFolder]获取完毕后执行
function GetScheduleFolderOver()
	if tonumber(SKIN:GetVariable('StopNoticeForOnce'))~=0 then
		SKIN:Bang('!WriteKeyValue','Variables','StopNoticeForOnce',0)
		return
	end
	ClearScheduleFile()
	local ScheNum=ReadScheduleFile()
	if ScheNum>0 then
		SendNotice(ScheNum)
	end
end

-- 删除旧日志
function ClearScheduleFile()
	local Today=GetToday()
	local mFile=SKIN:GetMeasure('LogFile')
	local mCount=SKIN:GetMeasure('LogFileCount')
	local Count=tonumber(mCount:GetValue())
	local Name
	for i=1,Count do
		Name=tonumber(mFile:GetStringValue())
		if Name<Today then
			os.remove(SKIN:MakePathAbsolute(SELF:GetOption("LogFolder"))..'\\'..Name..'.txt')
		end
		SKIN:Bang('!CommandMeasure mLogFolder IndexDown')
		SKIN:Bang('!UpdateMeasure LogFile')
	end
	SKIN:Bang('!DisableMeasureGroup FileView')
end

-- 获取今天的事项个数
function ReadScheduleFile()
	local Today=GetToday()
	local File=io.open(SKIN:MakePathAbsolute(SELF:GetOption("LogFolder"))..'\\'..Today..'.txt','r')
	if not File then return 0
	else
		local Idx=0
		for l in File:lines() do
			if l ~='' then
				Idx=Idx+1
			end
		end
		File:close()
		return Idx
	end
end

-- 发送通知指令
function SendNotice(N)
	local Color=tostring(SKIN:GetVariable('ColorSchedule'))
	local Tip=Tipsub(tostring(SKIN:GetVariable('ScheduleNumberTip')),tostring(N))
	SKIN:Bang(
			'!CommandMeasure',
			'MeasureScript',
			'Notice("1","'..Color..'","Font Awesome 5 Free Solid","[\\\\xf007]","'..Tip..'","Schedule\\\\ScheduleNotice")',
			'#RootConfig#\\Notice'
			)
end

-- 接收通知删除完毕信号
function NoticeDelOver(Index,IfAction)
	if IfAction then
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
		SKIN:Bang('!ActivateConfig','#RootConfig#\\Schedule','Schedule #ComponentSize#.ini')
		SKIN:Bang('!CommandMeasure','MeasureScript','ChangeType("Schedule")','#RootConfig#\\Schedule')
	end
end

-- 接收通知未被接受信号
function NoticeNotAccept(Index)
end

--*************************************************

-- 获取当前日期并返回数字型YYYYMMDD格式
function GetToday()
	local Tab=os.date("*t")
	return tonumber(string.format("%04d%02d%02d",Tab.year,Tab.month,Tab.day))
end

-- 划分时间为时、分
function SeparateTime(Time)
	local Min=Time%100
	local Hour=math.floor(Time/100)
	return Hour,Min
end

-- 替换字符串中的*
function Tipsub(Tip,Str)
	return (string.gsub(Tip,'%*',Str))
end

