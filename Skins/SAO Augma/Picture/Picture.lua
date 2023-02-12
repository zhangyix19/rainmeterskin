--[[
Name = Picture.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Picture皮肤
]]

LOAD={}

function Initialize()
	--皮肤样式，Picture/Album
	TYPE=tostring(SELF:GetOption('SkinType'))
	--图片模式：True——背景动/False——背景不动
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
	--设置标题
	if TITLE~=nil and TITLE~='' then
		SKIN:Bang('!SetOption','Title','Text',TITLE)
	else
		local ImagePath=tostring(SKIN:GetVariable('PicturePath'))
		local ImageFile=StripPath(ImagePath)
		local ImageName=StripExtension(ImageFile)
		SKIN:Bang('!SetOption','Title','Text',ImageName)
	end
	--处理图片模式
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
	--设置标题
	if TITLE~=nil and TITLE~='' then
		SKIN:Bang('!SetOption','Title','Text',TITLE)
	else
		SKIN:Bang('!SetOption','Title','MeasureName','mName')
	end
	--处理图片模式
	if not MODE then
		local Pic=tonumber(SELF:GetOption('DefaultPic'))
		SKIN:Bang('!SetOption','Album','H',Pic)
	else
		METER=SKIN:GetMeter('Album')
	end
end

--mView读取完毕后执行
function SetAlbum()
	COUNT=mCOUNT:GetValue()
	if COUNT <= 0 then return end
	SKIN:Bang('!Redraw')
	--处理图片模式
	if MODE then
		VeriBG(METER)
	end
end

--调整背景高度
function VeriBG(Meter)
	local Ph=Meter:GetH()
	SKIN:Bang('!SetVariable','PicHeight',Ph+EXTEND)
	SKIN:Bang('!UpdateMeter BG')
	SKIN:Bang('!Redraw')
end

---------------------------------------------------

--切换到下一张图片
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
	--处理图片模式
	if MODE then
		VeriBG(METER)
	end
end

--切换到上一张图片
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
	--处理图片模式
	if MODE then
		VeriBG(METER)
	end
end

--固定/取消固定图片
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

--*************************************************

--由路径获取文件名
function StripPath(Path)
	return string.match(Path, ".+\\([^\\]*%.%w+)$")
end
 
--去除扩展名
function StripExtension(Str)
	local idx = Str:match(".+()%.%w+$")
	if(idx) then
		return Str:sub(1, idx-1)
	else
		return Str
	end
end

