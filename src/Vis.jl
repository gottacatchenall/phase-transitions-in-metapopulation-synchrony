function plot_timeseries_of_abundances(abundance_matrix)
    plot(collect(1:length(abundance_matrix[:,1])), abundance_matrix, linewidth=2,      size=(700, 400))
end


#=
using StatsPlots
data = innerjoin(df, treatment_set.metadata, on=:treatment)

@df data scatter(:migration_rate,:mean_cc,
                 group=(:lambda,:sigma),
                 layout=(3,3),
                 markeralpha=0.1,
                 markersize=2,
                 markerstrokewidth=0.5,
                 markerstrokealpha=0)
                 =#

