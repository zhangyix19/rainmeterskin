--[[
Name = Guide.lua
Author = 雪月花
Vertion = 1.0
License = CC BY - NC - SA 4.0
Information = 脚本用于控制Guide皮肤
]]

explorericon={'f269','f268','f282'}
explorercolor={'255,70,70','20,210,140','0,120,215'}
explorerpath={'Firefox.exe','Chrome.exe','shell:Appsfolder\\Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge'}
explorertype={'Firefox','Chrome','Microsoft Edge'}

playershow={AIMP='AIMP',CAD='foobar2000',iTunes='iTunes',Winamp='Winamp',MediaMonkey='MediaMonkey',WMP='WindowsMediaPlayer'}
playertype={AIMP='NowPlaying',CAD='NowPlaying',iTunes='NowPlaying',Winamp='NowPlaying',MediaMonkey='NowPlaying',WMP='NowPlaying',
			QQMusic='MusicPlayer',CloudMusic='MusicPlayer',KGMusic='MusicPlayer',KwMusic='MusicPlayer',XMusic='MusicPlayer',BaiduMusic='MusicPlayer'}
playerlabel={AIMP='AIMP',CAD='FOOBAR2000',iTunes='ITUNES',Winamp='WINAMP',MediaMonkey='MediaMonkey',WMP='WMP',
			QQMusic='QQMusic',CloudMusic='CloudMusic',KGMusic='KGMusic',KwMusic='KwMusic',XMusic='XMusic',BaiduMusic='BaiduMusic'}

function Initialize()
	-- UI Text Translate
	explorertype[4]=SKIN:GetVariable('TR_ExplorerOther')
	playershow.QQMusic=SKIN:GetVariable('TR_PlayerQQMusic')
	playershow.CloudMusic=SKIN:GetVariable('TR_PlayerCloudMusic')
	playershow.KGMusic=SKIN:GetVariable('TR_PlayerKGMusic')
	playershow.KwMusic=SKIN:GetVariable('TR_PlayerKwMusic')
	playershow.XMusic=SKIN:GetVariable('TR_PlayerXMusic')
	playershow.BaiduMusic=SKIN:GetVariable('TR_PlayerBaiduMusic')
	
	mInput=SKIN:GetMeasure('MeasureInput')
	ShowExplorer(CheckExplorer())
	ShowPlayer(CheckPlayer())
end

-- 检查浏览器
function CheckExplorer()
	local Icon=SKIN:GetVariable('ExplorerIcon')
	local Color=SKIN:GetVariable('ExplorerColor')
	local Path=SKIN:GetVariable('ExplorerPath')
	for i=1,3 do
		if Icon==explorericon[i] and Color==explorercolor[i] and Path==explorerpath[i] then
			return i
		end
	end
	return 4
end

-- 显示浏览器类型
function ShowExplorer(N)
	SKIN:Bang('!SetOption','Value1','Text',explorertype[N])
	SKIN:Bang('!UpdateMeter','Value1')
	if N==4 then
		SKIN:Bang('!ShowMeterGroup','OtherExplorer')
	else
		SKIN:Bang('!HideMeterGroup','OtherExplorer')
	end
end

-- 设置浏览器类型
function SetExplorer(N)
	if N==1 or N==2 or N==3 then
		ChangeVariable('ExplorerIcon',explorericon[N],'#@#Config\\Setting.inc')
		ChangeVariable('ExplorerColor',explorercolor[N],'#@#Config\\Setting.inc')
		ChangeVariable('ExplorerPath',explorerpath[N],'#@#Config\\Setting.inc')
		ShowExplorer(N)
	elseif N==4 then
		ChangeVariable('ExplorerIcon','f26b','#@#Config\\Setting.inc')
		ChangeVariable('ExplorerColor','105,185,0','#@#Config\\Setting.inc')
		SKIN:Bang('!UpdateMeter','ExplorerPath')
		ShowExplorer(N)
	end
	SKIN:Bang('!Redraw')
end

-- 输入浏览器地址
function InputExplorerOver()
	local Value=mInput:GetStringValue()
	ChangeVariable('ExplorerPath',Value,'#@#Config\\Setting.inc')
	SKIN:Bang('!UpdateMeter','ExplorerPath')
	SKIN:Bang('!Redraw')
end

-- 检查播放器
function CheckPlayer()
	local Name=SKIN:GetVariable('PlayerName')
	local Type=SKIN:GetVariable('PlayerType')
	for k,v in pairs(playertype) do
		if Name==k and Type==v then
			return k
		end
	end
end

-- 显示播放器类型
function ShowPlayer(Str)
	if Str~=nil then
		SKIN:Bang('!SetOption','Value2','Text',playershow[Str])
	else
		SKIN:Bang('!SetOption','Value2','Text','')
	end
	SKIN:Bang('!UpdateMeter','Value2')
end

-- 设置播放器类型
function SetPlayer(Str)
	if playershow[Str]~=nil then
		ChangeVariable('PlayerName',Str,'#@#Config\\Setting.inc')
		ChangeVariable('PlayerType',playertype[Str],'#@#Config\\Setting.inc')
		ChangeVariable('playerlabel',playerlabel[Str],'#@#Config\\Setting.inc')
		ShowPlayer(Str)
		SKIN:Bang('!Redraw')
	end
end

-- 输入播放器地址
function InputPlayerOver()
	local Value=mInput:GetStringValue()
	ChangeVariable('PlayerPath',Value,'#@#Config\\Setting.inc')
	SKIN:Bang('!UpdateMeter','PlayerPath')
	SKIN:Bang('!Redraw')
end

-- 设置完毕
function OK()
	SKIN:Bang('!ActivateConfig','#RootConfig#\\Animation','Welcome.ini')
	SKIN:Bang('!DeactivateConfig','#CurrentConfig#')
end

--*************************************************

function ChangeVariable(Variable,Value,File)
	if Value~=nil then
		SKIN:Bang('!SetVariable',Variable,Value)
	end
	WriteVariable(Variable,Value,File)
end

function WriteVariable(Variable,Value,File)
	if Value==nil then Value=SKIN:GetVariable(Variable) end
	SKIN:Bang('!WriteKeyValue','Variables',Variable,Value,File)
end

