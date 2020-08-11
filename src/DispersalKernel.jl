abstract type DispersalKernel end

struct ExpKernel <: DispersalKernel
    ExpKernel(alpha::Number, distance::Number) = exp(-1*alpha*distance)
end

struct GaussKernel <: DispersalKernel
    GaussKernel(alpha::Number, distnace::Number) = exp( (-1* distance^2 * alpha^2) )
end

struct UniformKernel <: DispersalKernel
    UniformKernel(::Any) = 1.0
end


