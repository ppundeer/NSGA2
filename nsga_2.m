function nsga_2(pop,gen)
pyversion;
[v,e] = pyversion; system([e,' -m pip install --user -U CoolProp']);
import py.CoolProp.CoolProp.*;
fluid = 'Methanol';

%% function nsga_2(pop,gen)
% pop - Population size x
% gen - Total number of generations
if nargin < 2
    error('Please enter(population size, number of generations) as arguments');
end
if pop < 20
    error('Minimum population required is 20');
end
if gen < 5
    error('Minimum number of generations is 10');
end
pop = round(pop);
gen = round(gen);

%% Objective Function
[M, V, min_range, max_range] = objective_description_function(fluid);

% Initialize the population
chromosome = initialize_variables(fluid, pop, M, V, min_range, max_range);

% Sort the initialized population
chromosome = non_domination_sort_mod(chromosome, M, V);

%% Start the evolution process
for i = 1 : gen
    % NSGA-II uses a binary tournament selection.
    % pool - size of the mating pool
    % tour - Tournament size
    pool = round(pop/2);
    tour = 2;
    parent_chromosome = tournament_selection(chromosome, pool, tour);
    % Perfrom crossover and Mutation operator
    mu = 0.2;
    mum = 100;
    offspring_chromosome = genetic_operator(fluid, parent_chromosome, ...
        M, V, mu, mum, min_range, max_range);
    % Intermediate population is the combined population of parents and
    % offsprings of the current generation. 
    % The population size is two times the initial population.
    [main_pop,temp] = size(chromosome);
    [offspring_pop,temp] = size(offspring_chromosome);
    % temp is a dummy variable
    clear temp
    % intermediate_chromosome is a concatenation of current population and
    % the offspring population.
    intermediate_chromosome(1:main_pop,:) = chromosome;
    intermediate_chromosome(main_pop + 1 : main_pop + offspring_pop,1 : M+V) = ...
        offspring_chromosome;

    % Non-domination-sort of intermediate population
    intermediate_chromosome = ...
        non_domination_sort_mod(intermediate_chromosome, M, V);
    
    % Perform Selection
    chromosome = replace_chromosome(intermediate_chromosome, M, V, pop);
end

%% Result is saved in chromosome
% Visualize
   
   plot(-chromosome(:,V + 1),chromosome(:,V + 2),'*');
   title('EXE vs LEC');
   xlabel('EXE/%');
   ylabel('LEC/(USD.kWh)^-1');
   %legend('Methanol','Ethanol','Acetone');
   %}
   t     = chromosome(:,:)
   dist  = [];
   
   %for each individual in t, calculate distance from pt. (100,0)
   for j = 1:pop
       dist(j) = ((chromosome(j,6)/100+1)^2)+((4*chromosome(j,7))^2);
   end
   [a,b] = min(dist);
   dna   = chromosome(b,:)
   evaluate_ORC(dna,fluid);

end