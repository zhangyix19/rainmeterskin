--[[
Name = AugmaThemeColor.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = 各部件颜色的搭配数据
]]

ATTR_COLOR={}

ATTR_COLOR.Weather={
				Color={'ColorWeather','ColorWeather2'},
				Alpha='AlphaWeather',
				Day={
					{Grey=210,S=0.88,V=1},
					{Grey=150,H=0,S=0.88,V=0.8}
					},
				Night={
					{Grey=210,S=0.88,V=1},
					{Grey=180,H=0,S=0.88,V=0.9}
					}
				}

ATTR_COLOR.Calendar={
				Color={'ColorCalendar','ColorCalendar2','ColorCalendar3','ColorCalenSun','ColorCalenToday'},
				Alpha='AlphaCalendar',
				Day={
					{Grey=170,S=0.8,V=1},
					{Grey=210,H=0,S=0.8*0.66,V=1},
					{Grey=150,H=0,S=0.8,V=0.85},
					{Grey=120,H=140,S=0.8*0.9,V=1},
					{Grey=170,H=-180,S=0.4,V=0.8}
					},
				Night={
					{Grey=180,S=0.8,V=1},
					{Grey=120,H=0,S=0.8,V=0.85},
					{Grey=200,H=0,S=0.8*0.66,V=1},
					{Grey=150,H=140,S=0.8*0.9,V=1},
					{Grey=180,H=0-180,S=0.4,V=0.8}
					}
				}

ATTR_COLOR.Picture={
				Color={'ColorPicture'},
				Alpha='AlphaPicture',
				Day={
					{}
					},
				Night={
					{}
					}
				}

ATTR_COLOR.System={
				Color={'ColorSystem','ColorSystem2','ColorSystemTemp'},
				Alpha='AlphaSystem',
				Day={
					{Grey=120,S=1,V=0.6},
					{Grey=180,H=-30,S=0.9,V=0.9},
					{}
					},
				Night={
					{Grey=180,S=0.75,V=200/255},
					{Grey=120,H=0,S=1,V=200/255*0.8},
					{}
					}
				}

ATTR_COLOR.FolderView={
				Color={'ColorView'},
				Alpha='AlphaView',
				Day={
					{}
					},
				Night={
					{}
					}
				}

ATTR_COLOR.Schedule={
				Color={'ColorSchedule'},
				Alpha='AlphaSchedule',
				Day={
					{}
					},
				Night={
					{}
					}
				}

ATTR_COLOR.Power={
				Color={'ColorPower'},
				Alpha='AlphaPower',
				Day={
					{}
					},
				Night={
					{}
					}
				}

ATTR_COLOR.Launcher={
				Color={'ColorLauncher','ColorLauncher2','ColorSearch'},
				Alpha=nil,
				Day={
					{Grey=245,S=0.1,V=245/255},
					{Grey=0,H=30,S=0.9,V=1},
					{Gery=50,H=-135,S=1,V=0.9}
					},
				Night={
					{Grey=30,S=0.1,V=30/255},
					{Grey=255,H=30,S=0.9,V=1},
					{Gery=230,H=-135,S=1,V=0.9}
					}
				}

ATTR_COLOR.Music={
				Color={'ColorMusic'},
				Alpha=nil,
				Day={
					{}
					},
				Night={
					{}
					}
				}

