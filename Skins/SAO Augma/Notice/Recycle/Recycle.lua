--[[
Name = Recycle.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Notice\Recycle皮肤向Notice皮肤发送数据
]]

function Initialize()
	RYC_INFO=true
	RYC_IFFULL=false
	RYC_TEXT=SKIN:GetVariable('TR_ClearRecycleText')
end

--回收站满时动作
function RycFull()
	if not RYC_INFO then
		return
	else
		RycNotice()
	end
end

--回收站空时动作
function RycEmpty()
	RYC_IFFULL=false
	if RYC_INFO then return
	else
		RycDelNotice()
	end
end

--发送回收站满通知
function RycNotice()
	RYC_INFO=false
	SKIN:Bang(
			'!CommandMeasure',
			'MeasureScript',
			'Notice(1,"#ColorSystem#","Font Awesome 5 Free Solid","[\\\\xf1f8]","'..RYC_TEXT..'","Notice\\\\Recycle")',
			'#RootConfig#\\Notice'
			)
end

--撤回回收站满通知
function RycDelNotice()
	SKIN:Bang(
			'!CommandMeasure',
			'MeasureScript',
			'DelNotice(1,"Notice\\\\Recycle")',
			'#RootConfig#\\Notice'
			)
end

--接收通知删除完毕信号
function NoticeDelOver(Index,IfAction)
	RYC_INFO=true
	if IfAction then
		SKIN:Bang('[::{645FF040-5081-101B-9F08-00AA002F954E}]')
	end
end

--接收通知未被接受信号
function NoticeNotAccept(Index)
	RYC_INFO=true
end

