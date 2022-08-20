extends Spatial

export var zoom_speed = 0.5
export var slide_speed = 0.5


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN:
			$Camera.size += zoom_speed
		elif event.button_index == BUTTON_WHEEL_UP:
			$Camera.size -= zoom_speed
	
	
func _process(delta):
	if Input.is_action_pressed("camera_left"):
		$Camera.translation.x -= slide_speed
	if Input.is_action_pressed("camera_right"):
		$Camera.translation.x += slide_speed
	if Input.is_action_pressed("camera_up"):
		$Camera.translation.y += slide_speed
	if Input.is_action_pressed("camera_down"):
		$Camera.translation.y -= slide_speed
	
