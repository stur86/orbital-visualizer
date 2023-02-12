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
