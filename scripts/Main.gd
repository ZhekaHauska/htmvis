extends Node

export var data_path = ''

var info_data
var data
var chunk = 0
var chunk_step = 0
var step = 0


func _ready():
	$GUI/Settings.popup()


func _input(_event):
	if Input.is_action_pressed("next_step"):
		next_step(1)
	
	if Input.is_action_pressed("prev_step"):
		next_step(-1)
	
	if Input.is_action_just_pressed("settings"):
		$GUI/Settings.popup()
		print('settings')
	

func next_step(inc):
	step += inc
	chunk_step += inc
	
	if chunk_step >= len(data['cells']):
		chunk += 1
		var chunks = find_data_chunks()
		
		if chunk >= len(chunks):
			chunk = 0
			data = load_json_data(chunks[chunk])
		
		chunk_step = 0
		
	elif chunk_step < 0:
		chunk -= 1
		var chunks = find_data_chunks()
		
		if chunk < 0:
			chunk = len(chunks) - 1
			data = load_json_data(chunks[chunk])
			
		chunk_step = len(data['cells']) - 1
		
	$Layer.update(data['cells'][chunk_step])
	$GUI/GeneralInfo.text = \
	"""
	Step: %s  Forward: %s  Context: %s  Feedback: %s 
	""" % [
		step, 
		data['symbols']['forward'][chunk_step],
		data['symbols']['context'][chunk_step],
		data['symbols']['feedback'][chunk_step],
	]

	
func find_data_chunks():
	var dir = Directory.new()
	
	if dir.open('%s/stream'% data_path) == OK:
		dir.list_dir_begin()
		
		var chunks = []
		 
		var file_name = dir.get_next()
		# find all chunks
		while file_name != "":
			if file_name.ends_with('.json'):
			
				var path = dir.get_current_dir()
				chunks.append('%s/%s' % [path, file_name])
				
			file_name = dir.get_next()
		
		# sort chunks
		chunks.sort_custom(self, 'chunk_sort_key')
		
		return chunks
	else:
		print('Data is not found.')
		
func chunk_sort_key(a: String, b: String):
	a = a.split('_')[-1].split('.')[0]
	b = b.split('_')[-1].split('.')[0]
	return int(a) < int(b)
	

func load_json_data(path):
	var file = File.new()
	
	file.open(path, File.READ)
	
	var json_string = file.get_as_text()
	
	var parse_result = JSON.parse(json_string)
	
	var parse_data = parse_result.result
	
	file.close()
	
	return parse_data


func _on_Settings_confirmed():
	data_path = $GUI/Settings/VBoxContainer/PathContainer/DataPath.text
	
	chunk = 0
	chunk_step = 0
	step = 0
	
	var dir = Directory.new()
	
	if dir.open(data_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with('info.json'):
				var path = dir.get_current_dir()
				info_data = load_json_data('%s/%s' % [path, file_name])
				
				print('Info file found: %s' % file_name)
				break
			else:
				file_name = dir.get_next()
		
		if file_name == "":
			print('Info file not found in %s' % data_path)
		else:
			var chunks = find_data_chunks()
			data = load_json_data(chunks[chunk])
			
			$Layer.initialize(info_data)
			next_step(0)
			
			
	else:
		print('Error loading data.')


func _on_Browse_pressed():
	$GUI/FileDialog.popup()
