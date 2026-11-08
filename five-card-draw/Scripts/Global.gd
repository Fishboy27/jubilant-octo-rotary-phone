extends Node

var playerraiseamount : int = 0
var dealerraiseamount : int = 0
var dealerchips : int = 10
var playerchips : int = 10
var playerbet : int = 0
var dealerbet : int = 0
var playercardplace : int = 0
var dealercardplace : int = 0
var switchingcardplayer : int = 0
var switchingcarddealer : int = 0
var dealercall : bool = true
var canraise : bool = false
var candeal : bool = true
var canswitch : bool = false
var playerhand : Array = [0, 0, 0, 0, 0]
var dealerhand : Array = [0, 0, 0, 0, 0]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
