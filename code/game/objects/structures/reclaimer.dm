//Important alien structure. Lets aliens make rippers, other aliens, and evolve. -Marshall

var/tyranids = list() //You probably want to put this somewhere else I am just storing the list here so a list exists at all.

/obj/structure/alien/resin/reclaimer
	name = "biomass pool"
	desc = "A pool of liquid biomass."
	icon = 'icons/mob/tyranids.dmi'
	icon_state = "reclaimer"
	density = 0
	opacity = 1
	anchored = 1
	health = 300

/obj/structure/alien/resin/reclaimer/attack_alien(mob/user)
	if(islarva(user))
		return
	if(istype(user,/mob/living/carbon/alien/humanoid/tyranid))
		var/mob/living/carbon/alien/humanoid/tyranid/T = user
		var/choice
		if (istype(user,/mob/living/carbon/alien/humanoid/tyranid/genestealer/antag))
//			choice = input("Choose:","Biomass Pool") as null|anything in list("Produce Ripper (80)") //Commented out but left here if genestealer antags are meant to be able to make ripper swarms. Also useful if we add more options to the pool so the genestealer list can be added without fuss
			user << "You have no need to change your form or create other Tyranids to spread your cult."
		else
			choice = input("Choose:","Biomass Pool") as null|anything in list("Evolve", "Produce Larva (1000)", "Produce Parasite (500)", "Produce Ripper (80)")
		switch(choice)
			if("Produce Parasite (500)")
				if(T.powerc(500))
					T.adjustToxLoss(-500)
					new /mob/living/simple_animal/hostile/alien/parasite(src.loc)
			if("Produce Larva (1000)")
				if(T.powerc(1000))
					T.adjustToxLoss(-1000)
					new /mob/living/carbon/alien/larva/tyranid(src.loc)
			if("Produce Ripper (80)")
				if(istype(T, /mob/living/carbon/alien/humanoid/tyranid/hormagaunt))
					T << "\red You can't make rippers in this evolution."
					return
				if(T.powerc(80))
					T.adjustToxLoss(-80)
					new /mob/living/simple_animal/hostile/alien/ripper(src.loc)
			if("Evolve")
				var/evolchoice
				/*if(T.key in tyranid || lowertext(T.key) in tyranids || T.key in tyranidleader || lowertext(T.key) in tyranidleader)*/
				evolchoice = input("Choose what you wish to evolve into.","Tyranid Evolution") as null|anything in list("Hormagaunt (0)","Warrior (500)","Genestealer (1000)","Lictor (2500)","Ravener (2500)","Venomthropes (3000)","Zoanthropes (3000)")
				/*else
					evolchoice = input("Choose what you wish to evolve into.","Tyranid Evolution") as null|anything in list("Hormagaunt (0)","Warrior (500)")*/
				switch(evolchoice)
					if("Hormagaunt (0)")
						var/mob/living/carbon/alien/humanoid/new_xeno = new /mob/living/carbon/alien/humanoid/tyranid/hormagaunt(T.loc)
						if(T.mind)	T.mind.transfer_to(new_xeno)
						new_xeno.adjustToxLoss(T.getPlasma())
						qdel(T)
					if("Warrior (500)")
						if(T.powerc(500))
							T.adjustToxLoss(-450)
							var/mob/living/carbon/alien/humanoid/new_xeno = new /mob/living/carbon/alien/humanoid/tyranid/warrior(T.loc)
							if(T.mind)	T.mind.transfer_to(new_xeno)
							new_xeno.adjustToxLoss(T.getPlasma()) //Any biomass on top of what you spend evolving you keep.
							qdel(T)
					if("Genestealer (1000)")
						src << {"<span class='noticealien'>Disabled because Lazy coder</span>"}
						if(T.powerc(1000))
							T.adjustToxLoss(-900)
							var/mob/living/carbon/alien/humanoid/new_xeno = new /mob/living/carbon/alien/humanoid/tyranid/genestealer(T.loc)
							if(T.mind)	T.mind.transfer_to(new_xeno)
							new_xeno.adjustToxLoss(T.getPlasma()) //Any biomass on top of what you spend evolving you keep.
							qdel(T)
					if("Lictor (2500)")
						if(T.powerc(2500))
							T.adjustToxLoss(-2250)
							var/mob/living/carbon/alien/humanoid/new_xeno = new /mob/living/carbon/alien/humanoid/tyranid/lictor(T.loc)
							if(T.mind)	T.mind.transfer_to(new_xeno)
							new_xeno.adjustToxLoss(T.getPlasma()) //Any biomass on top of what you spend evolving you keep.
							qdel(T)
					if("Ravener (2500)")
						if(T.powerc(2500))
							T.adjustToxLoss(-2250)
							var/mob/living/carbon/alien/humanoid/new_xeno = new /mob/living/carbon/alien/humanoid/tyranid/ravener(T.loc)
							if(T.mind)	T.mind.transfer_to(new_xeno)
							new_xeno.adjustToxLoss(T.getPlasma()) //Any biomass on top of what you spend evolving you keep.
							qdel(T)
					if("Zoanthropes (3000)")
						if(T.powerc(3000))
							T.adjustToxLoss(-2750)
							var/mob/living/carbon/alien/humanoid/new_xeno = new /mob/living/carbon/alien/humanoid/tyranid/zoanthropes(T.loc)
							if(T.mind)	T.mind.transfer_to(new_xeno)
							new_xeno.adjustToxLoss(T.getPlasma()) //Any biomass on top of what you spend evolving you keep.
							qdel(T)
					if("Venomthropes (3000)")
						if(T.powerc(3000))
							T.adjustToxLoss(-2750)
							var/mob/living/carbon/alien/humanoid/new_xeno = new /mob/living/carbon/alien/humanoid/tyranid/venomthropes(T.loc)
							if(T.mind)	T.mind.transfer_to(new_xeno)
							new_xeno.adjustToxLoss(T.getPlasma()) //Any biomass on top of what you spend evolving you keep.
							qdel(T)


