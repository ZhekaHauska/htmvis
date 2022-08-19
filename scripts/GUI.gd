extends Control

var segment_states = ['inactive', 'active', 'matching']

func _on_Cell_selected(cell_data):
	$CellInfo.popup()
	
	var segments = [
		cell_data['segments']['basal'],
		cell_data['segments']['apical']
	]
	# fill containers
	var containers = [
			$CellInfo/VBoxContainer/Segments/Basal,
			$CellInfo/VBoxContainer/Segments/Apical
		]
	
	$CellInfo/VBoxContainer/GeneralInfo.text = \
	"""
	Cell id: %s 
	Active: %s
	Winner: %s
	Predicted: %s
	Type: %s
	""" % [
			cell_data['id'],
			cell_data['active'], 
			cell_data['winner'], 
			cell_data['predictive'],
			cell_data['type']
		]
	
	for i in range(len(segments)):
		containers[i].clear()
		for segment in segments[i]:
			var text = "%s %s" % [
				segment['id'], 
				segment_states[segment['state']]
				]
			containers[i].add_item(text, null, true)
