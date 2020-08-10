function get_random_metapop(num_populations::Int64, total_carrying_capacity::Float64; dimensions::Int64 = 2, alpha::Float64 = 3.0, carrying_capacity_distribution=nothing)
    coordinates::Array{Float64,2} = zeros(num_populations, dimensions)
    k::Array{Float64} = zeros(num_populations)

    k_subdivided::Float64 = total_carrying_capacity / num_populations

    # random locations in the unit square
    for p = 1:num_populations
        coordinates[p, :] = rand(Uniform(), 2)
        k[p] = k_subdivided
    end

    dispersal_potential = get_dispersal_potential(coordinates, alpha, exp_kernel)
    return(Metapopulation(num_populations, k, coordinates, dispersal_potential))
end
