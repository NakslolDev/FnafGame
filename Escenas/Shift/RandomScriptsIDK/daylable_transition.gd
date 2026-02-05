extends Label

var id: String

func _ready() -> void:
	id = "Night" + str(Global.noche)
	
	text = Global.get_csv_value_id(Global.text_CSV_name, id, Global.language)
