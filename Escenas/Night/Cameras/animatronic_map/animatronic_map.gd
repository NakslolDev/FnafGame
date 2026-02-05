extends Node2D

func _ready():
	Global.connect("act_ai_state", Callable(self, "act_activated"))

func act_first():
	Bonnie.connect("movement", Callable(self, "movement_bonnie"))
	Chica.connect("movement", Callable(self, "movement_chica"))
	Freddy.connect("movement", Callable(self, "movement_freddy"))
	Foxy.connect("movement", Callable(self, "movement_foxy"))
	$BonnieIcon.position = Vector2(1714.0, 142.0)
	$ChicaIcon.position = Vector2(1750.0, 142.0)
	$FreddyIcon.position = Vector2(1732.0, 142.0)
	$FoxyIcon.position = Vector2(1753.0, 205.0)
	movement_foxy(null, null, null, null)
	act_activated()

func act_activated():
	if Bonnie.AI_level == 0: 
		$BonnieIcon.modulate.a = 0.0
	else:
		$BonnieIcon.modulate.a = 1.0
	if Chica.AI_level == 0: 
		$ChicaIcon.modulate.a = 0.0
	else:
		$ChicaIcon.modulate.a = 1.0
	if Freddy.AI_level == 0: 
		$FreddyIcon.modulate.a = 0.0
	else:
		$FreddyIcon.modulate.a = 1.0
	if Foxy.AI_level == 0: 
		$FoxyIcon.modulate.a = 0.0
	else:
		$FoxyIcon.modulate.a = 1.0

func movement_bonnie(_a = null, _b = null):
	if Bonnie.position == "S":
		$BonnieIcon.position = Vector2(1714.0, 142.0)
	elif Bonnie.position == "0":
		$BonnieIcon.position = Vector2(1619.0, 53.0)
	elif Bonnie.position == "1":
		$BonnieIcon.position = Vector2(1672.0, 106.0)
	elif Bonnie.position == "2":
		$BonnieIcon.position = Vector2(1611.0, 130.0)
	elif Bonnie.position == "3":
		$BonnieIcon.position = Vector2(1626.0, 182.0)
	elif Bonnie.position == "4":
		$BonnieIcon.position = Vector2(1672.0, 187.0)
	elif Bonnie.position == "5":
		$BonnieIcon.position = Vector2(1634.0, 249.0)
	elif Bonnie.position == "PI":
		$BonnieIcon.position = Vector2(1689.0, 249.0)
	elif Bonnie.position == "office":
		$BonnieIcon.position = Vector2(1732.0, 250.0)

func movement_chica(_a = null, _b = null):
	if Chica.position == "S":
		$ChicaIcon.position = Vector2(1750.0, 142.0)
	elif Chica.position == "1":
		$ChicaIcon.position = Vector2(1778.0, 73.0)
	elif Chica.position == "2":
		$ChicaIcon.position = Vector2(1859.0, 120.0)
	elif Chica.position == "3":
		$ChicaIcon.position = Vector2(1843.0, 175.0)
	elif Chica.position == "4":
		$ChicaIcon.position = Vector2(1795.0, 188.0)
	elif Chica.position == "5":
		$ChicaIcon.position = Vector2(1732.0, 189.0)
	elif Chica.position == "6":
		$ChicaIcon.position = Vector2(1842.0, 239.0)
	elif Chica.position == "PD":
		$ChicaIcon.position = Vector2(1779.0, 249.0)
	elif Chica.position == "office":
		$ChicaIcon.position = Vector2(1732.0, 250.0)

