--[[
Name = Notice.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Notice皮肤
]]

function Initialize()
	local Allow=tonumber(SKIN:GetVariable('SendNotice'))
	if Allow==0 then
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
		return
	else
		spread={0,0,0}
		decline={0,0,0}
		ifactionflag={false,false,false}
		SPR_RANGE=tonumber(SELF:GetOption('BGSpreadRange'))
		DEC_RANGE=tonumber(SELF:GetOption('BGDeclineRange'))
		SPR_START=tonumber(SELF:GetOption('BGXStart'))
		DEC_START=tonumber(SELF:GetOption('BGYStart'))
		list={Index={},Color={},Font={},Icon={},Text={},Config={}}
		SKIN:Bang('!ActivateConfig','#CurrentConfig#\\Recycle')
	end
end

-- 接收通知时执行
function Notice(Index,Color,Font,Icon,Text,Config)
	AddList(Index,Color,Font,Icon,Text,Config)
	local ActionNumber=OpenNoticeReady()
	SKIN:Bang('!CommandMeasure','mActionOpen','Execute '..ActionNumber)
end

-- 添加通知到队列
function AddList(Index,Color,Font,Icon,Text,Config)
	local Idx=#list.Index+1
	list.Index[Idx]=Index
	list.Color[Idx]=Color
	list.Font[Idx]=Font
	list.Icon[Idx]=Icon
	list.Text[Idx]=Text
	list.Config[Idx]=Config
end

-- 展开通知预处理
function OpenNoticeReady()
	local Idx=1
	for i=#list.Index,1,-1 do
		SKIN:Bang('!SetOption','BG'..Idx,'Color','Fill Color '..list.Color[i])
		SKIN:Bang('!SetOption','CloseBG'..Idx,'Color','Fill Color '..list.Color[i])
		SKIN:Bang('!SetOption','Icon'..Idx,'FontFace',list.Font[i])
		SKIN:Bang('!SetOption','Icon'..Idx,'Text',list.Icon[i])
		SKIN:Bang('!SetOption','Text'..Idx,'Text',list.Text[i])
		SKIN:Bang('!UpdateMeter CloseBG'..Idx)
		Idx=Idx+1
		if Idx>3 then break end
	end
	spread[1]=0
	SKIN:Bang('!SetOption','BG1','X',SPR_START+SPR_RANGE)
	SKIN:Bang('!SetVariable','BGW1',0)
	SKIN:Bang('!UpdateMeterGroup 1')
	if #list.Index>=2 then
		SKIN:Bang('!HideMeterGroup 1')
		SKIN:Bang('!SetOption','BG2','X',SPR_START)
		SKIN:Bang('!SetVariable','BGW2',SPR_RANGE)
		SKIN:Bang('!SetOption','BG2','Y',DEC_START)
		spread[2]=90
		decline[2]=0
		SKIN:Bang('!ShowMeterGroup 2')
		SKIN:Bang('!UpdateMeterGroup 2')
		if #list.Index>=3 then
			SKIN:Bang('!SetOption','BG3','X',SPR_START)
			SKIN:Bang('!SetVariable','BGW3',SPR_RANGE)
			SKIN:Bang('!SetOption','BG3','Y',DEC_START+DEC_RANGE)
			spread[3]=90
			decline[3]=0
			SKIN:Bang('!ShowMeterGroup 3')
			SKIN:Bang('!UpdateMeterGroup 3')
			SKIN:Bang('!Redraw')
			return 3
		else
			SKIN:Bang('!HideMeterGroup 3')
			SKIN:Bang('!Redraw')
			return 2
		end
	else
		SKIN:Bang('!ShowMeter BG1')
		SKIN:Bang('!ShowMeter Icon1')
		SKIN:Bang('!HideMeterGroup 2')
		SKIN:Bang('!HideMeterGroup 3')
		SKIN:Bang('!Redraw')
		return 1
	end
end

-- 控制通知项的横向展开动画
function Spread(Item,Num)
	spread[Item]=spread[Item]+Num
	local Pos,Width
	if Num>0 then
		Width=SPR_RANGE*math.sin(math.rad(spread[Item]))
		Pos=SPR_START+SPR_RANGE-Width
	else
		Width=SPR_RANGE-SPR_RANGE*math.sin(math.rad(90-spread[Item]))
		Pos=SPR_START+SPR_RANGE-Width
	end
	SKIN:Bang('!SetOption','BG'..Item,'X',Pos)
	SKIN:Bang('!SetVariable','BGW'..Item,Width)
	SKIN:Bang('!UpdateMeter','BG'..Item)
end