/obj/structure/alien/resin/wall/tyranid //Better looking resin walls and membranes.
	name = "wall"
	desc = "A large, solid chunk of biomass."
	icon = 'icons/mob/tyranids.dmi'
	icon_state = "wall0"

/obj/structure/alien/resin/wall/tyranid/New(loc)
	src.loc = loc
	relativewall_neighbours()
	return

/obj/structure/alien/resin/wall/tyranid/Del()
	spawn(10)
		for(var/obj/structure/alien/resin/wall/tyranid/W in range(src,1))
			W.relativewall()

/obj/structure/alien/resin/wall/tyranid/relativewall_neighbours()
	for(var/obj/structure/alien/resin/wall/tyranid/W in range(src,1))
		W.relativewall()
		W.update_icon()//Refreshes the wall to make sure the icons don't desync
	return

/obj/structure/alien/resin/wall/tyranid/relativewall()
	var/junction = 0 //will be used to determine from which side the wall is connected to other walls
	for(var/obj/structure/alien/resin/wall/tyranid/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			junction |= get_dir(src,W)
	icon_state = "wall[junction]"
	return

/obj/structure/alien/resin/membrane/tyranid
	name = "membrane"
	desc = "A translucent blob of biomass."
	icon = 'icons/mob/tyranids.dmi'
	icon_state = "membrane0"

/obj/structure/alien/resin/membrane/tyranid/New(loc)
	src.loc = loc
	relativewall_neighbours()
	return

/obj/structure/alien/resin/membrane/tyranid/Del()
	spawn(10)
		for(var/obj/structure/alien/resin/membrane/tyranid/W in range(src,1))
			W.relativewall()

/obj/structure/alien/resin/membrane/tyranid/relativewall_neighbours()
	for(var/obj/structure/alien/resin/membrane/tyranid/W in range(src,1))
		W.relativewall()
		W.update_icon()//Refreshes the wall to make sure the icons don't desync
	return

/obj/structure/alien/resin/membrane/tyranid/relativewall()
	var/junction = 0 //will be used to determine from which side the wall is connected to other walls
	for(var/obj/structure/alien/resin/membrane/tyranid/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			junction |= get_dir(src,W)
	icon_state = "membrane[junction]"
	return

/obj/structure/stool/bed/nest/tyranid //recolorized nest
	name = "nest"
	desc = "It's a gruesome pile of thick, sticky biomass shaped like a nest."
	icon = 'icons/mob/tyranids.dmi'
	icon_state = "nest"

/obj/structure/alien/weeds/tyranid  //reskinned weeds
	icon = 'icons/mob/tyranids.dmi'

/obj/structure/alien/weeds/tyranid/Life()
	var/turf/U = get_turf(src)

	if(istype(U, /turf/space))
		qdel(src)
		return

	direction_loop:
		for(var/dirn in cardinal)
			var/turf/T = get_step(src, dirn)

			if (!istype(T) || T.density || locate(/obj/structure/alien/weeds) in T || istype(T, /turf/space))
				continue

			if(!linked_node || get_dist(linked_node, src) > linked_node.node_range)
				return

			for(var/obj/O in T)
				if(O.density)
					continue direction_loop

			new /obj/structure/alien/weeds/tyranid(T, linked_node)

/obj/structure/alien/weeds/tyranid/node
	name = "harvest node"
	desc = "Weird red octopus-like thing."
	icon_state = "weednode"
	luminosity = 3
	var/node_range = 4

/obj/structure/alien/weeds/tyranid/node/New()
	..(loc, src)

/obj/structure/mineral_door/resin/tyranid
	icon = 'icons/mob/tyranids.dmi'

/obj/structure/alien/resin/spore //default is explosive/old spore mine.
	name = "Spore Mine"
	desc = "Some sort of strange hovering organism. This one has has a strange yellow colour."
	icon = 'icons/mob/tyranids.dmi'
	icon_state = "mine"
	density = 0
	opacity = 0
	layer = 5
	var/tripped = 0 //Added as acid/poison pods explode more based on how many times they're tripped and stepping onto a mine can trigger it twice.

/obj/structure/alien/resin/spore/poison
	desc = "Some sort of strange hovering organism. This one leaks traces of gas and smells foul."

/obj/structure/alien/resin/spore/poison/New()
	create_reagents(1000)
	reagents.add_reagent("lesservenomthropes",250) //Non-melting version of venomthrope poison..
	reagents.add_reagent("toxin",250) //This and chloromethane are in a venomthrope's gas.
	reagents.add_reagent("chloromethane",250)
	reagents.add_reagent("tyranid",250) //Hormagaunt venomous bite.

/obj/structure/alien/resin/spore/frag
	desc = "Some sort of strange hovering organism. This one has has a metallic shell."

/obj/structure/alien/resin/spore/acid
	desc = "Some sort of strange hovering organism. This one has has liquid filled sacs under the surface."

/obj/structure/alien/resin/spore/acid/New()
	create_reagents(100)
	reagents.add_reagent("hacid",30) //Should be eacid to match canon strength but that's not balanced at all

/obj/structure/alien/resin/spore/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(tripped) return
	if(istype(mover, /mob/living/carbon/alien))
		return 1
	if(istype(mover, /mob/living/simple_animal/hostile/alien/ripper))
		return 1
	else if(istype(mover, /mob/living/carbon))
		var/mob/living/carbon/M = mover
		if(M.mind && M.mind.special_role == "Genestealer Cult Member")
			return 1
		mover.visible_message("The [src] begins to shake violently!")
		tripped=1
		spawn(10)
			src.explode()
		return 1
	else if(istype(mover, /obj/item/projectile))
		if(prob(65))
			return 1
		else
			tripped=1
			src.explode()
	return 1

/obj/structure/alien/resin/spore/HasProximity(atom/movable/AM as mob|obj)
	if(tripped) return
	if(istype(AM, /mob/living) && !istype(AM, /mob/living/carbon/alien) && !istype(AM, /mob/living/simple_animal/hostile/alien/ripper))
		var/mob/living/carbon/human/T = AM
		if (T.mind && T.mind.special_role == "Genestealer Cult Member") //Feels very messy but alternative is to define T before the first if check. Not sure if it'd be slightly heavier on performance to create a variable every time someone moves near a mine.
			return
		AM.visible_message("The [src] begins to shake violently!")
		tripped=1
		spawn(10)
			src.explode()

/obj/structure/alien/resin/spore/proc/explode()
	if (istype(src, /obj/structure/alien/resin/spore/poison) || istype(src, /obj/structure/alien/resin/spore/acid))	//Can group these as they spit out different reagents
		var/location = get_turf(src)
		var/datum/effect/effect/system/chem_smoke_spread/S = new /datum/effect/effect/system/chem_smoke_spread //And time for toxic smokescreen.
		S.attach(location)
		playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
		spawn(0)
			if(S)
				S.set_up(src.reagents, 10, 0, location)
				S.start() //Should be balanced to keep an area filled for a few seconds but not break the game with lag.
				sleep(30)
				S.start()
				sleep(30)
				S.start()
				sleep(30)
				S.start()
		spawn (92) //Sticks around making chemsmoke for a while.
			qdel(src)
		return
	else if (istype(src, /obj/structure/alien/resin/spore/frag))
		explosion(src.loc,0,0.5,1,flame_range = 2, shrapnel_count = 200) //Same shrapnel as a frag grenade.
	else //defaults to explosive
		explosion(src.loc,1,2,3,flame_range = 3)
	qdel(src)

/obj/structure/alien/resin/spore/healthcheck()
	if(health <=0)
		src.explode()

/obj/effect/resinspikes
	name = "tyranid spikes"
	desc = "looks sharp..."
	icon = 'icons/mob/tyranids.dmi'
	icon_state = "spikes1"
	anchored = 1
	density = 0
	opacity = 0
	var/health = 20

/obj/effect/resinspikes/New()
	icon_state = pick("spikes1","spikes2","spikes3")

/obj/effect/resinspikes/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover, /mob/living/carbon/alien))
		return 1
	else if(istype(mover, /mob/living/carbon))
		var/mob/living/carbon/M = mover
		if(M.mind && M.mind.special_role == "Genestealer Cult Member")
			return 1
		M << "\red You are stabbed by the [src]!"
		M.take_organ_damage(10, 0)
		return prob(10)
	else if(istype(mover, /obj/item/projectile))
		return prob(75)
	return 1

