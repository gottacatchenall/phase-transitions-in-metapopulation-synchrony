

# -------------------------------------------------------------
#   RandomDispersal()
# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------
function RandomDispersal(ibm::IBM)
    (population_labels, migration_rates, dispersal_potential) = ibm.population_labels, [ibm.metapopulation], ibm.metapopulation.dispersal_potential

    pop_i::Int64 = 0
    for i = 1:max_n_indivs
        pop_i = population_labels[i]
        if pop_i > 0

        end
    end


end


# -------------------------------------------------------------
#   PoissonWSelection()
# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------
function PoissonWSelection(ibm::IBM)

end



# -------------------------------------------------------------
#   PoissonWRandomDispersal()
# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------
function PoissonWRandomDispersal(ibm::IBM)
    num_populations::Int64 = ibm.parameters.num_populations
    max_n_indivs::Int64 = ibm.parameters.max_number_individuals

    RandomDispersal(ibm)
    PoissonWSelection(ibm)

  end
