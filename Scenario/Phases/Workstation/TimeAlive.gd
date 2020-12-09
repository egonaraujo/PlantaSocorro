extends Particles2D

var time_alive = 0

func _ready():
	set_process(true)
	
func _process(delta):
	time_alive += delta
