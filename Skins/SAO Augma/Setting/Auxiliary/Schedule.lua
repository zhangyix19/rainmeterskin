--[[
Name = Schedule.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Auxiliary皮肤的Schedule页面
]]

sche={}
scheitem={}
note={}
newsche={}
add={}
PAGE=1
TOTALPAGE=1
TYPE='Schedule'

-- UI Text Translate
TR_AddNew={}

function Initialize()
	-- Container高度
	WIN_H=SELF:GetOption('WindowHeight')
	-- 日程日期格式
	SCHENAME=SELF:GetOption('ScheduleName')
	-- 默认标题
	TR_ALLSCHEDULE=SKIN:GetVariable('TR_AllSchedule')
	TR_AddNew.Title=SKIN:GetVariable('TR_ScheNewTitleText')
	TR_AddNew.Tip=SKIN:GetVariable('TR_ScheNewContextText')
	DETAIL_Y=0			-- 控制添加内容页面的文字滚动
	DETAIL_H=0			-- 添加内容页面，文字总高度
	-- 内容预览页高度限制
	local MaskMeter=SKIN:GetMeter('NewContextMask')
	RANGE_DETAIL=MaskMeter:GetH()
	-- 内容预览部分单次滚轮移动距离
	RANGE_SCROLL=tonumber(SELF:GetOption('ScrollHeight'))
	
	local Tab=os.date("*t")
	newsche.Year=tonumber(Tab.year)
	newsche.Month=tonumber(Tab.month)
	newsche.Day=tonumber(Tab.day)
	SKIN:Bang('!SetOption','ScheNew01V','Text',string.format("%04d",newsche.Year))
	SKIN:Bang('!SetOption','ScheNew02V','Text',string.format("%02d",newsche.Month))
	SKIN:Bang('!SetOption','ScheNew03V','Text',string.format("%02d",newsche.Day))
	
	ChangeType('Schedule',true)
end

