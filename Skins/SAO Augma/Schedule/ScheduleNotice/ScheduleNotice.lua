--[[
Name = ScheduleNotice.lua
Author = ѩ�»�
Version = 1.0
License = CC BY - NC - SA 4.0
Information = �ű����ڿ���ScheduleNoticeƤ������֪ͨ����
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

-- ��[mLogFolder]��ȡ��Ϻ�ִ��
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

-- ɾ������־
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

-- ��ȡ������������
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

-- ����ָ֪ͨ��
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

-- ����֪ͨɾ������ź�
function NoticeDelOver(Index,IfAction)
	if IfAction then
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
		SKIN:Bang('!ActivateConfig','#RootConfig#\\Schedule','Schedule #ComponentSize#.ini')
		SKIN:Bang('!CommandMeasure','MeasureScript','ChangeType("Schedule")','#RootConfig#\\Schedule')
	end
end

-- ����֪ͨδ�������ź�
function NoticeNotAccept(Index)
end

--*************************************************

-- ��ȡ��ǰ���ڲ�����������YYYYMMDD��ʽ
function GetToday()
	local Tab=os.date("*t")
	return tonumber(string.format("%04d%02d%02d",Tab.year,Tab.month,Tab.day))
end

-- ����ʱ��Ϊʱ����
function SeparateTime(Time)
	local Min=Time%100
	local Hour=math.floor(Time/100)
	return Hour,Min
end

-- �滻�ַ����е�*
function Tipsub(Tip,Str)
	return (string.gsub(Tip,'%*',Str))
end

