using StatsBase, Distributions, DataFrames, CSV, ProgressMeter, LinearAlgebra, Distances, Plots

cd("/home/michael/phase_transitions_in_metapopulation_synchrony/")

include("./DispersalPotential.jl")
include("./Metapopulation.jl")
include("./Generators.jl")
include("./Dynamics.jl")
include("./SummarizingStats.jl")
include("./Logging.jl")
include("./TreatmentFactory.jl")
include("./Vis.jl")
