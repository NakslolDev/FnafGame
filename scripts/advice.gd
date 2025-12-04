extends Label

func act_advice(type: int):
	text = get_advice_string(type)

func get_advice_string(type: int):
	var id: String
	
	if type == 0:
		id = "Adv_g_0" + str(randi_range(1, 5))
	elif type == 1:
		id = "Adv_b_0" + str(randi_range(1, 2))
	elif type == 2:
		id = "Adv_c_0" + str(randi_range(1, 4))
	elif type == 3:
		id = "Adv_fr_0" + str(randi_range(1, 3))
	elif type == 4:
		id = "Adv_fx_0" + str(randi_range(1, 5))
	
	return Global.get_csv_value_id(Global.text_CSV_name, id, Global.language)
