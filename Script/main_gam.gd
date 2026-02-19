extends Control

# --- UI NODES ---
@onready var score_label = $Header/ScoreLabel
@onready var manual_button = $Header/ManualButton
@onready var url_bar = $BrowserArea/URLBar
@onready var web_content = $BrowserArea/WebContent
@onready var fake_popup_visual = $BrowserArea/FakePopup
@onready var fake_popup_button = $BrowserArea/FakePopup/FakePopupButton
@onready var submit_button = $InvestigationPanel/SubmitButton
@onready var feedback_popup = $FeedbackPopup
@onready var manual_popup = $ManualPopup

# --- CHECKBOXES ---
@onready var chk_url = $InvestigationPanel/CheckboxContainer/Chk_SuspiciousURL
@onready var chk_http = $InvestigationPanel/CheckboxContainer/Chk_Unsecure
@onready var chk_tone = $InvestigationPanel/CheckboxContainer/Chk_UrgentTone
@onready var chk_design = $InvestigationPanel/CheckboxContainer/Chk_FakeDesign
@onready var chk_popups = $InvestigationPanel/CheckboxContainer/Chk_Popups
@onready var chk_hidden = $InvestigationPanel/CheckboxContainer/Chk_HiddenLinks
@onready var chk_permissions = $InvestigationPanel/CheckboxContainer/Chk_Permissions
@onready var chk_safe = $InvestigationPanel/CheckboxContainer/Chk_Safe
