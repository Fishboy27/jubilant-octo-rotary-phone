extends Node2D

@onready var Globle = get_node("/root/Global")

@onready var full_deck = [
	[$C2, 2, 0], [$C3, 3, 0], [$C4, 4, 0], [$C5, 5, 0], [$C6, 6, 0], [$C7, 7, 0], [$C8, 8, 0], 
	[$C9, 9, 0], [$C10, 10, 0], [$Cj, 11, 0], [$Cq, 12, 0], [$Ck, 13, 0], [$Ca, 14, 0], 
	[$D2, 2, 1], [$D3, 3, 1], [$D4, 4, 1], [$D5, 5, 1], [$D6, 6, 1], [$D7, 7, 1], [$D8, 8, 1], 
	[$D9, 9, 1], [$D10, 10, 1], [$Dj, 11, 1], [$Dq, 12, 1], [$Dk, 13, 1], [$Da, 14, 1], 
	[$H2, 2, 2], [$H3, 3, 2], [$H4, 4, 2], [$H5, 5, 2], [$H6, 6, 2], [$H7, 7, 2], [$H8, 8, 2],
	[$H9, 9, 2], [$H10, 10, 2], [$Hj, 11, 2], [$Hq, 12, 2], [$Hk, 13, 2], [$Ha, 14, 2],
	[$S2, 2, 3], [$S3, 3, 3], [$S4, 4, 3], [$S5, 5, 3], [$S6, 6, 3], [$S7, 7, 3], [$S8, 8, 3], 
	[$S9, 9, 3], [$S10, 10, 3], [$Sj, 11, 3], [$Sq, 12, 3], [$Sk, 13, 3], [$Sa, 14, 3]
]


@onready var coverplayer = [$CardCoverPlayer_slot, $CardCoverPlayer_slot2, $CardCoverPlayer_slot3, 
$CardCoverPlayer_slot4, $CardCoverPlayer_slot5]


@onready var coverdealer = [$CardCoverDealer_slot, $CardCoverDealer_slot2, $CardCoverDealer_slot3, 
$CardCoverDealer_slot4, $CardCoverDealer_slot5]


@onready var cardplayerplace : Array = [$Cardplace.position, $Cardplace2.position, 
$Cardplace3.position, $Cardplace4.position, $Cardplace5.position]


@onready var carddealerplace : Array = [$Cardplace6.position, $Cardplace7.position,
 $Cardplace8.position, $Cardplace9.position, $Cardplace10.position]

@onready var dealercovercards : Array = [$Dealer_cover_card, $Dealer_cover_card2, 
$Dealer_cover_card3, $Dealer_cover_card4, $Dealer_cover_card5]

@onready var dealing_timer: Timer = $Dealing_timer

@onready var dealer_cover_card: Sprite2D = $Dealer_cover_card

@onready var dealer_cover_card_2: Sprite2D = $Dealer_cover_card2

@onready var dealer_cover_card_3: Sprite2D = $Dealer_cover_card3

@onready var dealer_cover_card_4: Sprite2D = $Dealer_cover_card4

@onready var dealer_cover_card_5: Sprite2D = $Dealer_cover_card5

@onready var card_back: Sprite2D = $CardBack


