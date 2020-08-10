using StatsBase, Distributions, DataFrames, CSV, ProgressMeter, LinearAlgebra, Distances

cd("/home/michael/phase_transitions_in_metapopulation_synchrony/")

include("./src/DispersalPotential.jl")
include("./src/Metapopulation.jl")
include("./src/Generators.jl")
include("./src/Dynamics.jl")
include("./src/SummarizingStats.jl")
include("./src/Logging.jl")
include("./src/TreatmentFactory.jl")
