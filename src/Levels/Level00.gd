extends Node2D

enum OBJECT_TYPE { COIN, HAZARD }
const Coin := preload("res://src/Objects/Pickups/Coin.tscn")
const HazardStatic := preload("res://src/Objects/Hazards/Static.tscn")
const ObjectDetector := preload("res://src/Objects/ObjectDetector.tscn")
const GameOver := preload("res://src/UI/Screens/GameOver.tscn")
const Player := preload("res://src/Actors/Player.tscn")

const COIN_COUNT_MAX = 7

var coin_counter := 0
var score:= 0
var game_timer:= 30


func _ready():
	setup()


func setup():
	$Hud.set_timer(game_timer)
	$Hud.set_score_hi(Global.score_hi)
	yield(get_tree().create_timer(.4), "timeout")
	$TimerCoinSpawner.start()
	$TimerGame.start()
	#set player
	var p = Player.instance()
	p.position.x = Global.screen_safe_max_x/2
	p.position.y = Global.screen_safe_max_y/2
	p.connect("died", self, "_on_Player_died")
	Global.current_scene.add_child(p)
	#debug screen_safe_max_x
	var debug = "min_xy: %s max_x: %s max_y: %s "
	$Debug/Label.text = debug % [Global.screen_safe_min_xy,
		Global.screen_safe_max_x,
		Global.screen_safe_max_y]


func spawn_position_safe_object(type = OBJECT_TYPE.COIN ):
	var can_spawn_coin := false
	while not can_spawn_coin:
		var new_pos = Global.get_random_position()
		var o = ObjectDetector.instance()
		o.position = new_pos
		Global.current_scene.add_child(o)
		yield(get_tree().create_timer(.1), "timeout")
		if not o.get_has_detected():
			match type:
				OBJECT_TYPE.HAZARD:
					spawn_hazard(new_pos)
				_:
					spawn_coin(new_pos)
			can_spawn_coin = true
		o.queue_free()


func spawn_coin(pos: Vector2):
	var c= Coin.instance()
	c.position = pos
	c.connect("picked", self, "_on_Coin_picked")
	Global.current_scene.add_child(c)


func spawn_hazard(pos: Vector2):
	var c= HazardStatic.instance()
	c.position = pos
	c.connect("picked", self, "_on_Coin_picked")
	Global.current_scene.add_child(c)


func game_over():
	$TimerGame.stop()
	$TimerCoinSpawner.stop()
	$AudioGameOver.play()
	$Player.disable()
	var g = GameOver.instance()
	Global.current_scene.add_child(g)
	if score > Global.score_hi:
		Global.score_hi = score
		g.show_hi_score()
	#TODO: calc and show play rate


func _on_CoinSpawnerTimer_timeout():
	if coin_counter < COIN_COUNT_MAX:
		spawn_position_safe_object()
		coin_counter += 1
		if score >= COIN_COUNT_MAX && score % COIN_COUNT_MAX == 0:
			spawn_position_safe_object(OBJECT_TYPE.HAZARD)


func _on_Coin_picked():
	if coin_counter > 0:
		coin_counter -= 1
		score += 1
		$Hud.set_score(score)
		$Player.speedup(score)


func _on_TimerGame_timeout():
	if game_timer > 0:
		game_timer -= 1
		$Hud.set_timer(game_timer)
	else:
		game_over()


func _on_Player_died():
	game_over()


