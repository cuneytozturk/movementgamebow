extends Control
var score_entries := []
@export var MAX_ENTRIES:= 8
@onready var type_container: VBoxContainer = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer
@onready var score_container: VBoxContainer = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2
@onready var run_score: Label = $score

@onready var label = preload("res://scenes/score_label.tscn")

func add_entry(entry_type: String, score: int):
	score_entries.append({ "type": entry_type, "score": score })
	# Keep only last 8
	if score_entries.size() > MAX_ENTRIES:
		score_entries.remove_at(0)

	_refresh_ui()

func _refresh_ui():
	for child in score_container.get_children():
		child.queue_free()
	for child in type_container.get_children():
		child.queue_free()
		
	for entry in score_entries:
		var type_label = label.instantiate()
		var score_label = label.instantiate()
		type_label.set_text(entry["type"])
		score_label.set_text(str(entry["score"]))
		type_container.add_child(type_label)
		score_container.add_child(score_label)
