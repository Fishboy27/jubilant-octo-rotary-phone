extends Node2D

@onready var Globle = get_node("/root/Global")

var playervalues : Array = []
var playersuits : Array = []
var playersamecard = {}
var analyse : bool = true
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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if analyse:
		analyse = false
		await get_tree().create_timer(16).timeout
		_Analysedealerhand()
		_Analyseplayerhand()
		_Winner()

func _Analysedealerhand():
	for i in range(5):
		dealervalues.append(Global.dealerhand[i][1])
		dealersuits.append(Global.dealerhand[i][2])
	dealervalues.sort()
	dealersuits.sort()
	
	#Flush
	for i in range(4):
		if dealersuits[i] != dealersuits[i + 1]:
			dealerflush = false
			break
		else:
			dealerflush = true
			
	#Straight
	for i in range(4):
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
	
	for value in dealersamecard:
		if dealersamecard[value] == 2:
			dealerpairvalue = value
		if dealersamecard[value] == 3:
			dealerthreevalue = value
		if dealersamecard[value] == 4:
			dealerfourvalue = value
	
	# Number of same cards
	for count in dealersamecard.values():
		if count == 2:
			dealerpairs += 1
		elif count == 3:
			dealerthreeofakind = true
		elif count == 4:
			dealerfourofakind = true
	
	# Displaying hand
	print("Dealer")
	if dealerflush and dealerstraight and dealerroyalflush:
		print("Royal Flush")
		dealerhandrank = 10
	elif dealerflush and dealerstraight and not dealerroyalflush:
		print("Straight Flush")
		dealerhandrank = 9
	elif dealerfourofakind:
		print("Four of a Kind")
		dealerhandrank = 8
	elif dealerthreeofakind and dealerpairs == 1:
		print("Full House")
		dealerhandrank = 7
	elif dealerflush and not dealerstraight:
		print("Flush")
		playerhandrank = 6
	elif dealerstraight and not dealerflush:
		print("Straight")
		dealerhandrank = 5
	elif dealerthreeofakind:
		print("Three of a Kind")
		dealerhandrank = 4
	elif dealerpairs == 2:
		print("Two Pair")
		dealerhandrank = 3
	elif dealerpairs == 1:
		print("Pair")
		dealerhandrank = 2
	else:
		print("High Card")
		dealerhandrank = 1


func _Analyseplayerhand():
	for i in range(5):
		playervalues.append(Global.playerhand[i][1])
		playersuits.append(Global.playerhand[i][2])
	playervalues.sort()
	playersuits.sort()
	
	#Flush
	for i in range(4):
		if playersuits[i] != playersuits[i + 1]:
			playerflush = false
			break
		else:
			playerflush = true
			
	#Straight
	for i in range(4):
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
	for count in playersamecard.values():
		if count == 2:
			playerpairs += 1
		elif count == 3:
			playerthreeofakind = true
		elif count == 4:
			playerfourofakind = true
	
	# Displaying hand
	print("Player")
	if playerflush and playerstraight and playerroyalflush:
		print("Royal Flush")
		playerhandrank = 10
	elif playerflush and playerstraight and not playerroyalflush:
		print("Straight Flush")
		playerhandrank = 9
	elif playerfourofakind:
		print("Four of a Kind")
		playerhandrank = 8
	elif playerthreeofakind and playerpairs == 1:
		print("Full House")
		playerhandrank = 7
	elif playerflush and not playerstraight:
		print("Flush")
		playerhandrank = 6
	elif playerstraight and not playerflush:
		print("Straight")
		playerhandrank = 5
	elif playerthreeofakind:
		print("Three of a Kind")
		playerhandrank = 4
	elif playerpairs == 2:
		print("Two Pair")
		playerhandrank = 3
	elif playerpairs == 1:
		print("Pair")
		playerhandrank = 2
	else:
		print("High Card")
		playerhandrank = 1


func _Winner():
	if playerhandrank > dealerhandrank:
		print("Player Win")
	elif playerhandrank < dealerhandrank:
		print("Dealer Win")
	elif playerhandrank == dealerhandrank:
		# High card or Straight or Flush or Four of a kind
		if playerhandrank == 1 or playerhandrank == 5 or playerhandrank == 6 or playerhandrank == 9:
			if playervalues[4] > dealervalues[4]:
				print("Player Win")
			elif playervalues[4] < dealervalues[4]:
				print("Dealer Win")
			elif playervalues[4] == playervalues[4]:
				print("Tie")

		# Pair
		elif playerhandrank == 2:
			if playerpairvalue > dealerpairvalue:
				print("Player Win")
			elif playerpairvalue < dealerpairvalue:
				print("Dealer Win")
			elif playerpairvalue == dealerpairvalue:
				if playervalues[4] > dealervalues[4]:
					print("Player Win")
				elif playervalues[4] < dealervalues[4]:
					print("Dealer Win")
				elif playervalues[4] == playervalues[4]:
					if playervalues[3] > dealervalues[3]:
						print("Player Win")
					elif playervalues[4] < dealervalues[4]:
						print("Dealer Win")
					elif playervalues[3] == playervalues[3]:
						if playervalues[2] > dealervalues[2]:
							print("Player Win")
						elif playervalues[2] < dealervalues[2]:
							print("Dealer Win")
						elif playervalues[2] == playervalues[2]:
							if playervalues[1] > dealervalues[1]:
								print("Player Win")
							elif playervalues[1] < dealervalues[1]:
								print("Dealer Win")
							elif playervalues[1] == playervalues[1]:
								if playervalues[0] > dealervalues[0]:
									print("Player Win")
								elif playervalues[0] < dealervalues[0]:
									print("Dealer Win")
								elif playervalues[1] == playervalues[1]:
									print("Tie")

		# Three of a kind or Full house
		elif playerhandrank == 3 or playerhandrank == 7:
			if playerthreevalue > dealerthreevalue:
				print("Player Win")
			elif playerthreevalue < dealerthreevalue:
				print("Dealer Win")
		# Four of a kind
		elif playerhandrank == 8:
			if playerfourvalue > dealerfourvalue:
				print("Player Win")
			elif playerfourvalue < dealerfourvalue:
				print("Dealer Win")
			
		else:
			print("Tie")
