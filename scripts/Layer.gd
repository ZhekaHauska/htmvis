extends Spatial

func initialize(layer_info):
	var local_sizes = [layer_info['columns'], layer_info['cells_per_column'], 1]
	var context_sizes = [layer_info['columns'], layer_info['cells_per_column'], 1]
	var feedback_sizes = [layer_info['feedback_cells'], 1, 1]
			
	$LocalCells.initialize(local_sizes)
	$ContextCells.initialize(context_sizes)
	$FeedbackCells.initialize(feedback_sizes)
	
	# pack arrays
	
	$LocalCells.translation = self.translation
	$ContextCells.translation = self.translation
	$FeedbackCells.translation = self.translation
	
	var y_shift = $LocalCells.bounding_box[1].y - $LocalCells.bounding_box[0].y + 5
	
	var context_shift = Vector3(0, -y_shift, 0)
	$ContextCells.translate(context_shift)
	$FeedbackCells.translate(-context_shift)
	
	
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
		
	
	$LocalCells.update_cells(states[0])
	$ContextCells.update_cells(states[1])
	$FeedbackCells.update_cells(states[2])


func bin2int(bin_str):
	var out = 0
	for c in bin_str:
		out = (out << 1) + int(c == "1")
	return out
	
