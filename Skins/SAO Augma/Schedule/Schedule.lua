--[[
Name = Schedule.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Schedule皮肤
]]

function Initialize()
	tip={Schedule={},Note={}}
	IFSCROLL=false		-- 控制翻页
	TIPTOTAL=1			-- 总页码
	ANI_DEL={0,0,0}		-- 控制Del弹出动画
	DETAIL_Y=0			-- 控制详细文字页面滚动
	DETAIL_H=0			-- 详细文字页面，文字总高度
	TYPE=tostring(SKIN:GetVariable('TypeSchedule'))
	if TYPE~='Schedule' and TYPE~='Note' then
		error('TypeSchedule cannot be '..TYPE)
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
		return
	end
	TITLESCHE=tostring(SKIN:GetVariable('ScheduleTitle'))
	if TITLESCHE=='' or TITLESCHE==nil then
		TITLESCHE='Schedule'
	end
	TITLENOTE=tostring(SKIN:GetVariable('NoteTitle'))
	if TITLENOTE=='' or TITLENOTE==nil then
		TITLENOTE='Notes'
	end
	-- 菜单弹出长度
	RANGE_MENU=tonumber(SELF:GetOption('MenuHeight'))
	ANI_MENU=0
	-- 关闭皮肤面板弹出长度
	RANGE_BOARD=tonumber(SELF:GetOption('BoardHeight'))
	ANI_BOARD=0
	TIPX=tonumber(SELF:GetOption('TipX'))
	RANGE_DEL=tonumber(SELF:GetOption('DelWidth'))
	-- 详细文字页面高度限制
	local MaskMeter=SKIN:GetMeter('MainDetailMask')
	RANGE_DETAIL=MaskMeter:GetH()
	-- 详细文字单次滚轮移动距离
	RANGE_SCROLL=tonumber(SELF:GetOption('ScrollHeight'))
	SetTitle()
end

-- 日期更替时执行
function ChangeDay()
	SKIN:Bang('!EnableMeasureGroup FileView')
	SKIN:Bang('!Update')
	SKIN:Bang('!CommandMeasure mLogFolder "Update"')
end

-- 切换样式
function ChangeType(T)
	-- 关闭菜单
	if ANI_MENU>=90 then
		CtrlAniMenu()
	end
	if T=='Schedule' or T=='Note' then
		TYPE=T
	else
		if TYPE=='Schedule' then
			TYPE='Note'
		elseif TYPE=='Note' then
			TYPE='Schedule'
		end
	end
	SetTitle()
	ShowMeter()
end

-- 设置标题
function SetTitle()
	if TYPE=='Schedule' then
		SKIN:Bang('!SetOption','Title','Text',TITLESCHE)
		SKIN:Bang('!SetOption','Menu1','Text','#TR_MenuCheckNote#')
	elseif TYPE=='Note' then
		SKIN:Bang('!SetOption','Title','Text',TITLENOTE)
		SKIN:Bang('!SetOption','Menu1','Text','#TR_MenuCheckSchedule#')
	else
		SKIN:Bang('!SetOption','Title','Text','')
	end
	SKIN:Bang('!UpdateMeter Title')
	SKIN:Bang('!UpdateMeter Menu1')
end

-- 由[mLogFolder]获取完毕后执行
function GetScheduleFolderOver()
	ClearScheduleFile()
	ReadScheduleFile()
	ReadNoteFile()
	ShowMeter()
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
		if not Name then
			os.remove(SKIN:MakePathAbsolute(SELF:GetOption("LogFolder"))..'\\'..mFile:GetStringValue()..'.txt')
		elseif Name<Today then
			os.remove(SKIN:MakePathAbsolute(SELF:GetOption("LogFolder"))..'\\'..Name..'.txt')
		end
		SKIN:Bang('!CommandMeasure mLogFolder IndexDown')
		SKIN:Bang('!UpdateMeasure LogFile')
	end
	SKIN:Bang('!DisableMeasureGroup FileView')
end

-- 获取今天的事项
function ReadScheduleFile()
	local Today=GetToday()
	local File=io.open(SKIN:MakePathAbsolute(SELF:GetOption("LogFolder"))..'\\'..Today..'.txt','r')
	if not File then return
	else
		local Idx=0
		for l in File:lines() do
			if l ~='' then
				local _,Num=string.find(l,"[_|]")
				if Num~=nil then
					local Title=string.sub(l,1,Num-1)
					local Tip=string.sub(l,Num+1,-1)
					if Tip~='' then
						Idx=Idx+1
						tip.Schedule[Idx]={Title=Title,Tip=Tip}
					end
				else
					Idx=Idx+1
					tip.Schedule[Idx]={Title='',Tip=l}
				end
			end
		end
		File:close()
	end
