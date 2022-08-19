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
	var cell_data = [[], [], []]
	
	for cell in layer_data:
		cell_data[cell['type']].append(cell)
		
	$LocalCells.update_cells(cell_data[0])
	$ContextCells.update_cells(cell_data[1])
	$FeedbackCells.update_cells(cell_data[2])
	
