extends Node

onready var pointsshow = $VBoxContainer/Label2
onready var next = $VBoxContainer/HBoxContainer/VBoxContainer2/Next
var mensager = preload("res://Actors/Menu/PlayerStatsMensager.tscn")

func _ready():
	Global._restore_points()

func _physics_process(delta):
	pointsshow.text = "You have " + str(Global.points_to_use) + " points to use"
	
func _on_Next_pressed():
	if Global.points_to_use == 0:
		var player_men = mensager.instance()._make(PlayerStats.new($VBoxContainer/HBoxContainer/VBoxContainer/SpeedSTatBarMenu/ProgressBar.value + 1
		,$VBoxContainer/HBoxContainer/VBoxContainer/LifeStatMenu/ProgressBar.value + 1
		,$VBoxContainer/HBoxContainer/VBoxContainer/Special/ProgressBar.value + 1
		,$VBoxContainer/HBoxContainer/VBoxContainer/AttackSTatBarMenu/ProgressBar.value + 1
		,$VBoxContainer/HBoxContainer/VBoxContainer/SizeStatBarMenu/ProgressBar.value + 1,
		0,
		0))
		player_men.name = "player_stats"
		get_parent().add_child(player_men)
		get_parent().add_child(load("res://Actors/Menu/EnemyPointsMenu.tscn").instance())
		print(player_men.player_stat.size)
		queue_free()
