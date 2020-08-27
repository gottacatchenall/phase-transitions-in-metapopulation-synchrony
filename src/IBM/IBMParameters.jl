# -------------------------------------------------------------
#   IBMParameters()
# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------

IBMParameters(; metapopulation::Metapopulation = get_random_metapopulation(),
                heritable_trait_variability::Number = 0.1,
                environmental_variability::Number = 0.1,
                selection_strength::Number = 1.0,
                base_lambda::Number  = 1.2,
                initial_trait_variation::Number = 0.3,
                max_number_individuals::Number = 1000,
                number_of_timesteps::Number = 200,
                log_frequency::Number = 10
             ) = IBMParameters(metapopulation,
                               heritable_trait_variability,
                               environmental_variability,
                               selection_strength,
                               base_lambda,
                               initial_trait_variation,
                               max_number_individuals,
                               number_of_timesteps,
                               log_frequency
                              )

