"""
    _downsample(network, matrix, y)

    Internal function to downsample a network based on species link 
    distributions.

    #### References
    Roopnarine, Peter D. 2006. “Extinction Cascades and Catastrophe in
    Ancient Food Webs.” Paleobiology 32 (1): 1-19. 
    https://www.jstor.org/stable/4096814.

"""
function _downsample(network, matrix, y)

    link_dist = zeros(Float64, richness(network))
    spp = species(network)
    S = richness(network)

    # get link distribution
    for i in eachindex(spp)
        sp = spp[i]
        r = generality(network, sp)
        E = exp(log(S) * (y - 1) / y)
        link_dist[i] = exp(r / E)
    end

    # create probabilistic int matrix
    prob_matrix = zeros(AbstractFloat, (S, S))
    for i in axes(matrix, 1)
        for j in axes(matrix, 2)
            if matrix[i, j] == true
                prob_matrix[i, j] = link_dist[i]
            end
        end
    end
    # make probabalistic
    prob_matrix = prob_matrix ./ maximum(prob_matrix)

    edges = Probabilistic(prob_matrix)
    nodes = Unipartite(spp)
    N = SpeciesInteractionNetwork(nodes, edges)
    return randomdraws(N)
end
