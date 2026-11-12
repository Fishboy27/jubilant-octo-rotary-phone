extends Node2D

@onready var Globle = get_node("/root/Global")

@onready var dealerhand: Label = $Dealerhand

@onready var playerhand: Label = $Playerhand

@onready var win: Label = $Win

@onready var tie: Label = $Tie

@onready var lose: Label = $Lose


var playervalues : Array = []
var playersuits : Array = []
var playersamecard = {}
var playerflush : bool = false
var playerstraight : bool = false
var playerroyalflush : bool = false
var playerfourofakind : bool = false
var playerthreeofakind : bool = false
var playertwopair : bool = false
var playerpair : bool = false
var playerhighcard : bool = false
var playerpairs : int = 0
var playerhandrank : int = 0
var playerpairvalue : int = 0
var playerthreevalue : int = 0
var playerfourvalue : int = 0
var playercount : int = 0

var dealervalues : Array = []
var dealersuits : Array = []
var dealersamecard = {}
var dealerflush : bool = false
var dealerstraight : bool = false
var dealerroyalflush : bool = false
var dealerfourofakind : bool = false
var dealerthreeofakind : bool = false
var dealertwopair : bool = false
var dealerpair : bool = false
var dealerhighcard : bool = false
var dealerpairs : int = 0
var dealerhandrank : int = 0
var dealerpairvalue : int = 0
var dealerthreevalue : int = 0
var dealerfourvalue : int = 0
var dealercount : int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.analyseplayer:
		Global.analyseplayer = false
		_Analyseplayerhand()
	
	if Global.analysedealer:
		Global.analysedealer = false
		_Analysedealerhand()
		_Winner()

func _Analysedealerhand():
	dealerhandrank = 0
	dealervalues = []
	dealersuits = []
	dealersamecard = {}
	dealerflush = false
	dealerstraight = false
	dealerroyalflush = false
	dealerfourofakind = false
	dealerthreeofakind = false
	dealertwopair = false
	dealerpair = false
	dealerhighcard = false
	dealercount = 0
	dealerpairs = 0
	dealerhand.text = " "
	for i in range(5):
		dealervalues.append(Global.dealerhand[i][1])
		dealersuits.append(Global.dealerhand[i][2])
	dealervalues.sort()
	dealersuits.sort()
	
	#Flush
	for i in range(5):
		if dealersuits[i] != dealersuits[i + 1]:
			dealerflush = false
			break
		else:
			dealerflush = true
			
	#Straight
	for i in range(5):
		if dealervalues[i] + 1 != dealervalues[i + 1]:
			dealerstraight = false
			break
		# Royal flush
		elif dealervalues[0] == 10:
			dealerstraight = true
			dealerroyalflush = true
		else:
			dealerstraight = true
	
	# Sorting into same cards
	for i in range(5):
		if dealersamecard.has(dealervalues[i]):
			dealersamecard[dealervalues[i]] += 1
		else:
			dealersamecard[dealervalues[i]] = 1
	
	for dealervalue in dealersamecard:
		if dealersamecard[dealervalue] == 2:
			dealerpairvalue = dealervalue
		if dealersamecard[dealervalue] == 3:
			dealerthreevalue = dealervalue
		if dealersamecard[dealervalue] == 4:
			dealerfourvalue = dealervalue
	
	# Number of same cards
	for dealercount in dealersamecard.values():
		if dealercount == 2:
			dealerpairs += 1
		elif dealercount == 3:
			dealerthreeofakind = true
		elif dealercount == 4:
			dealerfourofakind = true
	
	# Displaying hand
	if dealerflush and dealerstraight and dealerroyalflush:
		dealerhand.text = "Royal Flush"
		dealerhandrank = 10
	elif dealerflush and dealerstraight and not dealerroyalflush:
		dealerhand.text = "Straight Flush"
		dealerhandrank = 9
	elif dealerfourofakind:
		dealerhand.text = "Four of a Kind"
		dealerhandrank = 8
	elif dealerthreeofakind and dealerpairs == 1:
		dealerhand.text = "Full House"
		dealerhandrank = 7
	elif dealerflush and not dealerstraight:
		dealerhand.text = "Flush"
		playerhandrank = 6
	elif dealerstraight and not dealerflush:
		dealerhand.text = "Straight"
		dealerhandrank = 5
	elif dealerthreeofakind:
		dealerhand.text = "Three of a Kind"
		dealerhandrank = 4
	elif dealerpairs == 2:
		dealerhand.text = "Two Pair"
		dealerhandrank = 3
	elif dealerpairs == 1:
		dealerhand.text = "Pair"
		dealerhandrank = 2
	else:
		dealerhand.text = "High Card"
		dealerhandrank = 1


