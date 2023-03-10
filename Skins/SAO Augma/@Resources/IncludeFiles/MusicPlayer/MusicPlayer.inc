[Variables]
PlayerOpen=["#PlayerPath#"]
PlayerPlayPause=[!CommandMeasure mPlayer PlayPause]
PlayerPre=[!CommandMeasure mPlayer Previous]
PlayerNext=[!CommandMeasure mPlayer Next]
PlayerStop=[!CommandMeasure mPlayer Stop]
PlayerClose=[!CommandMeasure mPlayer Stop][!CommandMeasure MeasureScript "Augma()" "#RootConfig#\Background\MusicPlayer"]
PlayerVol-=[!CommandMeasure mPlayer VolumeDown]
PlayerVol+=[!CommandMeasure mPlayer VolumeUp]
PlayerRepeat=[]

[mPlayer]
Measure=Plugin
Plugin=MusicPlayer
PlayerName=#PlayerName#
PlayerPath=#PlayerPath#
PlayerType=Status

[mPlayerState]
Measure=Calc
Formula=0

[mPlayerProgress]
Measure=Calc
Formula=1

[mPlayerDuration]
Measure=String
String=00:00

[mPlayerPosition]
Measure=String
String=00:00

[mPlayerVolume]
Measure=Calc
Formula=0

[mPlayerArtist]
Measure=Plugin
Plugin=MusicPlayer
PlayerName=#PlayerName#
PlayerPath=#PlayerPath#
PlayerType=Artist

[mPlayerAlbum]
Measure=Plugin
Plugin=MusicPlayer
PlayerName=#PlayerName#
PlayerPath=#PlayerPath#
PlayerType=Album

[mPlayerTitle]
Measure=Plugin
Plugin=MusicPlayer
PlayerName=#PlayerName#
PlayerPath=#PlayerPath#
PlayerType=Title

[mPlayerRepeat]
Measure=Calc
Formula=0