var playercard
var dealercard
var covercountplayer : int = 0
var covercountdealer : int = 0
var cardamount : int = 0
var nextdeal : int = 1
var cardsplayedplayer : int = 0
var cardsplayeddealer : int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_initialise()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.candeal:
		_deal()
		Global.candeal = false
	
	if Global.canswitch:
		Global.canswitch = false
		Global.playerhand[Global.switchingcardplayer] = _switch_card_player(Global.switchingcardplayer)
		await get_tree().create_timer(2).timeout
		Global.dealerhand[Global.switchingcarddealer] = _switch_card_dealer(Global.switchingcarddealer)
		await get_tree().create_timer(1).timeout
		Global.switchingcarddealer += 1
		Global.dealerhand[Global.switchingcarddealer] = _switch_card_dealer(Global.switchingcarddealer)
		await get_tree().create_timer(1).timeout
		Global.switchingcarddealer += 1
		Global.dealerhand[Global.switchingcarddealer] = _switch_card_dealer(Global.switchingcarddealer)
		await get_tree().create_timer(1).timeout
		Global.switchingcarddealer += 1
		Global.dealerhand[Global.switchingcarddealer] = _switch_card_dealer(Global.switchingcarddealer)
		await get_tree().create_timer(1).timeout
		Global.switchingcarddealer += 1
		Global.dealerhand[Global.switchingcarddealer] = _switch_card_dealer(Global.switchingcarddealer)
		await get_tree().create_timer(3).timeout

	if Global.reveal:
		Global.reveal = false
		_show_dealer_hand(0)
		await get_tree().create_timer(0.15).timeout
		_show_dealer_hand(1)
		await get_tree().create_timer(0.15).timeout
		_show_dealer_hand(2)
		await get_tree().create_timer(0.15).timeout
		_show_dealer_hand(3)
		await get_tree().create_timer(0.15).timeout
		_show_dealer_hand(4)
		Global.analyseplayer = true
		Global.analysedealer = true


func _deal():
	_initialise()
	full_deck.shuffle()
	while cardamount < 9:
		await get_tree().create_timer(0.2).timeout
		if nextdeal > 0:
			Global.playerhand[Global.playercardplace] = _new_card_player()
			Global.playercardplace += 1
			dealing_timer.start()
		elif nextdeal < 0:
			Global.dealerhand[Global.dealercardplace] = _new_card_dealer()
			Global.dealercardplace += 1
			dealing_timer.start()
	Global.analyseplayer = true
	Global.round += 1


func _new_card_dealer():
	dealercard = full_deck[0][0]
	dealercard.scale = Vector2(0, 5)
	# Deals the cards out visually
	var tween = get_tree().create_tween()
	tween.tween_property(coverdealer[cardsplayeddealer], "scale", Vector2(5, 5), 0)
	tween.tween_property(dealercard, "position", carddealerplace[cardsplayeddealer], 0.5)
	tween.parallel().tween_property(coverdealer[cardsplayeddealer], "position", carddealerplace[cardsplayeddealer], 0.5)
	tween.tween_property(coverdealer[cardsplayeddealer], "scale", Vector2(0, 5), 0)
	tween.tween_property(dealercovercards[cardsplayeddealer], "scale", Vector2(5, 5), 0)
	cardsplayeddealer += 1
	var card = full_deck[0]
	full_deck.remove_at(0)
	return card


func _new_card_player():
	playercard = full_deck[0][0]
	playercard.scale = Vector2(0, 5)
	# Deals the cards out visually
	var tween = get_tree().create_tween()
	tween.tween_property(playercard, "position", cardplayerplace[cardsplayedplayer], 0.5)
	tween.parallel().tween_property(coverplayer[cardsplayedplayer], "position", cardplayerplace[cardsplayedplayer], 0.5)
	tween.tween_property(coverplayer[cardsplayedplayer], "scale", Vector2(0, 5), 0.07)
	tween.tween_property(playercard, "scale", Vector2(5, 5), 0.07)
	cardsplayedplayer += 1
	var card = full_deck[0]
	full_deck.remove_at(0)
	return card


func _switch_card_dealer(destination):
	dealercard = full_deck[0][0]
	dealercard.scale = Vector2(0, 5)
	# Deals the cards out visually-
	#dealercovercardsback[destination].z_index -= 1
	var tween = get_tree().create_tween()
	tween.tween_property(coverdealer[destination], "position", card_back.position, 0)
	tween.parallel().tween_property(coverdealer[destination], "scale", Vector2(5, 5), 0)
	tween.parallel().tween_property(dealercovercards[destination], "position", card_back.position, 0.5)
	tween.tween_property(dealercard, "position", carddealerplace[destination], 0.5)
	tween.parallel().tween_property(coverdealer[destination], "position", carddealerplace[destination], 0.5)
	tween.tween_property(coverdealer[destination], "scale", Vector2(5, 5), 0)
	tween.tween_property(dealercovercards[destination], "scale", Vector2(0, 5), 0)
	var card = full_deck[0]
	full_deck.remove_at(0)
	Global.dealerhand[destination] = 0
	return card


