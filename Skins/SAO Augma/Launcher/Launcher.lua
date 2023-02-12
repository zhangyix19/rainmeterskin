--[[
Name = Launcher.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Launcher皮肤
]]

function Initialize()
	MODE=tonumber(SKIN:GetVariable('LauncherMode'))
	RANGE_BG=tonumber(SELF:GetOption('BGYPos'))
	RANGE_MENU=tonumber(SELF:GetOption('MenuHeight'))
	ANI_BG=0
	ANI_MENU=0
	SetGroup()
	SetSearch()
end

--设置DOCK组
function SetGroup()
	local Group=GetGroup()
	DrawGroup(Group)
	DrawGroupNow()
end

function GetGroup()
	local GroupIdx=tonumber(SKIN:GetVariable('UseGroup')) or 1
	local Tab={}
	local Idx=0
	for i=1,4 do
		local Name=SKIN:GetVariable('Group'..i)
		if Name~=nil and Name~='' then
			Idx=Idx+1
			Tab[Idx]=i
			if GroupIdx==i then
				GROUP_IDX=Idx
			end
		end
	end
	if GROUP_IDX==nil then
		GROUP_IDX=1
		if Tab[1]==nil then
			Tab[1]=1
			local Default=SELF:GetOption('DefaultGroupName')
			SKIN:Bang('!SetVariable','Group1',Default)
			SKIN:Bang('!WriteKeyValue','Variables','Group1',Default,'#@#Config\\Launcher\\Launcher.inc')
		end
		SKIN:Bang('!WriteKeyValue','Variables','UseGroup',Tab[1],'#@#Config\\Launcher\\Launcher.inc')
	end
	return Tab
end

function DrawGroup(Tab)
	for i=1,#Tab do
		SKIN:Bang('!ShowMeter','G'..i)
		SKIN:Bang('!ShowMeter','G'..i..'T')
		SKIN:Bang('!SetOption','G'..i..'T','Text','#Group'..Tab[i]..'#')
		SKIN:Bang('!SetOption','G'..i,'LeftMouseUpAction','!CommandMeasure MeasureScript "ChangeGroup('..Tab[i]..','..i..')"')
	end
end

function DrawGroupNow()
	SKIN:Bang('!SetOption','G'..GROUP_IDX,'Fill1','Fill Color #ColorLauncher#')
	SKIN:Bang('!SetOption','G'..GROUP_IDX,'Fill2','Fill Color #ColorMain1#')
	SKIN:Bang('!SetOption','G'..GROUP_IDX..'T','FontColor','#ColorMain2#')
	SKIN:Bang('!SetOption','Title','Text','#Group'..GROUP_IDX..'#')
end

--切换Dock组
function ChangeGroup(N,I)
	--N为组文件编号，I为Meter编号
	if I~=GROUP_IDX then
		SKIN:Bang('!WriteKeyValue','Variables','UseGroup',N,'#@#Config\\Launcher\\Launcher.inc')
		UnlightGroup(GROUP_IDX)
		GROUP_IDX=I
		LightGroup(GROUP_IDX)
		SKIN:Bang('!SetOption','Title','Text','#Group'..N..'#')
		SKIN:Bang('!UpdateMeter Title')
		SKIN:Bang('!SetVariable','UseGroup',N,'#CurrentConfig#\\Icons')
		SKIN:Bang('!CommandMeasure','MeasureScript','Initialize()','#CurrentConfig#\\Icons')
	end
end

--绘制Dock组选项取消高亮
function UnlightGroup(I)
	SKIN:Bang('!SetOption','G'..I,'Fill1','Fill Color #ColorLauncher#,180')
	SKIN:Bang('!SetOption','G'..I,'Fill2','Fill Color #ColorMain1#,180')
	SKIN:Bang('!SetOption','G'..I..'T','FontColor','#ColorMain3#,180')
	SKIN:Bang('!UpdateMeter','G'..I)
	SKIN:Bang('!UpdateMeter','G'..I..'T')
end

--绘制Dock组选项高亮
function LightGroup(I)
	SKIN:Bang('!SetOption','G'..I,'Fill1','Fill Color #ColorLauncher#')
	SKIN:Bang('!SetOption','G'..I,'Fill2','Fill Color #ColorMain1#')
	SKIN:Bang('!SetOption','G'..I..'T','FontColor','#ColorMain2#')
	SKIN:Bang('!UpdateMeter','G'..I)
	SKIN:Bang('!UpdateMeter','G'..I..'T')
end

---------------------------------------------------

--设置Search
function SetSearch()
	if MODE==0 then
		SKIN:Bang('!HideMeterGroup Search')
		return
	else
		GetSearch()
		DrawSearch()
		DrawSearchNow()
	end
