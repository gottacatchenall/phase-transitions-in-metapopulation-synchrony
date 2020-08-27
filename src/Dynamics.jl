function run_dynamics(treatment_instance::TreatmentInstance)
    num_timesteps::Int64 = treatment_instance.simulation_parameters.number_of_timesteps
    num_populations::Int64 = treatment_instance.metapopulation.num_populations
    dx_dt = treatment_instance.dx_dt
    dt::Float64 = treatment_instance.simulation_parameters.timestep_width
    logging_frequency = treatment_instance.simulation_parameters.log_frequency

    abundance_matrix_time_index = 1

    abundance_matrix = zeros(Int64(ceil(treatment_instance.simulation_parameters.number_of_timesteps/treatment_instance.simulation_parameters.log_frequency)), treatment_instance.metapopulation.num_populations)



    for t = 1:num_timesteps
        time = t*dt
        dx_dt(treatment_instance)
        if t % logging_frequency == 0
            for p = 1:num_populations
                abundance_matrix[abundance_matrix_time_index,p] = treatment_instance.state[p]
            end
            abundance_matrix_time_index += 1
        end
    end
    return abundance_matrix
end
