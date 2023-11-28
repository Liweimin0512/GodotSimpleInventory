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
@export var stackable := 1
@export var quantity = 1 : 
	set(value):
		quantity = clamp(value, 0, stackable)
@export var weight = 0
@export var attributes = {} # 存储属性如 {"strength": 10, "health": 50}
