
function log_abundances(treatment_num, replicate, treatment_instance::TreatmentInstance; filename="abundances.csv")
    abundance_matrix::Array{Float64,2} = treatment_instance.abundance_matrix
    df = DataFrame(treatment=[], replicate=[], population=[], timestep=[], abundance=[] )
    n_pops = length(abundance_matrix[1,:])
    n_timesteps = length(abundance_matrix[:,1])

    for p = 1:n_pops
        for t = 1:n_timesteps
            push!(df.replicate, replicate)
            push!(df.treatment, treatment_num)
            push!(df.abundance, abundance_matrix[t,p])
            push!(df.timestep, t)
            push!(df.population, p)
        end
    end

    if (!isfile(filename))
        CSV.write(filename, df, append=false)
    else
        CSV.write(filename, df, append=true)
    end
end
