"""
    _PFIM_network(trait_data::DataFrame, feeding_rules::DataFrame)

    Internal function that constructs a network for a community
    when only categorical traits are given.

"""
function _PFIM_network(trait_data::DataFrame, feeding_rules::DataFrame)

    S = nrow(trait_data)
    int_matrix = zeros(Bool, (S, S))

    for cons = 1:nrow(trait_data)
        for res = 1:nrow(trait_data)
            consumer = trait_data[cons, :]
            resource = trait_data[res, :]
            traits = unique(collect(feeding_rules.trait_type_resource))

            # keep record if rule is met or not
            tally = 0

            if eltype(trait_data.size) == String
                for i in Symbol.(traits)
                    consumer_trait = consumer[i]
                    resource_trait = resource[i]
                    # get the resources (diet) for consumer trait
                    resources =
                        filter(
                            :trait_consumer => x -> x == consumer_trait,
                            feeding_rules,
                        ).trait_resource
                    # assess if resource trait is in the diet
                    if resource_trait ∈ resources
                        tally += 1
                    end
                end

                # only add link if all rules (i..e for each trait) are met
                if tally == length(traits)
                    int_matrix[cons, res] = 1
                end
            else
                if consumer.size >= resource.size
                    for i in Symbol.(traits[1:3])
                        consumer_trait = consumer[i]
                        resource_trait = resource[i]
                        resources =
                            filter(
                                :trait_consumer => x -> x == consumer_trait,
                                feeding_rules,
                            ).trait_resource
                        if resource_trait ∈ resources
                            tally += 1
                        end
                    end

                    # only add link if all 3 rules are met
                    if tally == [length(traits) - 1]
                        int_matrix[cons, res] = 1
                    end
                end
            end



        end
    end

    nodes = Unipartite(Symbol.(trait_data.species))
    edges = Binary(int_matrix)
    network = SpeciesInteractionNetwork(nodes, edges)
    return network, int_matrix
end
