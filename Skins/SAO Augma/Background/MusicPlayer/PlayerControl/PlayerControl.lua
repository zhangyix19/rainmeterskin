--[[
Name = PlayerControl.lua
Author = ѩ�»�
Version = 1.0
License = CC BY - NC - SA 4.0
Information = �ű����ڿ���Background\MusicPlayer\PlayerControlƤ��
]]

function Initialize()
	ANIVOL=0
	ANISONG=0
end

function AniVol()
	ANIVOL=(ANIVOL+1)%30
	local Alpha
	if ANIVOL<8 then
		Alpha=ANIVOL*32
	elseif (ANIVOL>=8) and (ANIVOL<=22) then
		Alpha=255
	else
		Alpha=(30-ANIVOL)*32
	end
	SKIN:Bang('!SetOption','Volume','FontColor','#ColorMain1#,'..Alpha)
	SKIN:Bang('!UpdateMeter','Volume')
	SKIN:Bang('!Redraw')
end

function AniSong()
	ANISONG=(ANISONG+1)%90
	local Alpha
	if ANISONG<8 then
		Alpha=ANISONG*32
	elseif (ANISONG>=8) and (ANISONG<=82) then
		Alpha=255
	else
		Alpha=(90-ANISONG)*32
	end
	SKIN:Bang('!SetOption','Song','FontColor','#ColorMain1#,'..Alpha)
	SKIN:Bang('!UpdateMeter','Song')
	SKIN:Bang('!Redraw')
end

