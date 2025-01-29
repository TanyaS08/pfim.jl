module pfim

# Dependencies
using DataFrames
using SpeciesInteractionNetworks

include(joinpath("lib", "pfimnetwork.jl"))
export extinctionsequence

include(joinpath("lib", "downsample.jl"))

include(joinpath("lib", "pfim.jl"))
export extinction

end # module pfim
