@tool
extends ItemSlot
class_name EquipSlot

const EQUIP_SLOT_TYPE : Array[Equip.EQUIP_TYPE] = [
	Equip.EQUIP_TYPE.CHEST,
	Equip.EQUIP_TYPE.FEET,
	Equip.EQUIP_TYPE.HEAD,
	Equip.EQUIP_TYPE.LEGS,
	Equip.EQUIP_TYPE.NECKLACE,
	Equip.EQUIP_TYPE.RING,
	Equip.EQUIP_TYPE.WEAPON,
]
const EQUIP_SLOT_TEXTURE : Array[Texture2D] = [
	preload("res://assets/equip_slot/chest_slot.tres"),
	preload("res://assets/equip_slot/feet_slot.tres"),
	preload("res://assets/equip_slot/head_slot.tres"),
	preload("res://assets/equip_slot/legs_slot.tres"),
	preload("res://assets/equip_slot/necklace_slot.tres"),
	preload("res://assets/equip_slot/ring_slot.tres"),
	preload("res://assets/equip_slot/weapon_slot.tres"),
]

@onready var tr_slot: TextureRect = $MarginContainer/tr_slot
@export var equip_slot_name : StringName = ""
@export var equip_type : Equip.EQUIP_TYPE = Equip.EQUIP_TYPE.CHEST :
	set(value):
		equip_type = value
		if tr_slot:
			_display_equip_slot()

func _ready() -> void:
	_display_equip_slot()
	super()

func _display_equip_slot() -> void:
	var slot_index : int = EQUIP_SLOT_TYPE.find(equip_type)
	if slot_index == -1 : return
	tr_slot.texture = EQUIP_SLOT_TEXTURE[slot_index]

func _item_setter(value : Item) -> void:
	tr_slot.visible = value == null
	super(value)
