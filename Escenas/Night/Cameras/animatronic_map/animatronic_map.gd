extends Node2D

@export var foxy_icon: Sprite2D
@export var bonnie_icon: Sprite2D
@export var chica_icon: Sprite2D
@export var freddy_icon: Sprite2D

func _ready():
	Global.act_ai_state.connect(act_activated)
	Bonnie.movement.connect(movement_bonnie)
	Chica.movement.connect(movement_chica)
	Freddy.movement.connect(movement_freddy)
	Foxy.movement.connect(movement_foxy)

func act_first():
	bonnie_icon.position = Vector2(1714.0, 142.0)
	chica_icon.position = Vector2(1750.0, 142.0)
	freddy_icon.position = Vector2(1732.0, 142.0)
	foxy_icon.position = Vector2(1753.0, 205.0)
	movement_foxy(null, null, null, null)
	act_activated()

func act_activated():
	if Bonnie.AI_level == 0: 
		bonnie_icon.modulate.a = 0.0
	else:
		bonnie_icon.modulate.a = 1.0
	if Chica.AI_level == 0: 
		chica_icon.modulate.a = 0.0
	else:
		chica_icon.modulate.a = 1.0
	if Freddy.AI_level == 0: 
		freddy_icon.modulate.a = 0.0
	else:
		freddy_icon.modulate.a = 1.0
	if Foxy.AI_level == 0: 
		foxy_icon.modulate.a = 0.0
	else:
		foxy_icon.modulate.a = 1.0

func movement_bonnie(_a = null, _b = null):
	if Bonnie.position == "S":
		bonnie_icon.position = Vector2(1714.0, 142.0)
	elif Bonnie.position == "0":
		bonnie_icon.position = Vector2(1619.0, 53.0)
	elif Bonnie.position == "1":
		bonnie_icon.position = Vector2(1672.0, 106.0)
	elif Bonnie.position == "2":
		bonnie_icon.position = Vector2(1611.0, 130.0)
	elif Bonnie.position == "3":
		bonnie_icon.position = Vector2(1626.0, 182.0)
	elif Bonnie.position == "4":
		bonnie_icon.position = Vector2(1672.0, 187.0)
	elif Bonnie.position == "5":
		bonnie_icon.position = Vector2(1634.0, 249.0)
	elif Bonnie.position == "PI":
		bonnie_icon.position = Vector2(1689.0, 249.0)
	elif Bonnie.position == "office":
		bonnie_icon.position = Vector2(1732.0, 250.0)

func movement_chica(_a = null, _b = null):
	if Chica.position == "S":
		chica_icon.position = Vector2(1750.0, 142.0)
	elif Chica.position == "1":
		chica_icon.position = Vector2(1778.0, 73.0)
	elif Chica.position == "2":
		chica_icon.position = Vector2(1859.0, 120.0)
	elif Chica.position == "3":
		chica_icon.position = Vector2(1843.0, 175.0)
	elif Chica.position == "4":
		chica_icon.position = Vector2(1795.0, 188.0)
	elif Chica.position == "5":
		chica_icon.position = Vector2(1732.0, 189.0)
	elif Chica.position == "6":
		chica_icon.position = Vector2(1842.0, 239.0)
	elif Chica.position == "PD":
		chica_icon.position = Vector2(1779.0, 249.0)
	elif Chica.position == "office":
		chica_icon.position = Vector2(1732.0, 250.0)

