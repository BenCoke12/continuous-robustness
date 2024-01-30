--The input for the network is a vector with 3 rational elements
type Input = Vector Rat 3

--The targets are Rational numbers between 0 and 1

--All elements in the input vector should be between 0 and 1
validElement : Rat -> Bool
validElement element = 0 <= element <= 1

validInput : Input -> Bool
validInput input = forall i . validElement (input ! i)

--The network takes an input containing:
--Saturation at step n-1 
--Relative permeability at step n-1
--Saturation at step n
--It returns the releative permeability at step n
@network
regression : Input -> Vector Rat 1

--The radius of the ball that we are checking within
@parameter
epsilon : Rat

--For each record in the dataset, we check that the output of the network on that record
--is within epsilon distance of the target contained in the dataset
--i.e. target - epsilon <= output <= target + epsilon
targetWithinEpsilon : Input -> Rat -> Bool
targetWithinEpsilon input target = 
    validInput input =>
        target - epsilon <= regression input ! 0 <= target + epsilon

--infer dataset size from datasets given
@parameter (infer=True)
n : Nat

--Datasets in idx format, inputs and targets
@dataset
data : Vector Input n

@dataset
targets : Vector Rat n

@property
WithinEpsilon : Vector Bool n
WithinEpsilon = foreach i . targetWithinEpsilon (data ! i) (targets ! i)