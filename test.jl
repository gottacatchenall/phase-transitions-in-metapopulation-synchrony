include("./src/deps.jl")

mp = get_random_metapop(10, 10.)

model = DynamicsModel(mp, parameters=DynamicsModelParameters(mp, migration_rate = 0.1))

@show model

run_dynamics(model)
plt = plot_timeseries_of_abundances(model)
plt
