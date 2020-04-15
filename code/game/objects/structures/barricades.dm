/obj/structure/sandbag
	name = "sandbag"
	icon = 'icons/obj/barricades.dmi'
	icon_state = "sandbag"
	anchored = 1
	density = 1
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/sandbag/New()
	atom_flags |= ATOM_FLAG_CHECKS_BORDER
	set_dir(dir)
	..()

/obj/structure/sandbag/set_dir(direction)
	dir = direction
	if(dir == NORTH)
		layer = OBJ_LAYER
	else
		layer = FLY_LAYER

/obj/structure/barricade/CanPass(atom/movable/mover, turf/target)

	if(mover && mover.throwing)
		if(iscarbon(mover)) //Leaping mob against barbed wire fails
			if(get_dir(loc, target) & dir)
				return 0
		return 1

	var/obj/structure/S = locate(/obj/structure) in get_turf(mover)
	if(S && ATOM_FLAG_CLIMBABLE && !(S.atom_flags & ATOM_FLAG_CHECKS_BORDER) && isliving(mover)) //Climbable objects allow you to universally climb over others
		return 1

	if(get_dir(loc, target) & dir)
		return 0
	else
		return 1

/obj/structure/sandbag/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover
	cover = get_turf(src)
	if(!cover)
		return 1
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1

	var/chance = 80
	if(ismob(P.original) && get_turf(P.original) == cover)
		var/mob/M = P.original
		if (M.lying)
			chance += 20				//Lying down lets you catch less bullets
		if(get_dir(loc, from) == dir)	//Flipped tables catch mroe bullets
			chance += 40
		else
			return 1					//But only from one side

	if(prob(chance))
		return 0 //blocked
	return 1


/obj/structure/sandbag/ex_act(severity)
	switch(severity)
		if(1.0) qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)
			else
				return


/obj/structure/sandbag/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/shovel/))
		if(anchored)
			playsound(src.loc, 'sound/effects/rustle1.ogg', 100, 1)
			to_chat(user, "<span class='notice'>Now displacing the sandbags...</span>")
			if(do_after(user, 40,src))
				if(!src) return
				to_chat(user, "<span class='notice'>You displaced the sandbags!</span>")
				qdel(src)
				new /obj/item/weapon/sandbag(src.loc)

/obj/item/weapon/sandbag
	name = "sandbags"
	icon_state = "sandbag_empty"
	w_class = 1
	var/sand_amount = 0

/obj/item/weapon/sandbag/attack_self(mob/user as mob)
	if(sand_amount < 1)
		to_chat(user, "\red You need more sand to make wall.")
		return
	else
		to_chat(user, "\red You begin to place the sandbags.")
		if(do_after(user, 40, src))
			var/obj/structure/sandbag/R = new (user.loc)
			R.set_dir(user.dir)
			user.drop_item()
			qdel(src)
		else
			return

/obj/item/weapon/sandbag/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/ore/glass))
		if(sand_amount >= 1)
			to_chat(user, "\red [name] is full!")
			return
		user.drop_item()
		qdel(O)
		sand_amount++
		w_class++
		update_icon()
		to_chat(user, "You need [4 - sand_amount] more units.")

/obj/item/weapon/sandbag/update_icon()
	if(sand_amount >= 1)
		icon_state = "sandbag"
	else
		icon_state = "sandbag_empty"

/obj/structure/foxhole
	name = "foxhole"
	icon = 'icons/obj/barricades.dmi'
	icon_state = "foxhole"
	anchored = 1
	density = 1
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/foxhole/New()
	atom_flags |= ATOM_FLAG_CHECKS_BORDER
	update_icon()
	..()

/obj/structure/foxhole/update_icon()
	..()
	overlays += image('icons/obj/barricades.dmi', src, "foxhole-over", FLY_LAYER)

/obj/structure/foxhole/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /obj/item/))
		return check_cover(mover, target)
	else
		return 0

/obj/structure/foxhole/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover
	cover = get_turf(src)
	if(!cover)
		return 1
	if(get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1

	var/chance = 20
	if(ismob(P.original) && get_turf(P.original) == cover)
		var/mob/M = P.original
		if (M.lying)
			chance += 60				//Lying down lets you catch less bullets
		if(get_dir(loc, from) == dir)	//Flipped tables catch mroe bullets
			chance += 40
		else
			return 1					//But only from one side

	if(prob(chance))
		return 0 //blocked
	return 1


/obj/structure/foxhole/ex_act(severity)
	switch(severity)
		if(1.0) qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)
			else
				return

