--[[
Name = Notice.lua
Author = ѩ�»�
Version = 1.0
License = CC BY - NC - SA 4.0
Information = �ű����ڿ���NoticeƤ��
]]

--����֪ͨʱִ��
function Notice(Index,Color,Font,Icon,Text,Config)
	SKIN:Bang('!CommandMeasure','MeasureScript','NoticeNotAccept('..Index..')','#RootConfig#\\'..Config)
end

--����ɾ��֪ͨʱִ��
function DelNotice(Index,Config,IfAction)
end