func _Analyseplayerhand():
	playerhandrank = 0
	playervalues = []
	playersuits = []
	playersamecard = {}
	playerflush = false
	playerstraight = false
	playerroyalflush = false
	playerfourofakind = false
	playerthreeofakind = false
	playertwopair = false
	playerpair = false
	playerhighcard = false
	playerpairs = 0
	playerhand.text = " "
	for i in range(5):
		playervalues.append(Global.playerhand[i][1])
		playersuits.append(Global.playerhand[i][2])
	playervalues.sort()
	playersuits.sort()
	
	#Flush
	for i in range(5):
		if playersuits[i] != playersuits[i + 1]:
			playerflush = false
			break
		else:
			playerflush = true
			
	# Straight
	for i in range(5):
		if playervalues[i] + 1 != playervalues[i + 1]:
			playerstraight = false
			break
		# Royal flush
		elif playervalues[0] == 10:
			playerstraight = true
			playerroyalflush = true
		else:
			playerstraight = true
	
	# Sorting into same cards
	for i in range(5):
		if playersamecard.has(playervalues[i]):
			playersamecard[playervalues[i]] += 1
		else:
			playersamecard[playervalues[i]] = 1
	
	for value in playersamecard:
		if playersamecard[value] == 2:
			playerpairvalue = value
		if playersamecard[value] == 3:
			playerthreevalue = value
		if playersamecard[value] == 4:
			playerfourvalue = value

	# Number of same cards
	for playercount in playersamecard.values():
		if playercount == 2:
			playerpairs += 1
		elif playercount == 3:
			playerthreeofakind = true
		elif playercount == 4:
			playerfourofakind = true
	
	# Displaying hand
	if playerflush and playerstraight and playerroyalflush:
		playerhand.text = "Royal Flush"
		playerhandrank = 10
	elif playerflush and playerstraight and not playerroyalflush:
		playerhand.text = "Straight Flush"
		playerhandrank = 9
	elif playerfourofakind:
		playerhand.text = "Four of a Kind"
		playerhandrank = 8
	elif playerthreeofakind and playerpairs == 1:
		playerhand.text = "Full House"
		playerhandrank = 7
	elif playerflush and not playerstraight:
		playerhand.text = "Flush"
		playerhandrank = 6
	elif playerstraight and not playerflush:
		playerhand.text = "Straight"
		playerhandrank = 5
	elif playerthreeofakind:
		playerhand.text = "Three of a Kind"
		playerhandrank = 4
	elif playerpairs == 2:
		playerhand.text = "Two Pair"
		playerhandrank = 3
	elif playerpairs == 1:
		playerhand.text = "Pair"
		playerhandrank = 2
	else:
		playerhand.text = "High Card"
		playerhandrank = 1


func _Winner():
	_Analyseplayerhand()
	_Analysedealerhand()
	if playerhandrank > dealerhandrank:
		Global.win = true
		_Win()
	elif playerhandrank < dealerhandrank:
		Global.lose = true
		_Lose()
	elif playerhandrank == dealerhandrank:
		# High card or Straight or Flush or Four of a kind
		if playerhandrank == 1 or playerhandrank == 5 or playerhandrank == 6 or playerhandrank == 9:
			if playervalues[4] > dealervalues[4]:
				Global.win = true
				_Win()
			elif playervalues[4] < dealervalues[4]:
				Global.lose = true
				_Lose()
			elif playervalues[4] == playervalues[4]:
				Global.tie = true
				_Tie()

		# Pair
		elif playerhandrank == 2:
			if playerpairvalue > dealerpairvalue:
				Global.win = true
				_Win()
			elif playerpairvalue < dealerpairvalue:
				Global.lose = true
				_Lose()
			elif playerpairvalue == dealerpairvalue:
				if playervalues[4] > dealervalues[4]:
					Global.win = true
					_Win()
				elif playervalues[4] < dealervalues[4]:
					Global.lose = true
					_Lose()
				elif playervalues[4] == playervalues[4]:
					if playervalues[3] > dealervalues[3]:
						Global.win = true
						_Win()
					elif playervalues[4] < dealervalues[4]:
						Global.lose = true
						_Lose()
					elif playervalues[3] == playervalues[3]:
						if playervalues[2] > dealervalues[2]:
							Global.win = true
							_Win()
						elif playervalues[2] < dealervalues[2]:
							Global.lose = true
							_Lose()
						elif playervalues[2] == playervalues[2]:
							if playervalues[1] > dealervalues[1]:
								Global.win = true
								_Win()
							elif playervalues[1] < dealervalues[1]:
								Global.lose = true
								_Lose()
							elif playervalues[1] == playervalues[1]:
								if playervalues[0] > dealervalues[0]:
									Global.win = true
									_Win()
								elif playervalues[0] < dealervalues[0]:
									Global.lose = true
									_Lose()
								elif playervalues[1] == playervalues[1]:
									Global.tie = true
									_Tie()

		# Three of a kind or Full house
		elif playerhandrank == 3 or playerhandrank == 7:
			if playerthreevalue > dealerthreevalue:
				Global.win = true
				_Win()
			elif playerthreevalue < dealerthreevalue:
				Global.lose = true
				_Lose()
		# Four of a kind
		elif playerhandrank == 8:
			if playerfourvalue > dealerfourvalue:
				Global.win = true
				_Win()
			elif playerfourvalue < dealerfourvalue:
				Global.lose = true
				_Lose()
			
		else:
			Global.tie = true
			_Tie()


func _Win():
	win.visible = true
	await get_tree().create_timer(4).timeout
	win.visible = false
	playerhand.text = " "
	dealerhand.text = " "


func _Tie():
	tie.visible = true
	await get_tree().create_timer(4).timeout
	tie.visible = false
	playerhand.text = " "
	dealerhand.text = " "


func _Lose():
	lose.visible = true
	await get_tree().create_timer(4).timeout
	lose.visible = false
	playerhand.text = " "
	dealerhand.text = " "
