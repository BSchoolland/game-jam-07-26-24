extends Node

var SDK = null
var username = 'guest'
var isLoggedIn : bool = false

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
	username = "Guest_"+str(round(randf()*80000 + 10000))
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
	SDK = window.CrazyGames.SDK
	if SDK:
		print("CrazyGames SDK initialized!")
		JavaScriptBridge.eval("var getUser = async function() {
	try {
		let user = await window.CrazyGames.SDK.user.getUser();
		localStorage.setItem('username', user.username); // Storing username
		localStorage.setItem('userReady', 'true'); // Flag to check readiness
	} catch (error) {
		localStorage.setItem('userReady', 'true');
		localStorage.setItem('userError', error.message); // Handling error
	}
};
getUser(); // Execute the function")
		check_for_user()

func check_for_user():
	var interval = 0.5  # How often to check (in seconds)
	var found = false
	while not found:
		found = JavaScriptBridge.eval("""(function () {
		return localStorage.getItem('userReady')
		})() """)
		await (get_tree().create_timer(interval).timeout)
	var username2 = JavaScriptBridge.eval("""(function () {
		return localStorage.getItem('username')
		})() """)
	var error = JavaScriptBridge.eval("""(function () {
		return localStorage.getItem('userError')
		})() """)
	if username2:
		print("Username loaded: ", username2)
		username = username2
		isLoggedIn = true
	elif error:
		print("Error loading user: ", error)
