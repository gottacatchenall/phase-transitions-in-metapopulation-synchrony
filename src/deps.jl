using StatsBase, Distributions, DataFrames, CSV, ProgressMeter, LinearAlgebra, Distances, Plots

wd = pwd()
cd("/home/michael/phase-transitions-in-metapopulation-synchrony/src")

include("./types.jl")
include("./Parameters.jl")
include("./Metapopulation.jl")
include("./DispersalKernel.jl")
include("./DispersalPotential.jl")
include("./Dynamics.jl")
include("./Logging.jl")
include("./TreatmentFactory.jl")
include("./StochasticLogisticWDiffusion.jl")
include("./SummaryStats.jl")
include("./Vis.jl")


# Source IBM stuff, maybe should be packaged as a module in the future
include("./IBM/types.jl")
include("./IBM/IBMParameters.jl")
include("./IBM/IBM.jl")
include("./IBM/PoissonWRandomDispersal.jl")

cd(wd)
