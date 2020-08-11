
struct DispersalPotential
    DispersalPotential(mp::Metapopulation) = (get_dispersal_potential(mp))
end

function DispersalPotential(mp::Metapopulation, kernel::T, alpha::Number) where {T <: DispersalKernel}
    n_pops::Int64 = mp.num_populations
    dispersal_potential::Array{Float64} = zeros(n_pops, n_pops)

    for p1 = 1:n_pops
        row_sum::Float64 = 0.0
        for p2 = 1:n_pops
            if (p1 != p2)
                d_ij::Float64 = get_distance_between_pops(mp.populations[p1], mp.populations[p2])
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

