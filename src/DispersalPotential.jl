function exp_kernel(alpha::Float64, d_ij::Float64)
    return(exp(-1*alpha*d_ij))
end

function gauss_kernel(alpha::Float64, d_ij::Float64)
    num::Float64 = (alpha^2)
    return(exp(-1*num*d_ij^2))
end

function uniform_kernel(alpha::Float64, d_ij::Float64)
    return(1.0)
end

function get_distance_between_pops(pop1_coordinate::Array{Float64}, pop2_coordinate::Array{Float64}; norm=Euclidean())
    distance::Float64 = evaluate(norm, pop1_coordinate, pop2_coordinate)
    return(distance)
end

function get_dispersal_potential(coordinates::Array{Float64}, alpha::Float64, kernel::Function)
    n_pops::Int64 = length(coordinates[:,1])
    dispersal_distribution = zeros(n_pops, n_pops)

    for p1 = 1:n_pops
        row_sum::Float64 = 0.0
        for p2 = 1:n_pops
            if (p1 != p2)
                coord1::Array{Float64} = Array(coordinates[p1,:])
                coord2::Array{Float64} = Array(coordinates[p2,:])
                d_ij::Float64 = get_distance_between_pops(coord1, coord2)
                dispersal_distribution[p1,p2] = kernel(alpha, d_ij)
                row_sum += dispersal_distribution[p1,p2]
            end
        end

        for p2 = 1:n_pops
            if (p1 != p2)
                dispersal_distribution[p1,p2] /= row_sum
            end
        end
    end
    return dispersal_distribution
end

function get_dispersal_matrix(dispersal_potential::Array{Float64,2}, migration_rate::Float64)
    n_pops = length(dispersal_potential[1,:])

    dispersal_matrix = zeros(n_pops, n_pops)

    for p1 = 1:n_pops
        for p2 = 1:n_pops
            if (p1 == p2)
                dispersal_matrix[p1,p2] = 1.0 - migration_rate
            else
                dispersal_matrix[p1,p2] = migration_rate * dispersal_potential[p1,p2]
            end
        end
    end

    return dispersal_matrix

end
