class_name SwappableWeapon
extends Node2D

# para escoger el arma
@export var WEAPON : PackedScene
@onready var COLLIDER = %CollisionShape2D
# senal para emitir cual arma este disponible
var currentWeapon : Weapon
var switchable_weapon : Weapon
# node para contener el arma tipo Weapon
var weapon_node


func _ready() -> void:
	
	if WEAPON:
		weapon_node = WEAPON.instantiate()
		# verifica que el Scene elegido es de clase Weapon
		if weapon_node is Weapon:
			currentWeapon = weapon_node
			add_child(weapon_node)
		else:
			push_warning("Scene {" + weapon_node.scene_file_path + "} is not Weapon")
			# se borra si no contiene Weapon
			queue_free()


func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	# si el jugador entra el area, puede agarrar el arma
	if body is Player:
		body.can_grab_weapon = true
		# cambia el valor pa que el jugador agarre el arma correcta
		body.switchable_weapon = currentWeapon
		switchable_weapon = body.currentWeapon
		# conecta la senal del jugador y la funcion swap_weapon (de este codigo) solo cuando esta dentro del area
		body.weapon_switched.connect(swap_weapon)

func _on_area_2d_body_exited(body: Node2D) -> void:
	# si el jugador se va, ya no puede agarrar el arma
	if body is Player:
		body.can_grab_weapon = false
		body.switchable_weapon = null
		switchable_weapon = null
		# disconecta la senal cuando el jugador se va del area
		body.weapon_switched.disconnect(swap_weapon)
	
func swap_weapon() -> void:
	print(get_child_count())
	# destruye arma que esta en el piso
	remove_child(currentWeapon)
	
	# produce arma nueva en el piso
	var weaponRes = load(switchable_weapon.scene_file_path)
	currentWeapon = weaponRes.instantiate()
	add_child(currentWeapon)
	
	# es necesario hacer esto para evitar un bug 
	# que no permite cambiar armas sin salir del Area2D
	reset_collider()
	
func reset_collider() -> void:
	COLLIDER.disabled = true
	COLLIDER.disabled = false
	
