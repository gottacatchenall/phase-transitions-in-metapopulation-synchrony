struct Metapopulation
    num_populations::Int64
    carrying_capacities::Array{Float64}
    coordinates::Array{Float64}
    dispersal_potential::Array{Float64,2}
end