-- 由[mLogFolder]获取完毕后执行
function GetScheduleFolderOver()
	GetScheduleFile()
	ReadNoteFile()
	PAGE=1
	TOTALPAGE=math.ceil(#sche/5)
	if TOTALPAGE<=0 then TOTALPAGE=1 end
	DrawSchedule()
end

-- 读取全部日志的文件名
function GetScheduleFile()
	local mFile=SKIN:GetMeasure('LogFile')
	local mCount=SKIN:GetMeasure('LogFileCount')
	local Count=tonumber(mCount:GetValue())
	local Idx=0
	for i=1,Count do
		local Name=tonumber(mFile:GetStringValue())
		if AssertDateCode(Name) then
			Idx=Idx+1
			sche[Idx]=Name
		end
		SKIN:Bang('!CommandMeasure mLogFolder IndexDown')
		SKIN:Bang('!UpdateMeasure LogFile')
	end
	table.sort(sche)
	SKIN:Bang('!DisableMeasureGroup FileView')
end

-- 读取日志内容
function ReadScheduleFile(FileName)
	scheitem={File=FileName}
	local File=io.open(SKIN:MakePathAbsolute(SELF:GetOption("LogFolder"))..'\\'..FileName..'.txt','r')
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
						scheitem[Idx]={Title=Title,Tip=Tip}
					end
				else
					Idx=Idx+1
					scheitem[Idx]={Title='',Tip=l}
				end
			end
		end
		File:close()
	end
end

-- 读取备忘内容
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
						note[Idx]={Title=Title,Tip=Tip}
					end
				else
					Idx=Idx+1
					note[Idx]={Title='',Tip=l}
				end
			end
		end
		File:close()
	end
end

-- 将更改写入Note文件
function WriteNoteFile()
	local File=io.open(SKIN:MakePathAbsolute(SELF:GetOption("NoteFile")),'w')
	if not File then return end
	for i=1,#note do
		File:write(note[i].Title..'_'..note[i].Tip)
		File:write('\n')
	end
	File:close()
end

-- 将更改写入Schedule文件
function WriteScheduleFile()
	local File=io.open(SKIN:MakePathAbsolute(SELF:GetOption("LogFolder"))..'\\'..scheitem.File..'.txt','w')
	if not File then return end
	for i=1,#scheitem do
		File:write(scheitem[i].Title..'_'..scheitem[i].Tip)
		File:write('\n')
	end
	File:close()
end

-- 绘制Schedule表格
function DrawSchedule()
	SKIN:Bang('!HideMeter ScheBack')
	-- 页码绘制
	SKIN:Bang('!SetOption','ListPage','Text',PAGE..' / '..TOTALPAGE)
	-- 表格绘制
	for i=1,5 do
		local Idx=(PAGE-1)*5+i
		if Idx<=#sche then
			SKIN:Bang('!SetOption','List0'..i..'T','Text',ScheNameNormalize(sche[Idx]))
			SKIN:Bang('!ShowMeter','List0'..i..'T')
			SKIN:Bang('!ShowMeter','ListOpt0'..i..'_3T')
			SKIN:Bang('!ShowMeter','ListOpt0'..i..'_4T')
		else
			SKIN:Bang('!HideMeter','List0'..i..'T')
			SKIN:Bang('!HideMeter','ListOpt0'..i..'_3T')
			SKIN:Bang('!HideMeter','ListOpt0'..i..'_4T')
		end
	end
	SKIN:Bang('!HideMeterGroup','List_Opt1')
	SKIN:Bang('!HideMeterGroup','List_Opt2')
	SKIN:Bang('!UpdateMeterGroup ListTip')
	SKIN:Bang('!Redraw')
end

-- 绘制Note表格
function DrawNote()
	SKIN:Bang('!HideMeter ScheBack')
	-- 页码绘制
	SKIN:Bang('!SetOption','ListPage','Text',PAGE..' / '..TOTALPAGE)
	-- 表格绘制
	for i=1,5 do
		local Idx=(PAGE-1)*5+i
		if Idx<=#note then
			local Text=note[Idx].Title~='' and note[Idx].Title or note[Idx].Tip
			SKIN:Bang('!SetOption','List0'..i..'T','Text',Text)
			SKIN:Bang('!ShowMeter','List0'..i..'T')
			SKIN:Bang('!ShowMeter','ListOpt0'..i..'_1T')
			SKIN:Bang('!ShowMeter','ListOpt0'..i..'_2T')
			SKIN:Bang('!ShowMeter','ListOpt0'..i..'_3T')
			SKIN:Bang('!ShowMeter','ListOpt0'..i..'_4T')
		else
			SKIN:Bang('!HideMeter','List0'..i..'T')
			SKIN:Bang('!HideMeter','ListOpt0'..i..'_1T')
			SKIN:Bang('!HideMeter','ListOpt0'..i..'_2T')
			SKIN:Bang('!HideMeter','ListOpt0'..i..'_3T')
			SKIN:Bang('!HideMeter','ListOpt0'..i..'_4T')
		end
	end
	SKIN:Bang('!UpdateMeterGroup ListTip')
	SKIN:Bang('!Redraw')
end

-- 绘制ScheduleItem表格
function DrawScheItem()
	SKIN:Bang('!ShowMeter ScheBack')
	-- 页码绘制
	SKIN:Bang('!SetOption','ListPage','Text',PAGE..' / '..TOTALPAGE)
	-- 表格绘制
	for i=1,5 do
		local Idx=(PAGE-1)*5+i
		if Idx<=#scheitem then
			local Text=scheitem[Idx].Title~='' and scheitem[Idx].Title or scheitem[Idx].Tip
			SKIN:Bang('!SetOption','List0'..i..'T','Text',Text)
			SKIN:Bang('!ShowMeter','List0'..i..'T')
			SKIN:Bang('!ShowMeter','ListOpt0'..i..'_1T')
			SKIN:Bang('!ShowMeter','ListOpt0'..i..'_2T')
			SKIN:Bang('!ShowMeter','ListOpt0'..i..'_3T')
			SKIN:Bang('!ShowMeter','ListOpt0'..i..'_4T')
		else
			SKIN:Bang('!HideMeter','List0'..i..'T')
			SKIN:Bang('!HideMeter','ListOpt0'..i..'_1T')
			SKIN:Bang('!HideMeter','ListOpt0'..i..'_2T')
			SKIN:Bang('!HideMeter','ListOpt0'..i..'_3T')
			SKIN:Bang('!HideMeter','ListOpt0'..i..'_4T')
		end
	end
	SKIN:Bang('!UpdateMeterGroup ListTip')
	SKIN:Bang('!Redraw')
end

---------------------------------------------------
-- 鼠标动作
---------------------------------------------------

-- 切换状态
function ChangeType(Type,IfNoDraw)
	if Type=='Schedule' then
		TYPE='Schedule'
		SKIN:Bang('!SetOption','Main01T','FontColor','#ColorMain2#,180')
		SKIN:Bang('!SetOption','Main02T','FontColor','#ColorMain3#,180')
		SKIN:Bang('!ShowMeter','Main01B')
		SKIN:Bang('!HideMeter','Main02B')
		SKIN:Bang('!SetOption','ScheduleWindow','H',WIN_H)
		SKIN:Bang('!SetOption','NoteWindow','H',0)
		SKIN:Bang('!SetOption','ListWindow','H',WIN_H)
		SKIN:Bang('!SetOption','AddNewWindow','H',0)
		SKIN:Bang('!HideMeter','NewContextText')
		SKIN:Bang('!ShowMeter','ScheTipNew')
		SKIN:Bang('!ShowMeter','ScheTipNewText')
		SKIN:Bang('!HideMeterGroup','ScheNew')
		if not IfNoDraw then
			SKIN:Bang('!SetOption','ScheTitle','Text',TR_ALLSCHEDULE)
			SKIN:Bang('!UpdateMeter','ScheTitle')
			PAGE=1
			TOTALPAGE=math.ceil(#sche/5)
			if TOTALPAGE<=0 then TOTALPAGE=1 end
			DrawSchedule()
		end
	elseif Type=='Note' then
		TYPE='Note'
		SKIN:Bang('!SetOption','Main01T','FontColor','#ColorMain3#,180')
		SKIN:Bang('!SetOption','Main02T','FontColor','#ColorMain2#,180')
		SKIN:Bang('!HideMeter','Main01B')
		SKIN:Bang('!ShowMeter','Main02B')
		SKIN:Bang('!SetOption','ScheduleWindow','H',0)
		SKIN:Bang('!SetOption','NoteWindow','H',WIN_H)
		SKIN:Bang('!SetOption','ListWindow','H',WIN_H)
		SKIN:Bang('!SetOption','AddNewWindow','H',0)
		SKIN:Bang('!HideMeter','NewContextText')
		if not IfNoDraw then
			PAGE=1
			TOTALPAGE=math.ceil(#note/5)
			if TOTALPAGE<=0 then TOTALPAGE=1 end
			DrawNote()
		end
	end
	SKIN:Bang('!Update')
end

-- 返回至Schedule页面
function BackToSchedule()
	TYPE='Schedule'
	SKIN:Bang('!SetOption','ScheTitle','Text',TR_ALLSCHEDULE)
	SKIN:Bang('!UpdateMeter','ScheTitle')
	PAGE=1
	TOTALPAGE=math.ceil(#sche/5)
	if TOTALPAGE<=0 then TOTALPAGE=1 end
	DrawSchedule()
end

-- 表格，上一页
function ListPageUp()
	if PAGE<=1 then return end
	PAGE=PAGE-1
	if TYPE=='Schedule' then
		DrawSchedule()
	elseif TYPE=='Note' then
		DrawNote()
	elseif TYPE=='ScheItem' then
		DrawScheItem()
	end
end

-- 表格，下一页
function ListPageDown()
	if PAGE>=TOTALPAGE then return end
	PAGE=PAGE+1
	if TYPE=='Schedule' then
		DrawSchedule()
	elseif TYPE=='Note' then
		DrawNote()
	elseif TYPE=='ScheItem' then
		DrawScheItem()
	end
end

-- 表格，向上移动
function ListMoveUp(N)
	local Index=(PAGE-1)*5+N
	if TYPE=='Note' then
		if Index<=1 then return end
		local TempTitle=note[Index].Title
		local TempTip=note[Index].Tip
		note[Index].Title=note[Index-1].Title
		note[Index].Tip=note[Index-1].Tip
		note[Index-1].Title=TempTitle
		note[Index-1].Tip=TempTip
		WriteNoteFile()
		DrawNote()
	elseif TYPE=='ScheItem' then
		if Index<=1 then return end
		local TempTitle=scheitem[Index].Title
		local TempTip=scheitem[Index].Tip
		scheitem[Index].Title=scheitem[Index-1].Title
		scheitem[Index].Tip=scheitem[Index-1].Tip
		scheitem[Index-1].Title=TempTitle
		scheitem[Index-1].Tip=TempTip
		WriteScheduleFile()
		DrawScheItem()
	end
end

-- 表格，向下移动
function ListMoveDown(N)
	local Index=(PAGE-1)*5+N
	if TYPE=='Note' then
		if Index>=#note then return end
		local TempTitle=note[Index].Title
		local TempTip=note[Index].Tip
		note[Index].Title=note[Index+1].Title
		note[Index].Tip=note[Index+1].Tip
		note[Index+1].Title=TempTitle
		note[Index+1].Tip=TempTip
		WriteNoteFile()
		DrawNote()
	elseif TYPE=='ScheItem' then
		if Index>=#scheitem then return end
		local TempTitle=scheitem[Index].Title
		local TempTip=scheitem[Index].Tip
		scheitem[Index].Title=scheitem[Index+1].Title
		scheitem[Index].Tip=scheitem[Index+1].Tip
		scheitem[Index+1].Title=TempTitle
		scheitem[Index+1].Tip=TempTip
		WriteScheduleFile()
		DrawScheItem()
	end
end

-- 表格，进入编辑
function ListEdit(N)
	local Index=(PAGE-1)*5+N
	if TYPE=='Schedule' then
		TYPE='ScheItem'
		ReadScheduleFile(sche[Index])
		local Meter=SKIN:GetMeter('List0'..N..'T')
		local Str=Meter:GetOption('Text')
		SKIN:Bang('!SetOption','ScheTitle','Text',Str)
		SKIN:Bang('!UpdateMeter','ScheTitle')
		PAGE=1
		TOTALPAGE=math.ceil(#scheitem/5)
		if TOTALPAGE<=0 then TOTALPAGE=1 end
		DrawScheItem()
	elseif TYPE=='Note' then
		add.Index=Index
		add.Title=note[Index].Title
		add.Tip=string.gsub(note[Index].Tip,'|','\r\n')
		SKIN:Bang('!SetOption','NoteWindow','H',0)
		SKIN:Bang('!SetOption','ListWindow','H',0)
		SKIN:Bang('!SetOption','AddNewWindow','H',WIN_H)
		SKIN:Bang('!ShowMeter','NewContextText')
		SKIN:Bang('!SetOption','NewTitleText','Text',add.Title)
		SKIN:Bang('!SetOption','NewContextText','Text',add.Tip)
		SKIN:Bang('!SetOption','NewContextText','Y',0)
		SKIN:Bang('!Update')
		local Meter=SKIN:GetMeter('NewContextText')
		DETAIL_H=Meter:GetH()
		DETAIL_Y=0
	elseif TYPE=='ScheItem' then
		add.Index=Index
		add.Title=scheitem[Index].Title
		add.Tip=string.gsub(scheitem[Index].Tip,'|','\r\n')
		SKIN:Bang('!SetOption','ScheduleWindow','H',0)
		SKIN:Bang('!SetOption','ListWindow','H',0)
		SKIN:Bang('!SetOption','AddNewWindow','H',WIN_H)
		SKIN:Bang('!ShowMeter','NewContextText')
		SKIN:Bang('!SetOption','NewTitleText','Text',add.Title)
		SKIN:Bang('!SetOption','NewContextText','Text',add.Tip)
		SKIN:Bang('!SetOption','NewContextText','Y',0)
		SKIN:Bang('!Update')
		local Meter=SKIN:GetMeter('NewContextText')
		DETAIL_H=Meter:GetH()
		DETAIL_Y=0
	end
end

-- 表格，删除
function ListDelete(N)
	local Index=(PAGE-1)*5+N
	if TYPE=='Schedule' then
		local FilePath=SKIN:MakePathAbsolute(SELF:GetOption("LogFolder"))..'\\'..sche[Index]..'.txt'
		local File=io.open(FilePath,'r')
		if File then
			File:close()
			os.remove(FilePath)
		end
		table.remove(sche,Index)
		TOTALPAGE=math.ceil(#sche/5)
		if TOTALPAGE<=0 then TOTALPAGE=1 end
		if PAGE>TOTALPAGE then PAGE=TOTALPAGE end
		DrawSchedule()
	elseif TYPE=='Note' then
		table.remove(note,Index)
		TOTALPAGE=math.ceil(#note/5)
		if TOTALPAGE<=0 then TOTALPAGE=1 end
		if PAGE>TOTALPAGE then PAGE=TOTALPAGE end
		WriteNoteFile()
		DrawNote()
	elseif TYPE=='ScheItem' then
		table.remove(scheitem,Index)
		TOTALPAGE=math.ceil(#scheitem/5)
		if TOTALPAGE<=0 then TOTALPAGE=1 end
		if PAGE>TOTALPAGE then PAGE=TOTALPAGE end
		WriteScheduleFile()
		DrawScheItem()
	end
end

function AddNewSchedule()
	if TYPE=='Schedule' then
		SKIN:Bang('!SetOption','ListWindow','H',0)
		SKIN:Bang('!UpdateMeter','ListWindow')
		SKIN:Bang('!HideMeter','ScheTipNew')
		SKIN:Bang('!HideMeter','ScheTipNewText')
		SKIN:Bang('!ShowMeterGroup','ScheNew')
		SKIN:Bang('!Redraw')
	elseif TYPE=='ScheItem' then
		add.Index=0
		add.Title=''
		add.Tip=''
		SKIN:Bang('!SetOption','ScheduleWindow','H',0)
		SKIN:Bang('!SetOption','ListWindow','H',0)
		SKIN:Bang('!SetOption','AddNewWindow','H',WIN_H)
		SKIN:Bang('!ShowMeter','NewContextText')
		SKIN:Bang('!SetOption','NewTitleText','Text',TR_AddNew.Title)
		SKIN:Bang('!SetOption','NewContextText','Text',TR_AddNew.Tip)
		SKIN:Bang('!SetOption','NewContextText','Y',0)
		SKIN:Bang('!Update')
		local Meter=SKIN:GetMeter('NewContextText')
		DETAIL_H=Meter:GetH()
		DETAIL_Y=0
	end
end

function AddNewScheduleOK()
	local FileName=string.format("%04d%02d%02d",newsche.Year,newsche.Month,newsche.Day)
	TYPE='ScheItem'
	ReadScheduleFile(tonumber(FileName))
	PAGE=1
	TOTALPAGE=math.ceil(#scheitem/5)
	if TOTALPAGE<=0 then TOTALPAGE=1 end
	SKIN:Bang('!SetOption','ListWindow','H',WIN_H)
	SKIN:Bang('!UpdateMeter','ListWindow')
	SKIN:Bang('!ShowMeter','ScheTipNew')
	SKIN:Bang('!ShowMeter','ScheTipNewText')
	SKIN:Bang('!HideMeterGroup','ScheNew')
	DrawScheItem()
end

function AddNewScheduleCancel()
	SKIN:Bang('!SetOption','ListWindow','H',WIN_H)
	SKIN:Bang('!UpdateMeter','ListWindow')
	SKIN:Bang('!ShowMeter','ScheTipNew')
	SKIN:Bang('!ShowMeter','ScheTipNewText')
	SKIN:Bang('!HideMeterGroup','ScheNew')
	SKIN:Bang('!Redraw')
end

function AddNewNote()
	add.Index=0
	add.Title=''
	add.Tip=''
	SKIN:Bang('!SetOption','NoteWindow','H',0)
	SKIN:Bang('!SetOption','ListWindow','H',0)
	SKIN:Bang('!SetOption','AddNewWindow','H',WIN_H)
	SKIN:Bang('!ShowMeter','NewContextText')
	SKIN:Bang('!SetOption','NewTitleText','Text',TR_AddNew.Title)
	SKIN:Bang('!SetOption','NewContextText','Text',TR_AddNew.Tip)
	SKIN:Bang('!SetOption','NewContextText','Y',0)
	SKIN:Bang('!Update')
	local Meter=SKIN:GetMeter('NewContextText')
	DETAIL_H=Meter:GetH()
	DETAIL_Y=0
end

function InputYearReady(Pos)
	SKIN:Bang('!SetOption','MeasureInput','Y',Pos)
	SKIN:Bang('!SetOption','MeasureInput','InputLimit',4)
	SKIN:Bang('!SetOption','MeasureInput','DefaultValue',string.format("%04d",newsche.Year))
	SKIN:Bang('!UpdateMeasure','MeasureInput')
	SKIN:Bang('!CommandMeasure','MeasureInput','ExecuteBatch 1')
end

function InputYearOver(Num)
	if Num~=nil and Num>=1000 and Num<10000 then
		newsche.Year=Num
		SKIN:Bang('!SetOption','ScheNew01V','Text',string.format("%04d",newsche.Year))
		SKIN:Bang('!UpdateMeter','ScheNew01V')
		SKIN:Bang('!Redraw')
	end
end

function InputMonthReady(Pos)
	SKIN:Bang('!SetOption','MeasureInput','Y',Pos)
	SKIN:Bang('!SetOption','MeasureInput','InputLimit',2)
	SKIN:Bang('!SetOption','MeasureInput','DefaultValue',string.format("%02d",newsche.Month))
	SKIN:Bang('!UpdateMeasure','MeasureInput')
	SKIN:Bang('!CommandMeasure','MeasureInput','ExecuteBatch 2')
end

function InputMonthOver(Num)
	if Num~=nil and Num>=1 and Num<13 then
		newsche.Month=Num
		SKIN:Bang('!SetOption','ScheNew02V','Text',string.format("%02d",newsche.Month))
		SKIN:Bang('!UpdateMeter','ScheNew02V')
		SKIN:Bang('!Redraw')
	end
end

function InputDayReady(Pos)
	SKIN:Bang('!SetOption','MeasureInput','Y',Pos)
	SKIN:Bang('!SetOption','MeasureInput','InputLimit',2)
	SKIN:Bang('!SetOption','MeasureInput','DefaultValue',string.format("%02d",newsche.Day))
	SKIN:Bang('!UpdateMeasure','MeasureInput')
	SKIN:Bang('!CommandMeasure','MeasureInput','ExecuteBatch 3')
end

function InputDayOver(Num)
	if Num~=nil and Num>=1 and Num<32 then
		newsche.Day=Num
		SKIN:Bang('!SetOption','ScheNew03V','Text',string.format("%02d",newsche.Day))
		SKIN:Bang('!UpdateMeter','ScheNew03V')
		SKIN:Bang('!Redraw')
	end
end

function AddNewItemOK()
	if TYPE=='ScheItem' then
		SKIN:Bang('!SetOption','ScheduleWindow','H',WIN_H)
		SKIN:Bang('!SetOption','ListWindow','H',WIN_H)
		SKIN:Bang('!SetOption','AddNewWindow','H',0)
		SKIN:Bang('!UpdateMeter','ScheduleWindow')
		SKIN:Bang('!UpdateMeter','ListWindow')
		SKIN:Bang('!UpdateMeter','AddNewWindow')
		SKIN:Bang('!HideMeter','NewContextText')
		if add.Tip~='' then
			local TipTemp=string.gsub(add.Tip,'\r\n','|')
			if add.Title=='' then
				local _,Num=string.find(TipTemp,"|")
				if Num~=nil then
					add.Title=string.sub(TipTemp,1,Num-1)
					local Tip=string.sub(TipTemp,Num+1,-1)
					TipTemp=Tip
				end
			end
			if add.Index==0 then
				table.insert(scheitem,{Title=add.Title,Tip=TipTemp})
				TOTALPAGE=math.ceil(#scheitem/5)
				if TOTALPAGE<=0 then TOTALPAGE=1 end
			else
				scheitem[add.Index].Title=add.Title
				scheitem[add.Index].Tip=TipTemp
			end
			WriteScheduleFile()
			DrawScheItem()
		else
			SKIN:Bang('!Redraw')
		end
	elseif TYPE=='Note' then
		SKIN:Bang('!SetOption','NoteWindow','H',WIN_H)
		SKIN:Bang('!SetOption','ListWindow','H',WIN_H)
		SKIN:Bang('!SetOption','AddNewWindow','H',0)
		SKIN:Bang('!UpdateMeter','NoteWindow')
		SKIN:Bang('!UpdateMeter','ListWindow')
		SKIN:Bang('!UpdateMeter','AddNewWindow')
		SKIN:Bang('!HideMeter','NewContextText')
		if add.Tip~='' then
			local TipTemp=string.gsub(add.Tip,'\r\n','|')
			if add.Title=='' then
				local _,Num=string.find(TipTemp,"|")
				if Num~=nil then
					add.Title=string.sub(TipTemp,1,Num-1)
					local Tip=string.sub(TipTemp,Num+1,-1)
					TipTemp=Tip
				end
			end
			if add.Index==0 then
				table.insert(note,{Title=add.Title,Tip=TipTemp})
				TOTALPAGE=math.ceil(#note/5)
				if TOTALPAGE<=0 then TOTALPAGE=1 end
			else
				note[add.Index].Title=add.Title
				note[add.Index].Tip=TipTemp
			end
			WriteNoteFile()
			DrawNote()
		else
			SKIN:Bang('!Redraw')
		end
	end
end

function AddNewItemCancel()
	if TYPE=='ScheItem' then
		SKIN:Bang('!SetOption','ScheduleWindow','H',WIN_H)
		SKIN:Bang('!SetOption','ListWindow','H',WIN_H)
		SKIN:Bang('!SetOption','AddNewWindow','H',0)
		SKIN:Bang('!UpdateMeter','ScheduleWindow')
		SKIN:Bang('!UpdateMeter','ListWindow')
		SKIN:Bang('!UpdateMeter','AddNewWindow')
		SKIN:Bang('!HideMeter','NewContextText')
		SKIN:Bang('!Redraw')
	elseif TYPE=='Note' then
		SKIN:Bang('!SetOption','NoteWindow','H',WIN_H)
		SKIN:Bang('!SetOption','ListWindow','H',WIN_H)
		SKIN:Bang('!SetOption','AddNewWindow','H',0)
		SKIN:Bang('!UpdateMeter','NoteWindow')
		SKIN:Bang('!UpdateMeter','ListWindow')
		SKIN:Bang('!UpdateMeter','AddNewWindow')
		SKIN:Bang('!HideMeter','NewContextText')
		SKIN:Bang('!Redraw')
	end
end

function NewScrollUp()
	DETAIL_Y=DETAIL_Y+RANGE_SCROLL
	if DETAIL_Y>0 then DETAIL_Y=0 end
	SKIN:Bang('!SetOption','NewContextText','Y',DETAIL_Y)
	SKIN:Bang('!UpdateMeter','NewContextText')
	SKIN:Bang('!Redraw')
end

function NewScrollDown()
	if DETAIL_Y+DETAIL_H>RANGE_DETAIL then
		DETAIL_Y=DETAIL_Y-RANGE_SCROLL
		SKIN:Bang('!SetOption','NewContextText','Y',DETAIL_Y)
		SKIN:Bang('!UpdateMeter','NewContextText')
		SKIN:Bang('!Redraw')
	end
end

function InputTitleReady()
	SKIN:Bang('!SetOption','MeasureInputTitle','DefaultValue',add.Title)
	SKIN:Bang('!UpdateMeasure','MeasureInputTitle')
	SKIN:Bang('!SetOption','NewTitleBG','Color','Fill Color #ColorSetting#')
	SKIN:Bang('!SetOption','NewTitleLabel','FontColor','255,255,255')
	SKIN:Bang('!UpdateMeter','NewTitleBG')
	SKIN:Bang('!UpdateMeter','NewTitleLabel')
	SKIN:Bang('!Redraw')
	SKIN:Bang('!CommandMeasure','MeasureInputTitle','ExecuteBatch 1')
end

function InputTitleOver()
	local Measure=SKIN:GetMeasure('MeasureInputTitle')
	local Value=string.gsub(Measure:GetStringValue(),'\r\n','')
	add.Title=Value
	SKIN:Bang('!SetOption','NewTitleText','Text',Value)
	SKIN:Bang('!SetOption','NewTitleBG','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','NewTitleLabel','FontColor','#ColorMain1#')
	SKIN:Bang('!UpdateMeter','NewTitleBG')
	SKIN:Bang('!UpdateMeter','NewTitleLabel')
	SKIN:Bang('!UpdateMeter','NewTitleText')
	SKIN:Bang('!Redraw')
end

function InputTitleDismiss()
	SKIN:Bang('!SetOption','NewTitleBG','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','NewTitleLabel','FontColor','#ColorMain1#')
	SKIN:Bang('!UpdateMeter','NewTitleBG')
	SKIN:Bang('!UpdateMeter','NewTitleLabel')
	SKIN:Bang('!Redraw')
end

function InputContextReady()
	SKIN:Bang('!SetOption','MeasureInputContext','DefaultValue',add.Tip)
	SKIN:Bang('!UpdateMeasure','MeasureInputContext')
	SKIN:Bang('!SetOption','NewContextBG','Color','Fill Color #ColorSetting#')
	SKIN:Bang('!SetOption','NewContextLabel','FontColor','255,255,255')
	SKIN:Bang('!UpdateMeter','NewContextBG')
	SKIN:Bang('!UpdateMeter','NewContextLabel')
	SKIN:Bang('!Redraw')
	SKIN:Bang('!CommandMeasure','MeasureInputContext','ExecuteBatch 1')
end

function InputContextOver()
	local Measure=SKIN:GetMeasure('MeasureInputContext')
	local Value=Measure:GetStringValue()
	if Value~='' then
		add.Tip=Value
		SKIN:Bang('!SetOption','NewContextText','Text',Value)
	end
	SKIN:Bang('!SetOption','NewContextBG','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','NewContextLabel','FontColor','#ColorMain1#')
	SKIN:Bang('!UpdateMeter','NewContextBG')
	SKIN:Bang('!UpdateMeter','NewContextLabel')
	SKIN:Bang('!UpdateMeter','NewContextText')
	SKIN:Bang('!Redraw')
end

function InputContextDismiss()
	SKIN:Bang('!SetOption','NewContextBG','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','NewContextLabel','FontColor','#ColorMain1#')
	SKIN:Bang('!UpdateMeter','NewContextBG')
	SKIN:Bang('!UpdateMeter','NewContextLabel')
	SKIN:Bang('!Redraw')
end

--*************************************************

-- 判断一个数字是否为所需的日期格式
function AssertDateCode(N)
	if N==nil then return false end
	local Num = math.floor(N/10000000)
	if Num>0 and Num<10 then
		return true
	else
		return false
	end
end

-- 将YYYYMMDD格式解析为年月日并输出
function ScheNameNormalize(ScheDate)
	local Day=ScheDate%100
	local Year=math.floor(ScheDate/10000)
	local Month=math.floor((ScheDate-Year*10000)/100)
	local Temp01=string.gsub(SCHENAME,'%%1',Year)
	local Temp02=string.gsub(Temp01,'%%2',Month)
	local Temp03=string.gsub(Temp02,'%%3',Day)
	return Temp03
end

