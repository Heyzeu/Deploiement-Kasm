# Packer - Génération d'Image ISO Debian Personnalisée

Ce répertoire contient les configurations Packer utilisées pour générer une image ISO Debian auto-installable. Cette image sert de base à la création des machines virtuelles cibles pour le déploiement de Kasm Workspaces, assurant une installation reproductible et automatisée du système d'exploitation.

## Rôle de Packer dans le Projet

Packer est l'outil de HashiCorp utilisé pour fabriquer automatiquement le disque d'installation Debian personnalisé. Il garantit que l'image résultante est toujours la même, grâce à l'utilisation de fichiers de configuration. Packer permet également d'intégrer des scripts d'automatisation directement dans l'image.

## Fichiers de Configuration

### `debian.pkr.hcl`

Ce fichier est la pierre angulaire de la création de l'ISO. Il instruit Packer sur la manière de construire la machine virtuelle et d'intégrer les éléments d'auto-installation de Debian. Il définit des paramètres clés tels que :
* L'URL de l'ISO Debian source (`iso_url`).
* Les ressources matérielles de la VM (`disk_size`, `memory`, `cpu_cores`).
* La commande de démarrage (`boot_command`), exécutée au démarrage de la VM pour lancer le processus d'auto-installation de Debian et y injecter les configurations nécessaires.
* D'autres options comme `headless` (exécution sans interface graphique) et `vm_name`.

### `preseed.cfg`

Indissociable du `boot_command` de Packer, ce fichier est le second pilier de l'automatisation de l'installation de Debian. Il contient toutes les réponses pré-définies aux questions que l'installeur Debian pose habituellement, rendant l'installation du système d'exploitation entièrement autonome et réduisant le temps de déploiement.

Ce fichier couvre les configurations suivantes:
* **Localisation** : Langue, pays, clavier.
* **Réseau** : Nom d'hôte et paramètres réseau (DHCP).
* **Comptes Utilisateurs** : Création des utilisateurs (`root` et `ansible`), avec gestion des mots de passe.
* **Partitionnement** : Instructions pour le partitionnement automatique du disque, y compris LVM et le chiffrement.
* **Installation du Système de Base** : Sélection et installation des paquets fondamentaux, dont OpenSSH.
* **Tâches Post-Installation** : Exécution de commandes finales pour installer des outils essentiels comme `sudo`, `curl`, et Ansible.

L'intégration de ce `preseed.cfg` via le `boot_command` de l'ISO générée par Packer garantit que chaque étape de l'installation de Debian est pré-répondue, établissant ainsi une base stable et automatisée pour l'orchestration ultérieure.

## Utilisation

Pour générer l'image ISO personnalisée, assurez-vous que Packer est installé sur votre machine hôte (Windows dans le cadre de ce projet).

1.  Accédez au répertoire `packer` :
    ```bash
    cd deploiement-kasm/packer
    ```
2.  Exécutez la commande de build Packer :
    ```bash
    packer build debian.pkr.hcl
    ```
    L'image ISO sera générée dans le répertoire de sortie défini par Packer, prête à être utilisée pour le provisionnement d'une VM cible dans VirtualBox.