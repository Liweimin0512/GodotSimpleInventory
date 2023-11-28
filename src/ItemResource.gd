extends Resource
class_name ItemResource

enum ITEM_TYPE{
	NONE,
	CONSUMABLE,	# 消耗品
	EQUIPMENT,	# 装备
	MATERIAL,	# 材料
}

# Item的属性
@export var name = "道具名称"
@export var icon: Texture = null
@export var description = "道具描述"
@export var category : ITEM_TYPE = ITEM_TYPE.NONE # 如 "consumable", "equipment", "material" 等
@export var quantity = 1
@export var stackable := 1
@export var weight = 0
@export var attributes = {} # 存储属性如 {"strength": 10, "health": 50}

# 信号定义
signal used(item_instance)
signal moved(item_instance, new_position)
signal discarded(item_instance)
signal combined(item_instance, other_item)
signal split(item_instance, split_quantity)

# 构造函数
#func _init(_name, _icon, _description, _category, _attributes, _quantity = 1, _stackable = false, _weight = 0) -> void:
#	name = _name
#	icon = _icon
#	description = _description
#	category = _category
#	attributes = _attributes
#	quantity = _quantity
#	stackable = _stackable
#	weight = _weight

# 使用物品的方法
func use() -> void:
	emit_signal("used", self)

# 移动物品的方法
func move(new_position) -> void:
	emit_signal("moved", self, new_position)

# 丢弃物品的方法
func discard() -> void:
	emit_signal("discarded", self)

# 合成或分解物品的方法
func combine(other_item) -> void:
	emit_signal("combined", self, other_item)

# 分割物品的方法
func split_item(split_quantity) -> void:
	emit_signal("split", self, split_quantity)

# 增加数量
func add_quantity(amount) -> void:
	if stackable:
		quantity += amount

# 减少数量
func remove_quantity(amount) -> void:
	if stackable and quantity - amount >= 0:
		quantity -= amount
