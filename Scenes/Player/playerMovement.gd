extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 1500.0
const FRICTION = 2500.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

#Weapon Inicalization
@export var base_weapon_scene: PackedScene
@export var starting_weapon: WeaponData

#health
@export var max_hp: int = 50
#Weapon Holder
@onready var weapon_holder: Node2D = $WeaponHolder

var current_weapon: BaseWeapon = null
var current_hp: int

#Movement
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("move_left", "move_right")

	if direction != 0:
		velocity.x = move_toward(
			velocity.x,
			direction * SPEED,
			ACCELERATION * delta
		)
	else:
		velocity.x = move_toward(
			velocity.x,
			0.0,
			FRICTION * delta
		)
	
	if direction != 0:
		var facing_left := direction < 0
		animated_sprite.flip_h = facing_left
		$WeaponHolder.position.x = -12.0 if facing_left else 12.0
		if current_weapon != null:
			current_weapon.set_facing_left(facing_left)

	if not is_on_floor():
		animated_sprite.stop()
	elif direction != 0:
		if animated_sprite.animation != "run":
			animated_sprite.play("run")
	else:
		animated_sprite.play("idle")

	move_and_slide()

#Enquip (Not Done)
func equip_weapon(data: WeaponData) -> void:
	if data == null:
		return

	if base_weapon_scene == null:
		return

	if current_weapon != null:
		current_weapon.queue_free()

	var weapon := base_weapon_scene.instantiate() as BaseWeapon

	if weapon == null:
		return

	weapon_holder.add_child(weapon)
	weapon.setup(data)
	current_weapon = weapon

func _ready() -> void:
	equip_weapon(starting_weapon)
	current_hp = max_hp

#Attack
func attack() -> void:
	if current_weapon == null:
		return

	if not current_weapon.can_attack:
		return

	current_weapon.play_swing()
	current_weapon.attack()

func die() -> void:
	print("Player Die!")
	
#Take Damage
func take_damage(amount: int) -> void:
	current_hp = max(current_hp - amount, 0)
	print("HP: ", current_hp, "/", max_hp)
	
	if current_hp <= 0:
		die()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack()
