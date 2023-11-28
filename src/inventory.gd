extends Control

@onready var label_weight: Label = %label_weight
@onready var btn_decompose: Button = %btn_decompose
@onready var btn_pack: Button = %btn_pack
@onready var grid_container: GridContainer = %GridContainer
@onready var tab_bar: TabBar = %TabBar
@onready var btn_close: Button = %btn_close

var selected_slot : Control:
	set(value):
		if selected_slot:
			selected_slot.disselected()
		selected_slot = value
		if selected_slot:
			selected_slot.selected()

var items : Array = []

func _ready() -> void:
	items.resize(20)
	var index = 0
	for slot in grid_container.get_children():
		slot.pressed.connect(_on_slot_pressed.bind(slot))
		if slot.item:
			items[index] = slot.item
		index += 1

func update_display(items: Array) -> void:
	clear_slot()
	for index in items.size():
		var slot = grid_container.get_child(index)
		slot.item = items[index]

func add_item(item) -> void:
	var index = get_empty_index()
	if index != -1:
		items[index] = item
	update_display(items)

func remove_item(index) -> void:
	items.remove_at(index)
	update_display(items)
	
func get_item(index) -> Control:
	return items[index]

func get_empty_index() -> int:
	for index in items.size():
		if items[index] == null:
			return index
	return -1

func get_slot(index: int) -> Control:
	return grid_container.get_child(index)

func filter_items_by_category(category: int) -> void:
	selected_slot = null
	if category == 0:
		update_display(items)
		return
	var filter_items : Array = items.filter(
		func(item):
			if item == null: return false
			return item.item_res.category == category
	)
	update_display(filter_items)

func clear_slot() -> void:
	for slot in grid_container.get_children():
		slot.item = null

## 背包整理
func pack_items():
	# 先合并相同道具，然后按类型排序，最后优化空格
	merge_similar_items()
#	sort_items_by_type()
#	optimize_spaces()
	update_display(items)

## 合并相同道具
func merge_similar_items():
	var temp_items = items.duplicate()
	for i in range(temp_items.size()):
		var item = temp_items[i]
		if item == null:
			continue
		for j in range(i + 1, temp_items.size()):
			var other_item = temp_items[j]
			if other_item != null and item.can_merge_with(other_item):
				item.merge(other_item)
				temp_items[j] = null
	items = temp_items.filter(func(i): return i != null)
	items.resize(20)

## 按类型排序
func sort_items_by_type():
	items.sort_custom(
		func(a, b):
			return a.item_res.category < b.item_res.category
	)

## 优化空格
func optimize_spaces():
	# 将所有道具移向背包的顶部或底部
	items = items.filter(func(i): i != null)
	items.resize(20)

func _on_slot_pressed(slot):
	selected_slot = slot

func _on_btn_decompose_pressed() -> void:
	if selected_slot != null and selected_slot.item != null:
		selected_slot.item.queue_free()

func _on_btn_pack_pressed() -> void:
	pack_items()

func _on_tab_bar_tab_changed(tab: int) -> void:
	filter_items_by_category(tab)
