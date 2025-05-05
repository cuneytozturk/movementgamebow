extends CanvasLayer
@onready var label: Label = $Control/Label
@onready var progress_bar: ProgressBar = $Control/ProgressBar

func _process(delta: float) -> void:
	#label.text= str(Global.player.charge)
	progress_bar.value = Global.player.charge
