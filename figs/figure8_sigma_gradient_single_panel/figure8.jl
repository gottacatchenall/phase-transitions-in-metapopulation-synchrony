
# Project Folder
proj_folder = "/home/michael/phase-transitions-in-metapopulation-synchrony/"
cd(proj_folder)

include(string(proj_folder, "./src/deps.jl"))

output_dir_path = string(proj_folder , "figs/figure8_sigma_gradient_single_panel/output/")
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
                        "lambda"            => [1.0],
                        "sigma"             => [0.1, 0.3, 0.5, 0.7, 0.9, 1.2],
                        "carrying_capacity" => [2.0],
                        "num_populations" => [20],
                        "alpha"           => [0],
                        "summary_stat" => [PCC],
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
