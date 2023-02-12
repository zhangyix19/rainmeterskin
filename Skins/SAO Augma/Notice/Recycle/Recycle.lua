--[[
Name = Recycle.lua
Author = ѩ�»�
Version = 1.0
License = CC BY - NC - SA 4.0
Information = �ű����ڿ���Notice\RecycleƤ����NoticeƤ����������
]]

function Initialize()
	RYC_INFO=true
	RYC_IFFULL=false
	RYC_TEXT=SKIN:GetVariable('TR_ClearRecycleText')
end

--����վ��ʱ����
function RycFull()
	if not RYC_INFO then
		return
	else
		RycNotice()
	end
end

--����վ��ʱ����
function RycEmpty()
	RYC_IFFULL=false
	if RYC_INFO then return
	else
		RycDelNotice()
	end
end

--���ͻ���վ��֪ͨ
function RycNotice()
	RYC_INFO=false
	SKIN:Bang(
			'!CommandMeasure',
			'MeasureScript',
			'Notice(1,"#ColorSystem#","Font Awesome 5 Free Solid","[\\\\xf1f8]","'..RYC_TEXT..'","Notice\\\\Recycle")',
			'#RootConfig#\\Notice'
			)
end

--���ػ���վ��֪ͨ
function RycDelNotice()
	SKIN:Bang(
			'!CommandMeasure',
			'MeasureScript',
			'DelNotice(1,"Notice\\\\Recycle")',
			'#RootConfig#\\Notice'
			)
end

--����֪ͨɾ������ź�
function NoticeDelOver(Index,IfAction)
	RYC_INFO=true
	if IfAction then
		SKIN:Bang('[::{645FF040-5081-101B-9F08-00AA002F954E}]')
	end
end

--����֪ͨδ�������ź�
function NoticeNotAccept(Index)
	RYC_INFO=true
end

