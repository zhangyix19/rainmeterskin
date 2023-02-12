--[[
Name = Notice.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Notice皮肤
]]

--接收通知时执行
function Notice(Index,Color,Font,Icon,Text,Config)
	SKIN:Bang('!CommandMeasure','MeasureScript','NoticeNotAccept('..Index..')','#RootConfig#\\'..Config)
end

--接收删除通知时执行
function DelNotice(Index,Config,IfAction)
end

