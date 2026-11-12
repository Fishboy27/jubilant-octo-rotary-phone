extends Node2D

@onready var Globle = get_node("/root/Global")

@onready var selectors : Array = [$Selector1, $Selector2, $Selector3, 
$Selector4, $Selector5]

@onready var switch: Button = $Switch

@onready var dudbutton: Button = $Dudbutton

@onready var passbutton: Button = $Passbutton

@onready var raise: Button = $Raise

@onready var call: Button = $Call

@onready var selector_1: AnimatedSprite2D = $Selector1

@onready var selector_2: AnimatedSprite2D = $Selector2

@onready var selector_3: AnimatedSprite2D = $Selector3

@onready var selector_4: AnimatedSprite2D = $Selector4

@onready var selector_5: AnimatedSprite2D = $Selector5


var select : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.canselect:
		if dudbutton.has_focus():
			if Input.is_action_just_pressed("Left") and select > 0:
				if selectors[select].animation == "Select":
						selectors[select].visible = false
				select -= 1

			if Input.is_action_just_pressed("Right") and select < 4:
				if selectors[select].animation == "Select":
					selectors[select].visible = false
				select += 1
			
			if select != -1:
				selectors[select].visible = true
			
			if Input.is_action_just_pressed("Enter") and selectors[select].animation == "Select":
				selectors[select].animation = "Selectedcard"
				Global.switchingcardplayer[select] = -1
			elif Input.is_action_just_pressed("Enter") and selectors[select].animation == "Selectedcard":
				selectors[select].animation = "Select"
				Global.switchingcardplayer[select] = select

		elif selectors[select].animation == "Select":
			selectors[select].visible = false
	
	if Global.canraise and Global.round == 1:
		passbutton.visible = false
		switch.visible = false
		raise.visible = true
		call.visible = false
	elif Global.canraise and Global.round != 1:
		passbutton.visible = true
		switch.visible = false
		raise.visible = true
		call.visible = true
	elif Global.canselect:
		passbutton.visible = true
		switch.visible = true
		raise.visible = false
		call.visible = false
	else:
		passbutton.visible = false
		switch.visible = false
		raise.visible = false
		call.visible = false
	
	
	if Global.goinvis:
		Global.goinvis = false
		await get_tree().create_timer(0.15).timeout
		for i in range(5):
			selectors[i].visible = false

	if Global.selecting:
		dudbutton.grab_focus()
		Global.selecting = false

	if Global.reset:
		Global.canswitch = false
		_Initialise()


func _Initialise():
	select = 0
	selector_1.animation = "Select"
	selector_2.animation = "Select"
	selector_3.animation = "Select"
	selector_4.animation = "Select"
	selector_5.animation = "Select"

func _on_pass_pressed() -> void:
	passbutton.release_focus()
	Global.switchingcardplayer = [-1, -1, -1, -1, -1]
	Global.canselect = false
	Global.canswitch = true
	_Initialise()


func _on_switch_pressed() -> void:
	switch.release_focus()
	Global.canselect = false
	Global.canswitch = true
	await get_tree().create_timer(5).timeout
	_Initialise()


func _on_raise_pressed() -> void:
	Global.hasbet = false
	Global.canraise = true
	Global.match = true
	Global.dealercall = true


func _on_call_pressed() -> void:
	#if Global.round != 1:
	pass
