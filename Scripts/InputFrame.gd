extends Node

class_name InputFrame

var movementInput := 0
var lastDirection := 1

var isJumpPressed := false
var isJumpReleased := false

var coyoteStartTime := 0
var elapsedCoyoteTime := 0
var coyoteDuration := 100

var jumpInput := 0

var isDashPressed := false
