function plot_timeseries_of_abundances(abundance_matrix)
    plot(collect(1:length(abundance_matrix[:,1])), abundance_matrix, linewidth=2,      size=(700, 400))
end
