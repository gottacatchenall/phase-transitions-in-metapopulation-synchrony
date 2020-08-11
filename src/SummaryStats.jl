abstract type SummaryStat <: Function end



# Pairwise Crosscorrelation
struct PCC <: SummaryStat

    function PCC(::DynamicsModel, ::Population, ::Population)
        return 1
    end

    function PCC(::DynamicsModel)
        return 0
    end
end

# Mean Pairwise Crosscorrelation, where all
struct MeanPCC <: SummaryStat

end