/obj/effect/resinspikes/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(70))
				qdel(src)
		if(3.0)
			if (prob(20))
				qdel(src)
	return

/obj/effect/resinspikes/attackby(var/obj/item/weapon/W, var/mob/user)
	if(W.attack_verb.len)
		visible_message("<span class='danger'>\The [src] has been [pick(W.attack_verb)] with \the [W][(user ? " by [user]" : "")]!</span>")
	else
		visible_message("<span class='danger'>\The [src] has been attacked with \the [W][(user ? " by [user]" : "")]!</span>")

	var/damage = W.force / 4.0

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(loc, 'sound/items/Welder.ogg', 100, 1)

	src.health -= damage
	healthcheck()

/obj/effect/resinspikes/bullet_act(var/obj/item/projectile/Proj)
	..()
	src.health -= Proj.damage
	healthcheck()

/obj/effect/resinspikes/proc/healthcheck()
	if(src.health <= 0)
		qdel(src)

/obj/structure/tunnel/vents
	name = "ventilation breach"
	desc = "A tunnel ripped into the outpost's ventilation system that allows for quick transport through them."
	icon_state = "tunnel_vents"

/obj/structure/tunnel/vents/attack_alien(mob/user)
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/vent/temp_vent in world)
		if(temp_vent.loc.z == 1 && !temp_vent.welded)
			var/turf/T = get_turf(temp_vent)
			var/i = 1
			var/index = "[T.loc.name]\[[i]\]"
			while(index in vents)
				i++
				index = "[T.loc.name]\[[i]\]"
			vents[index] = temp_vent
	var/obj/selection = input(user,"Select a destination.", "Duct System") as null|anything in sortAssoc(vents)
	if(!selection)	return
	if(!Adjacent(user))
		return
	var/obj/machinery/atmospherics/vent/target_vent = vents[selection]
	if(!target_vent)
		return
	user.loc = target_vent.loc

/obj/structure/tunnel/vents/attack_larva(mob/user)
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/vent/temp_vent in world)
		if(temp_vent.loc.z == 1 && !temp_vent.welded)
			var/turf/T = get_turf(temp_vent)
			var/i = 1
			var/index = "[T.loc.name]\[[i]\]"
			while(index in vents)
				i++
				index = "[T.loc.name]\[[i]\]"
			vents[index] = temp_vent
	var/obj/selection = input(user,"Select a destination.", "Duct System") as null|anything in sortAssoc(vents)
	if(!selection)	return
	if(!Adjacent(user))
		return
	var/obj/machinery/atmospherics/vent/target_vent = vents[selection]
	if(!target_vent)
		return
	user.loc = target_vent.loc