extends Spatial

var state = 0

export var colors = [
	Color(0, 0, 0, 1),
	Color(1, 0, 0, 1),
	Color(0, 1, 0, 1),
	Color(0, 0, 1, 1),
	Color(0, 0.5, 0.5, 1),
	Color(0.5, 0, 0.5, 1),
	Color(0.5, 0.5, 0, 1),
	Color(0.75, 0.25, 0.25, 1),
]

func set_state(value):
	state = value
	
	var material = $CSGMesh.get_material()
	material.albedo_color = colors[state]
	material.emission = colors[state]
	$CSGMesh.set_material(material)
	
	if state != 0:
		$AnimationPlayer.play("light_up")