func _switch_card_player(destination):
	playercard = full_deck[0][0]
	playercard.scale = Vector2(0, 5)
	# Deals the cards out visually
	Global.playerhand[destination][0].z_index += 1
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(coverplayer[destination], "position", card_back.position, 0)
	tween.parallel().tween_property(coverplayer[destination], "scale", Vector2(5, 5), 0)
	tween.parallel().tween_property(Global.playerhand[destination][0], "position", card_back.position, 0.5)
	tween.tween_property(playercard, "position", cardplayerplace[destination], 0.5)
	tween.parallel().tween_property(coverplayer[destination], "position", cardplayerplace[destination], 0.5)
	tween.tween_property(coverplayer[destination], "scale", Vector2(0, 5), 0.07)
	tween.tween_property(playercard, "scale", Vector2(5, 5), 0.07)
	var card = full_deck[0]
	full_deck.remove_at(0)
	Global.playerhand[destination] = 0
	return card

func _show_dealer_hand(slot):
	var tween = get_tree().create_tween()
	tween.tween_property(coverdealer[slot], "scale", Vector2(0, 5), 0.07)
	tween.parallel().tween_property(dealercovercards[slot], "scale", Vector2(0, 5), 0.07)
	tween.tween_property(Global.dealerhand[slot][0], "scale", Vector2(5, 5), 0.07)


func _on_dealing_timer_timeout() -> void:
	cardamount += 1
	nextdeal = -nextdeal


func _initialise():
	full_deck = [
	[$C2, 2, 0], [$C3, 3, 0], [$C4, 4, 0], [$C5, 5, 0], [$C6, 6, 0], [$C7, 7, 0], [$C8, 8, 0], 
	[$C9, 9, 0], [$C10, 10, 0], [$Cj, 11, 0], [$Cq, 12, 0], [$Ck, 13, 0], [$Ca, 14, 0], 
	[$D2, 2, 1], [$D3, 3, 1], [$D4, 4, 1], [$D5, 5, 1], [$D6, 6, 1], [$D7, 7, 1], [$D8, 8, 1], 
	[$D9, 9, 1], [$D10, 10, 1], [$Dj, 11, 1], [$Dq, 12, 1], [$Dk, 13, 1], [$Da, 14, 1], 
	[$H2, 2, 2], [$H3, 3, 2], [$H4, 4, 2], [$H5, 5, 2], [$H6, 6, 2], [$H7, 7, 2], [$H8, 8, 2],
	[$H9, 9, 2], [$H10, 10, 2], [$Hj, 11, 2], [$Hq, 12, 2], [$Hk, 13, 2], [$Ha, 14, 2],
	[$S2, 2, 3], [$S3, 3, 3], [$S4, 4, 3], [$S5, 5, 3], [$S6, 6, 3], [$S7, 7, 3], [$S8, 8, 3], 
	[$S9, 9, 3], [$S10, 10, 3], [$Sj, 11, 3], [$Sq, 12, 3], [$Sk, 13, 3], [$Sa, 14, 3]
	]
	dealer_cover_card.scale = Vector2(0, 5)
	dealer_cover_card_2.scale = Vector2(0, 5)
	dealer_cover_card_3.scale = Vector2(0, 5)
	dealer_cover_card_4.scale = Vector2(0, 5)
	dealer_cover_card_5.scale = Vector2(0, 5)
	$CardCoverDealer_slot5.scale = Vector2(0, 5)
	$CardCoverDealer_slot4.scale = Vector2(0, 5)
