extends Spatial

export var cell_scene_path = ''
export var steps = [0.0, 0.0, 0.0]

var cells = []
var bounding_box


func initialize(sizes):
	var cell_scene = load(cell_scene_path)
	var init_pos = self.translation
	var pos = self.translation
	
	for _i in range(sizes[2]):
		pos.x = init_pos.x
		for _j in range(sizes[0]):
			pos.y = init_pos.y
			for _k in range(sizes[1]):
				var cell = cell_scene.instance() 
				add_child(cell)
				cell.translation = pos
				cells.append(cell)
				
				pos.y += steps[1]
			pos.x += steps[0]
		pos.z += steps[2]
	
	bounding_box = [init_pos, pos]


func update_cells(states):
	for i in range(len(cells)):
		cells[i].set_state(states[i])

