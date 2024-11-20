# crea una clase para las armas
# asi podremos diferenciar armas y otros nodes
# cada arma tendra este progama atado u otro que extiende la clase Weapon

class_name Weapon
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fire() -> void:
	print("boom! ~~~> " + get_node(".").name)
