
proj_folder = "/home/michael/phase-transitions-in-metapopulation-synchrony/"
cd(proj_folder)

include(string(proj_folder, "./src/deps.jl"))
output_dir_path = string(proj_folder , "figs/figure3_2population_phase_transition/output/")


mkdir(output_dir_path)

# _______________________________________________________________________________________
#
#
#   phase transition diagram for two populations
#
#
#
#
#
# _______________________________________________________________________________________

param_dictionary = Dict(
                        "migration_rate"    => [i for i = 0.0:0.01:1.0],
                        "lambda"            => [0.5,1.0,2],
                        "sigma"             => [0.5, 0.1, 1.0 ],
                        "carrying_capacity" => [1.0],
                        "num_populations" => [2],
                        "alpha"           => [0],  # alpha is meaningless with two pops

                        # _________________________________________________
                        #
                        # simulation parameters
                        #
                        # _________________________________________________
                        "number_of_timesteps" => [300],
                        "metapopulation_generator" => [get_random_metapopulation],
                        "fixed_metapopulation" => [false],
                        "summary_stat" => [PCC],
                        "log_abundances" => [false]
                    )



treatment_set = create_treatments(param_dictionary, replicates_per_treatment = 100)

df = run_treatments(treatment_set)


CSV.write(string(output_dir_path, "treatment_set.csv"), df)
CSV.write(string(output_dir_path, "metadata.csv"), treatment_set.metadata)
