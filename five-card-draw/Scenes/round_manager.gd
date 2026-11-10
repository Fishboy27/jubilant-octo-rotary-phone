extends Node2D

@onready var Globle = get_node("/root/Global")

var roundoneactivated : bool = false
var roundtwoactivated : bool = false
var roundthreeactivated : bool = false
var roundfouractivated : bool = false
var roundfiveactivated : bool = false
var roundsixactivated : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.play:
		_Initialise()
		Global.play = false

	if Global.round == 1 and not roundoneactivated:
		# Put in initial bet/Raise
		roundoneactivated = true
		Global.hasbet = false
		Global.canraise = true
		Global.match = true
		Global.dealercall = true
		print("Round 1")

	if Global.round == 2 and not roundtwoactivated:
		# Deal
		roundtwoactivated = true
		Global.candeal = true
		print("Round 2")

	if Global.round == 3 and not roundthreeactivated:
		# Put in initial bet/Raise
		roundthreeactivated = true
		Global.hasbet = false
		Global.canraise = true
		Global.match = true
		Global.dealercall = true
		print("Round 3")

	if Global.round == 4 and not roundfouractivated:
		# Switch
		roundfouractivated = true
		Global.canswitch = true
		print("Round 4")

	if Global.round == 5 and not roundfiveactivated:
		# Put in initial bet/Raise
		roundfiveactivated = true
		Global.hasbet = false
		Global.canraise = true
		Global.match = true
		Global.dealercall = true
		print("Round 5")

	if Global.round == 6 and not roundsixactivated:
		roundsixactivated = true
		await get_tree().create_timer(1).timeout
		# Reveal
		Global.reveal = true
		print("Round 6")
		await get_tree().create_timer(4).timeout
		_Initialise()
		Global.reset = true
		Global.round = 1

func _Initialise():
	roundoneactivated = false
	roundtwoactivated = false
	roundthreeactivated = false
	roundfouractivated = false
	roundfiveactivated = false
	roundsixactivated = false
