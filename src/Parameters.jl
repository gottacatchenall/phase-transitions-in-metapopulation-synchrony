
function get_stochastic_logistic_parameter_bundle(dimensionality::Int64 ;alpha_distr=Exponential(3.0), lambda_distr = Uniform(0.5,1.5), mig_distr=Uniform(), sigma_distr=(Exponential(1.0)), carrying_distr=Uniform(0.5,1.5))
    alpha = Parameter(alpha_distr, 1) # always has dim = 1
    m = Parameter(mig_distr, dimensionality)
    lambda = Parameter(lambda_distr, dimensionality)
    sigma = Parameter(sigma_distr, dimensionality)
    k = Parameter(carrying_distr, dimensionality)

    return StochasticLogisticParameterBundle(alpha, m, lambda, sigma, k)
end

function draw_from_parameter_bundle(param_bundle::StochasticLogisticParameterBundle)
    param_values::StochasticLogisticParameterValues = StochasticLogisticParameterValues(
        param_bundle.num_populations, 
        param_bundle.alpha,
        rand(param_bundle.lambda.distribution, param_bundle.lambda.dimensionality),
        rand(param_bundle.migration_rate.distribution, param_bundle.migration_rate.dimensionality),
        rand(param_bundle.carrying_capacity.distribution, param_bundle.carrying_capacity.dimensionality),
        rand(param_bundle.sigma.distribution, param_bundle.sigma.dimensionality))
    return param_values
end
