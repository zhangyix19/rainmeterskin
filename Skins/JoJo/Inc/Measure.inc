
[Player]
Measure=Plugin
Plugin=NowPlaying
PlayerName=#PlayerName#
PlayerType=Cover

[Artist]
Measure=Plugin
Plugin=NowPlaying
PlayerName=[Player]
PlayerType=Artist
Substitute="":"JoJo"

[Title]
Measure=Plugin
Plugin=NowPlaying
PlayerName=[Player]
PlayerType=Title
Substitute="":"Music Player"

[Progress]
Measure=Plugin
Plugin=NowPlaying
PlayerName=[Player]
PlayerType=Progress

[Position]
Measure=Plugin
Plugin=NowPlaying
PlayerName=[Player]
PlayerType=Position

[Duration]
Measure=Plugin
Plugin=NowPlaying
PlayerName=[Player]
PlayerType=Duration

[State]
Measure=Plugin
Plugin=NowPlaying
PlayerName=[Player]
PlayerType=State
Substitute="0":"Play","1":"Pause","2":"Play"
