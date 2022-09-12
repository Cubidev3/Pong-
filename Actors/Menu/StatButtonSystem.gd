extends Button

onready var bar = $ProgressBar

func _disable_button(button: Button) -> void:
	button.disabled = true
	
func _habilitate_button(button: Button) -> void:
	button.disabled = false
	
func _ready():
	var plus = get_node("ProgressBar/Plus")
	connect("pressed", self, "_on_Minus_pressed")
	plus.connect("pressed",self,"_on_Plus_pressed")
	
func _on_Plus_pressed():
	print("gay")
	if Global.points_to_use > 0 and bar.value < bar.max_value:
		Global.points_to_use -= 1
		bar.value += 1
		_habilitate_button(self)
	if bar.value == bar.max_value:
		_disable_button($ProgressBar/Plus)
		
func _on_Minus_pressed():
	if bar.value > 0:
		Global.points_to_use += 1
		bar.value -= 1
		_habilitate_button($ProgressBar/Plus)
	if bar.value == 0:
		_disable_button(self)
