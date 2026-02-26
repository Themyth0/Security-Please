extends Control

@export var next_scene_path: String = "res://Scenes/menu.tscn"

# UI NODES 
@onready var score_label = $Header/ScoreLabel
@onready var manual_button = $Header/ManualButton
@onready var url_bar = $BrowserArea/URLBar
@onready var web_content = $BrowserArea/WebContent
@onready var fake_popup_visual = $BrowserArea/FakePopup
@onready var fake_popup_button = $BrowserArea/FakePopup/FakePopupButton
@onready var submit_button = $InvestigationPanel/SubmitButton
@onready var feedback_popup = $FeedbackPopup
@onready var manual_popup = $ManualPopup

# NODOS Sound
@onready var sfx_click = $SfxClick
@onready var sfx_success = $SfxSuccess
@onready var sfx_error = $SfxError

# CHECKBOXES 
@onready var chk_url = $InvestigationPanel/CheckboxContainer/Chk_SuspiciousURL
@onready var chk_http = $InvestigationPanel/CheckboxContainer/Chk_Unsecure
@onready var chk_tone = $InvestigationPanel/CheckboxContainer/Chk_UrgentTone
@onready var chk_design = $InvestigationPanel/CheckboxContainer/Chk_FakeDesign
@onready var chk_popups = $InvestigationPanel/CheckboxContainer/Chk_Popups
@onready var chk_hidden = $InvestigationPanel/CheckboxContainer/Chk_HiddenLinks
@onready var chk_permissions = $InvestigationPanel/CheckboxContainer/Chk_Permissions
@onready var chk_safe = $InvestigationPanel/CheckboxContainer/Chk_Safe

var score : int = 0
var current_level : int = 0

var websites = [
	{
		"url": "https://www.bank-login.secure-verify.net",
		"content": "Click the button below to verify your identity immediately.",
		"has_popup": true,
		"threats": ["url", "popups", "permissions"],
		"explanation": "This site uses a fake 'verify' URL, an intrusive pop-up, and asks for camera permissions without reason."
	},
	{
		"url": "http://www.download-free-movies.biz",
		"content": "Your download is ready. [color=blue][u]Click here to download[/u][/color]",
		"has_popup": false,
		"threats": ["http", "hidden"],
		"explanation": "The 'Download' link has an invisible layer (Clickjacking), and the site uses an unsecure HTTP connection."
	},
	{
		"url": "https://www.google.com",
		"content": "Welcome to Google. Search the web, images, videos, and more.",
		"has_popup": false,
		"threats": ["safe"],
		"explanation": "Excellent! This is a legitimate website with HTTPS and a correct URL."
	},
	{
		"url": "https://www.netflix-billing-update.tv",
		"content": "Update your payment method to continue watching. [b]Action required![/b]",
		"has_popup": true,
		"threats": ["url", "tone", "popups"],
		"explanation": "Fake domain (.tv instead of .com), urgent tone, and a suspicious pop-up."
	},
	{
		"url": "http://www.cheap-vbucks-generator.tk",
		"content": "[color=red][b]FREE REWARDS![/b][/color] Get 50,000 coins for free! Limited time only!",
		"has_popup": false,
		"threats": ["http", "url", "tone", "design"],
		"explanation": "Classic scam: No HTTPS, suspicious domain, urgent tone, and poor visual design."
	},
	{
		"url": "https://www.amazon.com/orders",
		"content": "Review your recent orders and manage your account settings.",
		"has_popup": false,
		"threats": ["safe"],
		"explanation": "Correct. This is the official Amazon site."
	}
]

func _ready():
	submit_button.pressed.connect(_on_submit_pressed)
	manual_button.pressed.connect(_on_manual_button_pressed)
	fake_popup_button.pressed.connect(_on_fake_popup_clicked)
	chk_safe.toggled.connect(_on_safe_toggled)
	
	score_label.text = "Score: 0"
	load_website(current_level)

func load_website(index: int):
	var data = websites[index]
	url_bar.text = data["url"]
	web_content.text = data["content"]
	fake_popup_visual.visible = data["has_popup"]
	var boxes = [chk_url, chk_http, chk_tone, chk_design, chk_popups, chk_hidden, chk_permissions, chk_safe]
	for box in boxes:
		box.button_pressed = false

func _on_submit_pressed():
	var current_data = websites[current_level]
	var correct_threats = current_data["threats"]
	var player_selection = []
	if chk_url.button_pressed: player_selection.append("url")
	if chk_http.button_pressed: player_selection.append("http")
	if chk_tone.button_pressed: player_selection.append("tone")
	if chk_design.button_pressed: player_selection.append("design")
	if chk_popups.button_pressed: player_selection.append("popups")
	if chk_hidden.button_pressed: player_selection.append("hidden")
	if chk_permissions.button_pressed: player_selection.append("permissions")
	if chk_safe.button_pressed: player_selection.append("safe")
	
	player_selection.sort()
	correct_threats.sort()
	
	if player_selection == correct_threats:
		score += 5
		sfx_success.play() 
		show_feedback("CORRECT!", "You identified all risks.\n\n" + current_data["explanation"], true)
	else:
		score -= 2
		sfx_error.play() 
		show_feedback("INCORRECT", "You missed something or marked a wrong threat.\n\n" + current_data["explanation"], true)
	
	score_label.text = "Score: " + str(score)

func _on_fake_popup_clicked():
	score -= 10
	sfx_error.play()
	score_label.text = "Score: " + str(score)
	fake_popup_visual.visible = false
	show_feedback("SECURITY WARNING", "DANGER! You interacted with a malicious pop-up. Cybercriminals use these to steal data. NEVER click them!", false)

func show_feedback(title: String, message: String, move_to_next: bool):
	feedback_popup.title = title
	feedback_popup.dialog_text = message
	feedback_popup.popup_centered()
	
	if feedback_popup.confirmed.is_connected(next_level):
		feedback_popup.confirmed.disconnect(next_level)
	
	if move_to_next:
		feedback_popup.confirmed.connect(next_level)

# Change scne or restart

func next_level():
	current_level += 1
	if current_level < websites.size():
		load_website(current_level)
	else:
		evaluate_final_result()

func evaluate_final_result():
	if score >= 15:
		print("Victory! Moving on to the next scene.")
		if ResourceLoader.exists(next_scene_path):
			get_tree().change_scene_to_file(next_scene_path)
		else:
			push_error("Scene not found: " + next_scene_path)
	else:
		print("Insufficient points (", score, "). Restarting level...")
		get_tree().reload_current_scene()

# Buttons signals

func _on_manual_button_pressed():
	manual_popup.popup_centered()

func _on_safe_toggled(is_pressed):
	if is_pressed:
		var threats = [chk_url, chk_http, chk_tone, chk_design, chk_popups, chk_hidden, chk_permissions]
		for box in threats:
			box.button_pressed = false
			



func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if sfx_click:
				sfx_click.play()


func _on_manual_popup_close_requested() -> void:
	manual_popup.hide()
