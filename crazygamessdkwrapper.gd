extends Node

var SDK = null
var username = 'guest'

signal ad_done
var adCallbacks = {}

func ad_started(args):
	print('started')

func ad_error(error):
	ad_done.emit()

func ad_finished(args):
	ad_done.emit()

var adStartedCallback = JavaScriptBridge.create_callback(ad_started)
var adErrorCallback = JavaScriptBridge.create_callback(ad_error)
var adFinishedCallback = JavaScriptBridge.create_callback(ad_finished)

# Ready function
func _ready() -> void:
	# Initialize ad callbacks
	adCallbacks["adFinished"] = adFinishedCallback
	adCallbacks["adError"] = adErrorCallback
	adCallbacks["adStarted"] = adStartedCallback

	# Get the JavaScript interface for the window object
	var window = JavaScriptBridge.get_interface("window")
	if !window:
		return
	print(window)

	# Check if CrazyGames object exists on the window object
	if !window.CrazyGames:
		return
	print(window.CrazyGames)

	# Get the CrazyGames SDK object
	var SDK = window.CrazyGames.SDK
	if SDK:
		print("CrazyGames SDK initialized!")
