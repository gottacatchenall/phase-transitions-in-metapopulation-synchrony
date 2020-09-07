
function check_for_nondefaults(param_dict::Dict)

    # Flag to not generate a random metapopulation every replicate
        # use-cases:
        #   - user defined metapopulation provided as CSV
        #   - only generate a new metapopulation at the Treatment or higher level

    # Flag to use a defined random seed
    #
    #

    # Flag to use stochastic dispersal, where dispersal events
    # occur according random draws from a Binomial(abundance, migration_probability).
    #

    # Flag to use

end

function create_metadata_df(param_dict::Dict)
	names::Array{String} = []
	vals = []
	metadata = DataFrame(names...)
	metadata.treatment = []

	for (param_name, param_values) in param_dict
		push!(names, param_name)
		push!(vals, param_values)
		metadata[!,  Symbol(param_name)] = []
	end
	ct = 1
	for p in Iterators.product(vals...)
		for (i, val) in enumerate(p)
			param = names[i]
			push!(metadata[!, Symbol(param)], val)
		end
		push!(metadata.treatment, ct)
		ct += 1
	end
	return(metadata)
end


# =================================================
#    treatment maker
#
#
# =================================================
function get_dist(item)
	if typeof(item) <: Distribution
		return item
	else
		return Normal(item, 0.0)
	end
end


function create_treatments(param_dict::Dict; replicates_per_treatment::Int64 = 50)
	metadata::DataFrame = create_metadata_df(param_dict)
	n_treatments::Int64 = nrow(metadata)

	treatments::Vector{Treatment} = []

	# Treatment(mp, dynamics_model, sim_params, param_bundle, param_values, PCC(), log, abundance_matrix, initial_condition)
	for t = 1:n_treatments
		num_pops = metadata.num_populations[t]
		alpha = metadata.alpha[t]

		migration_rate_distribution::Distribution = get_dist(metadata.migration_rate[t])
		lambda_distribution::Distribution = get_dist(metadata.lambda[t])
		sigma_distribution::Distribution = get_dist(metadata.sigma[t])
		carrying_capacity_distribution::Distribution = get_dist(metadata.carrying_capacity[t])

        dimensionality::Int64 = num_pops

		alpha_dist = Parameter(Normal(alpha, 0.0), 1)
		m_dist = Parameter(migration_rate_distribution, dimensionality)
		lambda_dist = Parameter(lambda_distribution, dimensionality)
		sigma_dist = Parameter(sigma_distribution, dimensionality)
		carrying_cap_dist = Parameter(carrying_capacity_distribution, dimensionality)

		param_bundle = StochasticLogisticParameterBundle(num_pops, alpha, m_dist, lambda_dist, sigma_dist, carrying_cap_dist)

		dynamics_model = StochasticLogisticWDiffusion()
		sim_params = SimulationParameters(metadata.number_of_timesteps[t], 0.1, 10, false)

		if (metadata.fixed_metapopulation[t])

		end

		mp = metadata.metapopulation_generator[t](num_populations=num_pops, alpha=alpha)

		tr = Treatment(mp, dynamics_model, sim_params, param_bundle, metadata.summary_stat[t], metadata.log_abundances[t], [])
		push!(treatments, tr)
	end

	return TreatmentSet(metadata, treatments, replicates_per_treatment )
end

# =================================================
#    treatment runner
#
#
# =================================================

function run_treatments(treatment_set::TreatmentSet; abundances_path = "./abundances.csv")
	n_treatments::Int64 = length(treatment_set.treatments)
	n_replicates::Int64 = treatment_set.replicates_per_treatment

	treatments::Vector{Treatment} = treatment_set.treatments
	@show treatments
	df = DataFrame()

	@showprogress for t in (1:n_treatments)
		summary_stat::Function = treatments[t].summary_stat
		for r = 1:n_replicates
			param_values = draw_from_parameter_bundle(treatments[t].theta)

			mp = treatments[t].metapopulation_generator
			abundance_matrix = zeros(Int64(ceil(treatments[t].simulation_parameters.number_of_timesteps/treatments[t].simulation_parameters.log_frequency)), mp.num_populations)
			initial_condition = [rand(Uniform(0, param_values.carrying_capacity[p])) for p = 1:mp.num_populations]

			treatment_instance::TreatmentInstance = TreatmentInstance(mp, treatments[t].dx_dt, treatments[t].simulation_parameters, param_values, abundance_matrix, initial_condition)
			push!(treatments[t].instances, treatment_instance)

			treatment_instance.abundance_matrix = run_dynamics(treatment_instance)

			stat_df = summary_stat(treatment_instance, t, r)
			df = vcat(df, stat_df)

			if (treatments[t].log_abundances)
				log_abundances(t, r, treatment_instance, filename=abundances_path)
			end
		end
	end

	return df
end

# ---------------------------------------------------------------
#
#       constructors for treatments
#
#
#
# ---------------------------------------------------------------

function get_treatment(;num_populations=10)
    mp = get_random_metapopulation(num_populations=num_populations)
    sim_params = SimulationParameters(1000, 0.1, 10, false)
    param_bundle = get_stochastic_logistic_parameter_bundle(mp.num_populations)
    param_values = draw_from_parameter_bundle(param_bundle)
    dynamics_model = StochasticLogisticWDiffusion()

    return Treatment(mp, dynamics_model, sim_params, param_bundle, PCC)
end
