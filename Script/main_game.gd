extends Control
#Variables
var points = 0
var current_email_idx = 0

var emails = [
	{
		"subject": "⚠️ SECURITY: Access denied",
		"sender": "security@support-netflix-login.com",
		"body": "Dear client,\n\nWe've detected a login from Russia. If that was'nt you, click the following link to secure your acount:\n\n[url=http://login-netflix-verificar.ru/acc]VERIFICAR CUENTA AHORA[/url]\n\nDe lo contrario, su cuenta será suspendida en 24 horas.",
		"errors": ["sender", "tone", "url", "greeting"],
		"is_safe": false,
		"explanation": "The sender is'nt @netflix.com, it uses a threatening tone, a generic greating and the links domain is .ru (Russia)."
	},
	{
		"subject": "Your amazon.es bill",
		"sender": "bills@amazon.es",
		"body": "Hello Juan,\n\nWe attached the bill from your purcharse from yesterdays. Thanks for shopping with us.\n\n[url=https://amazon.es/mis-pedidos]Ver mi pedido[/url]",
		"errors": [],
		"is_safe": true,
		"explanation": "This email is legit. The domain is correct, It calls you by your name and the link points to the official web."
	},
	{
		"subject": "¡YOU'VE WON! 🎁 CLAIM YOUR PRICE",
		"sender": "price@sorteos-internacionales.net",
		"body": "¡Congratulations user!\n\nYou've selected to win a Iphone 15 pro max complitely for free. You only have to download de paper and complete it with your info:\n\n[url=descarga]formulario_premio.zip.exe[/url]",
		"errors": ["tone", "greeting", "attachment"],
		"is_safe": false,
		"explanation": "Nobody gifts iPhones for free. The file has two extensions (.zip.exe), that is a classic virus technique."
	},
	{
		"subject": "Microsoft account update",
		"sender": "no-reply@mircosoft.com",
		"body": "Your Microsoft 365 subscription has ended. Please, update your payment info on the following formulary\n\n[url=http://mircosoft-pagos.com]Go to payment formulary[/url]",
		"errors": ["sender", "url"],
		"is_safe": false,
		"explanation": "This is a typosquatting attack. they wrote 'Mircosoft' (shifting the C and R) to fool you."
	},
	{
		"subject": "Medical date",
		"sender": "avisos@seg-social.es",
		"body": "Hello,\n\nwe like to remind you of your medical date that is arrange for tomorrow at 10:00 AM in oyur closest office. If you would like to change it, access to the official web.",
		"errors": [],
		"is_safe": true,
		"explanation": "Real informative email. Does'nt ask you for sensitive information, does'nt have strange links and the domain is the official goverment domain."
	},
	{
		"subject": "CREDICTCARD BLOCKED",
		"sender": "alertas@santander-seguro-web.com",
		"body": "URGENT: Your carc has been blocked for security ressons. In order to reactivate it, insert your PIN and digital sign in this link:\n\n[url=http://bit.ly/seguridad-banco]Reactivate Card[/url]",
		"errors": ["sender", "tone", "url"],
		"is_safe": false,
		"explanation": "Banks never ask for yor PIN by email and does'nt use link shorters such as bit.ly."
	}
]

#Node
@onready var label_subject = $MainLayout/Content/Header/MailSubject
@onready var text_email = $MainLayout/Content/EmailView/MarginEmail/ScrollContainer/VBoxEmail/EmailBody
@onready var label_url_tip = $MainLayout/Content/EmailView/MarginEmail/ScrollContainer/VBoxEmail/URLToolTip
@onready var label_points = $MainLayout/Sidebar/MarginSidebar/VBoxSidebar/LabelPoints
@onready var manual_popupE = $ManualPopupE
@onready var feedback_popup = $FeedbackPopUp

#checkbox
@onready var check_sender = $MainLayout/Content/ActionsFooter/HBoxActions/GridChecks/CheckSender
@onready var check_tone = $MainLayout/Content/ActionsFooter/HBoxActions/GridChecks/CheckTone
@onready var check_url = $MainLayout/Content/ActionsFooter/HBoxActions/GridChecks/CheckURL
@onready var check_attachment = $MainLayout/Content/ActionsFooter/HBoxActions/GridChecks/CheckAttachment
@onready var check_is_safe = $MainLayout/Content/ActionsFooter/HBoxActions/CheckIsSafe

func _ready():
	label_url_tip.hide()
	manual_popupE.hide()
	label_points.text = "Points: 0"
	update_email_ui()

func update_email_ui():
	var data = emails[current_email_idx]
	label_subject.text = "Subject: " + data.subject
	text_email.text = "FROM: " + data.sender + "\n\n" + data.body
	check_sender.button_pressed = false
	check_tone.button_pressed = false
	check_url.button_pressed = false
	check_attachment.button_pressed = false
	check_is_safe.button_pressed = false


func _on_btn_validate_pressed():
	var data = emails[current_email_idx]
	var hits_detected = []
	
	if check_sender.button_pressed: hits_detected.append("sender")
	if check_tone.button_pressed: hits_detected.append("tone")
	if check_url.button_pressed: hits_detected.append("url")
	if check_attachment.button_pressed: hits_detected.append("attachment")
	
	var is_safe_checked = check_is_safe.button_pressed
	var result_message = ""
	
	if is_safe_checked == data.is_safe:
		var missing_errors = false
		for e in data.errors:
			if not e in hits_detected:
				missing_errors = true
		
		if not missing_errors:
			points += 5
			result_message = "✅ EXCELLENT!\nPerfect identification.\n\n"
		else:
			points += 2
			result_message = "⚠️ GOOD, BUT...\nYou got the verdict right, but missed some red flags.\n\n"
	else:
		points -= 3
		result_message = "❌ ERROR!\nYou failed the security verdict.\n\n"

	show_feedback(result_message + "ANALYSIS:\n" + data.explanation)

func show_feedback(text):
	feedback_popup.dialog_text = text
	feedback_popup.popup_centered()
	label_points.text = "Points: " + str(points)


func _on_feedback_pop_up_confirmed():
	current_email_idx += 1
	if current_email_idx < emails.size():
		update_email_ui()
	else:
		finish_game()

func finish_game():
	label_subject.text = "GAME OVER"
	text_email.text = "[center][b]Inbox Cleaned![/b]\n\nFinal Score: " + str(points) + "[/center]"
	$MainLayout/Content/ActionsFooter.hide()

#UI functions
func _on_btn_manual_pressed():
	manual_popupE.show()

func _on_btn_close_manual_pressed():
	manual_popupE.hide()

func _on_email_body_meta_hover_started(meta):
	label_url_tip.text = "🔗 REAL URL: " + str(meta)
	label_url_tip.show()

func _on_email_body_meta_hover_ended(_meta):
	label_url_tip.hide()
