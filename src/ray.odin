package main

import "core:math/linalg"

Sphere :: struct {
	radius: f32,
	center: [3]f32,
	albedo: [3]u8,
}

Hittable :: union {
	Sphere,
}

HitRecord :: struct {
	distance:     f32,
	intersection: [3]f32,
	normal:       [3]f32,
	albedo:       [3]u8,
}

Ray :: struct {
	origin:    [3]f32,
	direction: [3]f32,
}

ray_at :: proc(ray: Ray, t: f32) -> [3]f32 {
	return ray.origin + t * ray.direction
}

ray_hit :: proc(ray: Ray, hittable: Hittable) -> (record: HitRecord, intersected: bool) {
	switch entity in hittable {
	case Sphere:
		o := ray.origin - entity.center
		d := ray.direction
		r2 := entity.radius * entity.radius

		a := linalg.dot(d, d)
		b := linalg.dot(d, o)
		c := linalg.dot(o, o) - r2

		discriminant := b * b - a * c

		if discriminant < 0 {
			return
		}

		record.distance = (-b - linalg.sqrt(discriminant)) / a
		record.intersection = ray_at(ray, record.distance)
		record.normal = record.intersection - entity.center
		record.albedo = entity.albedo

		intersected = true
	}

	return
}