/obj/structure/foxhole/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/shovel/))
		if(anchored)
			playsound('sound/effects/rustle1.ogg', 100, 1)
			to_chat(user, "<span class='notice'>Now displacing the foxhole...</span>")
			if(do_after(user, 40,src))
				if(!src) return
				to_chat(user, "<span class='notice'>You displaced the foxhole!</span>")
				qdel(src)


/obj/structure/m_barricade
	name = "metal barricade"
	desc = "A solid barricade made of steel. Use a welding tool and/or steel to repair it if damaged."
	icon = 'icons/obj/barricades.dmi'
	icon_state = "barricade"
	density = 1
	anchored = 1.0
	layer = 2.9
	throwpass = 1	//You can throw objects over this, despite its density.
	atom_flags = ATOM_FLAG_CHECKS_BORDER | ATOM_FLAG_CLIMBABLE
	var/health = 500 //Pretty tough. Changes sprites at 300 and 150.
	unacidable = 0 //Who the fuck though unacidable barricades with 500 health was a good idea?


/obj/structure/m_barricade/update_icon()
	if(health < 300 && health > 150)
		icon_state = "barricade_dmg1"
	else if(health <= 150)
		icon_state = "barricade_dmg2"
	else
		icon_state = initial(icon_state)

/obj/structure/m_barricade/proc/update_health()
	if(health < 0)
		src.visible_message("\red [src] collapses!")
		var/obj/item/stack/material/steel/P = new (src.loc)
		P.amount = pick(3,4)
		density = 0
		del(src)
		return

	if(health > 500) health = 500
	update_icon()
	return

/obj/structure/m_barricade/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_GRILLE))
		return 1
	if(locate(/obj/structure/table) in get_turf(mover)) //Tables let you climb on barricades.
		return 1
	if (get_dir(loc, target) == dir)
		return 0
	else
		return 1

/obj/structure/m_barricade/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASS_FLAG_GRILLE))
		return 1
	if(locate(/obj/structure/table) in get_turf(O)) //Tables let you climb on barricades.
		return 1
	if (get_dir(loc, target) == dir)
		return 0
	else
		return 1

/obj/structure/m_barricade/attackby(obj/item/W as obj, mob/user as mob)
	if (!W) return

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(health < 150)
			to_chat(user, "It's too damaged for that. Better just to build a new one.")
			return

		if(health >= 500)
			to_chat(user, "It's already in perfect condition.")
			return

		if(WT.remove_fuel(0, user))
			user.visible_message("\blue [user] begins repairing damage to the [src].","\blue You begin repairing the damage to the [src].")
			if(do_after(user,50))
				user.visible_message("\blue [user] repairs the damaged [src].","\blue You repair the [src]'s damage.")
				health += 150
				if(health > 500) health = 500
				update_health()
				playsound(src.loc, 'sound/items/Welder2.ogg', 75, 1)
				return
		return

	return

/obj/structure/m_barricade/ex_act(severity)
	switch(severity)
		if(1.0)
			health -= rand(150,500)
		if(2.0)
			health -= rand(150,350)
		if(3.0)
			health -= rand(50,100)

	update_health()




/obj/structure/concreteblock
	name = "concrete block"
	icon = 'icons/obj/barricades.dmi'
	icon_state = "block"
	anchored = 1
	density = 1
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/concreteblock/New()
	atom_flags |= ATOM_FLAG_CHECKS_BORDER
	set_dir(dir)
	..()

/obj/structure/concreteblock/set_dir(direction)
	dir = direction
	if(dir == NORTH)
		layer = OBJ_LAYER
	else
		layer = FLY_LAYER

/obj/structure/concreteblock/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /obj/item/projectile))
		return check_cover(mover, target)
	if (get_dir(loc, target) == dir)
		return !density
	else
		return 1

/obj/structure/concreteblock/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover
	cover = get_turf(src)
	if(!cover)
		return 1
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1

	var/chance = 80
	if(ismob(P.original) && get_turf(P.original) == cover)
		var/mob/M = P.original
		if (M.lying)
			chance += 35				//Lying down lets you catch less bullets
		if(get_dir(loc, from) == dir)	//Flipped tables catch mroe bullets
			chance += 40
		else
			return 1					//But only from one side

	if(prob(chance))
		return 0 //blocked
	return 1

