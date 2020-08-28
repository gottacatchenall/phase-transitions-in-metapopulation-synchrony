abstract type Dynamics end
abstract type DispersalKernel end


struct GaussKernel <: DispersalKernel
    GaussKernel(alpha::Number, distance::Number) = exp(-1*alpha^2*distance^2)
end


struct ExpKernel <: DispersalKernel
    ExpKernel(alpha::Number, distance::Number) = exp(-1*alpha*distance)
end

# -------------------------------------------------------------
#   ParameterBundle()
# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------

struct Parameter
    distribution::Distribution
    hyperparameters::Vector{Parameter}
    dimensionality::Int64
    Parameter(distribution::Distribution, dimensionality::Int64; hyperparameters=[])  = new(distribution, hyperparameters, dimensionality)
    Parameter(distribution::Distribution; dimensionality=1) = new(distribution, [], dimensionality)
end

Base.show(io::IO, p::Parameter) = print(io, "Parameter ~ ", p.distribution, "\n")


abstract type ParameterBundle end
abstract type ParameterValues end

struct StochasticLogisticParameterBundle <: ParameterBundle
    num_populations::Int64
    alpha::Float64
    migration_rate::Parameter
    lambda::Parameter
    sigma::Parameter
    carrying_capacity::Parameter
end



struct StochasticLogisticParameterValues <: ParameterValues
    num_populations::Int64
    alpha::Float64  # dispersal kernel alpha
    lambda::Vector{Float64} # lambda across pops
    migration_rate::Vector{Float64} # mig across pops
    carrying_capacity::Vector{Float64} # K across pops
    sigma::Vector{Float64} # sigma across pops
end

Base.show(io::IO, params::StochasticLogisticParameterValues) = print(io,
                                                                    "Stochastic Logistic Model with Parameters: \n",
                                                                    "\t\t\talpha:", params.alpha, "\n",
                                                                    "\t\t\tlambda:", params.lambda, "\n",
                                                                    "\t\t\tmigration:", params.migration_rate, "\n",
                                                                    "\t\t\tcarrying capacity:", params.carrying_capacity, "\n",
                                                                    "\t\t\tsigma:", params.sigma, "\n"

                                                                )


# -------------------------------------------------------------
#   Metapopulation
# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------

mutable struct Population
   coordinate::Vector{Float64}
end

mutable struct DispersalPotential
    matrix
    kernel
    alpha::Number
end

mutable struct Metapopulation
    num_populations::Int64
    populations::Vector{Population}
    dispersal_potential::DispersalPotential
end
Base.show(io::IO, metapopulation::Metapopulation) = print(io, "Metapopulation with ",
metapopulation.num_populations,
" populations and alpha = ",
metapopulation.dispersal_potential.alpha,
"\n",
" Coordinates: ", [metapopulation.populations[p].coordinate for p = 1:metapopulation.num_populations]
)

# -------------------------------------------------------------
#   DynamicsModel
# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------


mutable struct SimulationParameters
    number_of_timesteps::Int64
    timestep_width::Float64
    log_frequency::Int64
    redraw_parameters_every_timestep::Bool
end

abstract type SummaryStat

end

# -------------------------------------------------------------
#   Treatment
# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------


mutable struct TreatmentInstance
    metapopulation::Metapopulation
    dx_dt::Function
    simulation_parameters::SimulationParameters
    parameter_values::ParameterValues
    abundance_matrix::Array{Float64,2}
    state::Array{Float64}
end

mutable struct Treatment
    metapopulation_generator
    dx_dt::Function
    simulation_parameters::SimulationParameters
    theta::ParameterBundle
    summary_stat::Function
    instances::Vector{TreatmentInstance}
end

Base.show(io::IO, treatment::Treatment) = print(io, "\n\n\nTreatment\n",
                                                    "--------------------------------------------\n",
                                                    "\tdX/dt : ", (treatment.dx_dt), "\n",
                                                    )


struct TreatmentSet
    metadata::DataFrame
    treatments::Vector{Treatment}
    replicates_per_treatment::Int64
end

struct TreatmentMaker

end
