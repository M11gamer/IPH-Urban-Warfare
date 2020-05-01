#if !defined(using_map_DATUM)
	#include "fort_areas.dm"
	#include "fort_define.dm"

	#include "fort-1.dmm"
	#include "fort-2.dmm"
	#include "fort-3.dmm"

	#include "../shared/job/jobs.dm"
	#include "../../code/modules/lobby_music/absconditus.dm"

	#define using_map_DATUM /datum/map/example

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Example

#endif
