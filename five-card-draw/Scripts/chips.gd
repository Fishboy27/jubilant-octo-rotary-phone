extends Node2D

@onready var Globle = get_node("/root/Global")

@onready var playerchips : Array = [$PlayerChip0, $PlayerChip1, $PlayerChip2, $PlayerChip3, 
$PlayerChip4, $PlayerChip5, $PlayerChip6, $PlayerChip7, $PlayerChip8, $PlayerChip9, $PlayerChip10, 
$PlayerChip11, $PlayerChip12, $PlayerChip13, $PlayerChip14, $PlayerChip15, $PlayerChip16, 
$PlayerChip17, $PlayerChip18, $PlayerChip19]

@onready var dealerchips : Array = [$DealerChip0, $DealerChip1, $DealerChip2, $DealerChip3, 
$DealerChip4, $DealerChip5, $DealerChip6, $DealerChip7, $DealerChip8, $DealerChip9, $DealerChip10, 
$DealerChip11, $DealerChip12, $DealerChip13, $DealerChip14, $DealerChip15, $DealerChip16, 
$DealerChip17, $DealerChip18, $DealerChip19]

@onready var playerbet : Array = [$PlayerBet0, $PlayerBet1, $PlayerBet2, $PlayerBet3, $PlayerBet4, 
$PlayerBet5, $PlayerBet6, $PlayerBet7, $PlayerBet8, $PlayerBet9]

@onready var dealerbet : Array = [$DealerBet0, $DealerBet1, $DealerBet2, $DealerBet3, $DealerBet4, 
$DealerBet5, $DealerBet6, $DealerBet7, $DealerBet8, $DealerBet9]

var playerchipcount : int = 19
var dealerchipcount : int = 19
var playershownchips : int = 0
var dealershownchips : int = 0
var playerbetcount : int = 9
var dealerbetcount : int = 9
var playershownbet : int = 0
var dealershownbet : int = 0
var start : bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_initialise()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start:
		_showplayerchips()
		_showdealerchips()
		start = false

	if Global.win:
		Global.win = false
		await get_tree().create_timer(1).timeout
		_Win()
		_initialise()
		start = true
	
	if Global.lose:
		Global.lose = false
		await get_tree().create_timer(1).timeout
		_Lose()
		_initialise()
		start = true

	if Global.tie:
		Global.tie = true
		await get_tree().create_timer(1).timeout
		_Tie()
		_initialise()
		start = true

	if Global.canraise:
		if Input.is_action_just_pressed("Down") and Global.playerraiseamount < Global.playerchips and Global.playerraiseamount < Global.dealerchips + dealershownbet and not Global.hasbet:
			Global.playerraiseamount += 1
			_Update_raise_highlight()
		if Input.is_action_just_pressed("Up") and Global.playerraiseamount > 0 and not Global.hasbet:
			Global.playerraiseamount -= 1
			_Update_raise_highlight()
		#if Input.is_action_just_pressed("Left"):
			#_showplayerchips()
			#Global.playerraiseamount = 0
			#Global.canraise = false
		if Input.is_action_just_pressed("Enter") and (Global.playerraiseamount > 0 or Global.playerraiseamount > Global.dealerraiseamount):
			Global.hasbet = true
			Global.playerbet += Global.playerraiseamount
			playerchipcount = 19
			for i in range(20):
				if playerchipcount >= Global.playerchips - Global.playerraiseamount:
					playerchips[playerchipcount].animation = ("Invisible")
					playerchipcount -= 1
				elif playerchipcount >= 0:
					playerchips[playerchipcount].animation = ("Blue")
					playershownchips += 1
					playerchipcount -= 1
				else:
					playerchipcount = 19
			_showplayerbet()
			if Global.dealercall:
				Global.dealercall = false
				Global.dealerraiseamount = Global.playerraiseamount
				await get_tree().create_timer(0.5).timeout
				_showdealerbet()
			Global.playerchips -= Global.playerraiseamount
			Global.playerraiseamount = 0
			Global.dealerraiseamount = 0
			Global.canraise = false

	if Global.playerbet == Global.dealerbet and Global.hasbet and Global.match:
		Global.match = false
		await get_tree().create_timer(1).timeout
		Global.round += 1
	elif Global.playerchips == 0 and Global.match:
		Global.match = false
		await get_tree().create_timer(1).timeout
		Global.round += 1


func _showplayerchips():
	playershownchips = 0
	playerchipcount = 19
	for i in range(20):
		if i < Global.playerchips:
			playerchips[i].animation = "Blue"
			playershownchips += 1
		else:
			playerchips[i].animation = "Invisible"


func _showdealerchips():
	dealershownchips = 0
	dealerchipcount= 19
	for i in range(20):
		if i < Global.dealerchips:
			dealerchips[i].animation = "Blue"
			dealershownchips += 1
		else:
			dealerchips[i].animation = "Invisible"


func _showplayerbet():
	playershownbet = 0
	playerbetcount = 9
	for i in range(10):
		if playerbetcount >= Global.playerbet:
			playerbet[playerbetcount].animation = ("Invisible")
			playerbetcount -= 1
		elif playerbetcount >= 0:
			playerbet[playerbetcount].animation = ("Blue")
			playershownbet += 1
			playerbetcount -= 1
		else:
			playerbetcount = 9

