using StatsBase, Distributions, DataFrames, CSV, ProgressMeter, LinearAlgebra, Distances, Plots

wd = pwd()
cd("/home/michael/phase_transitions_in_metapopulation_synchrony/src")

include("./Metapopulation.jl")
include("./DispersalKernel.jl")
include("./DispersalPotential.jl")
include("./Dynamics.jl")
include("./Logging.jl")
include("./TreatmentFactory.jl")
include("./StochasticLogisticWDiffusion.jl")
include("./SummaryStats.jl")
include("./Vis.jl")


cd(wd)
