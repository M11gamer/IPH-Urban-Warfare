/datum/job/federal

/datum/job/federal/soldier
	title = "Federal Soldier"
	department = "Federation"
	department_flag = FDR

	total_positions = 10
	spawn_positions = 1
	rankprefix  = "Ryad."
	supervisors = "whoever is higher-ranked"
	selection_color = "#008000"
	economic_modifier = 7
	//access = list(
	//minimal_access = list(
	//minimal_player_age = 18
	ideal_character_age = 21
	outfit_type = /decl/hierarchy/outfit/job/federal/soldier

/datum/job/federal/medic
	title = "Federal Medic"
	department = "Federation"
	department_flag = FDR

	total_positions = 2
	spawn_positions = 1
	supervisors = "whoever is higher-ranked"
	selection_color = "#228B22"
	economic_modifier = 7
	//access = list(
	//alt_titles = list("Xenoarcheologist", "Anomalist", "Phoron Researcher")
	//minimal_player_age = 7
	ideal_character_age = 26
	outfit_type = /decl/hierarchy/outfit/job/federal/medic

/datum/job/federal/officer
	title = "Federal Officer"
	department = "Federation"
	department_flag = COMFDR

	total_positions = 2
	spawn_positions = 1
	rankprefix  = "Serg."
	supervisors = "the commanding officer"
	selection_color = "#00FF00"
	economic_modifier = 9
	is_officer = 1
	//access = list(
	//minimal_player_age = 7
	//outfit_type = /decl/hierarchy/outfit/job/federal/officer

	equip(var/mob/living/carbon/human/H)
		..()
		if(!H.religion_is_legal())//So that they can't be heretics. Orthodoxy only!
			H.religion = LEGAL_RELIGION
		//H.add_stats(rand(6,9), rand(9,11), rand(10,12))
		H.generate_stats(STAT_ST)
		H.generate_skills(list("melee","ranged","medical","engineering"))

/datum/job/federal/general
	title = "Federal General"
	head_position = 1
	req_admin_notify = 1
	department = "Federation"
	department_flag = COMFDR

	total_positions = 1
	spawn_positions = 1
	supervisors = "High Military Command and your good will"
	selection_color = "#32CD32"
	economic_modifier = 11
	is_officer = 1
	is_commander = 1
	//access = list(
	//minimal_access = list(
	//minimal_player_age = 7
	//outfit_type = /decl/hierarchy/outfit/job/federal/general
