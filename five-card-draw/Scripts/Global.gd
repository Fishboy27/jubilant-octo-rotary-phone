extends Node

var playerraiseamount : int = 1
var dealerraiseamount : int = 0
var dealerchips : int = 10
var playerchips : int = 10
var playerbet : int = 0
var dealerbet : int = 0
var playercardplace : int = 0
var dealercardplace : int = 0
var round : int = 1
var hasbet : bool = false
var match : bool = false
var dealercall : bool = true
var canraise : bool = false
var candeal : bool = false
var canselect : bool = false
var selecting : bool = false
var goinvis : bool = false
var canswitch : bool = false
var reveal : bool = false
var analyseplayer : bool = false
var analysedealer : bool = false
var play : bool = true
var win : bool = false
var tie : bool = false
var lose : bool = false
var reset = false
var playerhand : Array = [0, 0, 0, 0, 0]
var dealerhand : Array = [0, 0, 0, 0, 0]
var switchingcardplayer : Array = [0, 1, 2, 3, 4]
var switchingcarddealer : Array = [0, 1, 2, 3, 4]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
