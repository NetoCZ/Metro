extends CharacterBody2D

signal hp_changed(current_hp: int, max_hp: int)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 1500.0
const FRICTION = 2500.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var damage = $damage
@onready var kroky = $kroky

#Weapon Inicalization
@export var base_weapon_scene: PackedScene
@export var starting_weapon: WeaponData

#health
@export var max_hp: int = 50
@export var hit_duration: float = 0.4
#Weapon Holder
@onready var weapon_holder: Node2D = $WeaponHolder

var current_weapon: BaseWeapon = null
var current_hp: int
var is_dead: bool = false
var is_hit: bool = false
var last_hit_time: int = 0

#Movement
func _physics_process(delta: float) -> void:
	if is_dead:
		if not is_on_floor():
			velocity += get_gravity() * delta
		velocity.x = 0.0
		move_and_slide()
		return

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

	# během animace hit se nepřepínají ostatní animace
	if not is_hit:
		if not is_on_floor():
			animated_sprite.stop()
			animated_sprite.play("jump")
		elif direction != 0:
			if animated_sprite.animation != "run":
				animated_sprite.play("run")
		else:
			animated_sprite.play("idle")

	move_and_slide()

#Enquip (Not Done)
func equip_weapon(data: WeaponData) -> void:
	if data == null or base_weapon_scene == null:
		return

	# Удаляем старое оружие
	if is_instance_valid(current_weapon):
		current_weapon.queue_free()
		current_weapon = null

	var weapon := base_weapon_scene.instantiate() as BaseWeapon

	if weapon == null:
		return

	weapon_holder.add_child(weapon)
	current_weapon = weapon
	weapon.setup(data)
	
	GameState.saved_weapon = data

func _ready() -> void:
	add_to_group("playerTarget")

	# HP se přenáší mezi scénami přes GameState
	if GameState.current_hp < 0:
		current_hp = max_hp
	else:
		current_hp = GameState.current_hp
	GameState.set_hp(current_hp, max_hp)

	if GameState.saved_weapon != null:
		equip_weapon(GameState.saved_weapon)
	else:
		equip_weapon(starting_weapon)

	hp_changed.emit(current_hp, max_hp)

#Attack
func attack() -> void:
	if is_dead:
		return

	if current_weapon == null:
		return

	if not current_weapon.can_attack:
		return

	current_weapon.play_swing()
	current_weapon.attack()
func die() -> void:
	is_dead = true
	is_hit = false
	velocity = Vector2.ZERO
	animated_sprite.play("dead")
	if current_weapon != null:
		current_weapon.hide()
	GameState.current_hp = -1   # po smrti začne další život s plným HP
	
#Take Damage
func take_damage(amount: int) -> void:
	if is_dead:
		return
		
	damage.play()

	current_hp = max(current_hp - amount, 0)
	hp_changed.emit(current_hp, max_hp)
	GameState.set_hp(current_hp, max_hp)
	
	if current_hp <= 0:
		die()
		return

	is_hit = true
	animated_sprite.play("hit")

	var my_hit_time := Time.get_ticks_msec()
	last_hit_time = my_hit_time

	await get_tree().create_timer(hit_duration).timeout

	# pokud mezitím přišel další zásah, ten se postará o návrat
	if is_dead or last_hit_time != my_hit_time:
		return
	is_hit = false

func _input(event: InputEvent) -> void:
	if is_dead:
		return

	if event.is_action_pressed("attack"):
		attack()
	if event.is_action_pressed("hurt"):
		take_damage(10)
