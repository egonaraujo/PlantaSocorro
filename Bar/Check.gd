extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (float) var scaleMax = 1.5
export (float) var increment = 2.0

var increase = true



# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass # Replace with function body.

func _process(delta):
	if increase:
		$Done.scale = $Done.scale + (Vector2(1,1)*delta*increment)
	else:
		$Done.scale = $Done.scale - (Vector2(1,1)*delta*increment)
	
	if $Done.scale.x > scaleMax:
		increase = false
	
	if !increase && $Done.scale.x < 1.0:
		$Done.scale = Vector2(1.0, 1.0)
		set_process(false)
	pass

func done():
	set_process(true)
	$Done.show()
	$Undone.hide()

func undone():
	$Done.hide()
	$Undone.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
