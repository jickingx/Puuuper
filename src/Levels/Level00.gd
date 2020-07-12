extends Node2D

const Coin = preload("res://src/Objects/Coin.tscn")
const GameOver = preload("res://src/UI/Screens/GameOver.tscn")
const COIN_COUNT_MAX = 8

var rng := RandomNumberGenerator.new()
var coin_counter := 0
var score:= 0
var timer:= 20


func _ready():
	$Hud.set_timer(timer)
	$Hud.set_score_hi(Global.score_hi)
	
	rng.randomize()
	yield(get_tree().create_timer(.4), "timeout")
	$TimerCoinSpawner.start()
	$TimerGame.start()


func spawn_coin():
	var c= Coin.instance()
	c.position = get_random_position(
		Global.TILE_SIZE, Global.screen_width,
		Global.screen_width)
	c.connect("picked", self, "_on_Coin_picked")
	Global.add_child(c)


func get_random_position(
	tile_size:int,
	max_x:int,
	max_y:int
	) -> Vector2:
	var v:= Vector2.ZERO
	v.x = int(rng.randf_range(Global.TILE_SIZE, Global.screen_width - Global.TILE_SIZE))
	v.y = int(rng.randf_range(Global.TILE_SIZE, Global.screen_height - Global.TILE_SIZE))
	return v


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


func _on_CoinSpawnerTimer_timeout():
	if coin_counter < COIN_COUNT_MAX:
		spawn_coin()
		coin_counter += 1


func _on_Coin_picked():
	if coin_counter > 0:
		coin_counter -= 1
		score += 1
		$Hud.set_score(score)


func _on_TimerGame_timeout():
	if timer > 0:
		timer -= 1
		$Hud.set_timer(timer)
	else:
		game_over()


