extends CharacterBody2D

@export_enum("Unnamed_Guard", "Powerful cube")
var character: String

@export var speed := 70.0
@export var run_mult := 1.5
@export var step := 1
var freeze := false
