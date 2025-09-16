extends Node2D

@onready var chart = $CanvasLayer/HBoxContainer/ChartUI/Chart
@onready var price_label = $CanvasLayer/HBoxContainer/ChartUI/PriceLabel
@onready var button = $CanvasLayer/HBoxContainer/ChartUI/Button
@onready var company_buttons = [
	$CanvasLayer/HBoxContainer/CompanyButtons/CompanyButton0,
	$CanvasLayer/HBoxContainer/CompanyButtons/CompanyButton1,
	$CanvasLayer/HBoxContainer/CompanyButtons/CompanyButton2,
	$CanvasLayer/HBoxContainer/CompanyButtons/CompanyButton3,
	$CanvasLayer/HBoxContainer/CompanyButtons/CompanyButton4
]

var company_data = []
var company_names = ["Company A", "Company B", "Company C", "Company D", "Company E"]

func _ready():
	button.pressed.connect(_on_button_pressed)
	chart.price_label = price_label
	company_data = []
	for i in range(company_names.size()):
		company_data.append(_generate_prices())
		company_buttons[i].text = company_names[i]
		company_buttons[i].pressed.connect(_on_company_button_pressed.bind(i))
	_show_company(0)

func _on_button_pressed():
	var idx = _get_current_company_index()
	company_data[idx] = _generate_prices()
	_show_company(idx)

func _on_company_button_pressed(idx):
	_show_company(idx)

func _show_company(idx):
	chart.prices = company_data[idx]
	chart.animation_index = 0
	chart.animating = true
	chart.queue_redraw()

func _generate_prices():
	var prices = []
	var price = 100.0
	for i in range(chart.NUM_POINTS):
		price += randf_range(-3, 3)
		prices.append(price)
	return prices

func _get_current_company_index():
	for i in range(company_buttons.size()):
		if company_buttons[i].button_pressed:
			return i
	return 0
