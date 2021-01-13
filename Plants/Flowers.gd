extends Sprite

export (Vector2)var startPos

var endPos
var endScale

func _ready():
	endPos = $".".position
	endScale = $".".scale
	resetAnim()

func setAnimPercent(var percent):
	if(percent < 1):
		#this line ensures that the final stage will be different from
		#the last one
		percent*=0.7
	$".".position = startPos + (percent*(endPos - startPos))
	$".".scale = percent * endScale

func resetAnim():
	setAnimPercent(0)