end

-- 获取备忘事项
function ReadNoteFile()
	local File=io.open(SKIN:MakePathAbsolute(SELF:GetOption("NoteFile")),'r')
	if not File then return
	else
		local Idx=0
		for l in File:lines() do
			if l ~='' then
				local _,Num=string.find(l,"[_|]")
				if Num~=nil then
					local Title=string.sub(l,1,Num-1)
					local Tip=string.sub(l,Num+1,-1)
					if Tip~='' then
						Idx=Idx+1
						tip.Note[Idx]={Title=Title,Tip=Tip}
					end
				else
					Idx=Idx+1
					tip.Note[Idx]={Title='',Tip=l}
				end
			end
		end
		File:close()
	end
end

-----------------------------------------------

-- 展示Meter组
function ShowMeter()
	SKIN:Bang('!HideMeterGroup','Main')
	PAGE=1
	if #tip[TYPE]==0 then
		IFSCROLL=false
		DrawEmptyTip()
	else
		if #tip[TYPE]>3 then
			IFSCROLL=true
			TIPTOTAL=#tip[TYPE]
		else
			IFSCROLL=false
			TIPTOTAL=#tip[TYPE]
		end
		DrawTip()
	end
end

-- 重置文字坐标与Del标记
function ResetTextPosition()
	for i=1,3 do
		ANI_DEL[i]=0
	end
	SKIN:Bang('!SetOptionGroup','MainTitle','X',TIPX)
	SKIN:Bang('!SetOptionGroup','NoteTipText','X',TIPX)
	SKIN:Bang('!HideMeterGroup','Del')
end

-- 项目为空时画面处理
function DrawEmptyTip()
	ResetTextPosition()
	local Default=tostring(SKIN:GetVariable(TYPE..'DefaultTip'))
	SKIN:Bang('!SetOption','MainTitle1','Text',Default)
	SKIN:Bang('!ShowMeterGroup','Main1')
	SKIN:Bang('!UpdateMeter','MainTitle1')
	SKIN:Bang('!Redraw')
end

-- 绘制当前页项目
function DrawTip()
	ResetTextPosition()
	for i=1,3 do
		if PAGE+i-1<=TIPTOTAL then
			local Text=tip[TYPE][PAGE+i-1].Title~='' and tip[TYPE][PAGE+i-1].Title or tip[TYPE][PAGE+i-1].Tip
			SKIN:Bang('!SetOption','MainTitle'..i,'Text',Text)
			SKIN:Bang('!UpdateMeter','MainTitle'..i)
			SKIN:Bang('!ShowMeterGroup Main'..i)
		else
			SKIN:Bang('!HideMeterGroup Main'..i)
		end
	end
	if PAGE+2<TIPTOTAL then
		SKIN:Bang('!ShowMeterGroup','MainNext')
	else
		SKIN:Bang('!HideMeterGroup','MainNext')
	end
	SKIN:Bang('!Redraw')
end

-- 上一页
function PrePage()
	if IFSCROLL and PAGE>=2 then
		PAGE=PAGE-1
		DrawTip()
	end
end

-- 下一页
function NextPage()
	if IFSCROLL and PAGE<TIPTOTAL then
		PAGE=PAGE+1
		DrawTip()
	end
end

-- 查看详细
function CheckDetail(N)
	if #tip[TYPE]==0 then return end
	ResetTextPosition()
	SKIN:Bang('!HideMeterGroup','Main')
	SKIN:Bang('!ShowMeterGroup','MainDetail')
	SKIN:Bang('!SetOption','MainDetailTitle','Text',tip[TYPE][PAGE+N-1].Title)
	SKIN:Bang('!SetOption','MainDetailTip','Text',Tipsub(tip[TYPE][PAGE+N-1].Tip))
	SKIN:Bang('!SetOption','MainDetailTip','Y',0)
	SKIN:Bang('!UpdateMeter','MainDetailTitle')
	SKIN:Bang('!UpdateMeter','MainDetailTip')
	SKIN:Bang('!Redraw')
	local Meter=SKIN:GetMeter('MainDetailTip')
	DETAIL_H=Meter:GetH()
	DETAIL_Y=0
