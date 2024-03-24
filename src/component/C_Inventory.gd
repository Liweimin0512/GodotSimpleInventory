extends Node
class_name C_Inventory

## 存放道具ItemResource的数组
@export var items : Array[Item] = []
## 槽上限
var MAX_SLOT_COUNT := 20

## 道具变化时发出此信号
signal item_changed

func _ready() -> void:
	items.resize(MAX_SLOT_COUNT)

## 添加道具
func add_item(item: Item) -> void:
	var index = get_empty_index()
	if index != -1:
		items[index] = item
		item_changed.emit()

## 删除道具
func remove_item(index: int) -> void:
	var item = items[index]
	if item:
		items[index] = null
		item_changed.emit()

## 获取道具
func get_item(index: int) -> Item:
	return items[index]

## 获取空的索引
func get_empty_index() -> int:
	for index in items.size():
		if items[index] == null:
			return index
	return -1

## 背包整理
func pack_items():
	# 先合并相同道具，然后按类型排序，最后优化空格
	merge_similar_items()
	sort_items_by_type()
	item_changed.emit()

## 合并相同道具
func merge_similar_items():
	var temp_items = items.duplicate()
	for i in range(temp_items.size()):
		var item : Item = temp_items[i]
		if item == null or item.is_stack_maxed():
			continue
		for j in range(i + 1, temp_items.size()):
			var other_item : Item = temp_items[j]
			if other_item != null and item.can_merge_with(other_item):
				# 检查堆叠上限
				item.merge(other_item)
				if other_item.quantity <= 0:
					temp_items[j] = null
	items = temp_items.filter(func(i): return i != null)
	items.resize(MAX_SLOT_COUNT)

## 按类型排序
func sort_items_by_type():
	var temp_items = items.filter(func(item): return item != null)
	temp_items.sort_custom(
		func(a, b):
			return a.category < b.category
	)
	items = temp_items
	items.resize(MAX_SLOT_COUNT)
