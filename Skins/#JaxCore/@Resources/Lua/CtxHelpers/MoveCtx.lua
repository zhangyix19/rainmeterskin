function Update()
	moveX = '0'
	moveY = '0'
	anchorX = '0'
	anchorY = '0'

	ctxH = (SKIN:GetMeasure('Ctx.H:eX')):GetValue()
	ctxW = (SKIN:GetMeasure('Ctx.W:eX')):GetValue()
	ctxS = (SKIN:GetMeasure('Ctx.S:eX')):GetValue()
	sax = tonumber(SKIN:GetVariable('SCREENAREAX', -1))
	say = tonumber(SKIN:GetVariable('SCREENAREAY', -1))
	saw = tonumber(SKIN:GetVariable('SCREENAREAWIDTH', -1))
	sah = tonumber(SKIN:GetVariable('SCREENAREAHEIGHT', -1))

	if SKIN:GetMeasure('CurPos.X') ~= nil then
		moveX = (SKIN:GetMeasure('CurPos.X')):GetValue()
		moveY = (SKIN:GetMeasure('CurPos.Y')):GetValue()
		
		if ((moveX + ctxW) > saw and (moveY + ctxH) < sah) then
			-- quad 1
			anchorX = '100%'
		elseif ((moveX + ctxW) < saw and (moveY + ctxH) < sah) then
			-- quad 2
		elseif ((moveX + ctxW) < saw and (moveY + ctxH) > sah) then
			-- quad 3
			anchorY = '100%'
		elseif ((moveX + ctxW) > saw and (moveY + ctxH) > sah) then
			-- quad 4
			anchorX = '100%'
			anchorY = '100%'
		else
			error("Invalid Operation")
		end
	else
		moveX = SKIN:GetVariable('Ctx.LastX')
		moveY = SKIN:GetVariable('Ctx.LastY')
		local function toNum(s)
			if s == '100%' then return 1 else return 0 end
		end
		local lastXA = toNum(SKIN:GetVariable('Ctx.LastXA'))
		local lastYA = toNum(SKIN:GetVariable('Ctx.LastYA'))
		
		if ((moveX + ctxW) > saw and (moveY + ctxH) < sah) then
			-- quad 1
			anchorX = '100%'
			moveX = moveX - ctxW * (1 + lastXA) - 20 * ctxS
		elseif ((moveX + ctxW) < saw and (moveY + ctxH) < sah) then
			-- quad 2
		elseif ((moveX + ctxW) < saw and (moveY + ctxH) > sah) then
			-- quad 3
			anchorY = '100%'
		elseif ((moveX + ctxW) > saw and (moveY + ctxH) > sah) then
			-- quad 4
			anchorX = '100%'
			moveX = moveX - ctxW * (1 + lastXA) - 20 * ctxS
			anchorY = '100%'
		else
			error("Invalid Operation")
		end
	end

	-- SKIN:MoveWindow(moveX, moveY)
	-- SKIN:Bang('[!CommandMeasure SlideAnimation "importPosition('..moveX..', '..moveY..', \''..anchorX..'\', \''..anchorY..'\')"][!CommandMeasure ActionTimer "Execute 1"]')
	SKIN:Bang('[!SetWindowPosition '..moveX..', '..moveY..', '..anchorX..', '..anchorY..']')
end

function OpenSub(handlerName, subMenuName)
	local handler = SKIN:GetMeter(handlerName)
	local IsCore = SKIN:GetVariable('Sec.Ctx.Core')
	local SubX = moveX + ctxW + 10 * ctxS
	local SubY = handler:GetY() + SKIN:GetY()
	local SubXA = anchorX
	local SubYA = anchorY
	SKIN:Bang('[!DisableMeasure mToggle][!WriteKeyvalue Variables Sec.Skin '..SKIN:GetVariable('Ctx.Parent')..' "#ROOTCONFIGPATH#Ctx\\Submenu\\'..subMenuName..'.ini"][!WriteKeyvalue Variables Ctx.LastX '..SubX..' "#ROOTCONFIGPATH#Ctx\\Submenu\\'..subMenuName..'.ini"][!WriteKeyvalue Variables Ctx.LastY '..SubY..' "#ROOTCONFIGPATH#Ctx\\Submenu\\'..subMenuName..'.ini"][!WriteKeyvalue Variables Ctx.LastXA '..SubXA..' "#ROOTCONFIGPATH#Ctx\\Submenu\\'..subMenuName..'.ini"][!WriteKeyvalue Variables Ctx.LastYA '..SubYA..' "#ROOTCONFIGPATH#Ctx\\Submenu\\'..subMenuName..'.ini"][!WriteKeyvalue Variables Ctx.IsCore '..IsCore..' "#ROOTCONFIGPATH#Ctx\\Submenu\\'..subMenuName..'.ini"][!ActivateConfig "#JaxCore\\Ctx\\Submenu" "'..subMenuName..'.ini"]')
	SKIN:Bang('!SetVariable', 'CCW', SKIN:GetVariable('CCW'), '#JaxCore\\Ctx\\Submenu')
	SKIN:Bang('!SetVariable', 'CCH', SKIN:GetVariable('CCH'), '#JaxCore\\Ctx\\Submenu')
	SKIN:Bang('!SetVariable', 'SKINX', SKIN:GetVariable('SKINX'), '#JaxCore\\Ctx\\Submenu')
	SKIN:Bang('!SetVariable', 'SKINY', SKIN:GetVariable('SKINY'), '#JaxCore\\Ctx\\Submenu')
end