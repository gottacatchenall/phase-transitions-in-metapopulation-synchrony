struct DynamicsModelParameters
    number_of_timesteps::Int64
    timestep_width_determinstic::Float64
    timestep_width_stochastic::Float64
    lambda_vector::Array{Float64}
    sigma_vector::Array{Float64}
    log_frequency::Int64
    dx_dt::Function
    function DynamicsModelParameters(mp::Metapopulation;
                                        number_of_timesteps::Int64 = 1000,
                                        timestep_width_deterministic::Float64 = 0.1,
                                        timestep_width_stochastic::Float64 = 0.1,
                                        variable_sigma_across_populations = false,
                                        variable_lambda_across_populations = false,
                                        log_frequency::Int64 = 10,
                                        base_lambda = 1.0,
                                        base_sigma = 0.05,
                                        dx_dt::Function = stochastic_logistic_w_diffusion
                                    )
        num_populations::Int64 = mp.num_populations
        sigma_vector::Array{Float64} = [base_sigma for x = 1:num_populations]
        lambda_vector::Array{Float64} = [base_lambda for x = 1:num_populations]

        new(number_of_timesteps, timestep_width_deterministic, timestep_width_stochastic, lambda_vector, sigma_vector, log_frequency, dx_dt)
    end

end


struct DynamicsModel
    metapopulation::Metapopulation
    parameters::DynamicsModelParameters
    state::Array{Float64}
    log::DataFrame

    function DynamicsModel(mp::Metapopulation; parameters=nothing)
        num_populations::Int64 = mp.num_populations
        if parameters == nothing
            parameters = DynamicsModelParameters(mp)
        end

        number_of_logged_points::Int64 = ceil(parameters.number_of_timesteps / parameters.log_frequency)
        log = DataFrame(population=[0 for x = 1:number_of_logged_points], timestep=[0 for x = 1:number_of_logged_points], abundance=[0 for x = 1:number_of_logged_points])

        inital_state = rand(Uniform(), num_populations)

        new(mp, parameters, initial_state, log)
    end
end

function stochastic_logistic_w_diffusion(dynamics_model::DynamicsModel)
    current_state::Array{Float64} = dynamics_model.state
    num_populations = dynamics_model.parameters.num_populations

    # stochastic logistic model locally
    for p = 1:num_populations

    end


    # diffusion between populations


end

function run_timestep(dynamics_model::DynamicsModel, dx_dt::Function=stochastic_logistic_w_diffusion)
end

function run_dynamics(dynamics_model::DynamicsModel)
    num_timesteps::Int64 = dynamics_model.parameters.numbre_of_timesteps
    dx_dt::Function = dynamics_model.dx_dt

    for t = 1:num_timesteps
        dx_dt(dynamics_model)
    end
end
