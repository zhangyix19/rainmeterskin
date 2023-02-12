--[[
Name = Picture.lua
Author = ѩ�»�
Version = 1.0
License = CC BY - NC - SA 4.0
Information = �ű����ڿ���PictureƤ��
]]

LOAD={}

function Initialize()
	--Ƥ����ʽ��Picture/Album
	TYPE=tostring(SELF:GetOption('SkinType'))
	--ͼƬģʽ��True����������/False������������
	MODE=(tonumber(SELF:GetOption('DynamicHeight',0))~=0)
	TITLE=tostring(SKIN:GetVariable('PictureTitle'))
	local Height=tonumber(SELF:GetOption('DefaultHeight'))
	local Pic=tonumber(SELF:GetOption('DefaultPic'))
	EXTEND=Height-Pic
	RANGE_MENU=tonumber(SELF:GetOption('MenuHeight'))
	ANI_MENU=0
	LOAD[TYPE]()
end

function Update()
	if TYPE=='Album' then
		if CT>=0 then
			CT=CT+1
			if CT==ST then
				PicNext()
			end
		end
	end
end

LOAD.Picture=function ()
	SKIN:Bang('!EnableMeasureGroup MPicture')
	SKIN:Bang('!ShowMeter Picture')
	SKIN:Bang('!SetOption','Info','LeftMouseUpAction','["#PicturePath#"]')
	--���ñ���
	if TITLE~=nil and TITLE~='' then
		SKIN:Bang('!SetOption','Title','Text',TITLE)
	else
		local ImagePath=tostring(SKIN:GetVariable('PicturePath'))
		local ImageFile=StripPath(ImagePath)
		local ImageName=StripExtension(ImageFile)
		SKIN:Bang('!SetOption','Title','Text',ImageName)
	end
	--����ͼƬģʽ
	if not MODE then
		local Pic=tonumber(SELF:GetOption('DefaultPic'))
		SKIN:Bang('!SetOption','Picture','H',Pic)
	else
		METER=SKIN:GetMeter('Picture')
		VeriBG(METER)
	end
end

LOAD.Album=function ()
	SKIN:Bang('!EnableMeasureGroup MAlbum')
	SKIN:Bang('!ShowMeter Album')
	SKIN:Bang('!SetOption','Info','LeftMouseUpAction','[!CommandMeasure mAlbum Open]')
	mCOUNT=SKIN:GetMeasure('mCount')
	ST=tonumber(SKIN:GetVariable('PictureStayTime',20))
	CT=0
	IDX=1
	IFASCEND=true
	--���ñ���
	if TITLE~=nil and TITLE~='' then
		SKIN:Bang('!SetOption','Title','Text',TITLE)
	else
		SKIN:Bang('!SetOption','Title','MeasureName','mName')
	end
	--����ͼƬģʽ
	if not MODE then
		local Pic=tonumber(SELF:GetOption('DefaultPic'))
		SKIN:Bang('!SetOption','Album','H',Pic)
	else
		METER=SKIN:GetMeter('Album')
	end
end

--mView��ȡ��Ϻ�ִ��
function SetAlbum()
	COUNT=mCOUNT:GetValue()
	if COUNT <= 0 then return end
	SKIN:Bang('!Redraw')
	--����ͼƬģʽ
	if MODE then
		VeriBG(METER)
	end
end

--���������߶�
function VeriBG(Meter)
	local Ph=Meter:GetH()
	SKIN:Bang('!SetVariable','PicHeight',Ph+EXTEND)
	SKIN:Bang('!UpdateMeter BG')
	SKIN:Bang('!Redraw')
end

---------------------------------------------------

--�л�����һ��ͼƬ
function PicNext()
	CT=0
	if COUNT<=1 then return
	else
		if IDX>=COUNT then
			IFASCEND=false
		elseif IDX<=1 then
			IFASCEND=true
		end
		if IFASCEND then
			IDX=IDX+1
			SKIN:Bang('!CommandMeasure mView IndexDown')
		else
			IDX=IDX-1
			SKIN:Bang('!CommandMeasure mView IndexUp')
		end
	end
	SKIN:Bang('!UpdateMeter Album')
	SKIN:Bang('!UpdateMeter Title')
	SKIN:Bang('!Redraw')
	--����ͼƬģʽ
	if MODE then
		VeriBG(METER)
	end
end

--�л�����һ��ͼƬ
function PicPre()
	CT=0
	if COUNT<=1 then return
	else
		if IDX>=COUNT then
			IFASCEND=true
		elseif IDX<=1 then
			IFASCEND=false
		end
		if IFASCEND then
			IDX=IDX-1
			SKIN:Bang('!CommandMeasure mView IndexUp')
		else
			IDX=IDX+1
			SKIN:Bang('!CommandMeasure mView IndexDown')
		end
	end
	SKIN:Bang('!UpdateMeter Album')
	SKIN:Bang('!UpdateMeter Title')
	SKIN:Bang('!Redraw')
	--����ͼƬģʽ
	if MODE then
		VeriBG(METER)
	end
end

--�̶�/ȡ���̶�ͼƬ
function PicHold()
	if CT<0 then
		CT=0
		SKIN:Bang('!SetOption','Menu1','Text','#TR_MenuHoldPicture#')
	else
		CT=-1
		SKIN:Bang('!SetOption','Menu1','Text','#TR_MenuHoldCancel#')
	end
	SKIN:Bang('!UpdateMeter Menu1')
end

---------------------------------------------------

--���Ʋ˵���������
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

--*************************************************

--��·����ȡ�ļ���
function StripPath(Path)
	return string.match(Path, ".+\\([^\\]*%.%w+)$")
end
 
--ȥ����չ��
function StripExtension(Str)
	local idx = Str:match(".+()%.%w+$")
	if(idx) then
		return Str:sub(1, idx-1)
	else
		return Str
	end
end