/*
/obj/structure/concreteblock/ex_act(severity)
	switch(severity)
		if(1.0) qdel(src)
		if(2.0)
			if (prob(25))
				visible_message("\red <b>[src] is blown apart!.</b>")
				qdel(src)
				var/obj/item/stack/material/concrete/W = new /obj/item/stack/material/concrete(src.loc)
				W.pixel_y = src.pixel_y
				W.amount = rand(3,6) //going to mess with this value for a while, we'll see
*/

/obj/structure/brustwehr
	name = "brustwehr"
	desc = "It could be worse..."
	icon = 'icons/obj/barricades.dmi'
	icon_state = "brustwehr_0"
	var/health = 200 //Actual health depends on snow layer
	density = 1
	anchored = 1
	layer = 2.9
	atom_flags = ATOM_FLAG_CLIMBABLE

	//Constructed
/obj/structure/brustwehr/New()
		update_nearby_icons()

/obj/structure/brustwehr/attackby(obj/item/W as obj, mob/user as mob)
	switch(W.damtype)
		if("fire")
			src.health -= W.force * 0.6
		if("brute")
			src.health -= W.force * 0.3
		else
			health_check()
			..()

/obj/structure/brustwehr/proc/health_check(var/die)
	if(health < 1 || die)
		update_nearby_icons()
		visible_message("\red <B>[src] falls apart!</B>")
		qdel(src)

	//Explosion Act
/obj/structure/brustwehr/ex_act(severity)
	switch(severity)
		if(1.0)
			visible_message("\red <B>[src] is blown apart!</B>")
			src.update_nearby_icons()
			del(src)
			return
		if(2.0)
			src.health -= between(30,60)
			if (src.health <= 0)
				visible_message("\red <B>[src] is blown apart!</B>")
				src.update_nearby_icons()
				del(src)
			return
		if(3.0)
			src.health -= between(10,30)
			if (src.health <= 0)
				visible_message("\red <B>[src] is blown apart!</B>")
				src.update_nearby_icons()
				qdel(src)
			return

	//Bullet Passable
/obj/structure/brustwehr/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0))
		return 1
			//if(istype(mover,/obj/item/projectile))
				//return(check_cover(mover,target))
		if(istype(mover) && mover.checkpass(PASS_FLAG_GRILLE))
			return 1
		if(locate(/obj/structure/brustwehr) in get_turf(mover))
			return 1


	//checks if projectile 'P' from turf 'from' can hit whatever is behind the barricade. Returns 1 if it can, 0 if bullet stops.
/obj/structure/brustwehr/proc/check_cover(obj/item/projectile/P, turf/from)
	for(var/turf/cover)
		//get_step(src.loc,dir)
		if (get_dist(P.starting, loc) <= 1) //Barricades won't help you if people are THIS close
			return 1
		if (get_turf(P.original) == cover)
			var/chance = 70
			if (ismob(P.original))
				var/mob/M = P.original
				if (M.lying)
					chance += 20				//Lying down lets you catch less bullets
			if(prob(chance))
				health -= P.damage/4
				visible_message("<span class='warning'>[P] hits [src]!</span>")
				health_check()
				return 0
		return 1

	//Update Sides
/obj/structure/brustwehr/proc/update_nearby_icons()
	update_icon()
	for(var/direction in GLOB.cardinal)
		for(var/obj/structure/brustwehr/B in get_step(src,direction))
			B.update_icon()

	//Update Icons
/obj/structure/brustwehr/update_icon()
	spawn(2)
		if(!src)
			return
		var/junction = 0 //will be used to determine from which side the barricade is connected to other barricades
		for(var/obj/structure/brustwehr/B in orange(src,1))
			if(abs(x-B.x)-abs(y-B.y) ) 		//doesn't count barricades, placed diagonally to src
				junction |= get_dir(src,B)

		icon_state = "brustwehr_[junction]"
		return

/obj/structure/barbedwire
	name = "barbed wire"
	desc = "Don't tread on me."
	icon = 'icons/obj/barricades.dmi'
	icon_state = "barbedwire"
	var/health = 10000 //It's not easy to remove barbed wire with your damn fists. Leave that to the sappers.
	density = 1
	anchored = TRUE
	var/capture = FALSE
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/barbedwire/ex_act(severity)
	switch (severity)
		if (3.0)
			if (prob(50))
				qdel(src)
		else
			qdel(src)

/obj/structure/barbedwire/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return TRUE

