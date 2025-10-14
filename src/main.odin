package main

import "core:math"
import "vendor:sdl2"

main :: proc() {
	hittables: []Hittable = {
		Sphere{radius = 0.5, center = {0, 1, -1}, albedo = {255, 0, 0}},
		Sphere{radius = 0.5, center = {0, 0, -1}, albedo = {0, 255, 0}},
		Sphere{radius = 0.5, center = {0, -1, -1}, albedo = {0, 0, 255}},
	}

	window := sdl2.CreateWindow("Ray Tracer", 0, 0, 800, 600, {.RESIZABLE})

	event: sdl2.Event

	for event.type != .QUIT {
		sdl2.PollEvent(&event)

		surface := sdl2.GetWindowSurface(window)

		width := f32(surface.w)
		height := f32(surface.h)

		aspect_ratio := width / height

		for y in 0 ..< surface.h {
			for x in 0 ..< surface.w {
				color := ([^]u8)(surface.pixels)[x * 4 + (surface.h - y - 1) * surface.pitch:]

				u := (f32(x) / width * 2 - 1) * aspect_ratio
				v := f32(y) / height * 2 - 1

				ray: Ray = {
					origin    = {0, 0, 1},
					direction = {u, v, -1},
				}

				closest_record: HitRecord = {
					distance = math.max(f32),
				}

				for hittable in hittables {
					record, intersected := ray_hit(ray, hittable)

					if intersected && record.distance < closest_record.distance {
						closest_record = record
					}
				}

				if closest_record.distance < math.max(f32) {
					color[0] = closest_record.albedo.b
					color[1] = closest_record.albedo.g
					color[2] = closest_record.albedo.r
					color[3] = 0
				}
			}
		}

		sdl2.UpdateWindowSurface(window)
	}
}

