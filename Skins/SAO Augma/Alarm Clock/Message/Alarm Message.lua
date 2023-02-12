--[[
Name = Alarm Message.lua
Author = ѩ�»�
Version = 1.0
License = CC BY - NC - SA 4.0
Information = �ű����ڿ���Alarm MessageƤ��
]]

function Initialize()
	ANI=0
	RANGE=SELF:GetOption('Range')
end

--���ƹ��ɶ���
function Spread(N)
	ANI=ANI+N
	local Width
	if N>0 then
		Width=RANGE*math.sin(math.rad(ANI))
	else
		Width=RANGE-RANGE*math.sin(math.rad(90-ANI))
	end
	SKIN:Bang('!SetVariable','BGW',Width)
	SKIN:Bang('!UpdateMeter','BG')
	SKIN:Bang('!UpdateMeasure','MeasureAction')
	SKIN:Bang('!Redraw')
end

--����ָ���ʼ����
function GetMessage(TipStr)
	SKIN:Bang('!SetOption','Tip','Text',TipStr)
	SKIN:Bang('!UpdateMeter','Tip')
	SKIN:Bang('PlayLoop "#AlarmAudio#"')
	SKIN:Bang('!EnableMeasure','MeasureCalc')
	SKIN:Bang('!CommandMeasure','MeasureAction','Execute 1')
end

