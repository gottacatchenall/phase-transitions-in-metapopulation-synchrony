
function PCC(treatment_instance::TreatmentInstance, treatment_num::Int64, replicate_num::Int64)
        abundance_matrix::Array{Float64,2} =  treatment_instance.abundance_matrix
        n_pops = length(abundance_matrix[1,:])
        mean_cc::Float64 = 0.0
        s::Float64 =0.0
        ct::Int64 = 0
        for p1 = 1:n_pops
            for p2 = (p1+1):n_pops
                if (p1 != p2)
                    v1 = abundance_matrix[:,p1]
                    v2 = abundance_matrix[:,p2]
                    cc = crosscor(v1,v2,[0])
                    s += cc[1]
                    ct += 1
                end
            end
        end

        mean_cc = s/ct
        df = DataFrame(treatment=[treatment_num], replicate=[replicate_num], mean_cc=[mean_cc])

        return df
end

function PCC(abundance_matrix::Array{Float64}, populations::Vector{Int64})
    n_pops = length(populations)

    if (n_pops < 2)
        return 1.0
    end


    mean_cc::Float64 = 0.0
    s::Float64 =0.0
    ct::Int64 = 0
    for p1 = 1:n_pops
        for p2 = (p1+1):n_pops
            if (p1 != p2)
                v1 = abundance_matrix[:,p1]
                v2 = abundance_matrix[:,p2]
                cc = crosscor(v1,v2,[0])
                s += cc[1]
                ct += 1
            end
        end
    end
    mean_cc = s/ct
    return mean_cc
end

function get_populations_within_circle(mp, center, radius)
    num_populations = mp.num_populations
    pops_within_circle::Vector{Int64} = []

    for p in 1:num_populations
        dist = evaluate(Euclidean(), mp.populations[p].coordinate, center)
        if (dist < radius)
            push!(pops_within_circle, p)
        end
    end
    return pops_within_circle
end

function random_PCC_within_radius(treatment_instance::TreatmentInstance, treatment_num::Int64, replicate_num::Int64; radii = collect(0.0:0.05:(0.5)), num_samples_each_scale=20)
    abundance_matrix = treatment_instance.abundance_matrix
    mp = treatment_instance.metapopulation

    df = DataFrame(treatment=[], replicate=[], pcc=[], radius=[], pops_within_circle=[] )

    for radius in radii
        for s in 1:num_samples_each_scale
            center = rand(Uniform(),2)
            pops_within_circle::Vector{Int64} = get_populations_within_circle(mp, center, radius)

            mean_pcc_in_circle = PCC(abundance_matrix, pops_within_circle)

            push!(df.treatment, treatment_num)
            push!(df.replicate, replicate_num)
            push!(df.pcc, mean_pcc_in_circle)
            push!(df.radius, radius)
            push!(df.pops_within_circle, length(pops_within_circle))
        end
    end

    return df
end
