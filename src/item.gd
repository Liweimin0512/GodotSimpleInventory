extends MarginContainer

@export var item_res: ItemResource

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func _ready() -> void:
	item_res = item_res.duplicate()
	texture_rect.texture = item_res.icon
	if item_res.stackable <= 1:
		label.hide()
	else:
		label.text = str(item_res.quantity)
	tooltip_text = item_res.name + " : " + item_res.description
	get_parent().item = self
