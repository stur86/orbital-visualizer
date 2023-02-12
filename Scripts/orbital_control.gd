extends Node

var orbital: Orbital

signal new_quantum_numbers

func set_n(n: int):
	var l = orbital.l
	var m = orbital.m
	
	set_quantum_numbers(n, l, m)
	
func set_l(l: int):
	var n = orbital.n
	var m = orbital.m
	
	set_quantum_numbers(n, l, m)
	
func set_m(m: int):
	var n = orbital.n
	var l = orbital.l
	
	set_quantum_numbers(n, l, m)
	
func set_quantum_numbers(n: int, l: int, m: int):
	n = max(1, n)
	l = min(l, n-1)
	m = signi(m)*min(abs(m), l)
	
	orbital.n = n
	orbital.l = l
	orbital.m = m
	
	new_quantum_numbers.emit(n, l, m)
