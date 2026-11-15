extends Node2D

@onready var Globle = get_node("/root/Global")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.reset:
		Global.switchingcarddealer = [0, 1, 2, 3, 4]
	
	if Global.dealerswitch:
		Global.dealerswitch = false
		_Analysehand()


func _Analysehand():
	for i in range(5):
		var chance = randi_range(1, 10)
		if chance < 7:
			Global.switchingcarddealer[i] = -1
