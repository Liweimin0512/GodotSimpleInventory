extends Control

@onready var inventory: MarginContainer = %inventory
@onready var line_edit: LineEdit = %LineEdit
@onready var btn_submit: Button = %btn_submit





func _on_line_edit_text_submitted(new_text: String) -> void:
	process_command(new_text)


func _on_btn_submit_pressed() -> void:
	process_command(line_edit.text)

func process_command(command: String):
	var parts = command.split(" ")
	if parts.size() == 0:
		return

	var cmd = parts[0]
	var args = parts.slice(1, parts.size())

	if has_method(cmd):
		self.callv(cmd, args)
	else:
		push_warning("未找到指定的命令：", cmd)

func add_item(item_name: String, item_count: String) -> void:
	var _count = int(item_count)
	var item = create_item(item_name, _count)
	if item == null: return
	inventory.add_item(item)
	print_debug("add_item: ", item_name, " count: ", item_count)

func remove_item(slot_index: String) -> void:
	var _index = int(slot_index)
	inventory.remove_item(_index)

func create_item(item_name, item_count) -> Control:
	var res_path : String = "res://src/item/" + item_name + ".tres"
	if not ResourceLoader.exists(res_path): return null
	var item = preload("res://src/item.tscn").instantiate()
	var item_data : ItemResource = load(res_path)
	item_data.quantity = item_count
	item.item_res = item_data
	return item
