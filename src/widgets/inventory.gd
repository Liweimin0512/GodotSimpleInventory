extends Control

## 分解按钮
@onready var btn_decompose: Button = %btn_decompose
## 整合按钮
@onready var btn_pack: Button = %btn_pack
## 背包孔网格
@onready var grid_container: GridContainer = %GridContainer
## 筛选道具的选项卡
@onready var tab_bar: TabBar = %TabBar
## 退出按钮
@onready var btn_close: Button = %btn_close

var c_inventory : C_Inventory:
	set(value):
		if c_inventory:
			c_inventory.item_changed.disconnect(_on_item_changed)
			var index = 0
			for slot in grid_container.get_children():
				slot.pressed.disconnect(_on_slot_pressed.bind(index))
				index += 1
		c_inventory = value
		if c_inventory:
			c_inventory.item_changed.connect(_on_item_changed)
			var index = 0
			for slot in grid_container.get_children():
				slot.pressed.connect(_on_slot_pressed.bind(index))
				slot.item = c_inventory.items[index]
				index += 1
## 当前选中的道具槽
var selected_index : int = 0:
	set(value):
		var slot = get_slot(selected_index)
		slot.disselected()
		selected_index = value
		slot = get_slot(selected_index)
		slot.selected()

## 当前选中的类型
var current_category: int = 0

## 开启背包
func open() -> void:
	selected_index = 0
	tab_bar.current_tab = 0
	self.show()

## 切换分类页签
func switch_category_tab(tab: int) -> void:
	selected_index = 0
	current_category = tab
	update_display()

## 获取分类的道具
func get_category_items() -> Array[Item]:
	var items = c_inventory.items.duplicate()
	if current_category == 0:
		return items
	var filter_items : Array = items.filter(
		func(item: Item):
			if item == null: return false
			return item.category == current_category
	)
	filter_items.resize(c_inventory.MAX_SLOT_COUNT)
	return filter_items

## 更新显示
func update_display() -> void:
	var items : Array[Item] = get_category_items()
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
	switch_category_tab(tab)

func _on_btn_close_pressed() -> void:
	self.hide()

func _on_item_changed() -> void:
	update_display()
