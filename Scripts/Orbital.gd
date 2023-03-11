@tool
extends FogVolume
class_name Orbital

@export var a0: float = 0.5:
	get:
		return a0
	set(value):
		a0 = value
		material.set_shader_parameter("a0", a0)
		$SectionPlane.mesh.material.set_shader_parameter("a0", a0)

@export var n: int = 1 :
	get:
		return n
	set(value):
		n = value
		# Compute appropriate box size
		var L = n*a0*12.0
		size = Vector3.ONE*L
		
		material.set_shader_parameter("n", n)
		material.set_shader_parameter("side", L)
		$SectionPlane.mesh.size = Vector2.ONE*L
		$SectionPlane.mesh.material.set_shader_parameter("n", n)
		$SectionPlane.mesh.material.set_shader_parameter("side", L)
		
@export var l: int = 0:
	get:
		return l;
	set(value):
		if (value > n-1 or value < 0):
			return # Unphysical
		l = value
		material.set_shader_parameter("l", l)
		$SectionPlane.mesh.material.set_shader_parameter("l", l)

@export var m: int = 0:
	get:
		return m
	set(value):
		if (value > l or value < -l):
			return
		m = value
		material.set_shader_parameter("m", m)
		$SectionPlane.mesh.material.set_shader_parameter("m", m)

@export var color: Color = Color.DEEP_SKY_BLUE:
	get: 
		return color
	set(value):
		color = value
		material.set_shader_parameter("emission_color", color)

@export var intensity: float = 1.0:
	get:
		return intensity
	set(value):
		intensity = value
		material.set_shader_parameter("density_scaling", intensity)
		$SectionPlane.mesh.material.set_shader_parameter("density_scaling", intensity)
		
@export var enable_section: bool = false:
	get:
		return enable_section
	set(value):
		enable_section = value
		material.set_shader_parameter("plane_cut", enable_section)
		_update_section_plane()

@export var section_normal: Vector3 = Vector3.RIGHT:
	get:
		return section_normal
	set(value):
		section_normal = value
		material.set_shader_parameter("plane_normal", value)
		_update_section_plane()

@export var section_offset: float = 0.0:
	get:
		return section_offset
	set(value):
		section_offset = value
		material.set_shader_parameter("plane_offset", value)
		_update_section_plane()


func _enter_tree():
	OrbitalControl.orbital = self
	
func _update_section_plane():
	var up = Vector3.UP
	if (section_normal == up):
		up = Vector3.FORWARD
	
	$SectionPlane.visible = enable_section
	$SectionPlane.look_at_from_position(
		section_normal.normalized()*section_offset,
		section_normal.normalized()*(section_offset+1),
		up
	)
	
