extends Node2D
var p: Parallax2D
func _ready() -> void:
	var lvl: Node2D = load("res://src/levels/main_level.tscn").instantiate()
	add_child(lvl)
	p = lvl.get_node("Background/Dock")
	for i in 3: await get_tree().process_frame
	p.repeat_times = 14
	p.autoscroll = Vector2(-20, 0)
	for n in 4:
		for i in 20: await get_tree().process_frame
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("user://shot_fix%d.png" % n)
		print("fix", n, " pos:", p.global_position)
	get_tree().quit()
