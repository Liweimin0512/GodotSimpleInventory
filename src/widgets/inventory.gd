extends Control

@onready var label_weight: Label = %label_weight
@onready var btn_decompose: Button = %btn_decompose
@onready var btn_pack: Button = %btn_pack
@onready var grid_container: GridContainer = %GridContainer
@onready var tab_bar: TabBar = %TabBar
@onready var btn_close: Button = %btn_close

var c_inventory : C_Inventory:
	set(value):
		if c_inventory:
			c_inventory.item_changed.disconnect(_on_item_changed)
		c_inventory = value
		if c_inventory:
			c_inventory.item_changed.connect(_on_item_changed)

## 当前选中的道具槽
var selected_index : int = 0:
	set(value):
		var slot = get_slot(selected_index)
		slot.disselected()
		c_inventory.selected_index = value
		slot = get_slot(selected_index)
		slot.selected()
	get:
		return c_inventory.selected_index

## 当前选中的类型
var current_category: int = 0:
	set(value):
		c_inventory.current_category = value
	get:
		return current_category

func open() -> void:
	self.show()
	selected_index = 0
	var index = 0
	for slot in grid_container.get_children():
		slot.pressed.connect(_on_slot_pressed.bind(index))
		slot.item = c_inventory.items[index]
		index += 1

## 更新显示
func update_display() -> void:
	var items = c_inventory.filter_items_by_category()
	for index in items.size():
		var slot = grid_container.get_child(index)
		slot.item = items[index]

## 获取槽
func get_slot(index: int) -> Control:
	return grid_container.get_child(index)

func _on_slot_pressed(index: int) -> void:
	selected_index = index

func _on_btn_decompose_pressed() -> void:
	c_inventory.remove_item(selected_index)

func _on_btn_pack_pressed() -> void:
	c_inventory.pack_items()

func _on_tab_bar_tab_changed(tab: int) -> void:
	current_category = tab
	update_display()

func _on_btn_close_pressed() -> void:
	self.hide()

func _on_item_changed() -> void:
	update_display()
