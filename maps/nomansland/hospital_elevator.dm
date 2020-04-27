/obj/turbolift_map_holder/hospital
    icon = 'icons/obj/turbolift_preview_3x3.dmi'
    depth = 2
    lift_size_x = 4
    lift_size_y = 4

/obj/turbolift_map_holder/hospital/main
    name = "Hospital turbolift map placeholder MAIN"
    dir = EAST
    areas_to_use = list(
        /area/turbolift/cargo_maintenance,
        /area/turbolift/cargo_station
        )

/obj/turbolift_map_holder/hospital/underground
    name = "Hospital turbolift map placeholder UNDERGROUND"
    dir = EAST
    areas_to_use = list(
        /area/turbolift/cargo_maintenance,
        /area/turbolift/cargo_station
        )
