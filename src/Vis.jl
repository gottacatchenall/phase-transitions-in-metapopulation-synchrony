function plot_timeseries_of_abundances(dynamics_model::DynamicsModel)
    @show dynamics_model.log
    num_timesteps = length(dynamics_model.log[:,1])
    plot(dynamics_model.time_vector, dynamics_model.log[:,:],
         linewidth=2,
         ylims=(0.7,1.2),
         size=(700, 400))
end
