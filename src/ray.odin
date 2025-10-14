package main

import "core:math/linalg"

Sphere :: struct {
	center: [3]f32,
	radius: f32,
}

Hittable :: union {
	Sphere,
}

HitRecord :: struct {
	distance: f32,
}

Ray :: struct {
	origin:    [3]f32,
	direction: [3]f32,
}

ray_point :: proc(ray: Ray, t: f32) -> [3]f32 {
	return ray.origin + t * ray.direction
}

ray_hit :: proc(ray: Ray, hittable: Hittable) -> (found : bool, record: HitRecord) {
	switch entity in hittable {
	case Sphere:
		shifted_origin := ray.origin - entity.center

		// Coefficients of the quadratic equation
		a := linalg.dot(ray.direction, ray.direction)
		b := 2 * linalg.dot(ray.direction, shifted_origin)
		c := linalg.dot(shifted_origin, shifted_origin) - (entity.radius * entity.radius)

		discriminant := b * b - (4 * a * c)

		found = discriminant > 0

		if found {
			record.distance = (-b + linalg.sqrt(discriminant)) / (2 * a)
		}
	}

	return
}

