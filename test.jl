include("./src/deps.jl")


mp = get_random_metapopulation(10, 10.)

model = DynamicsModel(mp, StochasticLogisticWDiffusion, parameters=DynamicsModelParameters(mp, migration_rate = 0.9))

@show model

run_dynamics(model)
plt = plot_timeseries_of_abundances(model)
treatment_dictionary =

                    Dict(
                        # =======================================
                        # dynamics model parameters
                        # =======================================
                        "migration_rate" => vcat(collect(0.01:0.01:1.)),
                        "base_lambda" => [1.0],
                        "base_sigma" => [0.4],

                        # ========================================
                        # parameters for metapopulation generation
                        # ========================================
                        "metapopulation_generator" => [get_random_metapopulation]
                        "fixed_metapopulation" => [false],
                        "num_populations" => [20],
                        "base_carrying_capacity" => [20.],

                        # ===============================================================
                        # parameters that should not change unless you have a good reason
                        # ===============================================================
                        "number_of_timesteps" => [1000],
                        "variable_sigma_across_populations" => [false],
                        "variable_lambda_across_populations" => [false],
                    );


create_treatments(treatment_dictionary)





plt
