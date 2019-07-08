function f = initialize_variables(fluid, N, M, V, min_range, max_range)
import py.CoolProp.CoolProp.PropsSI;
% N - Population size
% M - Number of objective functions
% V - Number of decision variables
% min_range - A vector of decimal values which indicate the minimum value
% for each decision variable.
% max_range - Vector of maximum possible values for decision variables.
min = min_range;
max = max_range;
K = M + V;
Pcond = PropsSI('P','T',295,'Q',0,fluid);
%% Initialize each chromosome
% For each chromosome perform the following (N is the population size)
for i = 1 : N
    for j = 1 : (V-1)
        f(i,j) = min(j) + (max(j) - min(j))*rand(1);
    end
    % The elements V + 1 to K has the objective function values. 
    % The function evaluate_objective takes one chromosome at a time,
    % infact only the decision variables are passed to the function along
    % with information about the number of objective functions which are
    % processed and returns the value for the objective functions. These
    % values are now stored at the end of the chromosome itself
    f(i,V + 1: K) = evaluate_objective(fluid, f(i,:), M, V);
end
