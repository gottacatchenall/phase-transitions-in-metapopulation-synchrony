abstract type Dynamics  end

struct StochasticLogisticWDiffusion <: Dynamics
    function StochasticLogisticWDiffusion(model::DynamicsModel)
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
end


struct DynamicsModelParameters
    number_of_timesteps::Int64
    timestep_width_deterministic::Float64
    timestep_width_stochastic::Float64
    dispersal_decay_strength::Float64
    migration_rate::Float64
    lambda_vector::Array{Float64}
    sigma_vector::Array{Float64}
    log_frequency::Int64
    function DynamicsModelParameters(mp::Metapopulation;
                                        number_of_timesteps::Int64 = 1000,
                                        timestep_width_deterministic::Float64 = 0.1,
                                        timestep_width_stochastic::Float64 = 0.1,
                                        migration_rate::Float64 = 0.01,
                                        variable_sigma_across_populations = false,
                                        variable_lambda_across_populations = false,
                                        log_frequency::Int64 = 10,
                                        base_lambda::Number = 1.0,
                                        base_sigma::Number = 0.4,
                                        dispersal_decay_strength::Number = 3.0,
                                       )
        num_populations::Int64 = mp.num_populations
        sigma_vector::Array{Float64} = [base_sigma for x = 1:num_populations]
        lambda_vector::Array{Float64} = [base_lambda for x = 1:num_populations]

        new(number_of_timesteps, timestep_width_deterministic, timestep_width_stochastic, dispersal_decay_strength, migration_rate, lambda_vector, sigma_vector, log_frequency)
    end
end


mutable struct DynamicsModel
    metapopulation::Metapopulation
    dx_dt::Dynamics
    dispersal_potential::DispersalPotential
    parameters::DynamicsModelParameters
    state::Array{Float64}
    time_vector::Array{Float64}
    log::Array{Float64, 2}

    function DynamicsModel(mp::Metapopulation, dx_dt::T ; parameters=nothing) where {T <: Dynamics}
        num_populations::Int64 = mp.num_populations
        if parameters == nothing
            parameters = DynamicsModelParameters(mp)
        end

        num_logged_points::Int64 = ceil(parameters.number_of_timesteps / parameters.log_frequency)

        log = zeros(num_logged_points, num_populations)

        time_vector::Array{Float64} = [x*parameters.log_frequency*parameters.timestep_width_deterministic for x = 1:num_logged_points]

        initial_state = rand(Uniform(), num_populations)
        alpha::Float64 = parameters.dispersal_decay_strength
        dispersal_potential::DispersalPotential(mp, ExpKernel, parameters.dispersal_decay_strength )
        new(mp, dx_dt, dispersal_potential, parameters, initial_state, time_vector, log)
    end
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
            dynamics_model.log[logging_index, :] = dynamics_model.state
            logging_index += 1
        end
    end
end
