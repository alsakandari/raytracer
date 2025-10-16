package main

import "core:mem"
import "vendor:sdl2"

main :: proc() {
	window := sdl2.CreateWindow("Ray Tracer", 0, 0, 800, 600, {.RESIZABLE})

	world: []Hittable = {
		Sphere{radius = 0.5, center = {0, 1, -1}, albedo = {255, 0, 0}},
		Sphere{radius = 0.5, center = {0, 0, -1}, albedo = {0, 255, 0}},
		Sphere{radius = 0.5, center = {0, -1, -1}, albedo = {0, 0, 255}},
	}

	event: sdl2.Event

	for event.type != .QUIT {
		sdl2.PollEvent(&event)

		surface := sdl2.GetWindowSurface(window)

		width, height := f32(surface.w), f32(surface.h)

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
					distance = 0h7ff00000_00000000,
				}

				intersected_at_all := false

				for hittable in world {
					record, intersected := ray_hit(ray, hittable)

					if intersected && record.distance < closest_record.distance {
						closest_record = record
						intersected_at_all = true
					}
				}

				if intersected_at_all {
					albedo := closest_record.albedo.bgr

					mem.copy_non_overlapping(color, &albedo, len(albedo))
				}
			}
		}

		sdl2.UpdateWindowSurface(window)
	}
}

