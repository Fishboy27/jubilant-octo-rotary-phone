extends Node2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

var change : bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if change:
		cpu_particles_2d.gravity = Vector2(randi_range(-75, 75), randi_range(-30, 30))
		change = false
		await get_tree().create_timer(0.5).timeout
		change = true
