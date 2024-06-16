%% Valeurs du modèle :
n_g = 43.165 ; % sans unité
J_r = 3.25e5; % kg/m^2
J_g = 34.4 ; % kg/m^2
K_s = 269.1e3 ; % N.m/rad
rho = 1.225 ; % en kg/m3
V = 7 ; % en m/s
D_s= 9500; % Nm/rad/s

%% Points d'équilibres (calcul avec les équations) :
wrn= 4.3982; 
theta0 = 5 ;
wg0 = n_g*wrn ;
Tr0 = funPuissance(wrn,theta0,V)/wrn;
Tg0=Tr0/n_g;
delta0 = n_g / K_s * Tg0 ;
Pe=Tg0*wg0;

%% Points d'équilibres (calcul avec la fonction Trim) : 

x0=[wrn;wg0;delta0]; %points de départs des différents variables
y0=[wrn;wg0;delta0];
u0=[theta0;Tg0;V];
ix=[1]; % variable à fixer
iy=[1];
iu=[];

[x,u,y,dx]= trim('equilibre',x0,u0,y0,ix,iu,iy);

%% Linéarisation du système autour du point d'équilibre :

[A,B,C,D] = linmod('linearisation',x,u(1:2)) ; 

%% Correcteur PI 

%Tracé diagramme de bodes pour Tg :

BTg = B(:,2) ; 
DTg = D(2) ;
sys = ss(A,BTg,C,DTg) ; 
[mag, phase, omega] = bode(sys) ;

subplot(2, 1, 1);  % Correction ici
semilogx(omega, 20*log10(squeeze(mag)));
grid on;
title('Diagramme de Bode - Magnitude (dB)');

subplot(2, 1, 2);
semilogx(omega, squeeze(phase));
grid on;
title('Diagramme de Bode - Phase (degrés)');
xlabel('Fréquence (rad/s)');

[Gm,Pm,Wcg,Wcp] = margin(sys) ;

Ki = 0.0011 ;
Ti = 0.8 ; % Le detail des calculs sont sur le rapport 

%% Diagramme de bode après correction 

% Fonction de transfert du correcteur PI
numerator = Ki * [Ti, 1];
denominator = [Ti, 0];
Gc = tf(numerator, denominator); % Fonction de transfert du correcteur PI

sys_with_PI = sys * Gc ; % Fonction de transfert du système corrigé

[mag, phase, omega] = bode(sys_with_PI);

figure;

subplot(2, 1, 1);
semilogx(omega, 20*log10(squeeze(mag)));
grid on;
title('Diagramme de Bode - Magnitude (dB)');

subplot(2, 1, 2);
semilogx(omega, squeeze(phase));
grid on;
title('Diagramme de Bode - Phase (degrés)');
xlabel('Fréquence (rad/s)');

%% MPPT 
% Tout sur le simulink sauf le vent variable : 
temps = wdata7(:,1);
vitesse = wdata7(:,2);
vent = timeseries(vitesse,temps);

%% Correcteur : Retour d'état et action intégrale :

% On définit des nouvelles matrices A_a,B_a,C_a et D_a pour effectuer une
% correction par retour d'état avec action intégrale (état augmenté)

A_a = [A [0;0;0] ; [0,Tg0,0,0] ] ;
B_a = [B ; [0, wg0] ] ; 

% performances : dépassement de 10 % et temps de réponse de 10s 
depassement = 0.1 ;
t_reponse = 10 ;
xi = sqrt(log(depassement)^2 / (log(depassement)^2 + pi^2)) ;
w0 = pi / (t_reponse*sqrt(1-xi^2)) ; 

p = roots([1,2*xi*w0,w0^2]) ; 
pa = [p ; real(p(1)*10); real(p(1)*10)] ;

K = place(A_a,B_a,pa) ;
K_x = K(:,1:3) ;
K_I = K(:,4) ;

%% LQI 

q1 = 0.01 ; % Coefficient q1 représentant le poids du suivi de wr
q2 = 0.01 ; % Coefficient q2 représentant le poids du suivi de wg
q3 = 0.01 ; % Coefficient q1 représentant le poids du suivi de delta
q4 = 0.1; % Coefficient q1 représentant le poids du suivi de l'intégrale
r1 = 10 ;
r2 = 100 ; 
Q = diag([q1,q2,q3,q4]) ;
R = diag([r1,r2]) ;

K_LQI = lqr(A_a,B_a,Q,R) ;

K_LQI_x = K_LQI(:,1:3) ;
K_LQI_I = K_LQI(:,4) ;

% Profil de vent variable adapté LQI :
Temps = wdata7(:,1);
Vents=wdata7(:,2);
Vents=Vents.';
Ve=[];
for V=Vents 
    if V>u(3)-1.4
        Ve=[Ve,V];
    else 
        Ve=[Ve,u(3)];
    end
end
Wind=timeseries(Ve,Temps);


%% Consigne otpimale pour un parc éolien : 

Ventre = 10 ; %m/s vitesse du vent entrant

% Stratégie de Maximisation du Cp pour chaque éolienne
Ind = [1,2,3,4,5,6,7,8,9,10] ; %indice des éolienne du parc
Ptm = funPuissancemaxtot(Ventre) ;
plot(Ind,Ptm)


% Stratégie d'optimisation de la puissance totale 
objectiveFunction = @(alpha) -sum(4 * alpha .* (1 - alpha) .* (1 - alpha) .* prod(1 - alpha(1:end-1)).^3); %fonction objectif 

initialAlpha = [1/5 ; 1/5 ; 1/5 ; 1/5 ; 1/5 ; 1/5 ; 1/5 ; 1/5 ; 1/5 ; 1/5]; % Initialiser les coefficients alpha

Aeq = [];
beq = []; % Pas de contraintes spécifiques (matrices vides)

lb = zeros(10, 1);
ub = [1/3 ; 1/3 ; 1/3 ; 1/3 ; 1/3 ; 1/3 ; 1/3 ; 1/3 ; 1/3 ; 1/3]; % Définir les limites des coefficients (par exemple, alpha doit être compris entre 0 et 1)

options = optimoptions('fmincon', 'Display', 'iter');
alphaOptimal = fmincon(objectiveFunction, initialAlpha, [], [], Aeq, beq, lb, ub, [], options);
O= -objectiveFunction(alphaOptimal) ;







