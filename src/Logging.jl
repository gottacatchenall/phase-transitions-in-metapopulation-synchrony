
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

function log_metapopulation(treatment_num, replicate, treatment_instance::TreatmentInstance; filename="./metapopulations.csv")
    df = DataFrame(treatment=[], replicate=[], population=[], x=[],y=[])     
    n_pops = treatment_instance.metapopulation.num_populations

    for p = 1:n_pops
        pop = treatment_instance.metapopulation.populations[p]
        push!(df.replicate, replicate)
        push!(df.treatment, treatment_num)
        push!(df.population, p)
        push!(df.x, pop.coordinate[1])
        push!(df.y, pop.coordinate[2])
    end
        
    if (!isfile(filename))
        CSV.write(filename, df, append=false)
    else
        CSV.write(filename, df, append=true)
    end
end
