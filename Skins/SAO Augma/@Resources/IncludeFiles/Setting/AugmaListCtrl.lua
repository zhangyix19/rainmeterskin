--[[
Name = AugmaListCtrl.lua
Author = ѩ�»�
Version = 1.0
License = CC BY - NC - SA 4.0
Information = ��ҳ��Ľ��������
]]

ATTR={}
--[[
	ATTR[i]={
				IfLocked=
				ConfigFile=
				Option=
				Type=
				Help=		��Type=HELP��
				Other=		��Type=Theme��
				Variable=	��Type=STRING\NUMBER\COLOR\IMAGE\FILE\FOLDER\BOOLEAN��
					Variable={[1],[2]...}	��Type=VALUE��
				Value={[1],[2]...}	��Type=VALUE��
				Function=	��(FUNCTION)��
				Key= ��(LOCK)��
				Unit= ��(UNIT) Type=NUMBER��
				}
]]
TREE={}
--[[
	TREE[j][i]={
				Parent={Tree,Attr}	��TREE[j][1]ʱΪnil��
				[j]={Attr,Sub}		����Type=��
				}
]]
LIST={}
--[[
	��ʼ��ʱ��¼ÿ���Ӳ˵��ĸ��������TREE��ź͵�ǰ���TREE���
	��ʼ����Ϻ󣬼�¼��ǰҳ����չʾ����
	LIST[i]={
				Attr=
				Sub=
				T��Title��=
				C��Color��=
				V��Value��=
				F��Flag��=
				S��Switch��=
				}
]]

LOGPOS={}
--[[
	��¼�ض�ҳ���TREE��ţ��Ա��������򿪸�ҳ��
	_searchres		--��¼�������
]]

--=================================================
-- ����ȫ�ֱ���
-- LOADITEM			--��¼��ǰ���ص�ҳ��
-- CURRENTITEM		--��ת��Panelʱ����¼ListIndex
-- FLAG.Visual		--��¼Ƶ��ѡ���Ƿ����䶯
--=================================================

---------------------------------------------------
-- �����ļ��ɱ�
---------------------------------------------------

