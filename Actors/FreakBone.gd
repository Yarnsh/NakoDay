extends PhysicalBone3D

@onready var body = $"../../../.."

func destroy():
	body.destroy()
