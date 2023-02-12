--[[
Name = Circle.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Circle Launcher皮肤
]]

function Initialize()
	--图标大小
	ICONSIZE=SELF:GetOption('IconSize')
end

function Over(N)
	SKIN:Bang('!SetOption '..N..' Size "Scale 1.2,1.2"')
	SKIN:Bang('!SetOption '..N..' Color "Fill Color #CircleColor'..N..'#"')
	SKIN:Bang('!SetOption I'..N..' X -'..1.2*ICONSIZE..'r')
	SKIN:Bang('!SetOption I'..N..' Y -'..1.2*ICONSIZE..'r')
	SKIN:Bang('!SetOption I'..N..' W '..2.4*ICONSIZE)
	SKIN:Bang('!SetOption I'..N..' ImageAlpha 255')
	SKIN:Bang('!UpdateMeterGroup',N)
	SKIN:Bang('!Redraw')
end

function Leave(N)
	SKIN:Bang('!SetOption '..N..' Size "Scale 1.0,1.0"')
	SKIN:Bang('!SetOption '..N..' Color "Fill Color #CircleColor'..N..'#,#AlphaCircle#"')
	SKIN:Bang('!SetOption I'..N..' X -'..ICONSIZE..'r')
	SKIN:Bang('!SetOption I'..N..' Y -'..ICONSIZE..'r')
	SKIN:Bang('!SetOption I'..N..' W '..2*ICONSIZE)
	SKIN:Bang('!SetOption I'..N..' ImageAlpha #AlphaCircle#')
	SKIN:Bang('!UpdateMeterGroup',N)
	SKIN:Bang('!Redraw')
end

