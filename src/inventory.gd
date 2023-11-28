extends Control

@onready var label_weight: Label = %label_weight
@onready var btn_decompose: Button = %btn_decompose
@onready var btn_pack: Button = %btn_pack
@onready var grid_container: GridContainer = %GridContainer
@onready var tab_bar: TabBar = %TabBar
@onready var btn_close: Button = %btn_close

var drag_slot = null
var drag_item

func _ready() -> void:
	var i = 0
	for item_slot in grid_container.get_children():
		item_slot.mouse_entered.connect(_on_drag_started.bind(item_slot, i ))
		item_slot.mouse_exited.connect(_on_drag_ended.bind(item_slot, i ))
		i += 1

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() and drag_slot:
			drag_item = drag_slot.item
		if event.is_released() and drag_slot:
			pass
		drag_slot.item.global_position = event.global_position

func _on_drag_started(item_slot, index) -> void:
	print("_on_drag_started ", index)
	drag_slot = item_slot
	var item = item_slot.item
	if not item: return
	item.z_index = 128
#	item.global_position = item_slot.global_position

func _on_drag_ended(item_slot, index) -> void:
	print("_on_drag_ended ", index)
	if drag_slot == item_slot:
		drag_slot = null
