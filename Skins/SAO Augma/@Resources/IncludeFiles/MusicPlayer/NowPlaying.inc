[Variables]
PlayerOpen=[!CommandMeasure mPlayer OpenPlayer]
PlayerPlayPause=[!CommandMeasure mPlayer PlayPause]
PlayerPre=[!CommandMeasure mPlayer Previous]
PlayerNext=[!CommandMeasure mPlayer Next]
PlayerStop=[!CommandMeasure mPlayer Stop]
PlayerClose=[!CommandMeasure mPlayer ClosePlayer]
PlayerVol-=[!CommandMeasure mPlayer "SetVolume -5"]
PlayerVol+=[!CommandMeasure mPlayer "SetVolume +5"]
PlayerRepeat=[!CommandMeasure mPlayer "SetRepeat -1"]

[mPlayer]
Measure=NowPlaying
PlayerName=#PlayerName#
PlayerPath=#PlayerPath#
PlayerType=Status

[mPlayerState]
Measure=NowPlaying
PlayerName=[mPlayer]
PlayerType=State

[mPlayerProgress]
Measure=NowPlaying
PlayerName=[mPlayer]
PlayerType=Progress

[mPlayerDuration]
Measure=NowPlaying
PlayerName=[mPlayer]
PlayerType=Duration

[mPlayerPosition]
Measure=NowPlaying
PlayerName=[mPlayer]
PlayerType=Position

[mPlayerVolume]
Measure=NowPlaying
PlayerName=[mPlayer]
PlayerType=Volume

[mPlayerArtist]
Measure=NowPlaying
PlayerName=[mPlayer]
PlayerType=Artist

[mPlayerAlbum]
Measure=NowPlaying
PlayerName=[mPlayer]
PlayerType=Album

[mPlayerTitle]
Measure=NowPlaying
PlayerName=[mPlayer]
PlayerType=Title

[mPlayerRepeat]
Measure=NowPlaying
PlayerName=[mPlayer]
PlayerType=Repeat

