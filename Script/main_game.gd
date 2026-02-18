extends Control

var points = 0
var current_email_idx = 0

var emails = [
	{
		"subject": "⚠️ SEGURIDAD: Acceso no autorizado",
		"sender": "seguridad@soporte-netflix-login.com",
		"body": "Estimado cliente,\n\nHemos detectado un inicio de sesión desde Rusia. Si no has sido tú, haz clic en el siguiente enlace para asegurar tu cuenta inmediatamente:\n\n[url=http://login-netflix-verificar.ru/acc]VERIFICAR CUENTA AHORA[/url]\n\nDe lo contrario, su cuenta será suspendida en 24 horas.",
		"errors": ["sender", "tone", "url", "greeting"],
		"is_safe": false,
		"explanation": "El remitente no es @netflix.com, usa un tono de amenaza, un saludo genérico y el link va a un dominio .ru (Rusia)."
	},
	{
		"subject": "Tu factura de Amazon.es",
		"sender": "facturacion@amazon.es",
		"body": "Hola Juan,\n\nAdjuntamos la factura de tu pedido realizado ayer. Gracias por comprar con nosotros.\n\n[url=https://amazon.es/mis-pedidos]Ver mi pedido[/url]",
		"errors": [],
		"is_safe": true,
		"explanation": "Este correo es legítimo. El dominio es correcto, te llama por tu nombre y el enlace apunta a la web oficial."
	},
	{
		"subject": "¡HAS GANADO! 🎁 RECLAMA TU PREMIO",
		"sender": "premios@sorteos-internacionales.net",
		"body": "¡Felicidades usuario!\n\nHas sido seleccionado para recibir un iPhone 15 Pro Max totalmente gratis. Solo tienes que descargar el formulario de envío y rellenarlo:\n\n[url=descarga]formulario_premio.zip.exe[/url]",
		"errors": ["tone", "greeting", "attachment"],
		"is_safe": false,
		"explanation": "Nadie regala iPhones. El archivo tiene doble extensión (.zip.exe), lo cual es un virus clásico."
	},
	{
		"subject": "Actualización de cuenta Microsoft",
		"sender": "no-reply@mircosoft.com",
		"body": "Tu suscripción de Microsoft 365 ha caducado. Por favor, actualiza tus datos de pago en el siguiente portal:\n\n[url=http://mircosoft-pagos.com]Ir al portal de pagos[/url]",
		"errors": ["sender", "url"],
		"is_safe": false,
		"explanation": "Es un ataque de 'typosquatting'. Han escrito 'Mircosoft' (con R antes de la C) para engañar tu vista."
	},
	{
		"subject": "Cita previa Seguridad Social",
		"sender": "avisos@seg-social.es",
		"body": "Hola,\n\nLe recordamos que tiene una cita programada para mañana a las 10:00 AM en su oficina más cercana. Si desea modificarla, acceda a la sede electrónica.",
		"errors": [],
		"is_safe": true,
		"explanation": "Correo informativo real. No pide datos sensibles, no tiene enlaces externos raros y el dominio es el oficial del gobierno."
	},
	{
		"subject": "BLOQUEO DE TARJETA",
		"sender": "alertas@santander-seguro-web.com",
		"body": "URGENTE: Su tarjeta ha sido bloqueada por seguridad. Para reactivarla, introduzca su PIN y clave de firma en este enlace:\n\n[url=http://bit.ly/seguridad-banco]DESBLOQUEAR TARJETA[/url]",
		"errors": ["sender", "tone", "url"],
		"is_safe": false,
		"explanation": "Los bancos nunca piden el PIN por email ni usan acortadores de enlaces como bit.ly."
	}
]

# Nodos actualizados
@onready var label_subject = $MainLayout/Content/Header/MailSubject
@onready var text_email = $MainLayout/Content/EmailView/MarginEmail/ScrollContainer/VBoxEmail/EmailBody
@onready var label_url_tip = $MainLayout/Content/EmailView/MarginEmail/ScrollContainer/VBoxEmail/URLToolTip
@onready var label_points = $MainLayout/Sidebar/MarginSidebar/VBoxSidebar/LabelPoints
@onready var manual_overlay = $ManualOverlay
@onready var feedback_popup = $FeedbackPopUp

# Checkboxes actualizados
@onready var check_sender = $MainLayout/Content/ActionsFooter/HBoxActions/GridChecks/CheckSender
@onready var check_tone = $MainLayout/Content/ActionsFooter/HBoxActions/GridChecks/CheckTone
@onready var check_url = $MainLayout/Content/ActionsFooter/HBoxActions/GridChecks/CheckURL
@onready var check_attachment = $MainLayout/Content/ActionsFooter/HBoxActions/GridChecks/CheckAttachment
@onready var check_is_safe = $MainLayout/Content/ActionsFooter/HBoxActions/CheckIsSafe

func _ready():
	label_url_tip.hide()
	manual_overlay.hide()
	label_points.text = "Points: 0"
	update_email_ui()

func update_email_ui():
	var data = emails[current_email_idx]
	label_subject.text = "Subject: " + data.subject
	text_email.text = "FROM: " + data.sender + "\n\n" + data.body
	
	# Limpiar checkboxes
	check_sender.button_pressed = false
	check_tone.button_pressed = false
	check_url.button_pressed = false
	check_attachment.button_pressed = false
	check_is_safe.button_pressed = false

# --- Lógica de Validación ---
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

# --- Señal de confirmación del Popup ---
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

# --- Funciones de Interfaz ---
func _on_btn_manual_pressed():
	manual_overlay.show()

func _on_btn_close_manual_pressed():
	manual_overlay.hide()

# Señales para el RichTextLabel
func _on_email_body_meta_hover_started(meta):
	label_url_tip.text = "🔗 REAL URL: " + str(meta)
	label_url_tip.show()

func _on_email_body_meta_hover_ended(_meta):
	label_url_tip.hide()