func movement_freddy(_a = null, _b = null, _c = null, _d = null):
	if Freddy.path == 0:
		if Freddy.position == "S":
			freddy_icon.position = Vector2(1732.0, 142.0)
		elif Freddy.position == "0":
			freddy_icon.position = Vector2(1588.0, 79.0)
		elif Freddy.position == "T1":
			freddy_icon.position = Vector2(1727.0, 54.0)
		elif Freddy.position == "T2":
			freddy_icon.position = Vector2(1758.0, 170.0)
		elif Freddy.position == "office":
			freddy_icon.position = Vector2(1732.0, 250.0)
	elif Freddy.path == 1:
		if Freddy.position == "1":
			freddy_icon.position = Vector2(1648.0, 135.0)
		elif Freddy.position == "2":
			freddy_icon.position = Vector2(1600.0, 132.0)
		elif Freddy.position == "3":
			freddy_icon.position = Vector2(1674.0, 170.0)
		elif Freddy.position == "PI":
			freddy_icon.position = Vector2(1666.0, 257.0)
	elif Freddy.path == 2:
		if Freddy.position == "1":
			freddy_icon.position = Vector2(1825.0, 60.0)
		elif Freddy.position == "2":
			freddy_icon.position = Vector2(1862.0, 142.0)
		elif Freddy.position == "3":
			freddy_icon.position = Vector2(1826.0, 169.0)
		elif Freddy.position == "4":
			freddy_icon.position = Vector2(1790.0, 169.0)
		elif Freddy.position == "PD":
			freddy_icon.position = Vector2(1774.0, 241.0)

