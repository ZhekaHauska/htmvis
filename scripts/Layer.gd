extends Spatial

func initialize(layer_info):
	var local_sizes = [layer_info['columns'], layer_info['cells_per_column'], 1]
	var context_sizes = [layer_info['columns'], layer_info['cells_per_column'], 1]
	var feedback_sizes = [layer_info['feedback_cells'], 1, 1]
			
	$local_cells.initialize(local_sizes)
	$context_cells.initialize(context_sizes)
	$feedback_cells.initialize(feedback_sizes)
	
	# pack arrays
	
	$local_cells.translation = self.translation
	$context_cells.translation = self.translation
	$feedback_cells.translation = self.translation
	
	var y_shift = $local_cells.bounding_box[1].y - $local_cells.bounding_box[0].y + 5
	
	var context_shift = Vector3(0, -y_shift, 0)
	$context_cells.translate(context_shift)
	$feedback_cells.translate(-context_shift)
	
	
func update(layer_data):
	var states = [[], [], []]
	
	for cell in layer_data:
		var state = '%s%s%s' % [
				int(cell['active']), 
				int(cell['winner']), 
				int(cell['predictive'])
			]
			
		state = bin2int(state)
		states[cell['type']].append(state)
		
	
	$local_cells.update_cells(states[0])
	$context_cells.update_cells(states[1])
	$feedback_cells.update_cells(states[2])


func bin2int(bin_str):
	var out = 0
	for c in bin_str:
		out = (out << 1) + int(c == "1")
	return out
	
