
/datum/map/hospital
	name = "Nikolaevskaya Hospital"
	full_name = "Nikolaevskaya Therapy Hospital"
	path = "hospital"

	lobby_icon = 'maps/hospital/hospital_lobby.dmi'

	sealed_levels = list(1)
	admin_levels = list(5)
	contact_levels = list(1)
	player_levels = list(1)
	accessible_z_levels = list("1"=1,"2"=1,"3"=1,"4"=1)

	allowed_spawns = list("Unknown")

	station_name  = "Nikolaevskaya Therapy Hospital"
	station_short = "Nikolaevskaya Hospital"
	dock_name     = "Evacuation Point"
	boss_name     = "Postia Federation"
	boss_short    = "Federation"
	company_name  = "Postia Insurgents"
	company_short = "Insurgents"
	system_name = "Postia"

	id_hud_icons = 'maps/dreyfus/icons/assignment_hud.dmi'


	map_admin_faxes = list("United Nations Peacekeeper Authority")

	shuttle_docked_message = "The helicopter has reached the evacuation point."
	shuttle_leaving_dock = "The helicopter has departed from the evacuation point.."
	shuttle_called_message = "A helicopter was called to Nikolaevskaya Hospital, it is expected to land in the evacuation point."
	shuttle_recall_message = "The evacuation helicopter was recalled."
	emergency_shuttle_docked_message = "The emergency helicopter has reached the evacuation point.."
	emergency_shuttle_leaving_dock = "The emergency helicopter has departed from the evacuation point."
	emergency_shuttle_called_message = "An emergency helicopter has been sent."
	emergency_shuttle_recall_message = "The emergency helicopter was called back."

	evac_controller_type = /datum/evacuation_controller/shuttle

/datum/event_container/mundane
	available_events = list(
		// Severity level, event name, even type, base weight, role weights, one shot, min weight, max weight. Last two only used if set and non-zero
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Nothing",			/datum/event/nothing,			100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "APC Damage",		/datum/event/apc_damage,		20, 	list(ASSIGNMENT_ENGINEER = 10)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Brand Intelligence",/datum/event/brand_intelligence,10, 	list(ASSIGNMENT_JANITOR = 10),	1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Camera Damage",		/datum/event/camera_damage,		20, 	list(ASSIGNMENT_ENGINEER = 10)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Economic News",		/datum/event/economic_event,	300),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Lost Carp",			/datum/event/carp_migration, 	20, 	list(ASSIGNMENT_SECURITY = 10), 1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Hacker",		/datum/event/money_hacker, 		0, 		list(ASSIGNMENT_ANY = 4), 1, 10, 25),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Lotto",		/datum/event/money_lotto, 		0, 		list(ASSIGNMENT_ANY = 1), 1, 5, 15),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mundane News", 		/datum/event/mundane_news, 		300),
		//new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Psionic Signal", 		/datum/event/minispasm, 		300),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Shipping Error",	/datum/event/shipping_error	, 	30, 	list(ASSIGNMENT_ANY = 2), 0),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Sensor Suit Jamming",/datum/event/sensor_suit_jamming,50,	list(ASSIGNMENT_MEDICAL = 20, ASSIGNMENT_AI = 20), 1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Trivial News",		/datum/event/trivial_news, 		400),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Vermin Infestation",/datum/event/infestation, 		100,	list(ASSIGNMENT_JANITOR = 100)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Wallrot",			/datum/event/wallrot, 			0,		list(ASSIGNMENT_ENGINEER = 30, ASSIGNMENT_GARDENER = 50)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Space Cold Outbreak",/datum/event/space_cold,		100,	list(ASSIGNMENT_MEDICAL = 20)),
	)

/datum/map/hospital/perform_map_generation()
	return 0
