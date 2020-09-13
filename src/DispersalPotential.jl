
function get_dispersal_matrix(coordinates, kernel, alpha)
    n_pops::Int64 = length(coordinates[:,1])
    matrix::Array{Float64,2} = zeros(n_pops, n_pops)
    for p1 = 1:n_pops
        for p2 = 1:n_pops
            if (p1 != p2)
                d_ij::Float64 = get_distance_between_pops(coordinates[p1], coordinates[p2])
                matrix[p1,p2] = kernel(alpha, d_ij)
            end
        end
    end
    return matrix 
end

function get_dispersal_potential(coordinates, kernel, alpha::Number)
  dispersal_matrix = get_dispersal_matrix(coordinates, kernel, alpha)
  for p = 1:n_pops
    dispersal_matrix[p,:] = dispersal_matrix[p,:] / sum(dispersal_matrix[p,:])    
  end
  return DispersalPotential(matrix, kernel, alpha)
end
