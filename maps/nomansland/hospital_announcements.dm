/datum/map/hospital
	emergency_shuttle_docked_message = "The Federation evacuation helicopter has arrived. All troops have %ETD% to reach the evacuation point!"
	emergency_shuttle_leaving_dock = "The Federation evacuation helicopter has departed. Estimate %ETA% to reach %dock_name%."

	emergency_shuttle_called_message = "Distress signal launched from operating Federation units. The helicopter will arrive in approximately %ETA%"
	emergency_shuttle_called_sound = 'sound/AI/november/warning.ogg'

	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."

	command_report_sound = 'sound/AI/november/attention.ogg'
	grid_check_sound = 'sound/AI/november/warning.ogg'
	grid_restored_sound = 'sound/AI/november/warning.ogg'
	meteor_detected_sound = 'sound/AI/november/threat.ogg'
	radiation_detected_message = "WARNING: High levels of radiation detected in proximity of the %STATION_NAME%. Please evacuate into one of the shielded maintenance tunnels."
	radiation_detected_sound = 'sound/AI/november/threat.ogg'
	space_time_anomaly_sound = 'sound/AI/november/subspace.ogg'
	unidentified_lifesigns_sound = 'sound/AI/november/threat.ogg'

	electrical_storm_moderate_sound = null
	electrical_storm_major_sound = null

/datum/map/hospital/level_x_biohazard_sound(var/bio_level)
	switch(bio_level)
		if(7)
			return 'sound/AI/november/threat.ogg'
		else
			return 'sound/AI/november/threat.ogg'
