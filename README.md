# NSGA2
Optimization of working parameters for Organic Rankine Cycle using NSGA-2

Run nsga_2.m in the Matlab command window with input (population size, generations) as >> nsga_2(X,Y).

Objective functions are defined in evaluate_objective.m

Random values of decision variables are initialised in initialise_variable.m which recieves the lower and upper bound
of 5 decision variables from the file objective_description_function.m

NSGA generates random decision variables for every member of population,
and keeps on saving the most elite member in every generation.

At the end we have a pareto frontier of all the elite members and we select a compromised solution among all the points
according to normalised distance method.
