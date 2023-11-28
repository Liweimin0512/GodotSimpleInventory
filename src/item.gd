extends MarginContainer

@export var item_res: ItemResource

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func _ready() -> void:
	item_res = item_res.duplicate()
	get_parent().item = self
	update_display()

func update_display() -> void:
	texture_rect.texture = item_res.icon
	if item_res.stackable <= 1:
		label.hide()
	else:
		label.text = str(item_res.quantity)
	tooltip_text = item_res.name + " : " + item_res.description	

func merge(other_item) -> void:
	self.item_res.quantity += other_item.item_res.quantity
	other_item.queue_free()
	update_display()
	
func can_merge_with(other_item) -> bool:
	return self.item_res.name == other_item.item_res.name
