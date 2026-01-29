extends Node3D

@export var fire_rate: float = 0.5
@export var projectile_lifetime: float = 4.0
@export var projectile_prefab: PackedScene
@export var rotate_to_mouse: Node3D
@export var fire_point: Node3D


const VFX_PROJECTILE_01 = preload("uid://kci7jweltgf2")
const VFX_PROJECTILE_01_IMPACT = preload("uid://dw3s15ubej8p7")
const VFX_PROJECTILE_01_MUZZLE = preload("uid://ukbl6m6hc7o")
const AO_E_01 = preload("uid://ccbxgocynnlbu")
const AO_E_02 = preload("uid://nef8v330dc3f")



var can_fire: bool = true

func _process(_delta):
	if Input.is_action_pressed("fire") and can_fire:
		fire_projectile()
		can_fire = false
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true

func fire_projectile():
	if projectile_prefab and fire_point and rotate_to_mouse:
		var projectile_instance = projectile_prefab.instantiate()
		get_parent().add_child(projectile_instance)
		projectile_instance.global_position = fire_point.global_position
		projectile_instance.set_fire_point(fire_point.global_transform.origin)  		
		
		var direction = -rotate_to_mouse.global_transform.basis.z.normalized()
		projectile_instance.direction = direction		
		projectile_instance.look_at(fire_point.global_position + -direction)
		
		await get_tree().create_timer(projectile_lifetime).timeout		
		if projectile_instance:
			projectile_instance.queue_free()
