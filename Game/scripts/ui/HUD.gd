extends CanvasLayer

@onready var wood_label:  Label = $HBoxContainer/WoodLabel
@onready var stone_label: Label = $HBoxContainer/StoneLabel
@onready var food_label:  Label = $HBoxContainer/FoodLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	ResourceManager.resources_changed.connect(_on_resources_changed)
	_refresh_all()

func _on_resources_changed(_type: String, _amount: int) -> void:
	_refresh_all()

func _refresh_all() -> void:
	wood_label.text = "Wood: " + str(ResourceManager.get_amount("wood"))
	stone_label.text = "Stone: " + str(ResourceManager.get_amount("stone"))
	food_label.text = "Food: " + str(ResourceManager.get_amount("food"))
