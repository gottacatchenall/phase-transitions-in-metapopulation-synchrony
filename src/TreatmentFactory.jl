
# =================================================
#    treatment maker
#
#
# =================================================
function create_treatments(param_dict::Dict)
	names::Array{String} = []
	vals = []
	treatment_df = DataFrame(names...)
	treatment_df.treatment = []

	for (param_name, param_values) in param_dict
		push!(names, param_name)
		push!(vals, param_values)
		treatment_df[!,  Symbol(param_name)] = []
	end

	ct = 1
	for p in Iterators.product(vals...)
		for (i, val) in enumerate(p)
			param = names[i]
			push!(treatment_df[!, Symbol(param)], val)
		end
		push!(treatment_df.treatment, ct)
		ct += 1
	end
	return(treatment_df)
end

# =================================================
#    treatment runner
#
#
# =================================================

function run_treatments(treatment_df::DataFrame, output_dir::String; n_replicates::Int64 = 50, n_generations = 500, log_abundances=false, mp = nothing, log_all_pairwise_cc::Bool = false)

	if (!isdir(output_dir))
		mkdir(output_dir)
	end

	if (mp != nothing)
		mp_df = DataFrame(x=mp.x, y=mp.y, k=mp.k)
		mp_path =  string(output_dir, "/", "mp.csv")
		CSV.write(mp_path, mp_df)
	end

	cc_df = nothing
	if (log_all_pairwise_cc)
		cc_df = DataFrame(treatment=[], replicate=[], pop1=[], pop2=[],cc=[])
	else
		cc_df = DataFrame(treatment=[], replicate=[], mean_cc=[], var_delta=[])
	end
	abundance_df = DataFrame(treatment=[], replicate=[], gen=[], abundance=[])

	metadata_path = string(output_dir, "/", "metadata.csv")
	CSV.write(metadata_path, treatment_df)


	@showprogress for (iter, row) in enumerate(eachrow(treatment_df))
		m::Float64 = row.migration_rate
		alpha::Float64 = row.alpha
		sigma_p::Float64 = row.sigma_p
		k::Float64 = row.k_total
		cc_wrt_total::Bool = row.cc_wrt_total
		n_pops::Int64 = row.n_pops
		kernel::Function = row.dispersal_kernel
		determ_mig = row.deterministic_migration

		sigma = sigma_p*k
		lambda = row.lambda
		treatment_ct = row.treatment

		for r = 1:n_replicates
			run = run_dynamics(n_generations, n_pops=n_pops, lambda=lambda, k_total = k, migration_rate=m, alpha=alpha, sigma=sigma, deterministic_migration=determ_mig, kernel=kernel, cc_wrt_total=cc_wrt_total, log_dynamics=log_abundances, mp = mp)

			mean_cc = run[1]
			var_delta = run[2]

			    	push!(cc_df.mean_cc, mean_cc)
			    	push!(cc_df.replicate, r)
			    	push!(cc_df.treatment, treatment_ct)
					push!(cc_df.var_delta, var_delta)

		end
	end

	cc_file_path = string(output_dir, "/", "cc.csv")
	CSV.write(cc_file_path, cc_df)
end
