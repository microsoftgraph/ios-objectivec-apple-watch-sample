# <a name="who-are-you?---microsoft-graph-and-apple-watch-sample"></a>Wer sind Sie? - Beispiel für Microsoft Graph und Apple Watch

**Wer sind Sie?** ist ein Beispiel, mit dem Sie mehr über einen Kollegen in einer Besprechung herausfinden können. Es soll als witziger Ansatz dafür dienen, wie Sie ein Wearable wie eine Apple Watch mit Microsoft Graph, einem einheitlichen Endpunkt für den Zugriff auf Daten, Beziehungen und Erkenntnisse, die von der Microsoft-Cloud stammen, kombinieren können.

In dem Szenario geht es darum, wie wir in einer Besprechung, in der wir nichts über eine bestimmte Person wissen, auf diskrete Weise etwas mehr über diese Person erfahren können. Auf der Apple Watch können Sie die Liste der Besprechungsteilnehmer abrufen und Profilinformationen anzeigen, z. B. Position, Vorgesetzter, direkte Mitarbeiter sowie alle zugehörigen Profilbilder.

![Uhr](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/WatchScene.jpg)


> Hinweis: Dieses Beispiel ist nur eine Idee und soll nur die Möglichkeiten für die Integration von Microsoft Graph in eine Vielzahl verschiedener Szenarien aufzeigen. Wenn Sie Ihre eigene App in Ihrer Organisation entwickeln, sollten Sie wie immer sicherstellen, dass Ihre eigenen Richtlinien im Zusammenhang mit Sicherheit (Authentifizierung und App-Berechtigungen) und App-Design implementiert werden. Lesen Sie bitte auch die [watchOS Human Interface Guidelines](https://developer.apple.com/watch/human-interface-guidelines/) von Apple.

Dieses Beispiel befindet sich noch in Bearbeitung und wir würden uns über Ihre Mitwirkung freuen, um es bei Bedarf zu verbessern. **Wer sind Sie?** ist ein WatchOS 2.2-Beispiel, das die Active Directory-Authentifizierungsbibliothek für iOS für die Authentifizierung und Microsoft Graph-Endpunkt für das Erfassen von Benutzerprofilinformationen verwendet. 

## <a name="prerequisites"></a>Anforderungen
* [Xcode](https://developer.apple.com/xcode/downloads/) von Apple (getestet auf Version 7.3.1 mit Unterstützung für WatchOS 2.2).
* Installation von [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) als ein Abhängigkeits-Manager.
* Ein Microsoft-Geschäftskonto, z. B. Office 365, das Microsoft Exchange unterstützt.  Sie können sich für ein [Testabonnement für Office 365 Enterprise](https://products.office.com/en-us/business/office-365-enterprise-e5-business-software) registrieren. Dieses umfasst die Ressourcen, die Sie zum Erstellen von Office 365-Apps benötigen. Es umfasst auch 25 Lizenzen für Benutzer.

     > Hinweis: Dieses Beispiel erfordert lizenzierte Organisationskonten mit beschränkten Profilinformationen, z. B. die Position eines Mitarbeiters, der Anzeigename, der Vorgesetzte, direkte Mitarbeiter und Profilbild. Wenn diese Informationen nicht ausgefüllt sind, werden sie nicht in der App angezeigt.    
* Ein Microsoft Azure-Mandant zum Registrieren Ihrer Anwendung. Von Azure Active Directory werden Identitätsdienste bereitgestellt, die durch Anwendungen für die Authentifizierung und Autorisierung verwendet werden. Hier kann ein Testabonnement erworben werden: [Microsoft Azure](https://account.windowsazure.com/SignUp).

**Wichtig**: Sie müssen zudem sicherstellen, dass Ihr Azure-Abonnement an Ihren Office 365-Mandanten gebunden ist. Rufen Sie dafür den Abschnitt „Adding a new directory section“ im Blogpost [Creating and Managing Multiple Windows Azure Active Directories](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx) des Active Directory-Teams auf. Weitere Informationen finden Sie auch unter [Set up Azure Active Directory access for your Developer Site](http://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription) (Einrichten des Zugriffs auf Active Directory für Ihre Entwicklerwebsite, in englischer Sprache).

## <a name="register-your-app-with-microsoft-azure"></a>Registrieren der App bei Microsoft Azure
1. Melden Sie sich beim [Azure-Portal](https://portal.azure.com/) an.
2. Klicken Sie in der oberen Leiste auf Ihr Konto, und wählen Sie unter der Liste **Verzeichnis** den Active Directory-Mandanten aus, bei dem Sie Ihre Anwendung registrieren möchten.
3. Klicken Sie im linken Navigationsbereich auf **Weitere Dienste**, und wählen Sie **Azure Active Directory** aus.
4. Klicken Sie auf **App-Registrierungen**, und wählen Sie **Hinzufügen** aus.
5. Geben Sie einen Anzeigenamen für die Anwendung ein, z.B. **Überwachungsprojekt**, und wählen Sie **Systemeigen** als Anwendungstyp aus. Geben Sie für den **Umleitungs-URI** **https://localhost** ein. Klicken Sie auf **Erstellen**, um die Anwendung zu erstellen.
6. Während Sie sich noch im Azure-Portal befinden, wählen Sie die Anwendung aus, und klicken Sie auf **Einstellungen** und dann auf **Eigenschaften**.
7. Suchen Sie den Wert **Anwendungs-ID**, und kopieren Sie ihn in die Zwischenablage. Dies ist der Client-ID-Wert, den wir dem Projekt später hinzufügen werden.
8. Konfigurieren Sie die **Berechtigungen** für Ihre Anwendung. Wählen Sie dafür im Menü **Einstellungen** den Abschnitt **Erforderliche Berechtigungen** aus, klicken Sie auf **Hinzufügen** und dann auf **Eine API auswählen** aus, und geben Sie im Textfeld „Microsoft Graph“ ein. Klicken Sie auf **Berechtigungen auswählen**, und wählen Sie Folgendes aus:
   * Vollständige Profile aller Benutzer lesen
   * Anmelden und Benutzerprofil lesen
   * Benutzerkalender lesen

9. Klicken Sie auf **Auswählen**.


## <a name="running-this-sample-in-xcode"></a>Ausführen dieses Beispiels in Xcode

1. Klonen Sie dieses Repository.
2. Verwenden Sie CocoaPods, um die ADAL-Authentifizierungsabhängigkeit zu importieren. Diese Beispiel-App enthält bereits eine POD-Datei, die die Pods in das Projekt überträgt. Navigieren Sie einfach über das **Terminal** zum Projekt, und führen Sie Folgendes aus:

        pod install

     Weitere Informationen finden Sie im Thema über das **Verwenden von CocoaPods** in [Zusätzliche Ressourcen](#AdditionalResources).

3. Öffnen Sie **iOS-ObjectiveC-MicrosoftGraph-WatchSample.xcworkspace**.
4. Öffnen Sie **ViewController.m**. Sie werden sehen, dass die **ClientID** (die Anwendungs-ID, die Sie im Abschnitt mit den Voraussetzungen erhalten haben) und der **Umleitungs-URI** aus dem Registrierungsprozess am Anfang der Datei hinzugefügt werden kann:

        // You will set your application's clientId and redirect URI.
        NSString * const kRedirectUri = @"ENTER_REDIRECT_URI_HERE";
        NSString * const kClientId    = @"ENTER_CLIENT_ID_HERE";
        NSString * const kAuthority   = @"https://login.microsoftonline.com/common";
        NSString * const kResourceId  = @"https://graph.microsoft.com";

5. Führen Sie das Beispiel aus, und stellen Sie sicher, dass das Ziel auf das iPhone/Apple Watch-Schema der WatchKit-App festgelegt ist. 
![Ziel](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/target.jpg)
6. Stellen Sie sicher, dass die Simulatoren für die iOS-App und die Watch-App sichtbar sind. Klicken Sie auf der Telefon-App auf *Verbinden*; Sie werden daraufhin aufgefordert, ein geschäftliches E-Mail-Konto zu authentifizieren. Geben Sie Ihre Anmeldeinformationen ein. 
![Authentifizierung](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/Authentication.jpg)
6. Nach der Authentifizierung versucht die Watch-App sofort, kürzliche Ereignisse aus dem Kalender des angemeldeten Benutzers abzurufen. Die Anzeige **Wird abgerufen...** wird angezeigt. Von dort aus können Sie einen Drilldown zu der Teilnehmerliste ausführen, eine Person suchen und Profilinformationen anzeigen: Position, Vorgesetzter, direkte Mitarbeiter und Profilbilder.

    > Hinweis: Auch in diesem Fall müssen Sie eine Besprechung in Ihrem Office 365-Mandanten erstellt, lizenzierte Teilnehmer hinzugefügt und einige Profilinformationen eingegeben haben, damit die App Ergebnisse zurückgeben kann. Stellen Sie sicher, dass eine Besprechung mit dem Anzeigenamen und der Position in der Office 365-Verwaltungskonsole erstellt wurde. Direkte Mitarbeiter und Vorgesetzte können im Exchange Admin Center (Empfänger/Postfächer) in Office 365 zugewiesen werden. Sehen Sie sich auch das Problem im Zusammenhang mit dem Zugriffstoken weiter unten im Abschnitt **Bekannte Probleme** an.

##<a name="code-of-interest"></a>Interessanter Code

**Telefon**

*ViewController* – Auf Seite des Telefons ist dies der Ort, an dem WCSession konfiguriert und zum Herstellen der Verbindung zwischen Telefon und Uhr aktiviert wird. Von hier wird ein Aufruf von **AuthenticationManager** für Zugriffstoken (ADAL für iOS) ausgeführt, und dieser wird über die **sendMessage:replyHandler:errorHandler:**-Methode an die Uhr gesendet. 

**Uhr**

InterfaceController – In diesem Controller wird **session:didReceiveMessageData:replyHandler:** implementiert, um das Zugriffstoken von dem Telefon zu empfangen. Von dort wird es im Network\NetworkManager.m gespeichert. Dieser Controller führt dann einen Aufruf des Microsoft Graph-Diensts aus, um die Kalenderereignisse des angemeldeten Benutzers abzurufen (getEvents) und diese anzuzeigen. Der Benutzer wählt dann eine Besprechung aus, und das Kalenderereignisobjekt wird an den **AttendeeListController** übergeben.

*AttendeeListController* – Dieser Controller zeigt die Liste der Besprechungsteilnehmer zusammen mit ihren Profilbildern an. Im Aufruf von Microsoft Graph (**getEventAttendees**) wird ein Teilnehmerobjekt mit dem Teilnehmernamen erstellt/initialisiert und dann bei Auswahl des Benutzers über den **ProfileController** übergeben. Außerdem ruft eine Hilfsklasse **ProfilePictureHelper** **getPhotoForAttendee:(Attendee *) withcompletion:** auf, um die Profilbilder aller Besprechungsteilnehmer abzurufen.
  
*ProfileController* – Schließlich werden zwei weitere Microsoft Graph-Methoden (**getUserManager, getUserDirects**) aufgerufen, um den Vorgesetzten, die Position und die zugewiesenen Profilbilder des ausgewählten Teilnehmers abzurufen.


##<a name="known-issues"></a>Bekannte Probleme
Auch dieses Projekt befindet sich noch in Bearbeitung. Derzeit wird das Zugriffstoken, das zwischen dem Telefon und der Uhr übergeben wird, nach Ablauf nicht aktualisiert. Im Moment müssen Sie sich erneut anmelden, wenn das Token abgelaufen ist. Auf dem Simulator können Sie die App einfach erneut bereitstellen, bei einer Bereitstellung auf einer Uhr reagiert die App nicht mehr, nachdem sie abgelaufen ist. Sie können die App entweder auf dem Gerät erneut bereitstellen oder die App im Hintergrund herunterfahren und neu starten (öffnen Sie die App, drücken Sie die seitliche Taste, bis das Stromversorgungsmenü angezeigt wird, halten Sie die seitliche Taste erneut gedrückt, bis dieses Menü verschwindet, starten Sie die App neu).

## <a name="questions-and-comments"></a>Fragen und Kommentare

Wir schätzen Ihr Feedback hinsichtlich der **Wer sind Sie**-App. Sie können uns Ihre Fragen und Vorschläge über den Abschnitt [Probleme](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/issues) dieses Repositorys senden.

Allgemeine Fragen zur Microsoft Graph-Entwicklung sollten in [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API) gestellt werden. Stellen Sie sicher, dass Ihre Fragen oder Kommentare mit [Office365] und [MicrosoftGraph] markiert sind.

## <a name="contributing"></a>Mitwirkung
Vor dem Senden Ihrer Pull Request müssen Sie eine [Lizenzvereinbarung für Teilnehmer](https://cla.microsoft.com/) unterschreiben. Zum Vervollständigen der Lizenzvereinbarung für Teilnehmer (Contributor License Agreement, CLA) müssen Sie eine Anforderung über das Formular senden. Nachdem Sie die E-Mail mit dem Link zum Dokument empfangen haben, müssen Sie die CLA anschließend elektronisch signieren.

In diesem Projekt wurden die [Microsoft Open Source-Verhaltensregeln](https://opensource.microsoft.com/codeofconduct/) übernommen. Weitere Informationen finden Sie unter [Häufig gestellte Fragen zu Verhaltensregeln](https://opensource.microsoft.com/codeofconduct/faq/), oder richten Sie Ihre Fragen oder Kommentare an [opencode@microsoft.com](mailto:opencode@microsoft.com).

## <a name="additional-resources"></a>Zusätzliche Ressourcen

* [Microsoft Graph-Übersichtsseite](https://graph.microsoft.io)
* [Verwenden von CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## <a name="copyright"></a>Copyright
Copyright (c) 2016 Microsoft. Alle Rechte vorbehalten.

