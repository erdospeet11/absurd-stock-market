@tool
extends Control

const AXIS_MARGIN = 40
const POINT_RADIUS = 6
const NUM_POINTS = 50

var prices = []
var hovered_index = -1
var price_label = null

var animation_index := -1.0
var animating := false
var animation_speed := 60.0 # points per second

@export var regenerate: bool = false:
	set(value):
		regenerate = value
		if value:
			_on_regenerate()
			regenerate = false

func _ready():
	set_process(true)
	generate_prices()

func generate_prices():
	prices.clear()
	var price = 100.0
	for i in range(NUM_POINTS):
		price += randf_range(-3, 3)
		prices.append(price)
	hovered_index = -1
	animation_index = 0
	animating = true
	queue_redraw()

func _process(delta):
	if animating:
		animation_index += animation_speed * delta
		if animation_index >= prices.size():
			animation_index = prices.size()
			animating = false
		queue_redraw()

func _draw():
	draw_axes()
	draw_chart()
	draw_points()

func draw_axes():
	var origin = Vector2(AXIS_MARGIN, size.y - AXIS_MARGIN)
	var x_end = Vector2(size.x - AXIS_MARGIN, size.y - AXIS_MARGIN)
	var y_end = Vector2(AXIS_MARGIN, AXIS_MARGIN)
	draw_line(origin, x_end, Color(1,1,1), 2)
	draw_line(origin, y_end, Color(1,1,1), 2)

func draw_chart():
	if prices.size() < 2:
		return
	var min_price = prices.min()
	var max_price = prices.max()
	var end_index = int(animation_index) if animating else prices.size() - 1
	for i in range(min(end_index, prices.size() - 1)):
		var p1 = price_to_pos(i, prices[i], min_price, max_price)
		var p2 = price_to_pos(i+1, prices[i+1], min_price, max_price)
		draw_line(p1, p2, Color(0.2,0.8,0.2), 2)

func draw_points():
	var min_price = prices.min()
	var max_price = prices.max()
	var end_index = int(animation_index) if animating else prices.size()
	for i in range(min(end_index, prices.size())):
		var pos = price_to_pos(i, prices[i], min_price, max_price)
		var color = Color(0.8,0.2,0.2) if i == hovered_index else Color(0.2,0.2,0.8)
		draw_circle(pos, POINT_RADIUS, color)

func price_to_pos(i, price, min_price, max_price):
	var x = lerp(float(AXIS_MARGIN), float(size.x - AXIS_MARGIN), float(i) / float(NUM_POINTS-1))
	var y = lerp(float(size.y - AXIS_MARGIN), float(AXIS_MARGIN), float(price - min_price) / max(0.01, float(max_price - min_price)))
	return Vector2(x, y)

func _input(event):
	if event is InputEventMouseMotion:
		var min_price = prices.min()
		var max_price = prices.max()
		var mouse_pos = get_local_mouse_position()
		hovered_index = -1
		for i in range(prices.size()):
			var pos = price_to_pos(i, prices[i], min_price, max_price)
			if pos.distance_to(mouse_pos) < POINT_RADIUS * 1.5:
				hovered_index = i
				if price_label:
					price_label.text = "Price: %.2f" % prices[i]
				break
		if hovered_index == -1 and price_label:
			price_label.text = "Hover over a point"
		queue_redraw()

func _on_regenerate():
	generate_prices()
