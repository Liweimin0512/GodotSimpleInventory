extends MarginContainer

@onready var reference_rect: ReferenceRect = $ReferenceRect
@onready var color_rect: ColorRect = %ColorRect
@onready var item_tile: MarginContainer = $item_tile

var item = null:
	set(value):
		item = value
		if item != null:
			item_tile.update_display(item)
			item_tile.show()
		else:
			item_tile.hide()
signal pressed

func _ready() -> void:
	self.gui_input.connect(_on_gui_input)

func selected() -> void:
	reference_rect.show()
	color_rect.color = Color.WHITE

func disselected() -> void:
	reference_rect.hide()
	color_rect.color = Color.BLACK

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			pressed.emit()
