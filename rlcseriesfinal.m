clc;
close all;
clear;

% ========================================================================
% INPUT FROM THE USER
% ========================================================================

fprintf('============================26MEE016================================\n');
fprintf('                  SERIES RLC CIRCUIT ANALYSIS\n');
fprintf('============================================================\n\n');

r = input('Enter resistance, R (ohm): ');
while r < 0
    disp('Invalid input. Resistance cannot be negative.');
    r = input('Enter resistance, R (ohm): ');
end

l = input('Enter inductance, L (H): ');
while l < 0
    disp('Invalid input. Inductance cannot be negative.');
    l = input('Enter inductance, L (H): ');
end

c = input('Enter capacitance, C (F): ');
while c < 0
    disp('Invalid input. Capacitance cannot be negative.');
    c = input('Enter capacitance, C (F): ');
end

% ========================================================================
%% SERIES RLC CIRCUIT
% Calculation of zeta and omega
% ========================================================================

fprintf('\n----------------------26MEE016--------------------------------------\n');
fprintf('  SYSTEM CHARACTERISTICS\n');
fprintf('------------------------------------------------------------\n');

zeta = (r/2)*sqrt(c/l);

if zeta < 1
    fprintf('  Damping condition    : Underdamped\n');
elseif zeta == 1
    fprintf('  Damping condition    : Critically damped\n');
else
    fprintf('  Damping condition    : Overdamped\n');
end

omega_n = sqrt(1/(l*c));

fprintf('  Damping ratio, zeta  : %.3f\n', zeta);
fprintf('  Natural frequency   : %.3f rad/s\n', omega_n);

% ========================================================================
%% STATE-SPACE REALIZATION
% ========================================================================

A = [0 1/c ; -1/l -1*(r/l)];
B = [0 ; 1/l];
C = [1 0];
D = [0];

sys = ss(A, B, C, D);

fprintf('\n------------------------------------------------------------\n');
fprintf('  STATE-SPACE MODEL\n');
fprintf('------------------------------------------------------------\n\n');
disp(sys);

[num, den] = ss2tf(A,B,C,D);
G = tf(num, den);

fprintf('\n------------------------------------------------------------\n');
fprintf('  TRANSFER FUNCTION\n');
fprintf('------------------------------------------------------------\n\n');
disp(G);

p = [1,r * sqrt(c/r),1/(l*c)];
s = roots(p);

fprintf('\n------------------------------------------------------------\n');
fprintf('  ROOTS\n');
fprintf('------------------------------------------------------------\n\n');
disp(s);

fprintf('============================================================\n\n');

% ========================================================================
%% RESPONSE PLOTS
% ========================================================================

% Bode
figure;
bode(G);
grid off;
title('Series RLC Circuit — Bode Plot');

% Step response
figure;
step(G);
grid off;
title('Series RLC Circuit — Step Response');

% Impulse response
figure;
impulse(G);
grid off;
title('Series RLC Circuit — Impulse Response');

% Root locus
figure;
rlocus(G);
grid off;
title('Series RLC Circuit — Root Locus');

% Nyquist
figure;
nyquist(G);
grid off;
title('Series RLC Circuit — Nyquist Plot');