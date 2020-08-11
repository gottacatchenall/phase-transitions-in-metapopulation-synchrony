
struct Population
    carrying_capacity::Number
    coordinate::Vector{Float64}
end

struct Metapopulation
    num_populations::Int64
    populations::Vector{Population}
end

function get_distance_between_pops(pop1::Population, pop2::Population; norm=Euclidean())
    distance::Float64 = evaluate(norm, pop1.coordinate, pop2.coordinate)
    return(distance)
end

function get_random_metapopulation(num_populations::Int64, total_carrying_capacity::Float64; dimensions::Int64 = 2, alpha::Float64 = 3.0, carrying_capacity_distribution=nothing)

    k_subdivided::Float64 = total_carrying_capacity / num_populations
    k::Array{Float64} = [k_subdivided for i = 1:num_populations]
    populations::Vector{Population} = []
    #
    # random locations in the unit square
    for p = 1:num_populations
        coordinate = rand(Uniform(), dimensions)
        push!(populations, Population(k_subdivided, coordinate))
    end

    return(Metapopulation(num_populations, populations))
end
