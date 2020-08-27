struct IBMParameters
    metapopulation::Metapopulation
    heritable_trait_variability::Float64
    temporal_environmental_variability::Float64
    selection_strength::Float64
    base_lambda::Float64
    initial_trait_variation::Float64
    max_number_individuals::Int64
    number_of_timesteps::Int64
    log_frequency::Int64
end

struct IBM
    parameters::IBMParameters

    derivative::Function

    # Vector of labels at individual level
    population_labels::Vector{Int64}
    trait_labels::Vector{Float64}

    # Vectors of population level info
    environmental_vector::Vector{Float64}
    abundance_vector::Vector{Int64}
end


