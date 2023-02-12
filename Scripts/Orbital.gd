extends FogVolume

@export var a0: float = 0.5:
	get:
		return a0
	set(value):
		a0 = value
		material.set_shader_parameters("a0", a0)

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

@export var l: int = 0:
	get:
		return l;
	set(value):
		if (value > n-1 or value < 0):
			return # Unphysical
		l = value
		material.set_shader_parameter("l", l)

@export var m: int = 0:
	get:
		return m
	set(value):
		if (value > l or value < -l):
			return
		m = value
		material.set_shader_parameter("m", m)

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
