# crea una clase para los jugadores "Player"
# asi podras discernir entre jugadores y otros "cuerpos"/bodies/objetos

class_name Player
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# se refiere al node que contiene el arma
@onready var weaponHolder : Node2D = %node_pal_arma
# el arma en mano ahora
var currentWeapon : Weapon
# el arma disponible para cambiar
var switchable_weapon : Weapon
# se transmite cuando el jugador decide cambiar el arma
signal weapon_switched

# var que permite o prohibe que agarre arma
var can_grab_weapon : bool = false

func _ready() -> void:
	# chequea que el "node_pal_arma" contiene Weapon
	if weaponHolder.get_child_count() != 0 and weaponHolder.get_child(0) is Weapon:
		currentWeapon = weaponHolder.get_child(0)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("attack") and currentWeapon != null:
		currentWeapon.fire()
	# boton para cambiar armas es 'E'
	if event.is_action_pressed("action") and can_grab_weapon:
		print("switch weapons")
		swap_weapon()
		print(get_child_count())

# cambia el arma cargada
func swap_weapon() -> void:
	
	# recibida por el arma_cambiable node
	weapon_switched.emit()
	# destruye arma cargada
	weaponHolder.remove_child(currentWeapon)
	
	# produce nueva arma
	var weaponRes = load(switchable_weapon.scene_file_path)
	currentWeapon = weaponRes.instantiate()
	weaponHolder.add_child(currentWeapon)
	
	
