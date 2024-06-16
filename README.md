# Control of a wind turbine

## Introduction

Projet scolaire effectué à CentraleSupélec sur Matlab et Simulink pour asservir en puissance une éolienne.
Sujets abordées:
- Correcteur PI
- Asservissement action intégrale
- Asservissement placement de pôle
- Asservissement LQI

Pour mieux comprendre le projet, clique [ici]() pour ouvrir le rapport.
## Utilisation
L'utilisation de chaque section du fichier Matlab est expliqué ici, en particulier l'utilisation des fichiers simulink liés.

### Valeurs du modèle : 
rien à faire sur cette section à part la lancer 

### Points d'équilibres (calcul avec les équations) :
rien à faire sur cette section à part la lancer 
On peut observer les points d'équilibre en tapant dans le terminal : wrn / wg0 / delta0 / theta0 / Tg0 / V

### Points d'équilibres (calcul avec la fonction Trim) : 
rien à faire sur cette section à part la lancer 
Dans la suite de l'étude les points d'équilibre du vecteur d'état seront notés x et ceux de la commande notés u 

### Linéarisation du système autour du point d'équilibre :
rien à faire sur cette section à part la lancer 

### Correcteur PI :
après avoir lancé la section, on voit apparaitre des diagrammes de bodes qui ont été utilisé pour déterminer Ki et Ti.
Pour observer la réponse temporelle à un échelon, il faut lancer le fichier simulink PI.slx 
Sur le fichier on peut 
- modifier la consigne de puissance dans le bloc step "consigne de Puissance", 
- observer la puissance de sortie dans le scope "puissance réelle"
- modifier les perturbations liées au vent (constante / variable) en déplaçant les blocs de vents 

### Diagramme de bode après correction :
rien à faire sur cette section à part la lancer 
Cette section donne accès aux diagrammes de bodes après correction

### MPPT :
Pour observer la réponse temporelle à un échelon, il faut lancer le fichier simulink MPPT.slx
Sur le modèle Simulink on peut :
- observer la puissance de sortie dans le scope "puissance de sortie"
- modifier les perturbations liées au vent mais ici un fichier de vent variable nous est déjà fourni

### Correcteur : Retour d'état et action intégrale :
Une fois la section lancée, et le fichier simulink retour_etat_integral.slx , il faut s'assurer que le gain intégral et le gain etat présent dans le fichier simulink sont bien K_I et K_x.
C'est gain sont déterminé grâce à un placement de pôles. 
Sur le modèle simulink on peut :
- modifier la consigne de puissance dans le bloc step "consigne de Puissance", 
- observer la puissance de sortie dans le scope "puissance de sortie"
- modifier les perturbations liées au vent (changement dans le bloc constant de la valeur finale)

### LQI :
Comme précédemment, on s'assure après avoir lancé la section que sur le ficher simulink retour_etat_integral.slx, le gain intégral et le gain état sont birn K_LQI_I et K_LQI_x 
Sur le modèle simulink on peut :
- modifier la consigne de puissance dans le bloc step "consigne de Puissance", 
- observer la puissance de sortie dans le scope "puissance de sortie"
- modifier les perturbations liées au vent (changement dans le bloc constant de la valeur finale) et le soumettre à un profil de vent variable

### Consigne optimale pour un parc éolien : 
On peut modifier la valeur du vent d'entré dans le parc éolien en jouant sur Ventre.
Après avoir lancé la section on obtient la courbe de la puissance totale au niveau de chaque éolienne et l'optimisation des paramètres alpha de chaque éolienne. 

# Auteurs
