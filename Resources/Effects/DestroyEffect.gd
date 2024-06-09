extends GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready():
	finished.connect(destroy.bind())

func destroy():
	queue_free()
