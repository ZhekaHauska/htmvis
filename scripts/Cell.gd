extends Spatial

signal selected(cell_data)

var state = 0
var cell

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

func _ready():
	var gui = get_node("/root/Main/GUI")
	self.connect("selected", gui, "_on_Cell_selected")

func set_cell_data(cell_data):
	cell = cell_data
	
	var val = '%s%s%s' % [
				int(cell['active']), 
				int(cell['winner']), 
				int(cell['predictive'])
			]
			
	state = bin2int(val)
	
	var material = $CellMesh.get_material()
	material.albedo_color = colors[state]
	material.emission = colors[state]
	$CellMesh.set_material(material)
	
	if state != 0:
		$AnimationPlayer.play("light_up")


func bin2int(bin_str):
	var out = 0
	for c in bin_str:
		out = (out << 1) + int(c == "1")
	return out


func _on_Area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("selected", cell)
