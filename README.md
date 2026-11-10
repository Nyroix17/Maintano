# MAINTANO

**MAINTANO** est une application de bureau développée dans le cadre d'un projet universitaire (SAE 2.01). Elle permet de gérer le parc de véhicules d'une entreprise et d'assurer le suivi de leurs entretiens.

L'application centralise les informations sur les véhicules, les points de contrôle et les interventions réalisées ou à effectuer. Elle propose également un tableau de bord permettant de consulter les entretiens et d'analyser l'activité de l'atelier.

Le projet a été réalisé en équipe.

---

## Sommaire

- [Objectifs du projet](#objectifs-du-projet)
- [Fonctionnalités](#fonctionnalités)
- [Les différents modules](#les-différents-modules)
- [Gestion des données](#gestion-des-données)
- [Architecture de l'application](#architecture-de-lapplication)
- [Technologies utilisées](#technologies-utilisées)
- [Structure du projet](#structure-du-projet)
- [Installation et lancement](#installation-et-lancement)
- [État du projet](#état-du-projet)

## Objectifs du projet

L'objectif de MAINTANO est de faciliter la gestion et le suivi des opérations d'entretien d'un parc de véhicules.

L'application permet notamment de :
- Centraliser les informations relatives aux véhicules.
- Organiser les différents points de contrôle.
- Planifier et suivre les entretiens.
- Consulter l'historique et l'état d'avancement des interventions.
- Obtenir des statistiques sur l'activité de l'atelier.

## Fonctionnalités

### Gestion des véhicules

- Affichage de la liste des véhicules.
- Consultation des caractéristiques : immatriculation, kilométrage, marque, modèle, couleur et poids.
- Affichage des photos des véhicules.
- Ajout d'un véhicule.
- Modification des informations d'un véhicule.
- Suppression d'un véhicule avec contrôle des contraintes d'intégrité.
- Importation et remplacement des photos.

### Gestion des entretiens

- Consultation des entretiens sous forme de tableau.
- Création d'un nouvel entretien.
- Modification et suppression d'un entretien.
- Association d'un entretien à un véhicule et à un point de contrôle.
- Gestion des dates d'arrivée, de prise en charge et de départ.
- Suivi du statut de l'entretien :
  - En attente
  - En cours
  - Terminé
- Ajout d'une évaluation et d'un commentaire.
- Actualisation des données affichées.

### Filtrage des entretiens

Plusieurs filtres permettent de retrouver rapidement les interventions :

**Filtrage par date :**
- Aucun filtre.
- Aujourd'hui.
- Depuis 7 jours.
- Depuis 1 mois.

**Filtrage par statut :**
- En attente.
- En cours.
- Terminé.
- Aucun filtre.

**Filtrage par point de contrôle :**
- Sélection d'un point de contrôle depuis une liste déroulante alimentée par la base de données.

### Gestion des points de contrôle

Les points de contrôle représentent les différents types d'opérations d'entretien.

L'application permet :
- De consulter les points de contrôle existants.
- D'ajouter un nouveau point de contrôle.
- De modifier un point de contrôle.
- De supprimer un point de contrôle lorsqu'il n'est pas utilisé par un entretien.
- De renseigner une durée moyenne estimée.
- D'ajouter une description ou des consignes.

### Fiche détaillée d'un entretien

Chaque entretien peut être consulté dans une fiche détaillée.

Elle permet :
- De consulter les informations du véhicule concerné.
- De visualiser les dates et le statut de l'intervention.
- De modifier les informations de suivi.
- D'ajouter des commentaires et une évaluation.
- De vérifier la cohérence des dates.
- De générer une fiche récapitulative au format HTML, consultable dans un navigateur.

### Statistiques

Un module permet d'obtenir une synthèse de l'activité de l'atelier.

Il propose notamment :
- Le nombre total d'entretiens planifiés.
- Le nombre d'entretiens réalisés.
- Des statistiques regroupées par véhicule et par période.
- Les évaluations minimales, maximales et moyennes.
- Un classement des résultats par mois et par marque de véhicule.

## Les différents modules

L'application est organisée autour de plusieurs modules accessibles depuis une fenêtre principale.

| Module | Rôle |
|---|---|
| Accueil | Consultation et suivi des entretiens |
| Véhicules | Gestion du parc automobile |
| Points de contrôle | Gestion du référentiel des interventions |
| Statistiques | Analyse de l'activité de l'atelier |

Les formulaires de création et de modification sont ouverts dans des fenêtres dédiées.

## Gestion des données

L'application utilise une base de données **SQLite** pour stocker les informations.

Les principales entités manipulées sont :

- **Véhicule :** informations techniques et caractéristiques des engins.
- **Point de contrôle :** nom, durée moyenne et description des opérations.
- **Entretien :** véhicule concerné, point de contrôle, dates, statut, évaluation et commentaire.

Les relations entre les tables permettent de conserver la cohérence des informations.

L'application utilise notamment :
- Des clés étrangères pour gérer les relations entre les données.
- Des transactions SQL pour valider ou annuler les modifications.
- Des requêtes SQL pour les opérations de consultation, d'insertion, de modification et de suppression.

## Architecture de l'application

L'application repose sur une architecture modulaire.

**Fenêtre principale :**
- Gère la navigation entre les modules.
- Charge dynamiquement les interfaces dans un conteneur central.
- Centralise la connexion SQLite et la gestion des transactions.

**Modules :**
- Chaque module possède ses propres fonctionnalités.
- Les interfaces sont organisées à l'aide de composants graphiques Lazarus.
- Les échanges avec la base de données sont réalisés à l'aide de requêtes SQL.

**Formulaires :**
- Les formulaires dédiés permettent de créer et modifier les différents enregistrements.
- Les validations contrôlent les champs obligatoires et certaines valeurs saisies.

## Technologies utilisées

| Technologie | Utilisation |
|---|---|
| Pascal Objet | Langage de programmation |
| Lazarus | Environnement de développement et conception des interfaces |
| Free Pascal | Compilateur |
| SQLite | Stockage des données |
| SQLDB | Connexion et accès à la base de données |
| SQL | Requêtes et manipulation des données |
| HTML | Génération des fiches récapitulatives |

## Structure du projet

```text
MAINTANO_Project/
│
├── project1.lpi
├── project1.lpr
├── project1.exe
│
├── unit1.pas
├── unit1.lfm
│
├── module0.pas
├── module0.lfm
├── module1.pas
├── module1.lfm
├── module2.pas
├── module2.lfm
├── module3.pas
├── module3.lfm
│
├── dlg_formulaire1.pas
├── dlg_formulaire2.pas
├── dlg_formulaire3.pas
├── dlg_formulaire4.pas
├── dlg_formulaire5.pas
├── dlg_formulaire6.pas
│
├── MAINTANO.db
│
├── photos/
├── Icone/
└── FicheVehicule/
```

Les fichiers `.pas` contiennent le code source Pascal Objet.

Les fichiers `.lfm` décrivent les interfaces graphiques des fenêtres et des formulaires.

Le fichier `.lpi` correspond au projet Lazarus et permet de l'ouvrir dans l'environnement de développement.

## Installation et lancement

### Prérequis

Pour ouvrir et compiler le projet, il faut disposer de :

- Lazarus.
- Free Pascal.
- La bibliothèque SQLite3.
- Les composants nécessaires à Lazarus, notamment LCL et SQLDB.

### Ouvrir le projet

1. Télécharger ou cloner le dépôt.
2. Ouvrir Lazarus.
3. Sélectionner le fichier `project1.lpi`.
4. Vérifier la configuration du projet.
5. Compiler et lancer l'application.

Le fichier `project1.exe` fourni dans le projet correspond à une version compilée pour Windows.

**Important :** la base de données `MAINTANO.db` ainsi que les dossiers contenant les photos et les ressources graphiques doivent rester accessibles à l'application. Leur emplacement doit respecter les chemins utilisés par le programme.

## État du projet

MAINTANO est un projet universitaire réalisé en équipe dans le cadre de la SAE 2.01.

Il met en œuvre les notions de programmation orientée objet, de conception d'interfaces graphiques, de bases de données relationnelles et de manipulation de données avec SQL.

---

## Utilisation du code

Ce dépôt est publié à des fins de présentation et de consultation.

Tous droits réservés. Aucune autorisation n'est accordée pour réutiliser, modifier, redistribuer ou exploiter commercialement le code source sans autorisation écrite préalable, sous réserve des droits et conditions applicables.