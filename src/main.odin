package main

import "core:fmt"

main :: proc() {
	sphere: Hittable = Sphere {
		radius = 1,
		center = {0, 0, 5},
	}

	ray: Ray = {
		origin    = {0, 0, 0},
		direction = {0, 0, 1},
	}

	found, record := ray_hit(ray, sphere)

	if found {
		fmt.println("Found a hit at distance:", record.distance)
	} else {
		fmt.println("Did not find a hit")
	}
}

