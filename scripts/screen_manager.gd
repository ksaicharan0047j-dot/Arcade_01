extends Node

func set_landscape():
	DisplayServer.window_set_size(Vector2i(1152,648))
func set_portrait():
	DisplayServer.window_set_size(Vector2i(648,1152))