func movement_freddy(_a = null, _b = null, _c = null, _d = null):
	if Freddy.path == 0:
		if Freddy.position == "S":
			$FreddyIcon.position = Vector2(1732.0, 142.0)
		elif Freddy.position == "0":
			$FreddyIcon.position = Vector2(1588.0, 79.0)
		elif Freddy.position == "T1":
			$FreddyIcon.position = Vector2(1727.0, 54.0)
		elif Freddy.position == "T2":
			$FreddyIcon.position = Vector2(1758.0, 170.0)
		elif Freddy.position == "office":
			$FreddyIcon.position = Vector2(1732.0, 250.0)
	elif Freddy.path == 1:
		if Freddy.position == "1":
			$FreddyIcon.position = Vector2(1648.0, 135.0)
		elif Freddy.position == "2":
			$FreddyIcon.position = Vector2(1600.0, 132.0)
		elif Freddy.position == "3":
			$FreddyIcon.position = Vector2(1674.0, 170.0)
		elif Freddy.position == "PI":
			$FreddyIcon.position = Vector2(1666.0, 257.0)
	elif Freddy.path == 2:
		if Freddy.position == "1":
			$FreddyIcon.position = Vector2(1825.0, 60.0)
		elif Freddy.position == "2":
			$FreddyIcon.position = Vector2(1862.0, 142.0)
		elif Freddy.position == "3":
			$FreddyIcon.position = Vector2(1826.0, 169.0)
		elif Freddy.position == "4":
			$FreddyIcon.position = Vector2(1790.0, 169.0)
		elif Freddy.position == "PD":
			$FreddyIcon.position = Vector2(1774.0, 241.0)