func _showdealerbet():
	dealerbetcount = 9
	Global.dealerbet += Global.dealerraiseamount
	Global.dealerchips -= Global.dealerraiseamount
	_showdealerchips()
	Global.dealerraiseamount = 0
	dealershownbet = 0
	dealerbetcount = 9
	for i in range(10):
		if i < Global.dealerbet:
			dealerbet[i].animation = "Blue"
			dealershownbet += 1
		else:
			dealerbet[i].animation = "Invisible"


func _first_visible_player_chip():
	for i in range(playerchips.size() -1, -1, -1):
		if playerchips[i].animation != "Invisible":
			return i
	return -1


func _first_visible_dealer_chip():
	for i in range(dealerchips.size() -1, -1, -1):
		if dealerchips[i].animation != "Invisible":
			return i
	return -1


func _Update_raise_highlight():
	var firstchip = _first_visible_player_chip()
	if firstchip == -1:
		return
	for i in range(Global.playerchips):
		playerchips[i].animation = "Blue"
	for i in range(Global.playerraiseamount):
		playerchips[firstchip - i].animation = "Highlighted"


func _Win():
	print("Win")
	Global.playerchips += Global.playerbet + Global.dealerbet
	playerchipcount = 19
	for i in range(20):
		if playerchipcount >= Global.playerchips - Global.playerraiseamount:
			playerchips[playerchipcount].animation = ("Invisible")
			playerchipcount -= 1
		elif playerchipcount >= 0:
			playerchips[playerchipcount].animation = ("Blue")
			playershownchips += 1
			playerchipcount -= 1
		else:
			playerchipcount = 19
	Global.playerraiseamount = 0
	Global.playerbet = 0
	_showplayerbet()
	Global.dealerraiseamount = 0
	Global.dealerbet = 0
	_showdealerbet()


func _Lose():
	print("Lose")
	Global.dealerchips += Global.dealerbet + Global.playerbet
	dealerchipcount = 19
	Global.dealerraiseamount = 0
	Global.dealerbet = 0
	_showdealerbet()
	Global.playerraiseamount = 0
	Global.playerbet = 0
	_showplayerbet()

func _Tie():
	print("Win")
	playerchipcount = 19
	for i in range(20):
		if playerchipcount >= Global.playerchips - Global.playerraiseamount:
			playerchips[playerchipcount].animation = ("Invisible")
			playerchipcount -= 1
		elif playerchipcount >= 0:
			playerchips[playerchipcount].animation = ("Blue")
			playershownchips += 1
			playerchipcount -= 1
		else:
			playerchipcount = 19
	Global.playerraiseamount = 0
	Global.playerbet = 0
	_showplayerbet()
	Global.dealerraiseamount = 0
	_showdealerbet()

func _initialise():
	playerchips[0].animation = ("Invisible")
	playerchips[1].animation = ("Invisible")
	playerchips[2].animation = ("Invisible")
	playerchips[3].animation = ("Invisible")
	playerchips[4].animation = ("Invisible")
	playerchips[5].animation = ("Invisible")
	playerchips[6].animation = ("Invisible")
	playerchips[7].animation = ("Invisible")
	playerchips[8].animation = ("Invisible")
	playerchips[9].animation = ("Invisible")
	playerchips[10].animation = ("Invisible")
	playerchips[11].animation = ("Invisible")
	playerchips[12].animation = ("Invisible")
	playerchips[13].animation = ("Invisible")
	playerchips[14].animation = ("Invisible")
	playerchips[15].animation = ("Invisible")
	playerchips[16].animation = ("Invisible")
	playerchips[17].animation = ("Invisible")
	playerchips[18].animation = ("Invisible")
	playerchips[19].animation = ("Invisible")
	dealerchips[0].animation = ("Invisible")
	dealerchips[1].animation = ("Invisible")
	dealerchips[2].animation = ("Invisible")
	dealerchips[3].animation = ("Invisible")
	dealerchips[4].animation = ("Invisible")
	dealerchips[5].animation = ("Invisible")
	dealerchips[6].animation = ("Invisible")
	dealerchips[7].animation = ("Invisible")
	dealerchips[8].animation = ("Invisible")
	dealerchips[9].animation = ("Invisible")
	dealerchips[10].animation = ("Invisible")
	dealerchips[11].animation = ("Invisible")
	dealerchips[12].animation = ("Invisible")
	dealerchips[13].animation = ("Invisible")
	dealerchips[14].animation = ("Invisible")
	dealerchips[15].animation = ("Invisible")
	dealerchips[16].animation = ("Invisible")
	dealerchips[17].animation = ("Invisible")
	dealerchips[18].animation = ("Invisible")
	dealerchips[19].animation = ("Invisible")
	playerbet[0].animation = ("Invisible")
	playerbet[1].animation = ("Invisible")
	playerbet[2].animation = ("Invisible")
	playerbet[3].animation = ("Invisible")
	playerbet[4].animation = ("Invisible")
	playerbet[5].animation = ("Invisible")
	playerbet[6].animation = ("Invisible")
	playerbet[7].animation = ("Invisible")
	playerbet[8].animation = ("Invisible")
	playerbet[9].animation = ("Invisible")
	dealerbet[0].animation = ("Invisible")
	dealerbet[1].animation = ("Invisible")
	dealerbet[2].animation = ("Invisible")
	dealerbet[3].animation = ("Invisible")
	dealerbet[4].animation = ("Invisible")
	dealerbet[5].animation = ("Invisible")
	dealerbet[6].animation = ("Invisible")
	dealerbet[7].animation = ("Invisible")
	dealerbet[8].animation = ("Invisible")
	dealerbet[9].animation = ("Invisible")
