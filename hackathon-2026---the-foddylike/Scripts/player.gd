extends CharacterBody2D


@export var SPEED = 0.0
@export var SPEED_CAP = 80.0
@export var AERIAL_SPEED_CAP = 160
@export var acceleration = 1.0
@export var JUMP_VELOCITY = -30.0


func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		clamp(SPEED,-1*AERIAL_SPEED_CAP,AERIAL_SPEED_CAP)
	else:
		clamp(SPEED,-1*SPEED_CAP,SPEED_CAP)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * (1+abs(SPEED/SPEED_CAP))
		SPEED = SPEED * 1.3

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if SPEED > -3.0 and SPEED < 3.0:
		$AnimatedSprite2D.animation = "idle"
	else:
		$AnimatedSprite2D.animation = "walker"
		$AnimatedSprite2D.speed_scale = 1+(abs(SPEED/SPEED_CAP)*2)
	
	if direction and is_on_floor():
		SPEED = SPEED + (direction * acceleration)
	elif direction and !is_on_floor():
		SPEED = SPEED + (direction * acceleration * .3)
	elif is_on_floor():
		var tween = get_tree().create_tween()
		tween.tween_property(self,"SPEED",0,.3)
		velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.x = SPEED
	move_and_slide()