end

-- 从详情页面返回
function BackFromDetail()
	SKIN:Bang('!HideMeterGroup','MainDetail')
	SKIN:Bang('!SetOption','MainDetailTip','Text','')
	SKIN:Bang('!UpdateMeter','MainDetailTip')
	DrawTip()
end

function DetailScrollUp()
	DETAIL_Y=DETAIL_Y+RANGE_SCROLL
	if DETAIL_Y>0 then DETAIL_Y=0 end
	SKIN:Bang('!SetOption','MainDetailTip','Y',DETAIL_Y)
	SKIN:Bang('!UpdateMeter','MainDetailTip')
	SKIN:Bang('!Redraw')
end

function DetailScrollDown()
	if DETAIL_Y+DETAIL_H>RANGE_DETAIL then
		DETAIL_Y=DETAIL_Y-RANGE_SCROLL
		SKIN:Bang('!SetOption','MainDetailTip','Y',DETAIL_Y)
		SKIN:Bang('!UpdateMeter','MainDetailTip')
		SKIN:Bang('!Redraw')
	end
end

-- 删除日程与备忘
function DeleteTip(Idx)
	if #tip[TYPE]==0 then
		CtrlAniDel(Idx)
		return
	else
		TIPTOTAL=TIPTOTAL-1
		for i=PAGE+Idx-1,#tip[TYPE] do
			tip[TYPE][i]=tip[TYPE][i+1]
		end
		if PAGE>#tip[TYPE] then
			PAGE=#tip[TYPE]
		end
		if TYPE=='Schedule' then
			-- 文件覆写
			local Today=GetToday()
			local File=io.open(SKIN:MakePathAbsolute(SELF:GetOption("LogFolder"))..'\\'..Today..'.txt','w')
			if not File then return
			else
				for i=1,#tip.Schedule do
					File:write(tip.Schedule[i].Title..'_'..tip.Schedule[i].Tip)
					File:write('\n')
				end
			end
			File:close()
			-- 处理界面
			if PAGE==0 then
				PAGE=1
				IFSCROLL=false
				DrawEmptyTip()
			else
				DrawTip()
			end
		elseif TYPE=='Note' then
			-- 文件覆写
			local File=io.open(SKIN:MakePathAbsolute(SELF:GetOption("NoteFile")),'w')
			if not File then return
			else
				for i=1,#tip.Note do
					File:write(tip.Note[i].Title..'_'..tip.Note[i].Tip)
					File:write('\n')
				end
			end
			File:close()
			-- 处理界面
			if PAGE==0 then
				PAGE=1
				IFSCROLL=false
				DrawEmptyTip()
			else
				DrawTip()
			end
		end
	end
end

-----------------------------------------------

-- 关闭皮肤时执行
function Close()
	local IfRemind=SKIN:GetVariable('ScheduleCloseRemind')~=0
	local IfHide=SKIN:GetVariable('ScheduleHide')~=0
	if IfRemind then
		SKIN:Bang('!SetVariable','BoardH_Ani',0)
		SKIN:Bang('!UpdateMeter Board')
		SKIN:Bang('!UpdateMeter BoardOKBG')
		SKIN:Bang('!HideMeterGroup','Main')
		ResetTextPosition()
		SKIN:Bang('!ShowMeterGroup Board')
		SKIN:Bang('!CommandMeasure','MeasureAction','Execute 3')
	else
		if IfHide then
			SKIN:Bang('!WriteKeyValue','Variables','StopNoticeForOnce',1,'#CurrentPath#\\ScheduleNotice\\ScheduleNotice.ini')
			SKIN:Bang('!ActivateConfig','#CurrentConfig#\\ScheduleNotice','ScheduleNotice.ini')
		end
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

function CloseOK()
	SKIN:Bang('!WriteKeyValue','Variables','ScheduleCloseRemind','#ScheduleCloseRemind#','#@#Config\\Others\\Sche&Alarm.inc')
	SKIN:Bang('!WriteKeyValue','Variables','ScheduleHide','#ScheduleHide#','#@#Config\\Others\\Sche&Alarm.inc')
	local IfHide=tonumber(SKIN:GetVariable('ScheduleHide'))~=0
	if IfHide then
		SKIN:Bang('!WriteKeyValue','Variables','StopNoticeForOnce',1,'#CurrentPath#\\ScheduleNotice\\ScheduleNotice.ini')
		SKIN:Bang('!ActivateConfig','#CurrentConfig#\\ScheduleNotice','ScheduleNotice.ini')
	end
	SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
