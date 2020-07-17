extends Node

const ScreenOverlay:= preload("res://src/FX/ScreenOverlay.tscn")
const MAIN_GAME_SCENE := "res://src/Game.tscn"
const FADE_DELAY = .6
const TILE_SIZE = 64

var current_scene_path:= ""
#safe
var screen_safe_min_xy: int
var screen_safe_max_y: int
var screen_safe_max_x: int
var score_hi:= 10
var rng := RandomNumberGenerator.new()

onready var current_scene = get_tree().get_root().get_child(
	get_tree().get_root().get_child_count() - 1)


func _ready():
	setup_fade_transition()
	screen_safe_min_xy = TILE_SIZE + (TILE_SIZE / 2)
	screen_safe_max_x = 1028 - (TILE_SIZE + (TILE_SIZE/2))
	screen_safe_max_y = 576 - (TILE_SIZE + (TILE_SIZE/2))
	
	#Disabled due to android viewport bug
	#screen_safe_max_y = current_scene.get_viewport().size.y - (TILE_SIZE + (TILE_SIZE/2))
	#screen_safe_max_x = current_scene.get_viewport().size.x - (TILE_SIZE + (TILE_SIZE/2))
	rng.randomize()


func restart_scene():
	fade_out_transition()
	switch_scene(current_scene_path)
	yield(get_tree().create_timer(FADE_DELAY), "timeout")


func switch_scene(path: String):
	current_scene_path = path
	fade_out_transition()
	yield(get_tree().create_timer(FADE_DELAY), "timeout")
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path: String):
	if path.length() == 0:
		path = MAIN_GAME_SCENE
	
	# It is now safe to remove the current scene
	current_scene.free()
	
	# Load the new scene.
	var s = ResourceLoader.load(path)
	# Instance the new scene.
	current_scene = s.instance()
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	setup_fade_transition()


func setup_fade_transition():
	var so = ScreenOverlay.instance()
	so.set_name("ScreenOverlay")
	current_scene.add_child(so)
	so.fade_in()


func fade_out_transition() -> void:
	var so = current_scene.get_node_or_null("ScreenOverlay")
	if so != null :
		so.fade_out()


#Get Game world values =============================================================
#returns a screen safe random pos
func get_random_position() -> Vector2:
	var v:= Vector2.ZERO
	var r_x = rng.randf_range(Global.screen_safe_min_xy, Global.screen_safe_max_x)
	var r_y = rng.randf_range(Global.screen_safe_min_xy, Global.screen_safe_max_y)
	v.x = get_grid_safe_val(r_x)
	v.y = get_grid_safe_val(r_y)
	return v


func get_grid_safe_val(val:int) -> int:
	#round to nearest 64
	var x = (val % TILE_SIZE)
	x = (val - x) / TILE_SIZE
	x *= TILE_SIZE
	x += TILE_SIZE/2
	return x


func get_grid_safe_pos(pos: Vector2) -> Vector2:
	var p = Vector2.ZERO
	p.x = get_grid_safe_val(clamp(pos.x, Global.screen_safe_min_xy, Global.screen_safe_max_x))
	p.y = get_grid_safe_val(clamp(pos.y, Global.screen_safe_min_xy, Global.screen_safe_max_y))
	return pos




