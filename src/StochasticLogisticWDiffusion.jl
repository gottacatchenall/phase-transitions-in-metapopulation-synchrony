
function stochastic_logistic_single_population(abundance::Float64, sigma::Float64, lambda::Float64, dt::Float64, dW::Float64, carrying_capacity::Float64)::Float64
    delta_abundance_deterministic::Float64 =  abundance*lambda*(1.0-(abundance/carrying_capacity))
    delta_abundance_stochastic::Float64 = rand(Normal(0, sigma*abundance))

    new_abundance::Float64 = abundance + delta_abundance_deterministic*dt + delta_abundance_stochastic*dW
    return new_abundance
end


function stochastic_logistic_w_diffusion(dynamics_model::DynamicsModel)::Array{Float64}
    current_state::Array{Float64} = dynamics_model.state
    num_populations = dynamics_model.metapopulation.num_populations

    sigma::Array{Float64} = dynamics_model.parameters.sigma_vector
    lambda::Array{Float64} = dynamics_model.parameters.lambda_vector
    carrying_capacity::Array{Float64} = [dynamics_model.metapopulation.populations[p].carrying_capacity for p in 1:num_populations]


    dt::Float64 = dynamics_model.parameters.timestep_width_deterministic
    dW::Float64 = dynamics_model.parameters.timestep_width_stochastic

    new_state::Array{Float64} = zeros(num_populations)

    # stochastic logistic model locally
    for p = 1:num_populations
        new_state[p] = stochastic_logistic_single_population(current_state[p], sigma[p], lambda[p], dt, dW, carrying_capacity[p])
    end


    # diffusion between populations
    dispersal_potential = dynamics_model.dispersal_potential
    diffusion_matrix = get_dispersal_matrix(dispersal_potential, dynamics_model.parameters.migration_rate)
    new_state = diffusion_matrix * new_state

    dynamics_model.state = new_state
end


function get_dispersal_matrix(dispersal_potential::Array{Float64,2}, migration_rate::Float64)
    n_pops = length(dispersal_potential[1,:])

    dispersal_matrix = zeros(n_pops, n_pops)

    for p1 = 1:n_pops
        for p2 = 1:n_pops
            if (p1 == p2)
                dispersal_matrix[p1,p2] = 1.0 - migration_rate
            else
                dispersal_matrix[p1,p2] = migration_rate * dispersal_potential[p1,p2]
            end
        end
    end

    return dispersal_matrix
end
