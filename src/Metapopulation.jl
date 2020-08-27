function get_distance_between_pops(coord1::Array{Float64,1}, coord2::Array{Float64,1}; norm=Euclidean())
    distance::Float64 = evaluate(norm, coord1, coord2)
    return distance
end
function get_distance_between_pops(pop1::Population, pop2::Population; norm=Euclidean())
    distance::Float64 = evaluate(norm, pop1.coordinate, pop2.coordinate)
    return(distance)
end

function get_random_metapopulation(;num_populations::Int64=10, dimensions::Int64 = 2, alpha::Number = 3.0, kernel=ExpKernel)

    populations::Vector{Population} = []
    coordinates::Vector{Array{Float64}} = []

    # random locations in the unit square
    for p = 1:num_populations
        coordinate = rand(Uniform(), dimensions)
        push!(populations, Population(coordinate))
        push!(coordinates, coordinate)
    end

    return(Metapopulation(num_populations, populations, get_dispersal_potential(coordinates, kernel, alpha)))
end
