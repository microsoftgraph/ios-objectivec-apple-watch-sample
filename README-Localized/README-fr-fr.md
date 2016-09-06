
# Qui êtes-vous ? - Exemple avec Microsoft Graph et Apple Watch

**Qui êtes-vous ?** est un exemple de surveillance qui vous permet d’obtenir de plus amples informations sur un collègue lors d’une réunion. C’est une façon amusante d’associer un accessoire portable comme une Apple Watch avec Microsoft Graph, un point de terminaison unifié pour accéder aux données, relations et connaissances fournies à partir du cloud Microsoft.

Le scénario repose sur la façon d’assister à une réunion pour laquelle nous ne connaissons pas l’un des participants et sur qui nous souhaiterions en savoir plus d’une manière discrète. À partir de l’Apple Watch, vous pouvez extraire la liste des participants à une réunion et consulter leurs informations de profil, telles que leur fonction, leur responsable, leurs collaborateurs directs et toutes les photos de profil associées.

![Surveillance](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/WatchScene.jpg)


> Remarque : Cet exemple est simplement une idée et il est destiné uniquement à ouvrir le champ des possibilités d’intégration de Microsoft Graph dans un certain nombre de scénarios différents. Comme toujours, lors de la création de votre propre application dans votre organisation, vous devez veiller à mettre en œuvre vos propres recommandations en matière de sécurité (authentification et autorisations de l’application) et de conception d’une application. En outre, veuillez vous reporter aux [bonnes pratiques pour l’IHM watchOS](https://developer.apple.com/watch/human-interface-guidelines/) d’Apple.

Enfin, ce travail n’est pas terminé et nous serions heureux que vous puissiez contribuer à son amélioration, si vous le pouvez. **Qui êtes-vous ?** est un exemple de WatchOS 2.2 qui utilise la bibliothèque Active Directory Authentication Library pour iOS pour l’authentification et le point de terminaison Microsoft Graph afin de recueillir des informations spécifiques sur les profils utilisateur. 

## Conditions préalables
* [Xcode](https://developer.apple.com/xcode/downloads/) d’Apple (testé sur la version 7.3.1 avec prise en charge de WatchOS 2.2.
* Installation de [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) comme gestionnaire de dépendances.
* Un compte professionnel Microsoft tel qu’Office 365 qui prend en charge Microsoft Exchange.  Vous pouvez souscrire à un [abonnement d’évaluation d’Office 365 Entreprise](https://products.office.com/en-us/business/office-365-enterprise-e5-business-software) pour accéder aux ressources dont vous avez besoin pour commencer à créer des applications Office 365. Cela inclut également 25 licences à appliquer aux utilisateurs.

     > Remarque : Cet exemple s’appuie sur la présence d’un compte professionnel sous licence avec des informations de profil limitées renseignées, telles que la fonction d’un employé, son nom d’affichage, son responsable, ses collaborateurs directs et sa photo de profil. Si ces informations ne sont pas renseignées, elles ne seront pas affichées dans l’application.    
* Un client Microsoft Azure pour enregistrer votre application. Azure Active Directory fournit des services d’identité que les applications utilisent à des fins d’authentification et d’autorisation. Un abonnement d’évaluation peut être demandé ici : [Microsoft Azure](https://account.windowsazure.com/SignUp).

**Important** : Vous devrez également vous assurer que votre abonnement Azure est lié à votre client Office 365. Pour cela, consultez la section sur l’ajout d’un répertoire dans le billet du blog de l’équipe d’Active Directory relatif à la [création et la gestion de plusieurs fenêtres dans les répertoires Azure Active Directory](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx). Vous pouvez également lire l’article relatif à la [configuration de l’accès Azure Active Directory pour votre site de développeur](http://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription) pour plus d’informations.


## Inscription de votre application auprès de Microsoft Azure
1.  Connectez-vous au [Portail de gestion Azure](https://manage.windowsazure.com) à l’aide de vos informations d’identification Azure AD.
2.  Cliquez sur **Tous les éléments** dans le menu de gauche, puis sélectionnez le répertoire sur votre site de développeur Office 365.
3.  Dans le menu supérieur, sélectionnez **Applications**.
4.  Sélectionnez **Ajouter** dans le menu inférieur.
5.  Sur la page **Que souhaitez-vous faire ?**, sélectionnez **Ajouter une application développée par mon entreprise**.
6.  Dans la page **Parlez-nous de votre application**, indiquez **iOS-Watch** pour le nom de l’application et sélectionnez **APPLICATION CLIENT NATIVE** pour le type.
7.  Cliquez sur l’icône de flèche en bas à droite de la page.
8.  Sur la page **Informations sur l’application**, spécifiez un **URI de redirection**. Pour cet exemple, vous pouvez indiquer **https://localhost**, puis sélectionner l’**icône de coche** dans le coin inférieur droit de la page. Mémorisez cette valeur pour la section **Exécution de cet exemple dans Xcode**.
9.  Une fois l’application ajoutée, vous serez redirigé vers la page de démarrage rapide de l’application. Sélectionnez **Configurer** dans le menu supérieur.
10. Accédez à la section intitulée **Autorisations accordées à d’autres applications**.
11. Cliquez sur **Ajouter une application**.
12. Cliquez sur **Microsoft Graph**. 
13. Cliquez sur l’**icône de coche** en bas de la page.
14. Dans la section **Autorisations déléguées**, sélectionnez **Activer la connexion et lire le profil utilisateur**, **Lire les profils complets de tous les utilisateurs** et **Accéder en lecture aux calendriers utilisateur**.
15. Cliquez sur le bouton **Enregistrer** situé en bas de la page.
16. Copiez les valeurs pour **ID client** et **URI de redirection** sur la page **Configurer**. Mémorisez ces valeurs pour la section **Exécution de cet exemple dans Xcode**.

## Exécution de cet exemple dans Xcode

1. Clonez ce référentiel.
2. Utilisez CocoaPods pour importer la dépendance d’authentification ADAL. Cet exemple d’application contient déjà un podfile qui recevra les pods dans le projet. Ouvrez simplement le projet à partir de **Terminal** et exécutez :

        pod install

     Pour plus d’informations, consultez **Utilisation de CocoaPods** dans [Ressources supplémentaires](#ressources-supplémentaires).

3. Ouvrez **iOS-ObjectiveC-MicrosoftGraph-WatchSample.xcworkspace**.
4. Ouvrez **ViewController.m**. Vous verrez que l’**ID client** et l’**URI de redirection** du processus d’inscription peuvent être ajoutés à la partie supérieure du fichier :

        // You will set your application's clientId and redirect URI.
        NSString * const kRedirectUri = @"ENTER_REDIRECT_URI_HERE";
        NSString * const kClientId    = @"ENTER_CLIENT_ID_HERE";
        NSString * const kAuthority   = @"https://login.microsoftonline.com/common";
        NSString * const kResourceId  = @"https://graph.microsoft.com";

5. Exécutez l’exemple et assurez-vous que la cible est définie sur le modèle WatchKit App iPhone/Apple Watch.
![Cible](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/target.jpg)
6. Vérifiez que l’application iOS et les simulateurs de l’application de surveillance sont visibles. Dans l’application du téléphone, cliquez sur *Connexion*. Vous êtes ensuite invité à vous authentifier auprès d’un compte de messagerie professionnel. Fournissez vos informations d’identification.
![Authentification](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/Authentication.jpg)
6. Après l’authentification, l’application de surveillance essaie immédiatement d’extraire les événements récents du calendrier de l’utilisateur connecté. Un indicateur **Récupération...** apparaît dans l’application de surveillance. À partir de là vous pouvez naviguer dans la liste des participants, trouver une personne d’intérêt et afficher des informations de profil spécifiques : fonction, responsable, collaborateurs directs et images de profil.

    > Remarque : Là encore, vous devez avoir créé une réunion dans votre client Office 365, ajouté des participants sous licence et saisi certaines informations de profil spécifiques pour que l’application renvoie une valeur. Assurez-vous que chaque personne soit créée avec son nom d’affichage et sa fonction dans la console d’administration Office 365. Les collaborateurs directs et le responsable peuvent être assignés dans le centre d’administration Exchange (destinataires/boîtes aux lettres) dans Office 365. Consultez également le problème relatif au jeton d’accès dans la section **Problèmes connus**.

##Code d’intérêt

**Téléphone**

*ViewController* : sur le côté téléphone, c’est là où WCSession est configuré et activé pour établir la connectivité entre le téléphone et l’application de surveillance. À partir d’ici, un appel est effectué dans **AuthenticationManager** pour un jeton d’accès (ADAL pour iOS) et il est envoyé à l’application de surveillance via la méthode **sendMessage:replyHandler:errorHandler:**. 

**Surveillance**

*InterfaceController* : dans ce contrôleur, **session:didReceiveMessageData:replyHandler:** est mis en œuvre pour recevoir le jeton d’accès à partir du téléphone, d’où il est stocké dans **Network\NetworkManager.m**. Ce contrôleur effectue ensuite un appel au service Microsoft Graph pour récupérer les événements de calendrier de l’utilisateur connecté (**getEvents**) et les afficher. L’utilisateur sélectionne ensuite une réunion et l’objet d’événement de calendrier est transmis à **AttendeeListController**.

*AttendeeListController* : ce contrôleur affiche la liste des participants à la réunion, ainsi que leurs photos de profil. Dans l’appel à Microsoft Graph (**getEventAttendees**), un objet de participant est créé/initialisé avec le nom du participant, puis transmis à **ProfileController** lorsque l’utilisateur les sélectionne. En outre, une classe d’assistance **ProfilePictureHelper** appelle **getPhotoForAttendee:(Attendee *) withcompletion:** pour récupérer les photos de profil de tous les participants à la réunion.
  
*ProfileController* : enfin, deux méthodes Microsoft Graph supplémentaires (**getUserManager, getUserDirects**) sont appelées pour récupérer le responsable, la fonction, les collaborateurs directs et les photos de profil associées du participant sélectionné.


##Problèmes connus
Une fois encore, ce projet est en cours de réalisation et, pour le moment, le jeton d’accès transmis entre le téléphone et l’application de surveillance n’est pas actualisé à expiration. Pour l’instant, une fois qu’il arrive à expiration, vous devez vous reconnecter. Sur le simulateur, vous pouvez simplement redéployer l’application, mais si vous déployez vers une application de surveillance, l’application se bloque après son expiration. Vous pouvez soit redéployer vers le périphérique, soit arrêter l’application en arrière-plan et relancer (ouvrez l’application, appuyez sur bouton latéral jusqu'à ce que le menu d’alimentation s’affiche, maintenez enfoncé le bouton latéral jusqu'à ce que ce menu disparaisse, redémarrez l’application).

## Questions et commentaires

Nous serions ravis de connaître votre opinion sur l’application **Qui êtes-vous ?**. Vous pouvez nous faire part de vos questions et suggestions dans la rubrique [Problèmes](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/issues) de ce référentiel.

Les questions générales sur le développement de Microsoft Graph doivent être publiées sur [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API). Veillez à poser vos questions ou à rédiger vos commentaires avec les tags [MicrosoftGraph] et [Office 365].

## Contribution
Vous devrez signer un [Contrat de licence de contributeur](https://cla.microsoft.com/) avant d’envoyer votre requête de tirage. Pour compléter le contrat de licence de contributeur (CLA), vous devez envoyer une requête en remplissant le formulaire, puis signer électroniquement le CLA quand vous recevrez le courrier électronique contenant le lien vers le document.

Ce projet a adopté le [code de conduite Microsoft Open Source](https://opensource.microsoft.com/codeofconduct/). Pour plus d’informations, reportez-vous à la [FAQ relative au code de conduite](https://opensource.microsoft.com/codeofconduct/faq/) ou contactez [opencode@microsoft.com](mailto:opencode@microsoft.com) pour toute question ou tout commentaire.

## Ressources supplémentaires

* [Page de présentation de Microsoft Graph](https://graph.microsoft.io)
* [Utilisation de CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## Copyright
Copyright (c) 2016 Microsoft. Tous droits réservés.
