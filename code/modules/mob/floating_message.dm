// Thanks to Burger from Burgerstation for the foundation for this

/atom/movable
	var/list/stored_chat_text

/atom/movable/proc/animate_chat(message, decl/language/language, small, list/show_to, duration)
	set waitfor = FALSE

	var/style	//additional style params for the message
	var/fontsize = 6
	if(small)
		fontsize = 5
	var/limit = 50
	if(copytext(message, length(message) - 1) == "!!")
		fontsize = 8
		limit = 30
		style += "font-weight: bold;"

	if(length(message) > limit)
		message = "[copytext(message, 1, limit)]..."

	style += "color: [get_floating_message_color(name)];"
	// create 1(2) messages, one that appears if you know the language, and one that appears when you don't know the language
	var/image/understood = generate_floating_text(src, capitalize(message), style, fontsize, duration, show_to)
	//var/image/gibberish = language ? generate_floating_text(src, language.scramble(message), style, fontsize, duration, show_to) : understood

	for(var/client/C in show_to)
		if(!C.mob.is_deaf() && C.get_preference_value(/datum/client_preference/floating_messages) == GLOB.PREF_SHOW)
			if(C.mob.say_understands(null))
				C.images += understood
			//else
		//return FALSE
				//C.images += gibberish

// Aracne magicks to keep consistent color for given name without me figuring out color maths
/proc/get_floating_message_color(name)
	var/seed = name+game_id
	seed = copytext(md5(seed), 1, 6)
	seed = hex2num(seed) % 10000
	rand_seed(seed)
	var/list/base_colors = list("#83c0dd","#8396dd","#9983dd","#c583dd","#dd83b6","#dd8383","#83dddc","#83dd9f","#a5dd83","#ddd983","#dda583","#dd8383")
	var/base_color = base_colors[seed % base_colors.len]
	var/list/components = GetHexColors(base_color)
	for(var/i in 1 to 3)
		var/sign = seed % 2 ? -1 : 1
		components[i] += sign * rand(60)
		components[i] = Clamp(components[i], 0, 255)
	return rgb(components[1], components[2], components[3])

/proc/generate_floating_text(atom/movable/holder, message, style, size, duration, show_to)
	var/image/I = image(null, holder)
	I.layer=FLY_LAYER
	I.alpha = 0
	I.maptext_width = 80
	I.maptext_height = 64
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
	I.pixel_x = -round(I.maptext_width/2) + 16

	style = "font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: [size]px; [style]"
	I.maptext = "<center><span style=\"[style]\">[message]</span></center>"
	animate(I, 1, alpha = 255, pixel_y = 16)

	for(var/image/old in holder.stored_chat_text)
		animate(old, 2, pixel_y = old.pixel_y + 8)
	LAZYADD(holder.stored_chat_text, I)

	addtimer(CALLBACK(GLOBAL_PROC, .proc/remove_floating_text, holder, I), duration)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/remove_images_from_clients, I, show_to), duration + 2)

	return I

/proc/remove_floating_text(atom/movable/holder, image/I)
	animate(I, 2, pixel_y = I.pixel_y + 10, alpha = 0)
	LAZYREMOVE(holder.stored_chat_text, I)