extends Node2D

@onready var full_deck = [
	[$C2, 2, 0], [$C3, 3, 0], [$C4, 4, 0], [$C5, 5, 0], [$C6, 6, 0], [$C7, 7, 0], [$C8, 8, 0], 
	[$C9, 9, 0], [$C10, 10, 0], [$Cj, 10, 0], [$Cq, 10, 0], [$Ck, 10, 0], [$Ca, 11, 0], 
	[$D2, 2, 1], [$D3, 3, 1], [$D4, 4, 1], [$D5, 5, 1], [$D6, 6, 1], [$D7, 7, 1], [$D8, 8, 1], 
	[$D9, 9, 1], [$D10, 10, 1], [$Dj, 10, 1], [$Dq, 10, 1], [$Dk, 10, 1], [$Da, 11, 1], 
	[$H2, 2, 2], [$H3, 3, 2], [$H4, 4, 2], [$H5, 5, 2], [$H6, 6, 2], [$H7, 7, 2], [$H8, 8, 2],
	[$H9, 9, 2], [$H10, 10, 2], [$Hj, 10, 2], [$Hq, 10, 2], [$Hk, 10, 2], [$Ha, 11, 2],
	[$S2, 2, 3], [$S3, 3, 3], [$S4, 4, 3], [$S5, 5, 3], [$S6, 6, 3], [$S7, 7, 3], [$S8, 8, 3], 
	[$S9, 9, 3], [$S10, 10, 3], [$Sj, 10, 3], [$Sq, 10, 3], [$Sk, 10, 3], [$Sa, 11, 3]
]

var card
var cardsplayed : int = 0
var candeal : bool = true
var playerhand : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if candeal:
		playerhand = [_new_card(2)]
		print(playerhand)
		candeal = false


func _new_card(destination):
	card = full_deck[0][0]
	cardsplayed += 1
	playerhand[0] = full_deck[0]
	full_deck.erase(full_deck[0][0])
