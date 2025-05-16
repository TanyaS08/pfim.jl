module SPTestMetaweb

using CSV
using DataFrames
using pfim
using SpeciesInteractionNetworks
using Test

# import feeding rules
feeding_rules = DataFrame(CSV.File("units/data/feeding_rules.csv"))
# import trait
traits = DataFrame(CSV.File.(joinpath("units/data/trait.csv")))
traits = convert.(String, traits)
# build metaweb
N = pfim.PFIM(traits, feeding_rules; downsample = false)

# get pfim interactions
pfim_int = interactions(N)

# get known interaction list
known_list = DataFrame(CSV.File("units/data/interactions.csv"))

known_int = tuple.(Symbol.(known_list.consumer), Symbol.(known_list.resource), true)

# test if interaction pairs match up
@test sort(pfim_int) == sort(known_int)

end
