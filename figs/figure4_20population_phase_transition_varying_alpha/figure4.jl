
# Project Folder
proj_folder = "/home/michael/phase_transitions_in_metapopulation_synchrony/"
cd(proj_folder)

include(string(proj_folder, "src/deps.jl"))

output_dir_path = string(proj_folder , "figs/figure4_20population_phase_transition_varying_alpha/output/")
mkdir(output_dir_path)
# _______________________________________________________________________________________
#
#
#   phase transition diagram for 20 populations, varying alpha
#
#
#
#
#
# _______________________________________________________________________________________

param_dictionary = Dict(
                        "migration_rate"    => [i for i = 0.0:0.01:1.0],
                        "lambda"            => [1.0],
                        "sigma"             => [0.5 ],
                        "carrying_capacity" => [1.0],
                        "num_populations" => [20],
                        "alpha"           => [0, 5, 10, 15],
                        # _________________________________________________
                        #
                        # simulation parameters
                        #
                        # _________________________________________________
                        "number_of_timesteps" => [300],
                        "metapopulation_generator" => [get_random_metapopulation]
                    )



treatment_set = create_treatments(param_dictionary, replicates_per_treatment = 50)

df = run_treatments(treatment_set)

CSV.write(string(output_dir_path, "treatment_set.csv"), df)
CSV.write(string(output_dir_path, "metadata.csv"), treatment_set.metadata)