func movement_foxy(_a = null, _b = null, _c = null, _d = null):
	#room -> 0 (nowhere), main, arcade, pas, entrance, kitchen, almacen, closet, lhall, rhall, office
	# Duc1, Duc2, Duc3... Duc8
	if Foxy.room == "main":
		foxy_icon.scale = Vector2(2.0, 2.0)
		if Foxy.position == 1:
			foxy_icon.position = Vector2(1647.0, 102.0)
		if Foxy.position == 2:
			foxy_icon.position = Vector2(1669.0, 133.0)
		if Foxy.position == 3:
			foxy_icon.position = Vector2(1733.0, 112.0)
		if Foxy.position == 4:
			foxy_icon.position = Vector2(1787.0, 134.0)
		if Foxy.position == 5:
			foxy_icon.position = Vector2(1822.0, 116.0)
	if Foxy.room == "arcade":
		foxy_icon.scale = Vector2(2.0, 2.0)
		if Foxy.position == 1:
			foxy_icon.position = Vector2(1602.0, 112.0)
		if Foxy.position == 2:
			foxy_icon.position = Vector2(1601.0, 163.0)
		if Foxy.position == 3:
			foxy_icon.position = Vector2(1636.0, 171.0)
		if Foxy.position == 4:
			foxy_icon.position = Vector2(1604.0, 214.0)
	if Foxy.room == "pas":
		foxy_icon.scale = Vector2(2.0, 2.0)
		if Foxy.position == 0:
			foxy_icon.position = Vector2(1761.0, 208.0)
		if Foxy.position == 1:
			foxy_icon.position = Vector2(1739.0, 208.0)
		if Foxy.position == 2:
			foxy_icon.position = Vector2(1762.0, 182.0)
		if Foxy.position == 3:
			foxy_icon.position = Vector2(1702.0, 169.0)
	if Foxy.room == "entrance":
		foxy_icon.scale = Vector2(2.0, 2.0)
		foxy_icon.position = Vector2(1860.0, 134.0)
	if Foxy.room == "kitchen":
		foxy_icon.scale = Vector2(2.0, 2.0)
		foxy_icon.position = Vector2(1844.0, 170.0)
	if Foxy.room == "almacen":
		foxy_icon.scale = Vector2(2.0, 2.0)
		if Foxy.position == 1:
			foxy_icon.position = Vector2(1850.0, 228.0)
		if Foxy.position == 2:
			foxy_icon.position = Vector2(1830.0, 256.0)
	if Foxy.room == "closet":
		foxy_icon.scale = Vector2(2.0, 2.0)
		foxy_icon.position = Vector2(1629.0, 249.0)
	if Foxy.room == "lhall":
		foxy_icon.scale = Vector2(2.0, 2.0)
		if Foxy.position == 0:
			foxy_icon.position = Vector2(1690.0, 250.0)
		if Foxy.position == 1:
			foxy_icon.position = Vector2(1674.0, 223.0)
		if Foxy.position == 2:
			foxy_icon.position = Vector2(1670.0, 257.0)
	if Foxy.room == "rhall":
		foxy_icon.scale = Vector2(2.0, 2.0)
		if Foxy.position == 0:
			foxy_icon.position = Vector2(1775.0, 249.0)
		if Foxy.position == 1:
			foxy_icon.position = Vector2(1793.0, 224.0)
		if Foxy.position == 2:
			foxy_icon.position = Vector2(1798.0, 256.0)
	if Foxy.room == "office":
		foxy_icon.scale = Vector2(2.0, 2.0)
		foxy_icon.position = Vector2(1732.0, 250.0)
	if Foxy.room == "Duc1":
		foxy_icon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 1:
			foxy_icon.position = Vector2(1632.0, 94.0)
		if Foxy.position == 2:
			foxy_icon.position = Vector2(1616.0, 94.0)
		if Foxy.position == 3:
			foxy_icon.position = Vector2(1599.0, 95.0)
	if Foxy.room == "Duc2":
		foxy_icon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 1:
			foxy_icon.position = Vector2(1583.0, 109.0)
		if Foxy.position == 2:
			foxy_icon.position = Vector2(1583.0, 136.0)
		if Foxy.position == 3:
			foxy_icon.position = Vector2(1583.0, 164.0)
		if Foxy.position == 4:
			foxy_icon.position = Vector2(1583.0, 192.0)
		if Foxy.position == 5:
			foxy_icon.position = Vector2(1583.0, 219.0)
	if Foxy.room == "Duc3":
		foxy_icon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 1:
			foxy_icon.position = Vector2(1636.0, 153.0)
		if Foxy.position == 2:
			foxy_icon.position = Vector2(1657.0, 153.0)
		if Foxy.position == 3:
			foxy_icon.position = Vector2(1675.0, 153.0)
		if Foxy.position == 4:
			foxy_icon.position = Vector2(1698.0, 153.0)
	if Foxy.room == "Duc4":
		foxy_icon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 1:
			foxy_icon.position = Vector2(1767.0, 153.0)
		if Foxy.position == 2:
			foxy_icon.position = Vector2(1789.0, 153.0)
		if Foxy.position == 3:
			foxy_icon.position = Vector2(1808.0, 153.0)
		if Foxy.position == 4:
			foxy_icon.position = Vector2(1824.0, 153.0)
	if Foxy.room == "Duc5":
		foxy_icon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 0:
			foxy_icon.position = Vector2(1732.0, 232.0)
		if Foxy.position == 1:
			foxy_icon.position = Vector2(1686.0, 225.0)
		if Foxy.position == 2:
			foxy_icon.position = Vector2(1708.0, 225.0)
		if Foxy.position == 3:
			foxy_icon.position = Vector2(1732.0, 225.0)
		if Foxy.position == 4:
			foxy_icon.position = Vector2(1759.0, 225.0)
		if Foxy.position == 5:
			foxy_icon.position = Vector2(1778.0, 225.0)
		if Foxy.position == 6:
			foxy_icon.position = Vector2(1732.0, 220.0)
	if Foxy.room == "Duc6":
		foxy_icon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 1:
			foxy_icon.position = Vector2(1878.0, 143.0)
		if Foxy.position == 2:
			foxy_icon.position = Vector2(1878.0, 168.0)
		if Foxy.position == 3:
			foxy_icon.position = Vector2(1878.0, 193.0)
		if Foxy.position == 4:
			foxy_icon.position = Vector2(1878.0, 220.0)
	if Foxy.room == "Duc7":
		foxy_icon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 1:
			foxy_icon.position = Vector2(1612.0, 232.0)
		if Foxy.position == 2:
			foxy_icon.position = Vector2(1612.0, 254.0)
	if Foxy.room == "Duc8":
		foxy_icon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 0:
			foxy_icon.position = Vector2(1732.0, 266.0)
		if Foxy.position == 1:
			foxy_icon.position = Vector2(1626.0, 273.0)
		if Foxy.position == 2:
			foxy_icon.position = Vector2(1667.0, 273.0)
		if Foxy.position == 3:
			foxy_icon.position = Vector2(1702.0, 273.0)
		if Foxy.position == 4:
			foxy_icon.position = Vector2(1732.0, 273.0)
		if Foxy.position == 5:
			foxy_icon.position = Vector2(1766.0, 273.0)
		if Foxy.position == 6:
			foxy_icon.position = Vector2(1798.0, 273.0)
		if Foxy.position == 7:
			foxy_icon.position = Vector2(1825.0, 273.0)
