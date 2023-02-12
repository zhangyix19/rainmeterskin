--[[
Name = LeftInfo.lua
Author = ѩ�»�
Version = 1.0
License = CC BY - NC - SA 4.0
Information = �ű����ڿ���MusicPlayer\Left InfoƤ��Artist���ֳ���
]]

function Initialize()
	MIN_BG=tonumber(SELF:GetOption('MinBG'))
	MAX_BG=tonumber(SELF:GetOption('MaxBG'))
	MAX_STR=tonumber(SELF:GetOption('MaxString'))
	artistbg=SKIN:GetMeter('ArtistBG')
	SetArtistLength()
end

function SetArtistLength()
	SKIN:Bang('!SetOption','Artist','W','')
	SKIN:Bang('!SetOption','Artist','ClipString',0)
	SKIN:Bang('!UpdateMeter Artist')
	SKIN:Bang('!UpdateMeter ArtistBG')
	local Length=tonumber(artistbg:GetW())
	if Length>MAX_BG then
		SKIN:Bang('!SetOption','Artist','W',MAX_STR)
		SKIN:Bang('!SetOption','Artist','ClipString',2)
		SKIN:Bang('!UpdateMeter Artist')
		SKIN:Bang('!UpdateMeter ArtistBG')
	end
end

