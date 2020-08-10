struct DynamicsModelParameters
    number_of_timesteps::Int64
    timestep_width_deterministic::Float64
    timestep_width_stochastic::Float64
    migration_rate::Float64
    lambda_vector::Array{Float64}
    sigma_vector::Array{Float64}
    log_frequency::Int64
    dx_dt::Function
    function DynamicsModelParameters(mp::Metapopulation;
                                        number_of_timesteps::Int64 = 1000,
                                        timestep_width_deterministic::Float64 = 0.1,
                                        timestep_width_stochastic::Float64 = 0.1,
                                        migration_rate::Float64 = 0.01,
                                        variable_sigma_across_populations = false,
                                        variable_lambda_across_populations = false,
                                        log_frequency::Int64 = 10,
                                        base_lambda = 1.0,
                                        base_sigma = 0.4,
                                        dx_dt::Function = stochastic_logistic_w_diffusion
                                    )
        num_populations::Int64 = mp.num_populations
        sigma_vector::Array{Float64} = [base_sigma for x = 1:num_populations]
        lambda_vector::Array{Float64} = [base_lambda for x = 1:num_populations]

        new(number_of_timesteps, timestep_width_deterministic, timestep_width_stochastic, migration_rate, lambda_vector, sigma_vector, log_frequency, dx_dt)
    end

end


mutable struct DynamicsModel
    metapopulation::Metapopulation
    parameters::DynamicsModelParameters
    state::Array{Float64}
    time_vector::Array{Float64}
    log::Array{Float64, 2}

    function DynamicsModel(mp::Metapopulation; parameters=nothing)
        num_populations::Int64 = mp.num_populations
        if parameters == nothing
            parameters = DynamicsModelParameters(mp)
        end

        num_logged_points::Int64 = ceil(parameters.number_of_timesteps / parameters.log_frequency)

        log = zeros(num_logged_points, num_populations)

        time_vector::Array{Float64} = [x*parameters.log_frequency*parameters.timestep_width_deterministic for x = 1:num_logged_points]

        initial_state = rand(Uniform(), num_populations)

        new(mp, parameters, initial_state, time_vector, log)
    end
end

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
    carrying_capacity::Array{Float64} = dynamics_model.metapopulation.carrying_capacities


    dt::Float64 = dynamics_model.parameters.timestep_width_deterministic
    dW::Float64 = dynamics_model.parameters.timestep_width_stochastic

    new_state::Array{Float64} = zeros(num_populations)

    # stochastic logistic model locally
    for p = 1:num_populations
        new_state[p] = stochastic_logistic_single_population(current_state[p], sigma[p], lambda[p], dt, dW, carrying_capacity[p])
    end


    # diffusion between populations
    diffusion_matrix = get_dispersal_matrix(dynamics_model.metapopulation.dispersal_potential, dynamics_model.parameters.migration_rate)


    new_state = diffusion_matrix * new_state

    dynamics_model.state = new_state
end

function update_log(dynamics_model::DynamicsModel, logging_index::Int64, timestep::Float64)
    num_populations::Int64 = dynamics_model.metapopulation.num_populations

    dynamics_model.log[logging_index, :] = dynamics_model.state

end

function run_dynamics(dynamics_model::DynamicsModel)
    num_timesteps::Int64 = dynamics_model.parameters.number_of_timesteps
    dx_dt::Function = dynamics_model.parameters.dx_dt
    dt::Float64 = dynamics_model.parameters.timestep_width_deterministic

    logging_frequency = dynamics_model.parameters.log_frequency
    logging_index = 1
    for t = 1:num_timesteps
        time = t*dt
        dx_dt(dynamics_model)
        if t % logging_frequency == 0
            update_log(dynamics_model, logging_index, time)
            logging_index += 1
        end
    end
end
