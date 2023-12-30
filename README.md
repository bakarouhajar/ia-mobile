## SocHub

Bienvenue sur SocHub !
# Les données de tests sont situées dans le dossier "Data" puis "Test" du projet.
# La plateforme utilisée pour tester :
<img width="190" alt="Capture d'écran 2023-12-30 164341" src="https://github.com/bakarouhajar/ia-mobile/assets/105990605/273efd4b-c160-4a06-8d64-195a23918c6e">

### Démonstration Vidéo : 


https://github.com/bakarouhajar/ia-mobile/assets/105990605/6dbda48f-9223-47ec-a635-8f6c5f9372a0



# Des identifiants de connexion à l’application : 
Identifiant 1 : 
Login : hajar@gmail.com               
Password : Hajar@123

Identifiant 2 : 
Login : mathieu.miollan@gmail.com
Password : Mathieu@123

# Le compte rendu envoyé par email contient toutes les captures d'écrans détaillées.

## Fonctionnalités Principales

### 1.Interface de Login

En tant qu'utilisateur, vous pouvez vous connecter à l'application en utilisant votre login et votre mot de passe [ Login : mathieu.miollan@gmail.com
Password : Mathieu@123 ]. L'interface de login comprend un headerBar avec le nom de l'application SocHub, deux champs de saisie (Login et Password), et un bouton "Se connecter". La sécurité est assurée avec l'obfuscation du champ de saisie du mot de passe. L'authentification est vérifiée en base de données, et en cas d'échec, un log est affiché dans la console tout en maintenant la fonctionnalité de l'application.


### 2. Liste des Activités

Une fois connecté, vous accédez à la page des activités qui comprend une BottomNavigationBar avec trois entrées : Activités, Ajout, et Profil. La liste des activités est dynamiquement récupérée de la base de données avec des informations telles que l'image, le titre, le lieu, et le prix. En cliquant sur une activité, vous pouvez voir les détails de celle-ci.

### 3. Détail d'une Activité

Lorsque vous cliquez sur une activité, vous voyes un dialog  détaillant des informations importantes telles que l'image, le titre, la catégorie, le lieu, le nombre de personnes minimum requis, et le prix...

### 4. iltrer sur la Liste des Activités

Sur la page des activités, une TabBar est présente, listant les différentes catégories d'activités. Par défaut, l'entrée "All" est sélectionnée, affichant toutes les activités. En sélectionnant une catégorie, la liste est filtrée en conséquence.

### 5. Profil Utilisateur

En tant qu'utilisateur connecté, vous pouvez accéder aux informations de votre profil, les visualiser, les modifier au besoin ( image , birthdate comme exemple), et les sauvegarder en base de données.

### 6. IA Ajouter une Nouvelle Activité

Vous pouvez ajouter une nouvelle activité à partir de votre profil. En accédant à la page "Ajout" depuis la BottomNavigationBar, un formulaire vous permet de saisir les détails de la nouvelle activité. Une fois validé, les données sont sauvegardées en base de données. La gatégorie de l'activité est détéctée automatiquement à l'aide du model AI. Elle est unchangeable.

### 7. Innovation

Les utilisateurs peuvent ajouter et retirer des activités de leur liste de favoris. De plus, es catégories sont générées dynamiquement à partir de la base de données, offrant une flexibilité maximale. 

