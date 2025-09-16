extends Node2D

@onready var chart = $Chart
@onready var price_label = $PriceLabel
@onready var button = $Button

func _ready():
	button.pressed.connect(_on_button_pressed)
	chart.price_label = price_label
	chart.generate_prices()

func _on_button_pressed():
	chart.generate_prices()
