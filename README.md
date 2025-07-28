# Projet DevOps: Déploiement Sécurisé de Postes avec Kasm Workspaces

## Description du Projet

Ce projet implémente une solution automatisée pour le déploiement de postes de travail sécurisés. L'objectif est de fournir des environnements virtuels "plug-and-play" accessibles via un navigateur web, permettant d'exécuter des applications spécifiques ou obsolètes dans un cadre sécurisé et isolé. Le processus est entièrement automatisé, de la génération de l'image de base à la configuration finale de la plateforme Kasm Workspaces.

## Architecture du Projet

Le déploiement est orchestré par une architecture automatisée intégrant plusieurs outils DevOps.

![Schéma d'architecture du projet](docs/architecture.png)

1.  **Packer** : Utilisé pour créer une image ISO Debian personnalisée et auto-installable, servant de base aux machines virtuelles.
2.  **Déploiement de la VM** : Provisionnement automatisé d'une machine virtuelle (VM) Debian à partir de l'ISO générée.
3.  **Ansible** : Configuration post-déploiement de la VM, incluant l'installation de Docker, Docker Compose et Kasm Workspaces, assurant la reproductibilité.
4.  **Docker et Docker Compose** : Environnements conteneurisés pour Kasm Workspaces, assurant l'exécution isolée des applications et bureaux virtuels.
5.  **Kasm Workspaces** : Plateforme permettant l'accès sécurisé aux bureaux virtuels conteneurisés via un navigateur web.
6.  **Accès Utilisateur** : Interface utilisateur pour l'accès aux instances de bureaux virtuels depuis divers dispositifs.

## Choix des Solutions Techniques

Les outils ont été sélectionnés pour automatiser et simplifier le déploiement de Kasm Workspaces.

* **Kasm Workspaces** : Plateforme flexible et sécurisée pour la diffusion d'environnements conteneurisés à distance.
* **Debian** : Système d'exploitation de base stable et fiable pour l'image personnalisée.
* **Docker et Docker Compose** : Fondamentaux pour l'exécution et l'orchestration des conteneurs Kasm Workspaces.
* **Packer** : Outil HashiCorp pour la création automatisée et reproductible de l'image d'installation Debian (`debian.pkr.hcl`, `preseed.cfg`).
* **Ansible** : Outil d'automatisation sans agent (via SSH) pour l'installation de Kasm Workspaces, garantissant des déploiements uniformes.
* **Git / GitHub** : Pour la gestion de version du code du projet (Packer, Ansible, scripts), assurant le suivi et la collaboration.

## Mise en Œuvre du Projet

### Workflow de Déploiement

Le workflow simule un processus de création d'images et de déploiement "plug-and-play" sur des machines virtuelles.

1.  **Environnement de Travail** : PC Windows hôte (développement Packer avec VS Code), VM Debian dédiée pour Ansible (MobaXterm pour SSH), VirtualBox pour la virtualisation des VMs en mode pont.

2.  **Processus de Création d'ISO** : Packer génère une image ISO Debian personnalisée en utilisant `debian.pkr.hcl` (paramètres VM, `boot_command`) et `preseed.cfg` (automatisation de l'installation Debian, y compris réseau, utilisateurs, partitionnement, et installation d'OpenSSH et Ansible).

3.  **Déploiement de la VM Cible** : L'ISO générée est utilisée dans VirtualBox pour créer et démarrer une nouvelle VM Debian cible.

4.  **Configuration Ansible** : La VM Debian dédiée Ansible est préparée avec Python 3, pip, un environnement virtuel Ansible, un utilisateur `ansible` avec sudo, et des clés SSH pour la connexion aux machines cibles.

5.  **Déploiement Docker, Docker Compose et Kasm** : Ansible exécute des playbooks pour installer Docker, Docker Compose et Kasm Workspaces sur la VM cible, rendant l'environnement Kasm pleinement opérationnel.

6.  **Versionnement** : Tous les fichiers de configuration et scripts sont versionnés avec Git.

### Accès à Kasm Workspaces

Kasm Workspaces est accessible via l'URL : `http://<IP_DE_LA_MACHINE_CIBLE>:3000`. L'interface permet la définition des identifiants administrateur et utilisateur.

## Améliorations Envisagées

* **Automatisation de la configuration des VMs** : Développer un script complet pour automatiser l'installation des prérequis, la configuration réseau et l'intégration des clés SSH sur les VMs cibles et la VM Ansible, garantissant une reproductibilité et une réduction significative du temps de déploiement.

## Prérequis

Pour exécuter ce projet, vous aurez besoin de :
* **Packer**
* **Ansible**
* **VirtualBox** (ou un hyperviseur compatible pour les VMs)
* Un système hôte (Windows avec VS Code, MobaXterm pour l'environnement de développement).
* Accès à Internet pour les téléchargements de dépendances.

## Guide de Démarrage Rapide

1.  **Cloner le dépôt :**
    ```bash
    git clone [https://github.com/votre-utilisateur/deploiement-kasm.git](https://github.com/votre-utilisateur/deploiement-kasm.git)
    cd deploiement-kasm
    ```

2.  **Générer l'ISO personnalisée avec Packer :**
    Accédez au dossier `packer` et exécutez la commande :
    ```bash
    cd packer
    packer build debian.pkr.hcl
    ```

3.  **Préparer la VM Ansible :**
    Configurez une VM Debian dédiée comme "centre de commande Ansible" comme décrit dans le rapport de projet.

4.  **Créer la VM Cible :**
    Utilisez l'ISO générée par Packer dans VirtualBox pour créer une nouvelle machine virtuelle cible Debian.

5.  **Mettre à jour l'inventaire Ansible :**
    Modifiez le fichier `ansible/inventories/production.ini` avec l'adresse IP de votre machine cible et les informations de connexion SSH :
    ```ini
    [kasm_hosts]
    votre_ip_cible ansible_user=votre_utilisateur ansible_ssh_private_key_file=/chemin/vers/votre/cle_ssh
    ```

6.  **Exécuter les playbooks Ansible :**
    Depuis la racine du projet, lancez le playbook principal depuis votre VM Ansible :
    ```bash
    ansible-playbook -i ansible/inventories/production.ini ansible/site.yml
    ```

7.  **Accéder à Kasm Workspaces :**
    Une fois le déploiement Ansible terminé, Kasm Workspaces sera accessible via votre navigateur :
    * **URL :** `https://<IP_DE_LA_MACHINE_CIBLE>` (ou sur le port 3000 initialement `http://<IP_DE_LA_MACHINE_CIBLE>:3000` pour la première configuration).
    * Suivez les instructions sur l'interface Kasm pour définir les identifiants admin et utilisateur.

## Auteur

* **Francesca EZELIN**