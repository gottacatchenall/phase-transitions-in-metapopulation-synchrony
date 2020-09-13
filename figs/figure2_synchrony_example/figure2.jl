
# Project Folder
proj_folder = "/home/michael/phase-transitions-in-metapopulation-synchrony/"
cd(proj_folder)

include(string(proj_folder, "./src/deps.jl"))
output_dir_path = string(proj_folder , "figs/figure2_synchrony_example/output/")
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
                        "migration_rate"    => [0.1, 0.3, 0.7],
                        "lambda"            => [1.0],
                        "sigma"             => [0.5],
                        "carrying_capacity" => [1.0],
                        "num_populations" => [5],
                        "alpha"           => [0],  # alpha is meaningless with two pops
                        "summary_stat"    => [PCC],

                        
                        # _________________________________________________
                        #
                        # simulation parameters
                        #
                        # _________________________________________________
                        "number_of_timesteps" => [300],
                        "metapopulation_generator" => [get_random_metapopulation],
                        "fixed_metapopulation" => [false],
                        "log_abundances" => [true]
                    )



treatment_set = create_treatments(param_dictionary, replicates_per_treatment = 50)

df = run_treatments(treatment_set)


CSV.write(string(output_dir_path, "treatment_set.csv"), df)
CSV.write(string(output_dir_path, "metadata.csv"), treatment_set.metadata)
