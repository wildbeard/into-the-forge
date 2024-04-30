extends CharacterBody2D

const GRAVITY:float = 15

# @todo: :)
var difficulty: float = 1.0
var sinceLastJump: float = 0.0

func _physics_process(delta: float) -> void:
	var rng: float = randf_range(0, 1.75)
	var stallingRng: float = randi() % 10
	sinceLastJump += delta
	
	if stallingRng < 5:
		return

	if !is_on_floor():
		velocity.y += GRAVITY * delta

	if sinceLastJump > 0.2:
		sinceLastJump = 0
		# Keep it from sitting at the top?
		if global_position.y < 18:
			rng = rng - (rng * .25)

		velocity.y = rng * -1

	move_and_collide(velocity)
