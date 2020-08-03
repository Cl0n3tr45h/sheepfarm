extends CanvasLayer


signal scene_changed()

export(String, FILE, "*.tscn") var path

onready var animationPlayer = $AnimationPlayer
onready var black = $Control/black

func _ready():
	$Control.hide()

func change_scene(delay = 0.5):
	$Control.show()
	yield(get_tree().create_timer(delay), "timeout")
	animationPlayer.play("fade")
	yield(animationPlayer,"animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animationPlayer.play_backwards("fade")
	yield(animationPlayer,"animation_finished")
	emit_signal("scene_changed")
