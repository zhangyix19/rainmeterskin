--[[
Name = Icons.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于获取Launcher皮肤的Dock项
]]

function Initialize()
	GROUP=tonumber(SKIN:GetVariable('UseGroup'))
	PAGE=1
	GetTotalNum()
	ClearDock()
	SetDock()
end

--获取并输出每组Dock的总数、总页码数
function GetTotalNum()
	dock={}
	local Idx=0
	while (type(SKIN:GetVariable('G'..GROUP..'Name'..Idx+1))~='nil' and SKIN:GetVariable('G'..GROUP..'Name'..Idx+1)~='') do
		Idx=Idx+1
	end
	dock.num=Idx
	local TotalPage=math.ceil(Idx/4)-1
	if TotalPage<1 then TotalPage=1 end
	dock.page=TotalPage
end

--初始化Dock
function ClearDock()
	SKIN:Bang('!HideMeterGroup','Launcher','#RootConfig#\\Launcher')
end

--布置Dock
function SetDock()
	for i=1,12 do
		local Idx=(PAGE-1)*4+i
		if Idx>dock.num then break
		else
			SKIN:Bang('!ShowMeterGroup','D'..i,'#RootConfig#\\Launcher')
			SKIN:Bang('!SetOption',i..'I','ImageName','#G'..GROUP..'Icon'..Idx..'#','#RootConfig#\\Launcher')
			SKIN:Bang('!SetOption',i..'T','Text','#G'..GROUP..'Name'..Idx..'#','#RootConfig#\\Launcher')
			SKIN:Bang('!SetOption',i,'LeftMouseUpAction','#G'..GROUP..'Path'..Idx..'##Click#','#RootConfig#\\Launcher')
		end
	end
	SKIN:Bang('!UpdateMeterGroup','Launcher','#RootConfig#\\Launcher')
	SKIN:Bang('!Redraw','#RootConfig#\\Launcher')
end

--切换页码
function ChangePage(N)
	PAGE=PAGE+N
	if PAGE<1 then PAGE=1 end
	if PAGE>dock.page then PAGE=dock.page end
	ClearDock()
	SetDock()
end

