# ¿Quién es usted? - Ejemplo de Microsoft Graph y de Apple Watch

**¿Quién es usted?** es un ejemplo de reloj que le permite obtener más información acerca de un compañero en una reunión. Está diseñado para indicar de forma divertida cómo puede interactuar un dispositivo portátil como un Apple Watch con Microsoft Graph, un punto de conexión unificado para acceder a los datos, las relaciones y los datos que proceden de Microsoft Cloud.

El escenario gira alrededor de cómo podemos acceder a una reunión donde no conocemos a alguien y nos gustaría obtener más información acerca de esa persona de manera discreta. Desde el Apple Watch pueden extraer la lista de asistentes a una reunión y ver la información de perfil, como su cargo, administrador, subordinados directos y todas las imágenes de perfil asociadas.

![Reloj](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/WatchScene.jpg)


> Nota: Este ejemplo es simplemente una idea y se ha diseñado exclusivamente para ampliar las posibilidades de integración de Microsoft Graph en una serie de escenarios diferentes. Como siempre, al construir su propia aplicación en su organización, debe asegurarse de que se implementan sus propias directrices de seguridad (autenticación y permisos de la aplicación) y el diseño de la aplicación. Además, consulte las [directrices de la interfaz humana de watchOS](https://developer.apple.com/watch/human-interface-guidelines/) de Apple.

Por último, este es un trabajo en curso y nos encantaría que pudiese colaborar y ayudar a mejorarlo según sea necesario. **¿Quién es usted?** es un ejemplo de WatchOS 2.2 que usa la biblioteca de autenticación de Active Directory para iOS para la autenticación y el punto de conexión de Microsoft Graph para recopilar detalles del perfil de usuario. 

## Requisitos previos
* [Xcode](https://developer.apple.com/xcode/downloads/) de Apple (probado en la versión 7.3.1 con compatibilidad para WatchOS 2.2.
* Instalación de [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) como administrador de dependencias.
* Una cuenta profesional de Microsoft como Office 365 que admite Microsoft Exchange.  Puede registrarse para [una suscripción de prueba a Office 365 Enterprise](https://products.office.com/en-us/business/office-365-enterprise-e5-business-software), que incluye los recursos que necesita para comenzar a crear aplicaciones de Office 365. También incluye 25 licencias para aplicar a los usuarios.

     > Nota: Este ejemplo se basa en tener cuentas de organización con licencia con información limitada sobre el perfil completada, como el cargo del empleado, el nombre para mostrar, el administrador, los subordinados directos y la imagen del perfil. Si no se rellena esta información no aparecerá en la aplicación.    
* Un inquilino de Microsoft Azure para registrar la aplicación. Azure Active Directory proporciona servicios de identidad que las aplicaciones usan para autenticación y autorización. Puede adquirir una suscripción de prueba aquí: [Microsoft Azure](https://account.windowsazure.com/SignUp).

**Importante**: También necesitará asegurarse de que su suscripción a Azure esté enlazada a su inquilino de Office 365. Para ello, consulte la sección Agregar un nuevo directorio en la publicación del blog del equipo de Active Directory [Crear y administrar varios directorios de Windows Azure Active](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx). También puede leer [Configurar el acceso a Azure Active Directory para su sitio para desarrolladores](http://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription) para obtener más información.


## Registre su aplicación con Microsoft Azure
1.  Inicie sesión en el [Portal de administración de Azure](https://manage.windowsazure.com) usando las credenciales de Azure AD.
2.  Seleccione **Todos los elementos** en el menú de la izquierda y, después, seleccione el directorio para el sitio para desarrolladores de Office 365.
3.  En el menú superior, seleccione **Aplicaciones**.
4.  Seleccione **Agregar** desde el menú inferior.
5.  En la página **Qué desea hacer**, seleccione **Agregar una aplicación que mi organización está desarrollando**.
6.  En la página **Háblenos acerca de su aplicación**, especifique **iOS-Watch** para el nombre de la aplicación y seleccione **APLICACIÓN DE CLIENTE NATIVO** para el tipo.
7.  Seleccione el icono de flecha en la esquina inferior derecha de la página.
8.  En la página **Información de la aplicación**, especifique el **URI de redirección**. Para este ejemplo, puede especificar **https://localhost**, y, después, seleccionar el **icono de marca de verificación** en la esquina inferior derecha de la página. Recuerde este valor para la sección **Ejecutar este ejemplo en Xcode**.
9.  Una vez que la aplicación se ha agregado correctamente, se le dirigirá a la página Inicio rápido de la aplicación. Seleccione **Configurar** en el menú superior.
10. Desplácese a la sección titulada **Permisos para otras aplicaciones**.
11. Haga clic en **Agregar aplicación**.
12. Haga clic en **Microsoft Graph**. 
13. Haga clic en **el icono de marca de verificación** en la parte inferior de la página.
14. Desde **Permisos delegados**, seleccione **Iniciar sesión y leer el perfil del usuario**, **Leer los perfiles completos de todos los usuarios** y **Leer calendarios del usuario**.
15. Haga clic en el botón **Guardar** en la parte inferior de la página.
16. Copie los valores de **ID de cliente** y **URI de redirección** en la página **Configurar**. Recuerde estos valores para la sección **Ejecutar este ejemplo en Xcode**.

## Ejecutar este ejemplo en Xcode

1. Clone este repositorio.
2. Use CocoaPods para importar la dependencia de autenticación ADAL. Esta aplicación de ejemplo ya contiene un podfile que recibirá los pods en el proyecto. Simplemente vaya al proyecto desde **Terminal** y ejecute:

        pod install

     Para obtener más información, consulte **Usar CocoaPods** en [Recursos adicionales](#recursos-adicionales)

3. Abra **iOS-ObjectiveC-MicrosoftGraph-WatchSample.xcworkspace**
4. Abra **ViewController.m**. Verá que el **ID de cliente** y **URI de redirección** del proceso de registro se pueden añadir a la parte superior del archivo:

        // You will set your application's clientId and redirect URI.
        NSString * const kRedirectUri = @"ENTER_REDIRECT_URI_HERE";
        NSString * const kClientId    = @"ENTER_CLIENT_ID_HERE";
        NSString * const kAuthority   = @"https://login.microsoftonline.com/common";
        NSString * const kResourceId  = @"https://graph.microsoft.com";

5. Ejecute el ejemplo y compruebe de que el destino se establece en el esquema de WatchKit App iPhone/Apple Watch.
![Destino](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/target.jpg)
6. Asegúrese de que la aplicación de iOS y los simuladores de la aplicación son visibles. En la aplicación de teléfono, haga clic en *Conectar* y deberá autenticar una cuenta de correo profesional. Proporcione sus credenciales.
![Autenticación](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/Authentication.jpg)
6. Una vez autenticado, la aplicación del reloj intentará recuperar inmediatamente los eventos recientes del calendario del usuario registrado. Verá un indicador **Recuperando...** en el reloj. Desde allí puede profundizar en la lista de asistentes, encontrar a alguien de interés y ver detalles del perfil: título, administrador, informes directos y las imágenes de perfil.

    > Nota: De nuevo, debe tener una reunión creada en los inquilinos de Office 365, con los asistentes con licencia agregados y algunos de sus datos de perfil especificados para que la aplicación devuelva algo. Asegúrese de crear una con su nombre para mostrar y el cargo en la consola de administración de Office 365. Se pueden asignar los subordinados directos y el administrador en el centro de administración de Exchange (destinatarios o buzones) en Office 365. Consulte también el problema relacionado con el token de acceso en la sección **Problemas conocidos**.

##Código de interés

**Teléfono**

*ViewController*: en el lateral del teléfono es donde está configurado y activado WCSession para establecer la conectividad entre el teléfono y el reloj. Desde aquí se realiza una llamada en **AuthenticationManager** para conseguir un token de acceso (ADAL para iOS) y se envía al reloj a través del método **sendMessage:replyHandler:errorHandler:**. 

**Reloj**

*InterfaceController*: en este controlador, se implementa **session: didReceiveMessageData:replyHandler:** para recibir el token de acceso desde el teléfono, desde allí se almacena en **Network\NetworkManager.m** Después, este controlador realiza una llamada al servicio Microsoft Graph para recuperar los eventos del calendario del usuario con la sesión iniciada (**getEvents**) y mostrarlos. Después, el usuario selecciona una reunión y el objeto del evento del calendario se pasa a **AttendeeListController**.

*AttendeeListController*: este controlador muestra la lista de los asistentes a la reunión junto con sus imágenes de perfil. En la llamada a Microsoft Graph (**getEventAttendees**), se crea y se inicializa un objeto Attendee con el nombre del asistente y, después, se pasa a **ProfileController** cuando el usuario lo selecciona. Además, una clase auxiliar **ProfilePictureHelper** llama a **getPhotoForAttendee:(Attendee *) withcompletion:** para recuperar las imágenes de perfil de todos los participantes de la reunión.
  
*ProfileController*: finalmente se solicitan dos métodos adicionales de Microsoft Graph (**getUserManager, getUserDirects**) para recuperar el administrador, el cargo, los subordinados directos y las imágenes de perfil asociadas del asistente seleccionado.


##Problemas conocidos
Este proyecto vuelve a ser un trabajo en curso y en este momento el token de acceso que pasa entre el teléfono y el reloj no se actualiza una vez caducado. De ahora en adelante, en cuanto caduque tendrá que iniciar sesión otra vez. En el simulador, simplemente puede volver a implementar la aplicación, pero si la implementa en un reloj, la aplicación se bloqueará después de que caduque. También puede volver a implementarla en el dispositivo, o apagar la aplicación en segundo plano y volver a iniciarla (abra la aplicación, pulse el botón lateral hasta que aparezca el menú de energía, mantenga presionado el botón lateral de nuevo hasta que desaparezca ese menú y reinicie la aplicación).

## Preguntas y comentarios

Nos encantaría recibir sus comentarios acerca de la aplicación **Quién es usted**. Puede enviarnos sus preguntas y sugerencias a través de la sección [Problemas](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/issues) de este repositorio.

Las preguntas generales sobre el desarrollo de Microsoft Graph deben publicarse en [Desbordamiento de pila](http://stackoverflow.com/questions/tagged/Office365+API). Asegúrese de que sus preguntas o comentarios se etiquetan con [Office365] y [MicrosoftGraph].

## Colaboradores
Deberá firmar un [Contrato de licencia de colaborador](https://cla.microsoft.com/) antes de enviar la solicitud de incorporación de cambios. Para completar el Contrato de licencia de colaborador (CLA), deberá enviar una solicitud mediante el formulario y, después, firmar electrónicamente el CLA cuando reciba el correo electrónico que contiene el vínculo al documento.

Este proyecto ha adoptado el [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/) (Código de conducta de código abierto de Microsoft). Para obtener más información, consulte las [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) (Preguntas más frecuentes del código de conducta) o póngase en contacto con [opencode@microsoft.com](mailto:opencode@microsoft.com) con otras preguntas o comentarios.

## Recursos adicionales

* [Página de información general de Microsoft Graph](https://graph.microsoft.io)
* [Usar CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## Copyright
Copyright (c) 2016 Microsoft. Todos los derechos reservados.