/obj/structure/barbedwire/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover = get_turf(src)
	if (!cover)
		return TRUE
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return TRUE

	var/chance = 50 - (P.penetrating * 3)
	if (prob(chance))
		visible_message("<span class='warning'>[P] hits \the [src]!</span>")
		return FALSE
	else
		return TRUE

/obj/structure/barbedwire/Crossed(AM as mob|obj)
	if (ismob(AM))
		var/mob/M = AM
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			if (prob (33))
				playsound(loc, 'sound/effects/glass_step.ogg', 50, TRUE)
				var/obj/item/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot", "l_leg", "r_leg"))
				if (affecting.status & ORGAN_ROBOT)
					return
				if (affecting.take_damage(3, FALSE))
					H.UpdateDamageIcon()
				H.updatehealth()
				if (!(H.species && (H.species.species_flags)))
					H.Weaken(1)
				to_chat(M, "<span class = 'danger'><b>Your [affecting.name] gets slightly cut by \the [src]!</b></span>")
			else if (prob (33))
				playsound(loc, 'sound/effects/glass_step.ogg', 50, TRUE)
				var/obj/item/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot", "l_leg", "r_leg"))
				if (affecting.status & ORGAN_ROBOT)
					return
				if (affecting.take_damage(8, FALSE))
					H.UpdateDamageIcon()
				H.updatehealth()
				if (!(H.species && (H.species.species_flags)))
					H.Weaken(2)
				to_chat(M, "<span class = 'danger'><b>Your [affecting.name] gets cut by \the [src]!</b></span>")
			else
				playsound(loc, 'sound/effects/glass_step.ogg', 50, TRUE)
				var/obj/item/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot", "l_leg", "r_leg"))
				if (affecting.status & ORGAN_ROBOT)
					return
				if (affecting.take_damage(13, FALSE))
					H.UpdateDamageIcon()
				H.updatehealth()
				if (!(H.species && (H.species.species_flags)))
					H.Weaken(3)
				to_chat(M, "<span class = 'danger'><b>Your [affecting.name] gets deeply cut by \the [src]!</b></span>")
			// stop crawling until we're up to prevent buggy crawling
			H.scrambling = TRUE
			spawn (35)
				H.scrambling = FALSE
	return ..()

/obj/structure/barbedwire/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wirecutters))
		if (anchored)
			user.visible_message("<span class = 'notice'>\The [user] starts to cut through \the [src] with [W].</span>")
			if (!do_after(user,60))
				user.visible_message("<span class = 'notice'>\The [user] decides not to cut through the \the [src].</span>")
				return
			user.visible_message("<span class = 'notice'>\The [user] finishes cutting through \the [src]!</span>")
			playsound(loc, 'sound/items/Wirecutter.ogg', 50, TRUE)
			qdel(src)
			return

	else if (istype(W, /obj/item/weapon/material/knife))
		if (anchored)
			user.visible_message("<span class = 'notice'>\The [user] starts to cut through \the [src] with [W].</span>")
			if (!do_after(user,80))
				user.visible_message("<span class = 'notice'>\The [user] decides not to cut through \the [src].</span>")
				return
			if (prob(40))
				user.visible_message("<span class = 'notice'>\The [user] finishes cutting through \the [src]!</span>")
				playsound(loc, 'sound/items/Wirecutter.ogg', 50, TRUE)
				qdel(src)
				return
			else
				if (ishuman(user))
					var/mob/living/carbon/human/H = user
					var/obj/item/organ/external/affecting = null
					if (istype(H.l_hand, /obj/item/weapon/material/knife))
						affecting = H.get_organ("l_hand")
					else
						affecting = H.get_organ("r_hand")

					to_chat(user, "<span class = 'danger'><b>Your hand slips, causing \the [src] to cut your [affecting.name] open!</b></span>")
					playsound(loc, 'sound/effects/glass_step.ogg', 50, TRUE)
					if (affecting.status & ORGAN_ROBOT)
						return
					if (affecting.take_damage(10, FALSE))
						H.UpdateDamageIcon()
					H.updatehealth()
					if (!(H.species && (H.species.species_flags)))
						H.Weaken(1)

/obj/structure/anti_tank
	name = "anti-tank structure"
	icon_state = "anti-tank"
	bound_width = 32
	bound_height = 32
	density = TRUE
	anchored = TRUE

