--[[
Name = Alarm Message.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Alarm Message皮肤
]]

function Initialize()
	ANI=0
	RANGE=SELF:GetOption('Range')
end

--控制过渡动画
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

--接收指令，开始响铃
function GetMessage(TipStr)
	SKIN:Bang('!SetOption','Tip','Text',TipStr)
	SKIN:Bang('!UpdateMeter','Tip')
	SKIN:Bang('PlayLoop "#AlarmAudio#"')
	SKIN:Bang('!EnableMeasure','MeasureCalc')
	SKIN:Bang('!CommandMeasure','MeasureAction','Execute 1')
end

