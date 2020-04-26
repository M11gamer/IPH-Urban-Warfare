/obj/item/weapon/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade"
	item_state = "grenade"
	throw_speed = 4
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	var/active = 0
	var/det_time = 50
	var/arm_sound = 'sound/weapons/armbomb.ogg'

/obj/item/weapon/grenade/proc/clown_check(var/mob/living/user)
	if((CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>Huh? How does this thing work?</span>")

		activate(user)
		add_fingerprint(user)
		spawn(5)
			detonate()
		return 0
	return 1


/*/obj/item/weapon/grenade/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	if (istype(target, /obj/item/weapon/storage)) return ..() // Trying to put it in a full container
	if (istype(target, /obj/item/weapon/gun/grenadelauncher)) return ..()
	if((user.get_active_hand() == src) && (!active) && (clown_check(user)) && target.loc != src.loc)
		to_chat(user, "<span class='warning'>You prime the [name]! [det_time/10] seconds!</span>")
		active = 1
		icon_state = initial(icon_state) + "_active"
		playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
		spawn(det_time)
			detonate()
			return
		user.set_dir(get_dir(user, target))
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
	return*/


/obj/item/weapon/grenade/examine(mob/user)
	if(..(user, 0))
		if(det_time > 1)
			to_chat(user, "The timer is set to [det_time/10] seconds.")
			return
		if(det_time == null)
			return
		to_chat(user, "\The [src] is set for instant detonation.")


/obj/item/weapon/grenade/attack_self(mob/user as mob)
	if(!active)
		if(clown_check(user))
			to_chat(user, "<span class='warning'>You prime \the [name]! [det_time/10] seconds!</span>")

			activate(user)
			add_fingerprint(user)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()
	return


/obj/item/weapon/grenade/proc/activate(mob/user as mob)
	if(active)
		return

	if(user)
		msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	icon_state = initial(icon_state) + "_active"
	active = 1
	playsound(loc, arm_sound, 75, 0, -3)

	spawn(det_time)
		detonate()
		return


/obj/item/weapon/grenade/proc/detonate()
//	playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(700,125)


/obj/item/weapon/grenade/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isScrewdriver(W))
		switch(det_time)
			if (1)
				det_time = 10
				to_chat(user, "<span class='notice'>You set the [name] for 1 second detonation time.</span>")
			if (10)
				det_time = 30
				to_chat(user, "<span class='notice'>You set the [name] for 3 second detonation time.</span>")
			if (30)
				det_time = 50
				to_chat(user, "<span class='notice'>You set the [name] for 5 second detonation time.</span>")
			if (50)
				det_time = 1
				to_chat(user, "<span class='notice'>You set the [name] for instant detonation.</span>")
		add_fingerprint(user)
	..()
	return

/obj/item/weapon/grenade/attack_hand()
	walk(src, null, null)
	..()
	return

/obj/item/weapon/grenade/suicide_vest
	name = "suicide vest"
	desc = "An IED suicide vest. Deadly!"
	icon_state = "suicide_vest"
	throw_speed = 1
	throw_range = 2
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	det_time = 10
	var/armed = "disarmed"

/obj/item/weapon/grenade/suicide_vest/detonate()
	if (active)
		var/turf/T = get_turf(src)
		if(!T) return
		var/original_mobs = list()
		var/original_objs = list()

		explosion(T,2,3,3,3)
		for (var/mob/living/L in T.contents)
			original_mobs += L
			if (L.client)
				L.canmove = FALSE
				L.gib()
		for (var/obj/O in T.contents)
			original_objs += O
		playsound(T, "explosion", 100, TRUE)
		spawn (1)
			for (var/mob/living/L in range(1,T))
				if (L)
					L.Weaken()
					if (L)
						L.canmove = TRUE
			for (var/obj/O in original_objs)
				if (O)
					O.ex_act(1.0)
			T.ex_act(1.0)
		qdel(src)


/obj/item/weapon/grenade/suicide_vest/examine(mob/user)
	..()
	to_chat(user, "\The [src] is <b>[armed]</b>.")
	return

/obj/item/weapon/grenade/suicide_vest/attack_self(mob/user as mob)
	if (!active && armed == "armed")
		to_chat(user, "<span class='warning'>You switch \the [name]!</span>")
		activate(user)
		add_fingerprint(user)

/obj/item/weapon/grenade/suicide_vest/attack_hand(mob/user as mob)
	if (!active && armed == "armed" && loc == user)
		to_chat(user, "<span class='warning'>You switch \the [name]!</span>")
		activate(user)
		add_fingerprint(user)
	else
		..()

/obj/item/weapon/grenade/suicide_vest/verb/arm()
	set category = null
	set name = "Arm/Disarm"
	set src in range(1, usr)

	if (armed == "armed")
		to_chat(usr, "You disarm \the [src].")
		armed = "disarmed"
		return
	else
		to_chat(usr, "<span class='warning'>You arm \the [src]!</span>")
		armed = "armed"
		return

/obj/item/weapon/grenade/suicide_vest/activate(mob/living/carbon/human/user as mob)
	if (active)
		return

	if (user)
		msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	if (user)
		user.emote("charge")
	active = TRUE
	playsound(loc, 'sound/weapons/armbomb.ogg', 75, TRUE, -3)

	spawn(det_time)
		visible_message("<span class = 'warning'>\The [src] goes off!</span>")
		detonate()
		return
