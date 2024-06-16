function Lambdai = funLambdai(lambda,theta)
    Lambdai = 1/(1/(lambda+0.08*theta)- 0.035/(theta^3 + 1)) ;
end