end

--输出搜索项目表searchoption
function GetSearch()
	SEARCH_IDX=tonumber(SKIN:GetVariable('UseSearch')) or 1
	searchoption={}
	local Idx=0
	while (type(SKIN:GetVariable('Search'..Idx+1))~='nil' and SKIN:GetVariable('Search'..Idx+1)~='') do
		Idx=Idx+1
		if Idx > 16 then break end
		local Content=SKIN:GetVariable('Search'..Idx)
		searchoption[Idx] = {}
		local Pos=string.find(Content, "%_")
		searchoption[Idx].name = string.sub(Content, 1, Pos-1) or ''
		searchoption[Idx].path = string.sub(Content, Pos+1, -1) or ''
	end
end

function DrawSearch()
	for i=1,#searchoption do
		SKIN:Bang('!ShowMeter','S'..i)
		SKIN:Bang('!ShowMeter','S'..i..'T')
		SKIN:Bang('!SetOption','S'..i..'T','Text',searchoption[i].name)
	end
end

function DrawSearchNow()
	if SEARCH_IDX>#searchoption then
		SEARCH_IDX=#searchoption
	end
	SKIN:Bang('!SetOption','S'..SEARCH_IDX,'Fill','Fill Color #ColorMain1#')
	SKIN:Bang('!SetOption','S'..SEARCH_IDX..'T','FontColor','#ColorMain2#')
end

--点击搜索时运行
function Search()
	SKIN:Bang('!SetOption','SearchBG','Fill','Fill Color #ColorMain1#,230')
	SKIN:Bang('!UpdateMeter SearchBG')
	SKIN:Bang('!Redraw')
	local Site = searchoption[SEARCH_IDX].path or ''
	local measure = SKIN:GetMeasure('MeasureInput')
	local String = measure:GetStringValue()
	SKIN:Bang('["'..Site..String..'"]')
	SKIN:Bang('!DeactivateConfig','#RootConfig#\\Launcher')
end

--切换Search项
function ChangeSearch(N)
	if N~=SEARCH_IDX then
		UnlightSearch(SEARCH_IDX)
		SEARCH_IDX=N
		LightSearch(SEARCH_IDX)
		SKIN:Bang('!Redraw')
	end
end

--关闭皮肤时，设置Search项
function WriteSearch()
	local S0=tonumber(SKIN:GetVariable('UseSearch')) or 1
	if S0~=SEARCH_IDX then
		SKIN:Bang('!WriteKeyValue','Variables','UseSearch',SEARCH_IDX,'#@#Config\\Launcher\\Launcher.inc')
	end
end

--绘制Search项取消高亮
function UnlightSearch(N)
	SKIN:Bang('!SetOption','S'..N,'Fill','Fill Color #ColorMain1#,180')
	SKIN:Bang('!SetOption','S'..N..'T','FontColor','#ColorMain2#,180')
	SKIN:Bang('!UpdateMeter','S'..N)
	SKIN:Bang('!UpdateMeter','S'..N..'T')
end

--绘制Search项高亮
function LightSearch(N)
	SKIN:Bang('!SetOption','S'..N,'Fill','Fill Color #ColorMain1#')
	SKIN:Bang('!SetOption','S'..N..'T','FontColor','#ColorMain2#')
	SKIN:Bang('!UpdateMeter','S'..N)
	SKIN:Bang('!UpdateMeter','S'..N..'T')
end

---------------------------------------------------

--控制启动动画
function AniBG()
	ANI_BG=ANI_BG+10
	local Pos=RANGE_BG *(math.sin(math.rad(ANI_BG)))
	SKIN:Bang('!SetOption','BG','Y',Pos)
	SKIN:Bang('!UpdateMeter BG')
	SKIN:Bang('!UpdateMeasure MeasureAction')
	SKIN:Bang('!Redraw')
end

--控制菜单弹出动画
function CtrlAniMenu()
	if ANI_MENU<=0 then
		SKIN:Bang('!ShowMeter MenuBottom')
		SKIN:Bang('!SetVariable','MenuH_Ani',0)
		SKIN:Bang('!UpdateMeter MenuBottom')
		SKIN:Bang('!Redraw')
		SKIN:Bang('!CommandMeasure MeasureAction "Execute 2"')
	elseif ANI_MENU>=90 then
		SKIN:Bang('!HideMeterGroup Menu')
		SKIN:Bang('!SetVariable','MenuH_Ani',RANGE_MENU)
		SKIN:Bang('!UpdateMeter MenuBottom')
		SKIN:Bang('!Redraw')
		SKIN:Bang('!CommandMeasure MeasureAction "Execute 3"')
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

