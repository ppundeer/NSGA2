function [number_of_objectives, number_of_decision_variables, min_range_of_decesion_variable, max_range_of_decesion_variable] = objective_description_function(fluid)
import py.CoolProp.CoolProp.PropsSI;
% fluid  = 'R141b';
T_hs1 = 328+273.15;
T_min = 297;
T_cs1 = 5+273.15;
T_c   = PropsSI('Tcrit',fluid)

if T_c > T_hs1
    T_max = T_hs1-4;
else
    T_max = T_c-4;
end

Pmax = PropsSI('P','T', T_max,'Q',0,fluid);
Pmin = PropsSI('P','T', T_min,'Q',0,fluid);

number_of_objectives = 2;
number_of_decision_variables = 6;

% P_evap
min_range_of_decesion_variable(1) = Pmin;
max_range_of_decesion_variable(1) = Pmax;

% T_sh
min_range_of_decesion_variable(2) = 0;
if T_c > T_hs1
    max_range_of_decesion_variable(2) = 0;
else
    max_range_of_decesion_variable(2) = abs(T_hs1-T_c)-4;
end
% m_f
min_range_of_decesion_variable(3) = 0.1;
max_range_of_decesion_variable(3) = 5;
% T_hs2
min_range_of_decesion_variable(4) = T_hs1-150;
max_range_of_decesion_variable(4) = T_hs1-50;
% T_cs2
min_range_of_decesion_variable(5) = T_cs1+10;
max_range_of_decesion_variable(5) = T_cs1+15;

end    