func movement_foxy(_a = null, _b = null, _c = null, _d = null):
	#room -> 0 (nowhere), main, arcade, pas, entrance, kitchen, almacen, closet, lhall, rhall, office
	# Duc1, Duc2, Duc3... Duc8
	if Foxy.room == "main":
		$FoxyIcon.scale = Vector2(2.0, 2.0)
		if Foxy.position == 1:
			$FoxyIcon.position = Vector2(1647.0, 102.0)
		if Foxy.position == 2:
			$FoxyIcon.position = Vector2(1669.0, 133.0)
		if Foxy.position == 3:
			$FoxyIcon.position = Vector2(1733.0, 112.0)
		if Foxy.position == 4:
			$FoxyIcon.position = Vector2(1787.0, 134.0)
		if Foxy.position == 5:
			$FoxyIcon.position = Vector2(1822.0, 116.0)
	if Foxy.room == "arcade":
		$FoxyIcon.scale = Vector2(2.0, 2.0)
		if Foxy.position == 1:
			$FoxyIcon.position = Vector2(1602.0, 112.0)
		if Foxy.position == 2:
			$FoxyIcon.position = Vector2(1601.0, 163.0)
		if Foxy.position == 3:
			$FoxyIcon.position = Vector2(1636.0, 171.0)
		if Foxy.position == 4:
			$FoxyIcon.position = Vector2(1604.0, 214.0)
	if Foxy.room == "pas":
		$FoxyIcon.scale = Vector2(2.0, 2.0)
		if Foxy.position == 0:
			$FoxyIcon.position = Vector2(1761.0, 208.0)
		if Foxy.position == 1:
			$FoxyIcon.position = Vector2(1739.0, 208.0)
		if Foxy.position == 2:
			$FoxyIcon.position = Vector2(1762.0, 182.0)
		if Foxy.position == 3:
			$FoxyIcon.position = Vector2(1702.0, 169.0)
	if Foxy.room == "entrance":
		$FoxyIcon.scale = Vector2(2.0, 2.0)
		$FoxyIcon.position = Vector2(1860.0, 134.0)
	if Foxy.room == "kitchen":
		$FoxyIcon.scale = Vector2(2.0, 2.0)
		$FoxyIcon.position = Vector2(1844.0, 170.0)
	if Foxy.room == "almacen":
		$FoxyIcon.scale = Vector2(2.0, 2.0)
		if Foxy.position == 1:
			$FoxyIcon.position = Vector2(1850.0, 228.0)
		if Foxy.position == 2:
			$FoxyIcon.position = Vector2(1830.0, 256.0)
	if Foxy.room == "closet":
		$FoxyIcon.scale = Vector2(2.0, 2.0)
		$FoxyIcon.position = Vector2(1629.0, 249.0)
	if Foxy.room == "lhall":
		$FoxyIcon.scale = Vector2(2.0, 2.0)
		if Foxy.position == 0:
			$FoxyIcon.position = Vector2(1690.0, 250.0)
		if Foxy.position == 1:
			$FoxyIcon.position = Vector2(1674.0, 223.0)
		if Foxy.position == 2:
			$FoxyIcon.position = Vector2(1670.0, 257.0)
	if Foxy.room == "rhall":
		$FoxyIcon.scale = Vector2(2.0, 2.0)
		if Foxy.position == 0:
			$FoxyIcon.position = Vector2(1775.0, 249.0)
		if Foxy.position == 1:
			$FoxyIcon.position = Vector2(1793.0, 224.0)
		if Foxy.position == 2:
			$FoxyIcon.position = Vector2(1798.0, 256.0)
	if Foxy.room == "office":
		$FoxyIcon.scale = Vector2(2.0, 2.0)
		$FoxyIcon.position = Vector2(1732.0, 250.0)
	if Foxy.room == "Duc1":
		$FoxyIcon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 1:
			$FoxyIcon.position = Vector2(1632.0, 94.0)
		if Foxy.position == 2:
			$FoxyIcon.position = Vector2(1616.0, 94.0)
		if Foxy.position == 3:
			$FoxyIcon.position = Vector2(1599.0, 95.0)
	if Foxy.room == "Duc2":
		$FoxyIcon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 1:
			$FoxyIcon.position = Vector2(1583.0, 109.0)
		if Foxy.position == 2:
			$FoxyIcon.position = Vector2(1583.0, 136.0)
		if Foxy.position == 3:
			$FoxyIcon.position = Vector2(1583.0, 164.0)
		if Foxy.position == 4:
			$FoxyIcon.position = Vector2(1583.0, 192.0)
		if Foxy.position == 5:
			$FoxyIcon.position = Vector2(1583.0, 219.0)
	if Foxy.room == "Duc3":
		$FoxyIcon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 1:
			$FoxyIcon.position = Vector2(1636.0, 153.0)
		if Foxy.position == 2:
			$FoxyIcon.position = Vector2(1657.0, 153.0)
		if Foxy.position == 3:
			$FoxyIcon.position = Vector2(1675.0, 153.0)
		if Foxy.position == 4:
			$FoxyIcon.position = Vector2(1698.0, 153.0)
	if Foxy.room == "Duc4":
		$FoxyIcon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 1:
			$FoxyIcon.position = Vector2(1767.0, 153.0)
		if Foxy.position == 2:
			$FoxyIcon.position = Vector2(1789.0, 153.0)
		if Foxy.position == 3:
			$FoxyIcon.position = Vector2(1808.0, 153.0)
		if Foxy.position == 4:
			$FoxyIcon.position = Vector2(1824.0, 153.0)
	if Foxy.room == "Duc5":
		$FoxyIcon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 0:
			$FoxyIcon.position = Vector2(1732.0, 232.0)
		if Foxy.position == 1:
			$FoxyIcon.position = Vector2(1686.0, 225.0)
		if Foxy.position == 2:
			$FoxyIcon.position = Vector2(1708.0, 225.0)
		if Foxy.position == 3:
			$FoxyIcon.position = Vector2(1732.0, 225.0)
		if Foxy.position == 4:
			$FoxyIcon.position = Vector2(1759.0, 225.0)
		if Foxy.position == 5:
			$FoxyIcon.position = Vector2(1778.0, 225.0)
	if Foxy.room == "Duc6":
		$FoxyIcon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 1:
			$FoxyIcon.position = Vector2(1878.0, 143.0)
		if Foxy.position == 2:
			$FoxyIcon.position = Vector2(1878.0, 168.0)
		if Foxy.position == 3:
			$FoxyIcon.position = Vector2(1878.0, 193.0)
		if Foxy.position == 4:
			$FoxyIcon.position = Vector2(1878.0, 220.0)
	if Foxy.room == "Duc7":
		$FoxyIcon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 1:
			$FoxyIcon.position = Vector2(1612.0, 232.0)
		if Foxy.position == 2:
			$FoxyIcon.position = Vector2(1612.0, 254.0)
	if Foxy.room == "Duc8":
		$FoxyIcon.scale = Vector2(1.0, 1.0)
		if Foxy.position == 0:
			$FoxyIcon.position = Vector2(1732.0, 266.0)
		if Foxy.position == 1:
			$FoxyIcon.position = Vector2(1626.0, 273.0)
		if Foxy.position == 2:
			$FoxyIcon.position = Vector2(1667.0, 273.0)
		if Foxy.position == 3:
			$FoxyIcon.position = Vector2(1702.0, 273.0)
		if Foxy.position == 4:
			$FoxyIcon.position = Vector2(1732.0, 273.0)
		if Foxy.position == 5:
			$FoxyIcon.position = Vector2(1766.0, 273.0)
		if Foxy.position == 6:
			$FoxyIcon.position = Vector2(1798.0, 273.0)
		if Foxy.position == 7:
			$FoxyIcon.position = Vector2(1825.0, 273.0)
