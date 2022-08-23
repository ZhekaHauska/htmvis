extends AcceptDialog

var config = ConfigFile.new()

func _ready():
	var err = config.load("user://settings.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		print("[%s] can't open config file" % err)
		return

	var path = config.get_value("Main", "data_path")
	$PathContainer/DataPath.text = path
	

func _on_Settings_confirmed():
	var path = $PathContainer/DataPath.text
	config.set_value("Main", "data_path", path)
	config.save("user://settings.cfg")


func _on_FileDialog_dir_selected(dir):
	$PathContainer/DataPath.text = dir