end

function CloseCancel()
	SKIN:Bang('!HideMeterGroup Close')
	SKIN:Bang('!CommandMeasure','MeasureAction','Execute 4')
end

-- 动画4结束后执行
function CloseCancelOver()
	SKIN:Bang('!HideMeterGroup Board')
	ShowMeter()
end

-----------------------------------------------

--控制菜单弹出动画
function CtrlAniMenu()
	if ANI_MENU<=0 then
		SKIN:Bang('!ShowMeter MenuBottom')
		SKIN:Bang('!SetVariable','MenuH_Ani',0)
		SKIN:Bang('!UpdateMeter MenuBottom')
		SKIN:Bang('!Redraw')
		SKIN:Bang('!CommandMeasure MeasureAction "Execute 1"')
	elseif ANI_MENU>=90 then
		SKIN:Bang('!HideMeterGroup Menu')
		SKIN:Bang('!SetVariable','MenuH_Ani',RANGE_MENU)
		SKIN:Bang('!UpdateMeter MenuBottom')
		SKIN:Bang('!Redraw')
		SKIN:Bang('!CommandMeasure MeasureAction "Execute 2"')
	end
end

function AniMenu(N)
	local Pos
	ANI_MENU=ANI_MENU+N
	if tonumber(N)>0 then
		Pos=RANGE_MENU *(math.sin(math.rad(ANI_MENU)))
	else
		Pos=RANGE_MENU - RANGE_MENU *(math.sin(math.rad(90 - ANI_MENU)))
	end
	SKIN:Bang('!SetVariable','MenuH_Ani',Pos)
	SKIN:Bang('!UpdateMeter MenuBottom')
	SKIN:Bang('!UpdateMeasure MeasureAction')
	SKIN:Bang('!Redraw')
end	

-- 控制关闭提醒页面弹出动画
function AniBoard(N)
	local Pos
	ANI_BOARD=ANI_BOARD+N
	if tonumber(N)>0 then
		Pos=RANGE_BOARD *(math.sin(math.rad(ANI_BOARD)))
	else
		Pos=RANGE_BOARD - RANGE_BOARD *(math.sin(math.rad(90 - ANI_BOARD)))
	end
	SKIN:Bang('!SetVariable','BoardH_Ani',Pos)
	SKIN:Bang('!UpdateMeter Board')
	SKIN:Bang('!UpdateMeter BoardOKBG')
	SKIN:Bang('!UpdateMeasure MeasureAction')
	SKIN:Bang('!Redraw')
end

--控制删除按钮弹出动画
function CtrlAniDel(Tip)
	if ANI_DEL[Tip]<=0 then
		SKIN:Bang('!CommandMeasure','MeasureActionDel','Execute '..Tip)
	elseif ANI_DEL[Tip]>=90 then
		SKIN:Bang('!HideMeter MainDel'..Tip)
		SKIN:Bang('!CommandMeasure','MeasureActionDel','Execute '..Tip+3)
	end
end

function AniDel(Tip,N)
	local Pos
	ANI_DEL[Tip]=ANI_DEL[Tip]+N
	if tonumber(N)>0 then
		Pos=TIPX - RANGE_DEL *(math.sin(math.rad(ANI_DEL[Tip])))
	else
		Pos=TIPX - RANGE_DEL + RANGE_DEL *(math.sin(math.rad(90 - ANI_DEL[Tip])))
	end
	SKIN:Bang('!SetOption','MainTitle'..Tip,'X',Pos)
	SKIN:Bang('!UpdateMeter MainTitle'..Tip)
	SKIN:Bang('!Redraw')
end

function AniDelOver(Tip)
	SKIN:Bang('!ShowMeter MainDel'..Tip)
	SKIN:Bang('!Redraw')
end

--*************************************************

-- 获取当前日期并返回数字型YYYYMMDD格式
function GetToday()
	local Tab=os.date("*t")
	return tonumber(string.format("%04d%02d%02d",Tab.year,Tab.month,Tab.day))
end

-- 替换|为换行符
function Tipsub(Tip)
	if Tip==nil then return Tip end
	return (string.gsub(Tip,'%|','#CRLF#'))
end

