
"""
   PFIM(trait_data::DataFrame, feeding_rules::DataFrame; y::Float64 = 2.5, downsample::Bool = true)

    Takes a data frame and implements the feeding rules to determine the
    feasibility of links between species. As well as applying the link
    distribution downsampling approach.
    
    #### References
    
    Shaw, Jack O., Alexander M. Dunhill, Andrew P. Beckerman, Jennifer A.
    Dunne, and Pincelli M. Hull. 2024. “A Framework for Reconstructing 
    Ancient Food Webs Using Functional Trait Data.” 
    https://doi.org/10.1101/2024.01.30.578036.
"""
function PFIM(
    trait_data::DataFrame,
    feeding_rules::DataFrame;
    y::Float64 = 2.5,
    downsample::Bool = true,
)

    # data checks
    for (i, v) in enumerate(["species", "motility", "tiering", "feeding", "size"])
        if v ∉ names(trait_data)
            error("Missing $(v) variable as a column in DataFrame, add or rename")
        end
    end

    network, matrix = _PFIM_network(trait_data, feeding_rules)

    # downsampling protocol
    if downsample == true
        network = _downsample(network, matrix, y)
    end

    return simplify(network)

end
