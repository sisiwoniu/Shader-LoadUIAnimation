#ifndef SHAPE_AND_MATH_G_INCLUDED
#define SHAPE_AND_MATH_G_INCLUDED

#define PI 3.141592653589793

half circle(fixed2 Pos) {
	return dot(Pos, Pos);
}

half circle(fixed2 Pos, fixed Radius) {
	return length(Pos) - Radius;
}

//ë»â~
half ellipse(fixed2 Pos, fixed2 R, fixed Size) {
	return length(Pos / R) - Size;
}

//éläp
half rectangle(fixed2 Pos, fixed2 Size) {
	return max(abs(Pos.x) - Size.x, abs(Pos.y) - Size.y);
}

//ïHå`
half rhombus(fixed2 Pos, fixed Size) {
	return abs(Pos.x) + abs(Pos.y) - Size;
}

half heart(fixed2 Pos, fixed Size) {
	Pos.x = 1.2 * Pos.x - sign(Pos.x) * Pos.y * 0.55;

	return length(Pos) - Size;
}

//NÇÕäpÇÃêî
half polygon(fixed2 Pos, int N, fixed Size) {
	half a = atan2(Pos.y, Pos.x) + PI;

	half r = 2 * PI / N;

	return cos(floor(0.5 + a / r) * r - a) * length(Pos) - Size;
}

//Size == ëÂÇ´Ç≥ÅAWidth = ringÇÃëæÇ≥
half ring(fixed2 Pos, fixed Size, fixed Width) {
	return abs(length(Pos) - Size) + Width;
}

//N = 5 T = 0.5ÇÕÉXÉ^Å[
half star(fixed2 Pos, fixed N, fixed T, fixed Size) {
	fixed a = 2 * PI / N * 0.5;

	fixed c = cos(a);

	fixed s = sin(a);

	fixed2 r = mul(Pos, fixed2x2(c, -s, s, c));

	return (polygon(Pos, N, Size) - polygon(r, N, Size) * T) / (1 - T);
}

fixed2 rotation2D(fixed2 Pos, fixed Angle) {
	return fixed2(Pos.x * cos(Angle) - Pos.y * sin(Angle), Pos.x * sin(Angle) + Pos.y * cos(Angle));
}

fixed random2D(fixed2 Pos) {
	return frac(sin(dot(Pos, fixed2(12.9898, 78.233))) * 43758.5453);
}

fixed2 random2DR2(fixed2 Pos) {
	Pos = fixed2(dot(Pos, fixed2(127.1, 311.7)), dot(Pos, fixed2(269.5, 183.3)));

	return -1 + 2 * frac(sin(Pos) * 43758.5453123);
}

fixed blocknoise(fixed2 Pos) {
	return random2D(floor(Pos));
}

fixed valuenoise(fixed2 Pos) {
	fixed2 i_uv = floor(Pos);

	fixed2 f_uv = frac(Pos);

	fixed v00 = random2D(i_uv);

	fixed v01 = random2D(i_uv + fixed2(0, 1));

	fixed v10 = random2D(i_uv + fixed2(1, 0));

	fixed v11 = random2D(i_uv + fixed2(1, 1));

	fixed2 uv = f_uv * f_uv * (3 - 2 * f_uv);

	fixed v0010 = lerp(v00, v10, uv.x);

	fixed v0111 = lerp(v01, v11, uv.x);

	return lerp(v0010, v0111, uv.y);
}

fixed perlinnoise(fixed2 Pos) {
	fixed2 i_uv = floor(Pos);

	fixed2 f_uv = frac(Pos);

	fixed2 uv = f_uv * f_uv * (3 - 2 * f_uv);

	fixed v00 = random2DR2(i_uv);

	fixed v01 = random2DR2(i_uv + fixed2(0, 1));

	fixed v10 = random2DR2(i_uv + fixed2(1, 0));

	fixed v11 = random2DR2(i_uv + fixed2(1, 1));

	fixed v0010 = lerp(dot(v00, f_uv), dot(v10, f_uv - fixed2(1, 0)), uv.x);

	fixed v0111 = lerp(dot(v01, f_uv - fixed2(0, 1)), dot(v11, f_uv - fixed2(1, 1)), uv.x);

	return lerp(v0010, v0111, uv.y) + 0.5;
}

#endif