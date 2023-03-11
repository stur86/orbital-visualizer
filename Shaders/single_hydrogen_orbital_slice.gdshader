shader_type spatial;
render_mode unshaded; 
render_mode cull_disabled;

uniform float side = 20.0;
uniform float density_scaling = 20.0;
uniform float a0 = 1.0;
uniform int n = 1;
uniform int l = 0;
uniform int m = 0;

int factorial_ratio(int n0, int n1) {
	int ans = 1;
	for (int i = n0+1; i <= n1; ++i) {
		ans *= i;
	}
	return ans;
}

int factorial(int n0) {
	return factorial_ratio(1, n0);
}

int binomial(int a, int b) {
	return factorial_ratio(b, a)/factorial(a-b);
}

float laguerre(float x, int a, int k) {
	float l0 = 1.;

	if (k == 0)
		return l0;

	float l1 = 1.+float(a)-x;

	if (k == 1)
		return l1;
		
	float l2 = 0.;
		
	for (int i = 1; i < k; ++i) {
		l2 = ((float(2*i+1+a)-x)*l1-float(i+a)*l0)/float(i+1);
		l0 = l1;
		l1 = l2;
	}
	
	return l2;
}

float legendre(float x, int l0, int m0) {
	float ans = 0.0;
	float term = 0.0;
	int min_i = int(ceil(float(l0+m0)/2.));
	
	for (int i = min_i; i <= l0; ++i) {
		term = float(binomial(l0, i)*factorial_ratio(2*i-l0-m0, 2*i));
		if ((l0-i)%2 == 1)
			term *= -1.;
		for (int j = 0; j < 2*i-l0-m0; ++j) {
			term *= x;
		}
		ans += term;
	}
	
	if (m0 != 0) {
		ans *= pow(1.-x*x, float(m0)/2.);
	}
	
	ans *= pow(2., -float(l0))/float(factorial(l0));
	
	return ans;
}

float spharm2(int l0, int m0, float cth, float phi) {
	float ans = 0.0;
	int am0 = abs(m0);
	
	float P = legendre(cth, l0, am0);
	
	ans = pow(P, 2.0);
	
	if (am0 > 0) {
		float mphi = float(am0)*phi;
		if (m0 > 0) {
			ans *= pow(cos(mphi), 2.0);
		}
		else {
			ans *= pow(sin(mphi), 2.0);
		}
	}
	
	ans *= float(2*l0+1)/(4.*PI);
	ans *= 1.0/float(factorial_ratio(l0-am0, l0+am0));
	ans *= am0 > 0? 2. : 1.;
		
	return ans;
}

float density(vec3 pos, int n0, int l0, int m0) {
	float r = length(pos);
	float cth = pos.y/r;
	float phi = atan(pos.z, pos.x);
	float rho = 2.*r/float(n);
	
	float L = laguerre(rho, 2*l+1, n-l-1);
	float Y2 = spharm2(l, m, cth, phi);
	float dens = exp(-rho)*pow(rho, 2.*float(l))*pow(L, 2)*Y2;
	dens *= float(factorial(n-l-1))/(2.0*float(n*factorial(n+l)));
	// Normalization
	//dens *= 8./(pow(float(n)*a0, 3.0));
	
	return dens;
}

void fragment() {
	vec3 xyz = (
		(UV.x-0.5)*MODEL_MATRIX[0].xyz+
		(UV.y-0.5)*MODEL_MATRIX[1].xyz+
		MODEL_MATRIX[3].xyz
	)*side;
	
	float dens = density(xyz/a0, n, l, m)*density_scaling*100.;
	
	ALBEDO = vec3(smoothstep(0.045, 0.5, dens), 
	smoothstep(0.4, 1.0, dens), 0);
	ALPHA = smoothstep(0.5, 0.45, length(xyz)/side)*0.8;
}
