--[[
Name = Search.lua
Author = 雪月花
Vertion = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制SettingPanel皮肤的Search页面
]]

SEARCH_IDX=nil
SEARCH_NAME=nil
SEARCH_SITE=nil

function Initialize()
	-- UI Text Translate
	_TR_SearchEngineSite=SKIN:GetVariable('TR_SearchEngineSite')
end

function InputNameReady()
	if SEARCH_IDX~=nil and SEARCH_NAME~=nil then
		SKIN:Bang('!SetOption','BGName','Color','Fill Color #ColorSetting#')
		SKIN:Bang('!SetOption','IndexNumber','FontColor','255,255,255')
		SKIN:Bang('!UpdateMeter','BGName')
		SKIN:Bang('!UpdateMeter','IndexNumber')
		SKIN:Bang('!Redraw')
		SKIN:Bang('!SetOption','MeasureInputName','DefaultValue',SEARCH_NAME)
		SKIN:Bang('!UpdateMeasure','MeasureInputName')
		SKIN:Bang('!CommandMeasure','MeasureInputName','ExecuteBatch 1')
	end
end

function InputSiteReady()
	if SEARCH_IDX~=nil and SEARCH_SITE~=nil then
		SKIN:Bang('!SetOption','BGSearch','Color','Fill Color #ColorSetting#')
		SKIN:Bang('!SetOption','SearchTitle','FontColor','255,255,255')
		SKIN:Bang('!UpdateMeter','BGSearch')
		SKIN:Bang('!UpdateMeter','SearchTitle')
		SKIN:Bang('!Redraw')
		SKIN:Bang('!SetOption','MeasureInputSite','DefaultValue',SEARCH_SITE)
		SKIN:Bang('!UpdateMeasure','MeasureInputSite')
		SKIN:Bang('!CommandMeasure','MeasureInputSite','ExecuteBatch 1')
	end
end

function InputNameOver()
	local Measure=SKIN:GetMeasure('MeasureInputName')
	SEARCH_NAME=Measure:GetStringValue()
	SKIN:Bang('!SetOption','NameText','Text',SEARCH_NAME)
	SKIN:Bang('!SetOption','BGName','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','IndexNumber','FontColor','#ColorMain1#')
	SKIN:Bang('!UpdateMeter','BGName')
	SKIN:Bang('!UpdateMeter','IndexNumber')
	SKIN:Bang('!UpdateMeter','NameText')
	SKIN:Bang('!Redraw')
end

function InputSiteOver()
	local Measure=SKIN:GetMeasure('MeasureInputSite')
	SEARCH_SITE=Measure:GetStringValue()
	SKIN:Bang('!SetOption','SearchText','Text',_TR_SearchEngineSite..'#CRLF#'..SEARCH_SITE)
	SKIN:Bang('!SetOption','BGSearch','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','SearchTitle','FontColor','#ColorMain1#')
	SKIN:Bang('!UpdateMeter','BGSearch')
	SKIN:Bang('!UpdateMeter','SearchTitle')
	SKIN:Bang('!UpdateMeter','SearchText')
	SKIN:Bang('!Redraw')
end

function InputNameDismiss()
	SKIN:Bang('!SetOption','BGName','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','IndexNumber','FontColor','#ColorMain1#')
	SKIN:Bang('!UpdateMeter','BGName')
	SKIN:Bang('!UpdateMeter','BGName')
	SKIN:Bang('!Redraw')
end

function InputSiteDismiss()
	SKIN:Bang('!SetOption','BGSearch','Color','Fill Color #ColorMain3#,45')
	SKIN:Bang('!SetOption','SearchTitle','FontColor','#ColorMain1#')
	SKIN:Bang('!UpdateMeter','BGSearch')
	SKIN:Bang('!UpdateMeter','SearchTitle')
	SKIN:Bang('!Redraw')
end

function Delete()
	if SEARCH_IDX~=nil and SEARCH_NAME~=nil and SEARCH_SITE~=nil then
		DelVari()
	end
end

function OK()
	if SEARCH_IDX~=nil and SEARCH_NAME~=nil and SEARCH_SITE~=nil then
		if SEARCH_NAME=='' and SEARCH_SITE=='' then
			DelVari()
		else
			local Value=SEARCH_NAME..'_'..SEARCH_SITE
			SKIN:Bang('!SetVariable','Search'..SEARCH_IDX,Value,'#RootConfig#\\Setting\\CtrlSetting')
			SKIN:Bang('!CommandMeasure','MeasureScript','PanelBack_Search(true,'..SEARCH_IDX..')','#RootConfig#\\Setting\\CtrlSetting')
			SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
		end
	end
end

function Cancel()
	if SEARCH_IDX~=nil and SEARCH_NAME~=nil and SEARCH_SITE~=nil then
		SKIN:Bang('!CommandMeasure','MeasureScript','PanelBack_Search(false)','#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
	end
end

-- 删除当前搜索项，后续搜索项向前移动
function DelVari()
	local Num=1
	while (type(SKIN:GetVariable('Search'..Num))~='nil' and SKIN:GetVariable('Search'..Num)~='') do
		Num=Num+1
		if Num > 16 then break end
	end
	if SEARCH_IDX>=Num then
		SKIN:Bang('!SetVariable','Search'..SEARCH_IDX,'','#RootConfig#\\Setting\\CtrlSetting')
		SKIN:Bang('!CommandMeasure','MeasureScript','PanelBack_Search(true,'..SEARCH_IDX..')','#RootConfig#\\Setting\\CtrlSetting')
	else
		for i=SEARCH_IDX,Num-1 do
			local Value=SKIN:GetVariable('Search'..i+1) or ''
			SKIN:Bang('!SetVariable','Search'..i,Value,'#RootConfig#\\Setting\\CtrlSetting')
		end
		SKIN:Bang('!CommandMeasure','MeasureScript','PanelBack_Search(true,'..SEARCH_IDX..','..(Num-1)..')','#RootConfig#\\Setting\\CtrlSetting')
	end
	SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
end

--*************************************************

-- 接收主皮肤的指令，打开页面
function GetData(SearchIdx)
	local SIdx=tonumber(string.match(SearchIdx,"Search(.*)"))
	local SText=tostring(SKIN:GetVariable(SearchIdx))
	if SText==nil or SText=='' then
		local Idx=1
		while (type(SKIN:GetVariable('Search'..Idx))~='nil' and SKIN:GetVariable('Search'..Idx)~='') do
			Idx=Idx+1
			if Idx > 16 then break end
		end
		SEARCH_IDX=Idx
		SEARCH_NAME=''
		SEARCH_SITE=''
	else
		SEARCH_IDX=SIdx
		local Pos=string.find(SText, "%_")
		SEARCH_NAME = string.sub(SText, 1, Pos-1) or ''
		SEARCH_SITE = string.sub(SText, Pos+1, -1) or ''
	end
	if SEARCH_IDX<10 then
		SKIN:Bang('!SetOption','IndexNumber','Text','0'..SEARCH_IDX)
	else
		SKIN:Bang('!SetOption','IndexNumber','Text',SEARCH_IDX)
	end
	SKIN:Bang('!SetOption','NameText','Text',SEARCH_NAME)
	SKIN:Bang('!SetOption','SearchText','Text',_TR_SearchEngineSite..'#CRLF#'..SEARCH_SITE)
	SKIN:Bang('!UpdateMeter','IndexNumber')
	SKIN:Bang('!UpdateMeter','NameText')
	SKIN:Bang('!UpdateMeter','SearchText')
	SKIN:Bang('!ShowMeterGroup','Initialize')
	SKIN:Bang('!Redraw')
end

