--[[
Name = RightInfo.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制MusicPlayer\Right Info皮肤SongName部分长度
]]

function Initialize()
	MIN_BG=tonumber(SELF:GetOption('MinBG'))
	MAX_BG=tonumber(SELF:GetOption('MaxBG'))
	MAX_STR=tonumber(SELF:GetOption('MaxString'))
	songbg=SKIN:GetMeter('SongBG')
	SetSongNameLength()
end

function SetSongNameLength()
	SKIN:Bang('!SetOption','Song','W','')
	SKIN:Bang('!SetOption','Song','ClipString',0)
	SKIN:Bang('!UpdateMeter Song')
	SKIN:Bang('!UpdateMeter SongBG')
	local Length=tonumber(songbg:GetW())
	if Length>MAX_BG then
		SKIN:Bang('!SetOption','Song','W',MAX_STR)
		SKIN:Bang('!SetOption','Song','ClipString',2)
		SKIN:Bang('!UpdateMeter Song')
		SKIN:Bang('!UpdateMeter SongBG')
	end
end