function MakeAttributeTable(Path)
	local File=io.open(Path,'r')
	if not File then return
	else
		LIST={[0]=0,1}
		local ConfigFile			-- ������ŵ��ļ���
		for l in File:lines() do
			-- ����ҳ��
			if l=='========' then
				TREE[#TREE+1]={{}}
				LIST[0]=LIST[0]+1
			-- �����ļ���ַ����
			elseif string.sub(l,1,1)=='*' then
				ConfigFile='#@#Config\\'..string.sub(l,2,-1)
			elseif l=='' or l==' ' then return
			else
				-- ������ͷ
				local IfLock
				if string.sub(l,1,1)=='&' then
					IfLock=true
				else
					IfLock=false
				end
				local SubNum=IfLock and 2 or 1
				while string.sub(l,SubNum,SubNum)=='#' do
					SubNum=SubNum+1
				end
				-- ������Ա�ATTR
				table.insert(ATTR,{IfLocked=IfLock})
				-- ��һ������
				local IfSub,IfNext,IfUseConfig,LogPos,StringLeft=Interpret01(string.sub(l,SubNum,-1))
				-- �ڶ�������
				if IfNext then
					Interpret02(StringLeft)
				end
				if IfUseConfig then
					ATTR[#ATTR].ConfigFile=ConfigFile
				end
				-- �����Ʊ�TREE
				local CurrentLevel=IfLock and SubNum-1 or SubNum
				if IfSub then
					table.insert(TREE[LIST[0]],{Parent={Tree=LIST[CurrentLevel],Attr=#ATTR}})
					LIST[CurrentLevel+1]=#TREE[LIST[0]]
					table.insert(TREE[LIST[0]][LIST[CurrentLevel]],{Attr=#ATTR,Sub=#TREE[LIST[0]]})
					if LogPos~=nil then
						LOGPOS[LogPos]=#TREE[LIST[0]]
					end
				else
					table.insert(TREE[LIST[0]][LIST[CurrentLevel]],{Attr=#ATTR})
				end
			end
		end
		File:close()
		LIST={}
	end
end

-- ��һ������
function Interpret01(Line)
	local IfSub,IfNext,IfUseConfig=false,false,true
	local LogPos=nil
	local StringLeft=nil
	local _,_,Option,Temp01,Temp02=string.find(Line,"{(.*)}<(.*)>_(.*)")
	ATTR[#ATTR].Option=Option
	if Temp01=='' or Temp01==nil then
		ATTR[#ATTR].Type='SUB'
		IfSub=true
		IfUseConfig=false
	else
		local _,_,Type,Variable=string.find(Temp01,"(.*):(.*)")
		ATTR[#ATTR].Type=Type
		if Type=='SELECT' then
			IfSub=true
			IfUseConfig=false
		elseif Type=='VALUE' then
			if Variable~=nil and Variable~='' then
				ATTR[#ATTR].Variable={Variable}
			end
			IfNext=true
		elseif Type=='NUMBER' or Type=='STRING' or Type=='COLOR'
			or Type=='BOOLEAN' or Type=='FILE' or Type=='FOLDER'
			or Type=='IMAGE' then
			ATTR[#ATTR].Variable=Variable
		elseif Type=='HELP' then
			ATTR[#ATTR].Help=Variable
			IfUseConfig=false
		elseif Type=='TIP' then
			IfUseConfig=false
		else
			ATTR[#ATTR].Other=Variable
			IfUseConfig=false
		end
	end
	if Temp02~=nil and Temp02~='' then
		if string.sub(Temp02,1,1)=='(' then
			local _,_,Addition,Value,Other=string.find(Temp02,"%((.*):(.*)%)(.*)")
			if Addition=='LOCK' then
				ATTR[#ATTR].Key=Value
			elseif Addition=='FUNCTION' then
				ATTR[#ATTR].Function=Value
			elseif Addition=='UNIT' then
				ATTR[#ATTR].Unit=Value
			elseif Addition=='LOG' then
				LogPos=Value
			end
			StringLeft=Other
		else
			StringLeft=Temp02
		end
	end
	return IfSub,IfNext,IfUseConfig,LogPos,StringLeft
end

-- �ڶ�������
function Interpret02(String)
	if ATTR[#ATTR].Variable~=nil then
		local _,_,Value=string.find(String,"%[(.*)%]<(.*)>")
		ATTR[#ATTR].Value={Value}
	else
		ATTR[#ATTR].Variable={}
		ATTR[#ATTR].Value={}
		for Str in string.gmatch(String, '[^%|]+') do
			local _,_,Value,Variable=string.find(Str,"%[(.*)%]<(.*)>")
			table.insert(ATTR[#ATTR].Variable,Variable)
			table.insert(ATTR[#ATTR].Value,Value)
		end
	end
end

---------------------------------------------------
-- ������
---------------------------------------------------

function SearchTree(KeyWords)
	local Str=string.gsub(KeyWords,' ','%(%.%*%)')
	for i=1,#TREE do
		for j=1,#TREE[i] do
			for k=1,#TREE[i][j] do
				local Pos=string.find(ATTR[TREE[i][j][k].Attr].Option,Str)
				if Pos~=nil then
					LOGPOS._searchres=j
					SKIN:Bang('!HideMeterGroup','Main',TARGETCONFIG)
					SKIN:Bang('!ShowMeter','TitleBar',TARGETCONFIG)
					SKIN:Bang('!ShowMeter','TitleText',TARGETCONFIG)
					LoadSettingPage(i,'_searchres')
					return
				end
			end
		end
	end
end

---------------------------------------------------
-- չʾ��
---------------------------------------------------

-- ���������������֮ǰ��Ԥ����
function MakeCurrentList()
	LIST={}
	local Lock_Enable=nil
	for i=1,#TREE[LOADITEM][TRAIL] do
		-- ������Բ�
		if ATTR[TREE[LOADITEM][TRAIL][i].Attr].IfLocked then
			if Lock_Enable==nil then
				Lock_Enable=true	-- ������ѭ��
			else
				if not Lock_Enable then
					table.insert(LIST,TREE[LOADITEM][TRAIL][i])
					GetListItem()
				end
			end
		else
			table.insert(LIST,TREE[LOADITEM][TRAIL][i])
			Lock_Enable=GetListItem()
		end
	end
	-- ҳ����1
	PAGE=1
	-- ���Ʊ�ͷ
	DrawListTitle()
end

-- ��ÿ����Ŀ�����
function GetListItem()
	local LockFlag=nil
	local AttrNum=LIST[#LIST].Attr
	local SubNum=LIST[#LIST].Sub
	LIST[#LIST].T=ATTR[AttrNum].Option
	-- FUNCTION
	if ATTR[AttrNum].Function~=nil and CMD_FUNC[ATTR[AttrNum].Function].GetValue~=nil then
		CMD_FUNC[ATTR[AttrNum].Function].GetValue(#LIST)
		return
	end
	-- ���ݲ�ͬ���ʹ�������
	local Type=ATTR[AttrNum].Type
	if Type=='VALUE' or Type=='TIP' then
	elseif Type=='SUB' then
		LIST[#LIST].F=true
	elseif Type=='COLOR' then
		LIST[#LIST].C=string.gsub(_STYLECOLOR,'*','#'..ATTR[AttrNum].Variable..'#')
	elseif Type=='NUMBER' then
		if ATTR[AttrNum].Unit~=nil then
			LIST[#LIST].V='#'..ATTR[AttrNum].Variable..'# '..ATTR[AttrNum].Unit
		else
			LIST[#LIST].V='#'..ATTR[AttrNum].Variable..'#'
		end
	elseif Type=='BOOLEAN' then
		if tonumber(SKIN:GetVariable(ATTR[AttrNum].Variable))==0 then
			LIST[#LIST].S=false
		else
			LIST[#LIST].S=true
		end
		if ATTR[AttrNum].Key~=nil then
			if tostring(LIST[#LIST].S)==ATTR[AttrNum].Key then LockFlag=false
			else LockFlag=true
			end
		end
	elseif Type=='SELECT' then
		LIST[#LIST].F=true
		for i=1,#TREE[LOADITEM][SubNum] do
			local AttrIdx=TREE[LOADITEM][SubNum][i].Attr
			local IfFit=true
			for j=1,#ATTR[AttrIdx].Variable do
				if string.sub(ATTR[AttrIdx].Value[j],1,1)~='*' then
					if tostring(SKIN:GetVariable(ATTR[AttrIdx].Variable[j]))~=ATTR[AttrIdx].Value[j] then
						IfFit=false
						break
					end
				end
			end
			if IfFit then
				LIST[#LIST].V=ATTR[AttrIdx].Option
				if ATTR[AttrNum].Key~=nil then
					if ATTR[AttrIdx].Option==ATTR[AttrNum].Key then LockFlag=false
					else LockFlag=true
					end
				end
				break
			end
		end
	elseif Type=='HELP' then
		LIST[#LIST].F=true
	elseif Type=='THEME' or Type=='OTHER' then
		LIST[#LIST].F=true
	elseif Type=='SEARCH' then
		LIST[#LIST].F=true
		local Temp=SKIN:GetVariable(ATTR[AttrNum].Other)
		if Temp~=nil and Temp~='' then
			local Pos=string.find(Temp, "%_")
			LIST[#LIST].V=string.sub(Temp,1,Pos-1) or ''
		else
			LIST[#LIST].V=''
		end
	elseif Type=='LAUNCHER' then
		LIST[#LIST].F=true
		if ATTR[AttrNum].Other=='Group1' or ATTR[AttrNum].Other=='Group2'
			or ATTR[AttrNum].Other=='Group3' or ATTR[AttrNum].Other=='Group4' then
			local GroupName=SKIN:GetVariable(ATTR[AttrNum].Other)
			if GroupName~=nil and GroupName~='' then
				LIST[#LIST].V=GroupName
			else
				LIST[#LIST].V=''
			end
		end
	else
		LIST[#LIST].V='#'..ATTR[AttrNum].Variable..'#'
	end
	return LockFlag
end

-- ���Ʊ�ͷ
function DrawListTitle()
	if TREE[LOADITEM][TRAIL].Parent==nil then
		SKIN:Bang('!SetOption','TitleText','Text',_TR_CurrentPage.._TR_MainTitle[LOADITEM],TARGETCONFIG)
	else
		SKIN:Bang('!SetOption','TitleText','Text',_TR_CurrentPage..ATTR[TREE[LOADITEM][TRAIL].Parent.Attr].Option,TARGETCONFIG)
	end
	SKIN:Bang('!UpdateMeter','TitleText',TARGETCONFIG)
end

-- ��ձ�Meter
function ClearList()
	for i=1,8 do
		SKIN:Bang('!HideMeterGroup','List0'..i,TARGETCONFIG)
		SKIN:Bang('!HideMeter','Tab0'..i,TARGETCONFIG)
	end
end

-- ����Meter�б�
function DrawList()
	ClearList()
	for i=1,8 do
		local Idx=PAGE+i-1
		if LIST[Idx]==nil then break
		else
			SKIN:Bang('!ShowMeter','List0'..i,TARGETCONFIG)
			SKIN:Bang('!ShowMeter','Tab0'..i,TARGETCONFIG)
			if LIST[Idx].T~=nil then
				SKIN:Bang('!SetOption','List0'..i..'T','Text',LIST[Idx].T,TARGETCONFIG)
				SKIN:Bang('!ShowMeter','List0'..i..'T',TARGETCONFIG)
			end
			if LIST[Idx].C~=nil then
				SKIN:Bang('!SetOption','List0'..i..'C','Color',LIST[Idx].C,TARGETCONFIG)
				SKIN:Bang('!ShowMeter','List0'..i..'C',TARGETCONFIG)
			end
			if LIST[Idx].V~=nil then
				SKIN:Bang('!SetOption','List0'..i..'V','Text',LIST[Idx].V,TARGETCONFIG)
				SKIN:Bang('!ShowMeter','List0'..i..'V',TARGETCONFIG)
			end
			if LIST[Idx].F~=nil then
				SKIN:Bang('!ShowMeter','List0'..i..'F',TARGETCONFIG)
			end
			if LIST[Idx].S~=nil then
				if LIST[Idx].S then
					SKIN:Bang('!SetOption','List0'..i..'S','Text','[\\xf205]',TARGETCONFIG)
					SKIN:Bang('!SetOption','List0'..i..'S','FontColor','#ColorSetting#',TARGETCONFIG)
				else
					SKIN:Bang('!SetOption','List0'..i..'S','Text','[\\xf204]',TARGETCONFIG)
					SKIN:Bang('!SetOption','List0'..i..'S','FontColor','#ColorMain3#',TARGETCONFIG)
				end
				SKIN:Bang('!ShowMeter','List0'..i..'S',TARGETCONFIG)
			end
		end
		SKIN:Bang('!UpdateMeterGroup','List0'..i,TARGETCONFIG)
	end
	SKIN:Bang('!Redraw',TARGETCONFIG)
end

-- ���ƹ�����
function DrawScroll()
	if #LIST<=8 then
		SKIN:Bang('!HideMeterGroup','ListScroll',TARGETCONFIG)
		SKIN:Bang('!Redraw',TARGETCONFIG)
	else
		SKIN:Bang('!ShowMeterGroup','ListScroll',TARGETCONFIG)
		local ScrollH=8/#LIST*_RANGESCROLL
		local ScrollY=math.min((PAGE-1)/#LIST*_RANGESCROLL,_RANGESCROLL-ScrollH)
		SKIN:Bang('!CommandMeasure','MeasureScript','SetScroll('..ScrollH..','..ScrollY..')',TARGETCONFIG)
	end
end

-- ��������ק���̼���
function CalcScroll(Y)
	local Page=math.ceil(Y/_RANGESCROLL*#LIST+0.5)
	if Page~=PAGE then
		PAGE=Page
		DrawList()
	end
end

-- ��һҳ
function PagePre()
	if #LIST<=8 then return
	else
		if PAGE==1 then return
		else
			PAGE=PAGE-1
			DrawList()
			DrawScroll()
		end
	end
end

-- ��һҳ
function PageNext()
	if PAGE+7>=#LIST then return
	else
		PAGE=PAGE+1
		DrawList()
		DrawScroll()
	end
end

---------------------------------------------------
-- ��궯��
---------------------------------------------------

-- �����Ŀʱ�Ķ���
function MouseClick(N)
	local Idx=N+PAGE-1
	-- FUNCTION
	if ATTR[LIST[Idx].Attr].Function~=nil and CMD_FUNC[ATTR[LIST[Idx].Attr].Function].SetValue~=nil then
		CMD_FUNC[ATTR[LIST[Idx].Attr].Function].SetValue(Idx)
		return
	end
	-- SUB��SELECT����
	local Type=ATTR[LIST[Idx].Attr].Type
	if Type=='SUB' or Type=='SELECT' then
		TRAIL=LIST[Idx].Sub
		MakeCurrentList()
		DrawList()
		DrawScroll()
	-- VALUE����
	elseif Type=='VALUE' then
		for i=1,#ATTR[LIST[Idx].Attr].Variable do
			local TempValue
			if string.sub(ATTR[LIST[Idx].Attr].Value[i],1,1)=='*' then
				TempValue=string.sub(ATTR[LIST[Idx].Attr].Value[i],2,-1) or ''
			else
				TempValue=ATTR[LIST[Idx].Attr].Value[i]
			end
			ChangeVariable(ATTR[LIST[Idx].Attr].Variable[i],TempValue,ATTR[LIST[Idx].Attr].ConfigFile)
		end
		MouseBack()
	-- HELP����
	elseif Type=='HELP' then
		CMD_HELP[ATTR[LIST[Idx].Attr].Help]()
	-- BOOLEAN����
	elseif Type=='BOOLEAN' then
		LIST[Idx].S= not LIST[Idx].S
		if LIST[Idx].S then
			ChangeVariable(ATTR[LIST[Idx].Attr].Variable,1,ATTR[LIST[Idx].Attr].ConfigFile)
		else
			ChangeVariable(ATTR[LIST[Idx].Attr].Variable,0,ATTR[LIST[Idx].Attr].ConfigFile)
		end
		if ATTR[LIST[Idx].Attr].Key~=nil then
			MakeCurrentList()
			DrawList()
			DrawScroll()
		else
			DrawList()
		end
	elseif Type=='TIP' then
	else
		-- �����������
		OpenSettingPanel(Idx)
	end
end

-- ��SettingPanel�Ա������
-- Type=STRING\NUMBER\COLOR\IMAGE\FILE\FOLDER\THEME\SEARCH\LAUNCHER\OTHER
function OpenSettingPanel(ListIndex)
	CURRENTITEM=ListIndex
	local Type=ATTR[LIST[ListIndex].Attr].Type
	if Type=='STRING' or Type=='NUMBER' then
		OpenPanel_Input(ListIndex)
	elseif Type=='THEME' then
		OpenPanel_Theme(ListIndex)
	elseif Type=='COLOR' then
		OpenPanel_Color(ListIndex)
	elseif Type=='IMAGE' then
		OpenPanel_Image(ListIndex)
	elseif Type=='FILE' or Type=='FOLDER' then
		OpenPanel_Program(ListIndex,Type)
	elseif Type=='SEARCH' then
		OpenPanel_Search(ListIndex)
	elseif Type=='LAUNCHER' then
		OpenPanel_Launcher(ListIndex)
	elseif Type=='OTHER' then
		OpenPanel_Other(ListIndex)
	end
end

-- ������һҳ
function MouseBack()
	if LOADITEM>5 then BackToMainPage() return end
	if TREE[LOADITEM][TRAIL].Parent~=nil then
		TRAIL=TREE[LOADITEM][TRAIL].Parent.Tree
		MakeCurrentList()
		DrawList()
		DrawScroll()
	else
		BackToMainPage()
	end
end

---------------------------------------------------
-- ��SettingPanel����ͨ��
---------------------------------------------------

-- �򿪶�Ӧ���

function OpenPanel_Input(ListIndex)
	local IfNumber=0
	local Option=LIST[ListIndex].T
	local Variable=ATTR[LIST[ListIndex].Attr].Variable
	if ATTR[LIST[ListIndex].Attr].Type=='NUMBER' then IfNumber=1 end
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Setting\\SettingPanel','Input '.._COMPOSIZE..'.ini')
	if ATTR[LIST[ListIndex].Attr].Unit~=nil then
		SKIN:Bang('!CommandMeasure','MeasureScript',
			"GetExtra(' "..ATTR[LIST[ListIndex].Attr].Unit.."',0)",'#RootConfig#\\Setting\\SettingPanel')
	end
	SKIN:Bang('!CommandMeasure','MeasureScript',
		"GetData("..IfNumber..",'"..Option.."','"..Variable.."')",'#RootConfig#\\Setting\\SettingPanel')
	SKIN:Bang('!Hide',TARGETCONFIG)
end

function OpenPanel_Theme(ListIndex)
	local Theme=ATTR[LIST[ListIndex].Attr].Other
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Setting\\SettingPanel','Theme '.._COMPOSIZE..'.ini')
	SKIN:Bang('!CommandMeasure','MeasureScript',
		"GetData('"..Theme.."')",'#RootConfig#\\Setting\\SettingPanel')
	SKIN:Bang('!Hide',TARGETCONFIG)
end

function OpenPanel_Color(ListIndex)
	local Option=LIST[ListIndex].T
	local Variable=ATTR[LIST[ListIndex].Attr].Variable
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Setting\\SettingPanel','Color '.._COMPOSIZE..'.ini')
	SKIN:Bang('!CommandMeasure','MeasureScript',
		"GetData('"..Option.."','"..Variable.."')",'#RootConfig#\\Setting\\SettingPanel')
	SKIN:Bang('!Hide',TARGETCONFIG)
end

function OpenPanel_Image(ListIndex)
	local Option=LIST[ListIndex].T
	local Variable=ATTR[LIST[ListIndex].Attr].Variable
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Setting\\SettingPanel','Image '.._COMPOSIZE..'.ini')
	SKIN:Bang('!CommandMeasure','MeasureScript',
		"GetData('"..Option.."','"..Variable.."')",'#RootConfig#\\Setting\\SettingPanel')
	SKIN:Bang('!Hide',TARGETCONFIG)
end

function OpenPanel_Program(ListIndex,Type)
	local Option=LIST[ListIndex].T
	local Variable=ATTR[LIST[ListIndex].Attr].Variable
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Setting\\SettingPanel','Program '.._COMPOSIZE..'.ini')
	SKIN:Bang('!CommandMeasure','MeasureScript',
		"GetData('"..Option.."','"..Variable.."','"..Type.."')",'#RootConfig#\\Setting\\SettingPanel')
	SKIN:Bang('!Hide',TARGETCONFIG)
end

function OpenPanel_Search(ListIndex)
	local SearchIdx=ATTR[LIST[ListIndex].Attr].Other
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Setting\\SettingPanel','Search '.._COMPOSIZE..'.ini')
	SKIN:Bang('!CommandMeasure','MeasureScript',
		"GetData('"..SearchIdx.."')",'#RootConfig#\\Setting\\SettingPanel')
	SKIN:Bang('!Hide',TARGETCONFIG)
end

function OpenPanel_Launcher(ListIndex)
	local Group=ATTR[LIST[ListIndex].Attr].Other
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Setting\\SettingPanel','Launcher '.._COMPOSIZE..'.ini')
	SKIN:Bang('!CommandMeasure','MeasureScript',
		"GetData('"..Group.."')",'#RootConfig#\\Setting\\SettingPanel')
	SKIN:Bang('!Hide',TARGETCONFIG)
end

function OpenPanel_Other(ListIndex)
	local Type=ATTR[LIST[ListIndex].Attr].Other
	if Type=='Alarm' then
		SKIN:Bang('!ActivateConfig','#RootConfig#\\Setting\\Auxiliary','Alarm '.._COMPOSIZE..'.ini')
	elseif Type=='Schedule' then
		SKIN:Bang('!ActivateConfig','#RootConfig#\\Setting\\Auxiliary','Schedule '.._COMPOSIZE..'.ini')
	end
end

-- �Ӷ�Ӧ��巵��

function PanelBack_Input(IfChange)
	SKIN:Bang('!Show',TARGETCONFIG)
	if IfChange then
		ChangeVariable(ATTR[LIST[CURRENTITEM].Attr].Variable,nil,ATTR[LIST[CURRENTITEM].Attr].ConfigFile)
	end
	if ATTR[LIST[CURRENTITEM].Attr].Function~=nil and CMD_FUNC[ATTR[LIST[CURRENTITEM].Attr].Function].GetValue~=nil then
		CMD_FUNC[ATTR[LIST[CURRENTITEM].Attr].Function].GetValue(CURRENTITEM)
	end
	DrawList()
	CURRENTITEM=nil
end

function PanelBack_Theme(IfChange)
	SKIN:Bang('!Show',TARGETCONFIG)
	if IfChange then
		local Compo=ATTR[LIST[CURRENTITEM].Attr].Other
		for i=1,#ATTR_COLOR[Compo].Color do
			ChangeVariable(ATTR_COLOR[Compo].Color[i],nil,'#@#Config\\Style.inc')
		end
	end
	CURRENTITEM=nil
end

function PanelBack_Color(IfChange)
	SKIN:Bang('!Show',TARGETCONFIG)
	if IfChange then
		ChangeVariable(ATTR[LIST[CURRENTITEM].Attr].Variable,nil,ATTR[LIST[CURRENTITEM].Attr].ConfigFile)
	end
	DrawList()
	CURRENTITEM=nil
end

function PanelBack_Image(IfChange)
	SKIN:Bang('!Show',TARGETCONFIG)
	if IfChange then
		ChangeVariable(ATTR[LIST[CURRENTITEM].Attr].Variable,nil,ATTR[LIST[CURRENTITEM].Attr].ConfigFile)
	end
	DrawList()
	CURRENTITEM=nil
end

function PanelBack_Program(IfChange)
	SKIN:Bang('!Show',TARGETCONFIG)
	if IfChange then
		ChangeVariable(ATTR[LIST[CURRENTITEM].Attr].Variable,nil,ATTR[LIST[CURRENTITEM].Attr].ConfigFile)
	end
	DrawList()
	CURRENTITEM=nil
end

function PanelBack_Search(IfChange,SearchIdx,OverIdx)
	SKIN:Bang('!Show',TARGETCONFIG)
	if IfChange then
		if OverIdx~=nil then
			for i=SearchIdx,OverIdx do
				ChangeVariable('Search'..i,nil,"#@#Config\\Launcher\\Search.inc")
			end
		else
			ChangeVariable('Search'..SearchIdx,nil,"#@#Config\\Launcher\\Search.inc")
		end
	end
	MakeCurrentList()
	DrawList()
	DrawScroll()
	CURRENTITEM=nil
end

function PanelBack_Launcher()
	SKIN:Bang('!Show',TARGETCONFIG)
	MakeCurrentList()
	DrawList()
	DrawScroll()
	CURRENTITEM=nil
end

---------------------------------------------------
-- ������ϢҪ��ĺ���
---------------------------------------------------

CMD_HELP={}
CMD_FUNC={recycle={},visualwidth={},visualgap={},hwinfo={},themecolor={}}

-- HELP

CMD_HELP.WritePlayerFile = function ()
	SKIN:Bang('["#@#Tutorial\\HowToCustomPlayerInterface.txt"]')
end

CMD_HELP.ConfigHWiNFO = function ()
	SKIN:Bang('["#@#Tutorial\\HowToConfigHWiNFO.png"]')
end

CMD_HELP.OpenHWiNFOConfig = function ()
	SKIN:Bang('["#@#Addons\\HWiNFOSharedMemoryViewer.exe"]')
end

-- FUNCTION

CMD_FUNC.recycle.GetValue = function (ListIndex)
	local Value=tonumber(SKIN:GetVariable('RecycleMaxSize'))
	LIST[ListIndex].V=tostring(math.floor(Value/1048576+0.5))..' MB'
end

CMD_FUNC.recycle.SetValue = function (ListIndex)
	CURRENTITEM=ListIndex
	local Option=LIST[ListIndex].T
	local Variable=ATTR[LIST[ListIndex].Attr].Variable
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Setting\\SettingPanel','Input '.._COMPOSIZE..'.ini')
	SKIN:Bang('!CommandMeasure','MeasureScript',
		"GetExtra(' MB',1048576)",'#RootConfig#\\Setting\\SettingPanel')
	SKIN:Bang('!CommandMeasure','MeasureScript',
		"GetData(1,'"..Option.."','"..Variable.."')",'#RootConfig#\\Setting\\SettingPanel')
	SKIN:Bang('!Hide',TARGETCONFIG)
end

CMD_FUNC.visualwidth.SetValue = function (ListIndex)
	FLAG.Visual=true
	OpenSettingPanel(ListIndex)
end

CMD_FUNC.visualgap.SetValue = function (ListIndex)
	FLAG.Visual=true
	OpenSettingPanel(ListIndex)
end

CMD_FUNC.hwinfo.SetValue = function (ListIndex)
	CMD_HELP.OpenHWiNFOConfig()
	TRAIL=LIST[ListIndex].Sub
	MakeCurrentList()
	DrawList()
	DrawScroll()
end

CMD_FUNC.themecolor.SetValue = function (ListIndex)
	if ListIndex==1 then
	-- ��ɫģʽ
		if tostring(SKIN:GetVariable('ColorMain1'))=='255,255,255'
			and tostring(SKIN:GetVariable('ColorMain2'))=='0,0,0' then
			MouseBack()
			return
		else
			ChangeAllColor(true)
		end
	elseif ListIndex==2 then
	-- ��ɫģʽ
		if tostring(SKIN:GetVariable('ColorMain1'))=='0,0,0'
			and tostring(SKIN:GetVariable('ColorMain2'))=='255,255,255' then
			MouseBack()
			return
		else
			ChangeAllColor(false)
		end
	end
	SKIN:Bang('!DeactivateConfig','#RootConfig#\\Setting\\SettingPanel')
	SKIN:Bang('!EnableMeasure','mRefreshColor')
	SKIN:Bang('!UpdateMeasure','mRefreshColor')
end

