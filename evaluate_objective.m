function f = evaluate_objective(fluid, x, M, V)
import py.CoolProp.CoolProp.PropsSI;
f = [];

T_hs1 = 328+273.15;
T_cs1 = 5+273.15;
% fluid  = 'R141b';
T_cond = 294;
LT  = 25;
n_t = 0.85*0.9;
n_p = 0.8;
T_c = PropsSI('Tcrit',fluid);

%% -------------------- Objective function one ----------------------- %%
T_1 = PropsSI('T','P',x(1),'Q',0,fluid);
T1 = T_1 + x(2)
P2 = PropsSI('P','T',T_cond,'Q',0,fluid);

h_hs1 = PropsSI('H','T',T_hs1,'P',150000,'Air');
h_hs2 = PropsSI('H','T',x(4),'P',100000,'Air');
Qav   = 10*(h_hs1-h_hs2);


% turbine inlet 
if T1 < T_c
    h1 = PropsSI('H','P',x(1),'Q',1,fluid);
    s1 = PropsSI('S','P',x(1),'Q',1,fluid);
elseif T1 >= T_c
    h1 = PropsSI('H','P',x(1),'T',T1,fluid);
    s1 = PropsSI('S','P',x(1),'T',T1,fluid);
end  

% State 2
   s2 = s1;
   h2 = PropsSI('H','P',P2,'S',s2,fluid);
   T2 = PropsSI('T','H',h2,'P',P2,fluid);
% State 3
   h3 = PropsSI('H','P',P2,'Q',0,fluid);
   v3 = 1/PropsSI('D','P',P2,'Q',0,fluid);
   T3 = PropsSI('T','Q',0,'P',P2,fluid);
% State 4 properties
   h4 = h3 + v3*(x(1) - P2);
   T4 = PropsSI('T','H',h4,'P',x(1),fluid);
   
% work turbine
   w_t = (h1 - h2)*n_t;
% work pump
   w_p = (h4 - h3)/n_p;
% mass flow
   x(3) = Qav/(h1-h4);
% efficiency
   w_net = x(3)*(w_t-w_p);
   n_th  = ((w_t-w_p)*100)/(h1-h4);
   FOM   = n_th/(1-(T_cond/T_1));
   
% Cooling / Condensor
   Q_out = x(3)*(h2-h3);
   hC    = PropsSI('H','T',T_cs1,'P',101325,'Water'); 
   hH    = PropsSI('H','T',x(5),'P',101325,'Water');
   mf_cs = Q_out/(hH-hC);
   
% Exergy Anaysis 
   h_o = PropsSI('H','T',293,'P',101325,'Air');
   s_h = PropsSI('S','T',T_hs1,'P',150000,'Air');
   s_o = PropsSI('S','T',293,'P',101325,'Air');
   
   Ex_hs = 10*((h_hs1-h_o)-293*(s_h-s_o));
   n_ex  = (100*w_net)/Ex_hs;
   
   f(1)  = - n_ex;
   
%% ----------------------- Objective function two ----------------------%%

% Evaporator - counter-flow HE
   D1     = T_hs1 - T1;
   D2     = x(4) - T4;
   lmtd_e = (D1-D2)/log(D1/D2);
   area_e = Qav/(6*lmtd_e);
   
   Cp_e    = 10^(4.3247-0.3030*log10(area_e)+0.1634*(log10(area_e))^2);
   Cbm_e   = 2.9*Cp_e;
% Turbine
   power_t = x(3)*(w_t/1000);
   
   Cp_t    = 10^(2.7051+1.4398*log10(power_t)-0.1776*(log10(power_t))^2);
   Cbm_t   = 3.5*Cp_t;
% Condensor - counter-flow HE
   D_1     = T2 - x(5);
   D_2     = T3 - T_cs1;
   lmtd_c  = (D_1-D_2)/log(D_1/D_2);
   area_c  = Q_out/(25*lmtd_c);
   
   Cp_c    = 10^(4.3247-0.3030*log10(area_c)+0.1634*(log10(area_c))^2);
   Cbm_c   = 2.9*Cp_c;
% Pump
   power_p = x(3)*(w_p/1000);
   
   Cp_p    = 10^(3.3892+0.0536*log10(power_p)+0.1538*(log10(power_p))^2);
   Cbm_p   = 2.8*Cp_p;
% Cummulative cost
   C_tot = Cbm_e + Cbm_t + Cbm_c + Cbm_p;
   C_t17 = C_tot*623.5/397;
   CRF   = (0.05*(1.05^LT))/((1.05^LT)-1);
   
   LEC   = (C_t17*(CRF + 0.015))/(x(3)*((w_t-w_p)/1000)*8000);
   f(2)  = LEC
end
