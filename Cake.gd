extends StaticBody3D

@onready var c1 = $Candle
@onready var c2 = $Candle2
@onready var c3 = $Candle3
@onready var c4 = $Candle4

func light():
	c1.light()
	c2.light()
	c3.light()
	c4.light()

func destroy():
	pass
