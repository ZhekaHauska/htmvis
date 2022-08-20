extends Spatial

signal selected(cell_data)

var state = 0
var shared_receptive_fields = 0
var is_selected = false
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
	var layer = get_node("/root/Main/Layer")
	self.connect("selected", layer, "_on_Cell_selected")
	var gui = get_node("/root/Main/GUI")
	self.connect("selected", gui, "_on_Cell_selected")
	var cell_info_panel = get_node("/root/Main/GUI/CellInfo")
	cell_info_panel.connect("popup_hide", self, "_on_CellInfo_hide")

func add_to_receptive_field():
	shared_receptive_fields += 1
	# draw hint that the cell in receptive field
	if shared_receptive_fields == 1:
		$InReceptiveField.visible = true

func reset_receptive_field():
	shared_receptive_fields = 0
	$InReceptiveField.visible = false

func set_selected(value):
	# draw hint that the cell is selected
	if value and (is_selected != value):
		$AnimationPlayer.play("selected")
	elif (not value) and (is_selected != value):
		$AnimationPlayer.play_backwards("selected")
	
	is_selected = value

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
			set_selected(true)


func _on_CellInfo_hide():
	set_selected(false)
