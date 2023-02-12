--[[
Name = System Windows.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制System皮肤的Windows部分
]]

function Initialize()
	Check()
	RANGE_MENU=tonumber(SELF:GetOption('MenuHeight'))
	ANI_MENU=0
	ANI_PWR=0
	local Title=tostring(SKIN:GetVariable('SystemTitle'))
	if Title~=nil and Title ~='' then
		SKIN:Bang('!SetOption','Title','Text',Title)
	else
		SKIN:Bang('!SetOption Title Text System')
	end
	local Thread=tonumber(SELF:GetOption('CPUNumber'))
	if Thread==nil then return end
	Thread= (Thread>12 and 12) or Thread
	local PosCenter=tonumber(SELF:GetOption('CPUCenter'))
	local PosRange=tonumber(SELF:GetOption('CPURadius'))
	local Height=SeparateNum(SELF:GetOption('CPU_H'))
	CPUPosCalc(Height[math.ceil(Thread/2)],Thread,PosCenter,PosRange)
	EnableCPU(Thread)
end

function Check()
	local Type=SKIN:GetVariable('TypeSystem')
	if Type=='Windows' then return
	elseif Type=='HWiNFO' then
		local Size=SKIN:GetVariable('ComponentSize')
		SKIN:Bang('!ActivateConfig','#CurrentConfig#','System '..Size..' HWiNFO.ini')
	else
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

--计算各CPU线程的Bar的位置
function CPUPosCalc(Height,Thread,Center,Range)
	local Pos={}
	Pos[1],Pos[3],Pos[5],Pos[7],Pos[9],Pos[11]=CPUPosCalc2(Height,math.ceil(Thread/2),Center,Range)
	Pos[2],Pos[4],Pos[6],Pos[8],Pos[10],Pos[12]=CPUPosCalc2(Height,math.floor(Thread/2),Center,Range)
	for i=0,Thread-1 do
		SKIN:Bang('!SetOption','CPU'..i..'Bottom','H',Height)
		SKIN:Bang('!SetOption','CPU'..i..'Bar','H',Height)
		SKIN:Bang('!SetOption','CPU'..i..'Bottom','Y',Pos[i+1])
		SKIN:Bang('!SetOption','CPU'..i..'Text','Y',tostring(Height/2)..'r')
	end
end

function CPUPosCalc2(Height,Total,Center,Range)
	local Break
	local Tab={}
	if Total>=4 then
		Break=math.floor((Range*2-Height*Total)/(Total-1))
		local i,j=1,Total
		while (j-i>=1) do
			Tab[i]=Center-Range+(Break+Height)*(i-1)
			Tab[j]=Center+Range-(Break+Height)*(Total-j)-Height
			i=i+1
			j=j-1
		end
		if i==j then
			Tab[i]=Center-Height/2
		end
	else
		Break=math.floor((Range*2-Height*Total)/(Total+1))
		local i,j=1,Total
		while (j-i>=1) do
			Tab[i]=Center-Range+(Break+Height)*(i-1)+Break
			Tab[j]=Center+Range-(Break+Height)*(Total-j)-Height-Break
			i=i+1
			j=j-1
		end
		if i==j then
			Tab[i]=Center-Height/2
		end
	end
	return Tab[1],Tab[2],Tab[3],Tab[4],Tab[5],Tab[6]
end

--使CPU组运作
function EnableCPU(Thread)
	for i=1,Thread do
		SKIN:Bang('!EnableMeasure','mCPU'..i-1)
		SKIN:Bang('!ShowMeterGroup','CPU'..i-1)
	end
end

---------------------------------------------------

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

--控制Power部分动画
function CtrlAniRAM(IfFree)
	if IfFree then
		SKIN:Bang('!SetOption','cRAMRound','Formula',0)
		SKIN:Bang('!SetOption','RAMRoundline','RotationAngle','(2*pi)')
		SKIN:Bang('!UpdateMeasure','cRAMRound')
		SKIN:Bang('!UpdateMeter','RAMRoundline')
		ANI_RAM=0
		SKIN:Bang('!CommandMeasure','MeasureAction','Execute 3')
	else
		SKIN:Bang('!SetOption','cRAMRound','Formula',1)
		SKIN:Bang('!SetOption','RAMRoundline','RotationAngle','(-2*pi)')
		SKIN:Bang('!UpdateMeasure','cRAMRound')
		SKIN:Bang('!UpdateMeter','RAMRoundline')
		ANI_RAM=1
		SKIN:Bang('!CommandMeasure','MeasureAction','Execute 4')
	end
end

function AniRAM(N)
	ANI_RAM=ANI_RAM+N
	SKIN:Bang('!SetOption','cRAMRound','Formula',ANI_RAM)
	SKIN:Bang('!UpdateMeasure','cRAMRound')
	SKIN:Bang('!UpdateMeter','RAMRoundline')
	SKIN:Bang('!UpdateMeasure MeasureAction')
	SKIN:Bang('!Redraw')
end

--控制Power部分动画
function CtrlAniPower()
	local mAC=SKIN:GetMeasure('mPWR')
	local IfACLine= tonumber(mAC:GetValue())==1
	if IfACLine then
		SKIN:Bang('!SetOption','cPWRRound','Formula',0)
		SKIN:Bang('!SetOption','PWRRoundline','RotationAngle','(2*pi)')
		SKIN:Bang('!UpdateMeasure','cPWRRound')
		SKIN:Bang('!UpdateMeter','PWRRoundline')
		ANI_PWR=0
		SKIN:Bang('!CommandMeasure','MeasureAction','Execute 5')
	else
		SKIN:Bang('!SetOption','cPWRRound','Formula',1)
		SKIN:Bang('!SetOption','PWRRoundline','RotationAngle','(-2*pi)')
		SKIN:Bang('!UpdateMeasure','cPWRRound')
		SKIN:Bang('!UpdateMeter','PWRRoundline')
		ANI_PWR=1
		SKIN:Bang('!CommandMeasure','MeasureAction','Execute 6')
	end
end

function AniPower(N)
	ANI_PWR=ANI_PWR+N
	SKIN:Bang('!SetOption','cPWRRound','Formula',ANI_PWR)
	SKIN:Bang('!UpdateMeasure','cPWRRound')
	SKIN:Bang('!UpdateMeter','PWRRoundline')
	SKIN:Bang('!UpdateMeasure MeasureAction')
	SKIN:Bang('!Redraw')
end

--*************************************************

--分割数据
function SeparateNum(String)
    local Tab={}
	for Str in string.gmatch(String,'[^|]+') do
		table.insert(Tab,tostring(Str))
	end
	return Tab
end
