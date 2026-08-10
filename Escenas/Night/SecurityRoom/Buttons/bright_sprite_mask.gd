extends BrightSprite

@onready var real_sprite: Sprite2D = get_child(0)

func _ready() -> void:
	add_to_group(GROUP_NAME)
	position += real_sprite.region_rect.position + real_sprite.region_rect.size / 2.0 - real_sprite.texture.get_size() / 2.0
