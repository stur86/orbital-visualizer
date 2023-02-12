extends Camera3D

@export var sensitivity: float = 0.01

var hinge: Node3D

var pos0: Vector3
var rot0: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	hinge = get_parent()
	
	pos0 = position
	rot0 = hinge.rotation

	set_process_input(true)
	
func _input(event):
	
	if event is InputEventMouseMotion:
		
		var dr = event.relative

		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			# Left button pressed: rotate
			hinge.global_rotate(global_transform.basis.y, dr.x*sensitivity)
			hinge.global_rotate(global_transform.basis.x, dr.y*sensitivity)
		elif event.button_mask == MOUSE_BUTTON_MASK_RIGHT:
			var dz = dr.y*sensitivity;
			dz = max(dz, -position.z)
			translate(Vector3.BACK*dz)
			hinge.global_rotate(global_transform.basis.z, dr.x*sensitivity)
	
func reset_view():
	position = pos0
	hinge.rotation = rot0
