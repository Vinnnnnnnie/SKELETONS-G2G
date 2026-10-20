extends Control
signal start()
signal survival()
@export var skip_menu = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_down() -> void:
	self.visible = false
	emit_signal("start")
	


func _on_survival_button_down() -> void:
	self.visible = false
	emit_signal("survival")