/obj/structure/anti_tank/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		if (anchored)
			user.visible_message("<span class = 'notice'>\The [user] starts to disassemble \the [src] with [W].</span>")
			if (!do_after(user,60))
				user.visible_message("<span class = 'notice'>\The [user] decides not to disassemble \the [src].</span>")
				return
			user.visible_message("<span class = 'notice'>\The [user] finishes disassembling \the [src]!</span>")
			playsound(loc, 'sound/items/Wirecutter.ogg', 50, TRUE)
			qdel(src)
			return

/obj/structure/anti_tank/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover, /obj/item/projectile))
		if (prob(20))
			return TRUE
		else
			visible_message("<span class = 'warning'>The [mover.name] riochetes off of the [name]!</span>")
			return FALSE
	return FALSE

/obj/structure/anti_tank/ex_act(severity)
	switch(severity)
		if (1.0)
			qdel(src)
			return
		if (2.0)
			if (prob(25))
				qdel(src)
				return
		if (3.0)
			return

/obj/structure/campfire //i legit don't have anywhere else to put this
	icon = 'icons/obj/campfire.dmi'
	icon_state = "campfire20"
	layer = MOB_LAYER - 0.01
	density = FALSE
	var/activeFire = FALSE
	anchored = TRUE


/obj/structure/campfire/attackby(obj/item/W as obj, mob/user as mob)
	if (!activeFire)
		if (istype(W, /obj/item/weapon/flame))
			user.visible_message("<span class = 'notice'>\The [user] lights \the [src] with [W].</span>")
			icon_state = "campfire21"
			set_light(4)
			activeFire = TRUE
	if (activeFire)
		if (istype(W, /obj/item/weapon/flame))
			return
		else
			user.visible_message("<span class = 'notice'>\The [user] puts out \the [src] with [W].</span>")
			icon_state = "campfire20"
			set_light(0)
			activeFire = FALSE

/obj/structure/minestructure
	name = "HE mine"
	desc = "Don't tread on me, but this time do it for sure."
	//icon = 'icons/obj/miscobjs.dmi'
	//icon_state = "mineobject"
	var/health = 10000
	density = 1
	anchored = TRUE
	var/capture = FALSE
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/minestructure/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		if (anchored)
			user.visible_message("<span class = 'notice'>\The [user] starts to deactivate \the [src] with [W].</span>")
			if (!do_after(user,60))
				user.visible_message("<span class = 'notice'>\The [user] decides not to deactivate \the [src].</span>")
				return
			user.visible_message("<span class = 'notice'>\The [user] finishes deactivating \the [src]!</span>")
			playsound(loc, 'sound/items/Wirecutter.ogg', 50, TRUE)
			qdel()
			return

/obj/structure/minestructure/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return TRUE

/obj/structure/minestructure/Crossed(AM as mob|obj)
	if (ismob(AM))
		var/mob/M = AM
		if(ishuman(M))
			playsound(loc, 'sound/weapons/mine_onstep.ogg', 100, TRUE) //Sorry, Matt. I had to do it to 'em.
			to_chat(M, "<span class = 'danger'>You step on the [src]! Pray to God you'll survive!</span>")
			explosion(src.loc, 0, 1, 2, 3, 0)
			qdel(src)
	return ..()

/obj/structure/minestructuredummy
	name = "HE mine"
	desc = "Don't tread on me, but this time do it for sure."
	//icon = 'icons/obj/miscobjs.dmi'
	//icon_state = "mineobject"
	var/health = 10000
	density = 1
	anchored = TRUE
	var/capture = FALSE
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/minestructuredummy/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		if (anchored)
			user.visible_message("<span class = 'notice'>\The [user] starts to deactivate \the [src] with [W].</span>")
			if (!do_after(user,60))
				user.visible_message("<span class = 'notice'>\The [user] decides not to deactivate \the [src].</span>")
				return
			user.visible_message("<span class = 'notice'>\The [user] finishes deactivating \the [src]!</span>")
			playsound(loc, 'sound/items/Wirecutter.ogg', 50, TRUE)
			qdel()
			return

/obj/structure/minestructuredummy/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return TRUE

/obj/structure/minestructuredummy/Crossed(AM as mob|obj)
	if (ismob(AM))
		var/mob/M = AM
		if(ishuman(M))
			playsound(loc, 'sound/weapons/mine_onstep.ogg', 50, TRUE) //Sorry, Matt. I had to do it to 'em.
			to_chat(M, "<span class = 'danger'>You step on \the [src]! Pray to God you'll survive...or don't?</span>")
	return ..()