extends Node

var username : String
var id : String
var lastPingTime : float
var connectedPlayers = []
var websocketServer = "ws://192.168.1.109:5000"
var httpServer = "http://192.168.1.109:3636"