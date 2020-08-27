
function get_dispersal_potential(coordinates, kernel, alpha::Number)
    n_pops::Int64 = length(coordinates[:,1])
    matrix::Array{Float64,2} = zeros(n_pops, n_pops)
    for p1 = 1:n_pops
        row_sum::Float64 = 0.0
        for p2 = 1:n_pops
            if (p1 != p2)
                d_ij::Float64 = get_distance_between_pops(coordinates[p1], coordinates[p2])
                matrix[p1,p2] = kernel(alpha, d_ij)
                row_sum += matrix[p1,p2]
            end
        end

        for p2 = 1:n_pops
            if (p1 != p2)
                matrix[p1,p2] /= row_sum
            end
        end
    end
    return DispersalPotential(matrix, kernel, alpha)
end
