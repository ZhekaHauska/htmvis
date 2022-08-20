extends Spatial

signal update_selection

var layer_info
var layer_data
var selected_cell
var selected_segment
var union_selected_segments = []
	
	
func initialize(info):
	layer_info = info
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
	
	
func update(data):
	layer_data = data
	var cell_data = [[], [], []]
	
	for cell in layer_data:
		cell_data[cell['type']].append(cell)
		
	$LocalCells.update_cells(cell_data[0])
	$ContextCells.update_cells(cell_data[1])
	$FeedbackCells.update_cells(cell_data[2])


func update_selection():
	var id_shift = [
			layer_info['local_range'][0],
			layer_info['context_range'][0],
			layer_info['feedback_range'][0]
		]
	var cells = [[], [], []]
	for synapse in selected_segment['data']['synapses']:
		var cell_id = synapse[1]
		var cell = layer_data[cell_id]
		var cell_type = cell['type']
		cells[cell_type].append(cell_id - id_shift[cell_type])
	
	$LocalCells.add_receptive_fields(cells[0])
	$ContextCells.add_receptive_fields(cells[1])
	$FeedbackCells.add_receptive_fields(cells[2])


func reset_selection():
	$LocalCells.reset_receptive_fields()
	$ContextCells.reset_receptive_fields()
	$FeedbackCells.reset_receptive_fields()
	

func _on_Cell_selected(cell_data):
	selected_cell = cell_data


func _on_Basal_item_selected(index):
	selected_segment = {
		'data': selected_cell['segments']['basal'][index],
		'type': 'basal'
	}
	reset_selection()
	update_selection()


func _on_Apical_item_selected(index):
	selected_segment = {
		'data': selected_cell['segments']['apical'][index],
		'type': 'apical'
	}
	reset_selection()
	update_selection()


func _on_Basal_item_rmb_selected(index, at_position):
	selected_segment = {
		'data': selected_cell['segments']['basal'][index],
		'type': 'basal'
	}
	union_selected_segments.append(selected_segment)
	update_selection()


func _on_Apical_item_rmb_selected(index, at_position):
	selected_segment = {
		'data': selected_cell['segments']['apical'][index],
		'type': 'apical'
	}
	union_selected_segments.append(selected_segment)
	update_selection()


func _on_Apical_nothing_selected():
	selected_segment = null
	reset_selection()


func _on_Basal_nothing_selected():
	selected_segment = null
	reset_selection()


func _on_CellInfo_popup_hide():
	selected_cell = null
	selected_segment = null
	reset_selection()