-- 控制通知项的纵向平移动画
function Decline(Item,Num)
	if Item==0 then
		for i=2,3 do
			decline[i]=decline[i]+Num
			local YPos
			if Num>0 then
				YPos=DEC_START+DEC_RANGE*(i-2)+DEC_RANGE*math.sin(math.rad(decline[i]))
			else
				YPos=DEC_START+DEC_RANGE*(i-1)-DEC_RANGE*math.sin(math.rad(90-decline[i]))
			end
			SKIN:Bang('!SetOption','BG'..i,'Y',YPos)
			SKIN:Bang('!UpdateMeter','BG'..i)
		end
		return
	end
	decline[Item]=decline[Item]+Num
	local YPos
	if Num>0 then
		YPos=DEC_START+DEC_RANGE*(Item-2)+DEC_RANGE*math.sin(math.rad(decline[Item]))
	else
		YPos=DEC_START+DEC_RANGE*(Item-1)-DEC_RANGE*math.sin(math.rad(90-decline[Item]))
	end
	SKIN:Bang('!SetOption','BG'..Item,'Y',YPos)
	SKIN:Bang('!UpdateMeter','BG'..Item)
end

---------------------------------------------------

-- 接收删除通知时执行
function DelNotice(Index,Config,IfAction)
	local Idx
	for i=1,#list.Index do
		if list.Config[i]==Config and list.Index[i]==Index then
			Idx=i
			break
		end
	end
	if Idx==nil then return
	else
		AdjustList(Idx,IfAction)
		if #list.Index-Idx<3 then
			SKIN:Bang('!CommandMeasure','mActionClose','Execute '..#list.Index-Idx+2)
		end
	end
end

-- 关闭显示中的通知
function CloseTop3Notice(N,IfAction)
	AdjustList(#list.Index-N+1,IfAction)
	SKIN:Bang('!CommandMeasure','mActionClose','Execute '..N)
end

-- 整理队列
function AdjustList(N,IfAction)
	if list.Config[N]~=nil and list.Config[N]~='' then
		SKIN:Bang('!CommandMeasure','MeasureScript','NoticeDelOver('..list.Index[N]..','..tostring(IfAction)..')','#RootConfig#\\'..list.Config[N])
	end
	table.remove(list.Index,N)
	table.remove(list.Color,N)
	table.remove(list.Font,N)
	table.remove(list.Icon,N)
	table.remove(list.Text,N)
	table.remove(list.Config,N)
end

--处理显示信息
function DealMeter(N)
	local Idx=1
	for i=#list.Index,1,-1 do
		SKIN:Bang('!SetOption','BG'..Idx,'Color','Fill Color '..list.Color[i])
		SKIN:Bang('!SetOption','CloseBG'..Idx,'Color','Fill Color '..list.Color[i])
		SKIN:Bang('!SetOption','Icon'..Idx,'FontFace',list.Font[i])
		SKIN:Bang('!SetOption','Icon'..Idx,'Text',list.Icon[i])
		SKIN:Bang('!SetOption','Text'..Idx,'Text',list.Text[i])
		SKIN:Bang('!UpdateMeter CloseBG'..Idx)
		Idx=Idx+1
		if Idx>3 then break end
	end
	if #list.Index>=1 then
		SKIN:Bang('!SetOption','BG1','X',SPR_START)
		SKIN:Bang('!SetVariable','BGW1',SPR_RANGE)
		SKIN:Bang('!ShowMeterGroup 1')
		SKIN:Bang('!UpdateMeterGroup 1')
		spread[1]=90
		if #list.Index>=2 then
			SKIN:Bang('!SetOption','BG2','X',SPR_START)
			SKIN:Bang('!SetVariable','BGW2',SPR_RANGE)
			SKIN:Bang('!SetOption','BG2','Y',DEC_START+DEC_RANGE)
			SKIN:Bang('!ShowMeterGroup 2')
			SKIN:Bang('!UpdateMeterGroup 2')
			spread[2]=90
			if #list.Index>=3 then
				SKIN:Bang('!SetOption','BG3','X',SPR_START)
				SKIN:Bang('!SetVariable','BGW3',SPR_RANGE)
				SKIN:Bang('!SetOption','BG3','Y',DEC_START+DEC_RANGE*2)
				SKIN:Bang('!ShowMeterGroup 3')
				SKIN:Bang('!UpdateMeterGroup 3')
				spread[3]=90
			else
				SKIN:Bang('!HideMeterGroup 3')
				SKIN:Bang('!UpdateMeterGroup 3')
			end
		else
			SKIN:Bang('!HideMeterGroup 2')
			SKIN:Bang('!HideMeterGroup 3')
			SKIN:Bang('!UpdateMeterGroup 2')
			SKIN:Bang('!UpdateMeterGroup 3')
		end
	else
		SKIN:Bang('!HideMeterGroup 1')
		SKIN:Bang('!HideMeterGroup 2')
		SKIN:Bang('!HideMeterGroup 3')
		SKIN:Bang('!UpdateMeterGroup 1')
		SKIN:Bang('!UpdateMeterGroup 2')
		SKIN:Bang('!UpdateMeterGroup 3')
	end
	SKIN:Bang('!Redraw')
end

