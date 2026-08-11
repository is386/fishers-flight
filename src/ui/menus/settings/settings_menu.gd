extends Control

const TAB_CONTENT_MARGIN: int = 8

@onready var back_button: BaseButton = %BackButton
@onready var settings_tabs: TabContainer = %SettingsTabs

var _callback_control: Control = null


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	back_button.pressed.connect(_on_back_button_pressed)
	SignalBus.settings_requested.connect(_on_settings_requested)

	settings_tabs.tab_focus_mode = Control.FOCUS_NONE
	_pad_tab_content()


func _pad_tab_content() -> void:
	var panel: StyleBox = settings_tabs.get_theme_stylebox(&"panel").duplicate() as StyleBox
	panel.content_margin_left = TAB_CONTENT_MARGIN
	panel.content_margin_top = TAB_CONTENT_MARGIN
	panel.content_margin_right = TAB_CONTENT_MARGIN
	panel.content_margin_bottom = TAB_CONTENT_MARGIN
	settings_tabs.add_theme_stylebox_override(&"panel", panel)


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		_on_back_button_pressed()
		get_viewport().set_input_as_handled()


func _focus_first_tab() -> void:
	settings_tabs.current_tab = 0
	settings_tabs.tab_focus_mode = Control.FOCUS_ALL
	settings_tabs.get_tab_bar().grab_focus.call_deferred()


func _on_visibility_changed() -> void:
	if not is_inside_tree():
		return

	if visible:
		_focus_first_tab()
	else:
		settings_tabs.tab_focus_mode = Control.FOCUS_NONE


func _on_settings_requested(callback_control: Control) -> void:
	_callback_control = callback_control
	if _callback_control != null:
		_callback_control.hide()

	show()


func _on_back_button_pressed() -> void:
	hide()

	if _callback_control == null:
		return

	_callback_control.show()
	_callback_control = null
