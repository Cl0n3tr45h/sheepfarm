extends Area2D

signal scene_changed()

export(String, FILE, "*.tscn") var path

var entered = true

onready var animationPlayer = $AnimationPlayer
onready var black = $Control/black

func _ready():
	var playerNode = get_tree().get_root().find_node("Player", true, false)
	#catch signals
	playerNode.connect("moved", self, "_on_Player_moved")
	

func overlapsPlayer():
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			return true
	return false

func _on_Player_moved():
	var newEntered  = overlapsPlayer()
	if(!entered and newEntered):
		change_scene()
	else:
		entered = newEntered

func change_scene():
	#$Control.show()
	yield(get_tree().create_timer(0.5), "timeout")
	animationPlayer.play("fade")
	yield(animationPlayer,"animation_finished")
	get_tree().change_scene(path)
	animationPlayer.play_backwards("fade")
	yield(animationPlayer,"animation_finished")
	emit_signal("scene_changed")
