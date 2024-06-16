function Cp = funCp(lambda,theta) 
    Cp = 0.5*(116/funLambdai(lambda,theta)-0.4*theta-5)*exp(-21/funLambdai(lambda,theta)) + 0.0068*lambda ;
end