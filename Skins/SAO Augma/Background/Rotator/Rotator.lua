--[[
Name = Rotator.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Background\Rotator皮肤
]]

Round={}

function Initialize()
	--旋转中心
	IDX=0
	RX=120
	RY=math.floor(tonumber(SKIN:GetVariable('SkinWidth'))*0.0548+0.5)
end

function Update()
	IDX=IDX+1
	for i=1,5 do
		Round[i]()
	end
end

Round[1] = function ()
	local Angle=IDX%45
	if Angle<=30 then
		Angle=200*math.sin((Angle)/60*math.pi)
	elseif Angle<=35 then
		Angle=200
	else
		Angle=200-200*math.sin((Angle-35)/20*math.pi)
	end
	local Ta=math.cos(math.rad(Angle))
	local Tb=-math.sin(math.rad(Angle))
	local Tc=math.sin(math.rad(Angle))
	local Td=math.cos(math.rad(Angle))
	local Tx=RX-RX*Ta-RY*Tc
	local Ty=RY-RX*Tb-RY*Td
	SKIN:Bang('!SetOption','Round1','TransformationMatrix',Ta..';'..Tb..';'..Tc..';'..Td..';'..Tx..';'..Ty)
end

Round[2] = function ()
	local Angle=-IDX*12
	local Ta=math.cos(math.rad(Angle))
	local Tb=math.sin(math.rad(Angle))
	local Tc=-math.sin(math.rad(Angle))
	local Td=math.cos(math.rad(Angle))
	local Tx=RX-RX*Ta-RY*Tc
	local Ty=RY-RX*Tb-RY*Td
	SKIN:Bang('!SetOption','Round2','TransformationMatrix',Ta..';'..Tb..';'..Tc..';'..Td..';'..Tx..';'..Ty)
end

Round[3] = function ()
	local Angle=IDX*4.5
	local Ta=math.cos(math.rad(Angle))
	local Tb=math.sin(math.rad(Angle))
	local Tc=-math.sin(math.rad(Angle))
	local Td=math.cos(math.rad(Angle))
	local Tx=RX-RX*Ta-RY*Tc
	local Ty=RY-RX*Tb-RY*Td
	SKIN:Bang('!SetOption','Round3','TransformationMatrix',Ta..';'..Tb..';'..Tc..';'..Td..';'..Tx..';'..Ty)
end

Round[4] = function ()
	local Angle=IDX%50
	if Angle<=15 then
		Angle=Angle*24
	else
		Angle=-360*math.sin((Angle-15)/70*math.pi)
	end
	local Ta=math.cos(math.rad(Angle))
	local Tb=-math.sin(math.rad(Angle))
	local Tc=math.sin(math.rad(Angle))
	local Td=math.cos(math.rad(Angle))
	local Tx=RX-RX*Ta-RY*Tc
	local Ty=RY-RX*Tb-RY*Td
	SKIN:Bang('!SetOption','Round4','TransformationMatrix',Ta..';'..Tb..';'..Tc..';'..Td..';'..Tx..';'..Ty)
end

Round[5] = function ()
	local Angle=IDX*9
	local Ta=math.cos(math.rad(Angle))
	local Tb=math.sin(math.rad(Angle))
	local Tc=-math.sin(math.rad(Angle))
	local Td=math.cos(math.rad(Angle))
	local Tx=RX-RX*Ta-RY*Tc
	local Ty=RY-RX*Tb-RY*Td
	SKIN:Bang('!SetOption','Round5','TransformationMatrix',Ta..';'..Tb..';'..Tc..';'..Td..';'..Tx..';'..Ty)
end

