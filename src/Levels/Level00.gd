extends Node2D

const Coin := preload("res://src/Objects/Coin.tscn")
const GameOver := preload("res://src/UI/Screens/GameOver.tscn")
const COIN_COUNT_MAX = 8

var coin_counter := 0
var score:= 0
var timer:= 10


func _ready():
	$Hud.set_timer(timer)
	$Hud.set_score_hi(Global.score_hi)
	yield(get_tree().create_timer(.4), "timeout")
	$TimerCoinSpawner.start()
	$TimerGame.start()


func spawn_coin():
	var c= Coin.instance()
	c.position = Global.get_random_position()
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


