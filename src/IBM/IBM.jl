# -------------------------------------------------------------
#   IBM()
# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------

IBM(; parameters=IBMParameters(), derivative=PoissonWRandomDispersal)::IBM = IBM(parameters, derivative, zeros(parameters.max_number_individuals), zeros(parameters.max_number_individuals), zeros(parameters.metapopulation.num_populations),zeros(parameters.metapopulation.num_populations))

# -------------------------------------------------------------
#   set_initial_conditions((::IBM))
# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------
function set_initial_conditions(ibm::IBM)
    num_populations = parameters.mp.num_populations
    num_indivs_initial::Int64 = ibm.parameters.max_number_individuals / 2

    trait_labels = rand(Uniform, num_indivs_initial)
    population_labels = rand(DiscreteUniform(1, num_populations))

    environmental_vector::Vector{Float64} = rand(Uniform(), num_populations)
    abundance_vector::Vector{Int64} = get_abundance_from_population_labels(population_labels)
end

# -------------------------------------------------------------
#   run_IBM(::IBM)
# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------

function run_IBM(ibm::IBM)
    num_timesteps::Int64 = ibm.parameters.number_of_timesteps

    for t = 1:num_timesteps
        dxdt::Function = ibm.derivative
        dxdt(ibm)
    end

end
