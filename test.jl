include("./src/deps.jl")



#model = get_treatment()
#@show model
#run_dynamics(model)
#plot_timeseries_of_abundances(model)


treatment_dictionary =

                    Dict(
                        # =======================================
                        # dynamics model parameters
                        # =======================================
                        "migration_rate_distribution" => [i for i = 0.01:0.01:1.0],
                        "lambda_distribution" => [Uniform(0.5,1.5)],
                        "sigma_distribution" => [1.0],
                        "carrying_capacity_distribution" => [Uniform(0.5,1.5)],

                        "parameters_fixed_across_populations" => [false],

                        # ========================================
                        # parameters for metapopulation generation
                        # ========================================
                        "metapopulation_generator" => [get_random_metapopulation],
                        "num_populations" => [20],
                        "alpha" => [0, 10, 20],
                        "fixed_metapopulation_per_treatment" => [false],

                        # ===============================================================
                        # parameters that should not change unless you have a good reason
                        # ===============================================================
                        "number_of_timesteps" => [300]
                    );



treatment_set = create_treatments(treatment_dictionary, replicates_per_treatment=1)
df = run_treatments(treatment_set)

inst = treatment_set.treatments[200].instances[10]
inst
plot(collect(1:length(inst.abundance_matrix[:,1])), inst.abundance_matrix)


cd("/home/michael/phase_transitions_in_metapopulation_synchrony/")
CSV.write("output/metadata.csv",treatment_set.metadata)
CSV.write("output/treatment_set.csv", df)
