extends StaticBody3D

var is_open: bool = false

@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var mesh: MeshInstance3D = $MeshInstance3D

func toggle_door() -> void:
	is_open = !is_open

	if is_open:
		mesh.visible = false
		collision.disabled = true
		print("Door disappeared")
	else:
		mesh.visible = true
		collision.disabled = false
		print("Door came back")
