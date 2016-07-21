# Who are you? - Microsoft Graph and Apple Watch Sample

**Who are you?** is a watch sample that lets you find out more about a colleague in a meeting. It's meant to be a fun take on how you can intersect a wearable like an Apple Watch with Microsoft Graph, a unified endpoint for accessing data, relationships and insights that come from the Microsoft Cloud.

The scenario revolves around on how we all sometimes get into a meeting where we don't know who somebody is, and we'd like to get a little more intel on them in a discreet manner. From the Apple Watch you can pull up the list of meeting attendees and view profile information such as their job title, manager, direct reports, and all associated profile pictures.

![Watch](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/WatchScene.jpg)


> Note: This sample is just an idea, and meant solely to open up the possibilities for integrating Microsoft Graph into a number of different scenarios. As always, when constructing your own app in your organization, you should ensure your own guidelines around security (authentication and app permissions) and app design are implemented. Also, please refer to Apple's [watchOS Human interface Guidelines](https://developer.apple.com/watch/human-interface-guidelines/).

Finally, this a work in progress and we'd love it if you could contribute to, and improve upon it, as needed. **Who Are You?** is a WatchOS 2.2 sample that uses the Active Directory Authentication Library for iOS for auth, and the Microsoft Graph endpoint for gathering user profile specifics. 

## Prerequisites
* [Xcode](https://developer.apple.com/xcode/downloads/) from Apple (tested on version 7.3.1 with support for WatchOS 2.2.
* Installation of [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)  as a dependency manager.
* A Microsoft work account such as Office 365.  You can sign up for [an Office 365 Developer subscription](https://aka.ms/devprogramsignup) that includes the resources that you need to start building Office 365 apps.

     > Note: This sample relies on having a licensed organizational account with limited profile information filled out such as an employee's job title and profile picture. If this information is not populated it won't show up in the app.    
* A Microsoft Azure tenant to register your application. Azure Active Directory provides identity services that applications use for authentication and authorization. A trial subscription can be acquired here: [Microsoft Azure](https://account.windowsazure.com/SignUp).

**Important**: You will also need to ensure your Azure subscription is bound to your Office 365 tenant. To do this, see the Adding a new directory section in the Active Directory team's blog post, [Creating and Managing Multiple Windows Azure Active Directories](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx). You can also read [Set up Azure Active Directory access for your Developer Site](http://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription) for more information.


## Register your app with Microsoft Azure
1.	Sign in to the [Azure Management Portal](https://manage.windowsazure.com), using your Azure AD credentials.
2.	Choose **All Items** on the left menu, then select the directory for your Office 365 developer site.
3.	On the top menu, select **Applications**.
4.	Select **Add** from the bottom menu.
5.	On the **What do you want to do** page, select **Add an application my organization is developing**.
6.	On the **Tell us about your application** page, specify **iOS-Watch** for the application name and select **NATIVE CLIENT APPLICATION** for type.
7.	Select the arrow icon on the lower-right corner of the page.
8.	On the **Application information** page, specify a Redirect URI, for this example, you can specify http://localhost, and then select the check box in the lower-right hand corner of the page. Remember this value for the section **Running this sample in Xcode**.
9.	Once the application has been successfully added, you will be taken to the quick start page for the application. Select Configure in the top menu.
10.	Under **permissions to other applications**, select **Microsoft Graph** and add the following permissions: **Sign in and read user profile**, **Read all users' full profiles**, and **Read user calendars**.
11.	Copy the values for **Client ID** an **Redirect URIS** on the **Configure** page. Remember this value for the section **Running this sample in Xcode**.
12.	Select **Save** in the bottom menu.

## Running this sample in Xcode

1. Clone this repository.
2. Use CocoaPods to import the ADAL authentication dependency. This sample app already contains a podfile that will get the pods into the project. Simply navigate to the project from **Terminal** and run:

        pod install

  	 For more information, see **Using CocoaPods** in [Additional Resources](#AdditionalResources)

3. Open **iOS-ObjectiveC-MicrosoftGraph-WatchSample.xcworkspace**
4. Open **ViewController.m**. You'll see that the **ClientID** and **Redirect URI** from the registration process can be added to the top of the file:

    	// You will set your application's clientId and redirect URI.
		NSString * const kRedirectUri = @"ENTER_REDIRECT_URI_HERE";
		NSString * const kClientId    = @"ENTER_CLIENT_ID_HERE";
		NSString * const kAuthority   = @"https://login.microsoftonline.com/common";
		NSString * const kResourceId  = @"https://graph.microsoft.com";

5. Run the sample and ensure the target is set to the WatchKit App iPhone/Apple Watch scheme.
![Target](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/target.jpg)
6. You'll be asked to connect/authenticate to a work mail account.
![Authentication](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/Authentication.jpg)
6. Once authenticated the phone will immediately try to retrieve recent events from the logged in user's calendar. You will see a **Retrieving...** indicator from the watch appear. From there you can drill down into the attendees list, find somebody of interest, and view profile specifics: job title, manager, direct reports, and profile pictures.

	> Note: Again, you need to have a meeting created in your Office 365 tenant, licensed attendees added, and some of their profile specifcs entered for the app to return anything. Ensure that one is created with their display name and job title in Office 365 admin console. Direct reports and manager can be assigned in the Exchange admin center (recipients/mailboxes) in Office 365. Also, see the issue regarding the access token below in the **Known issues** section.

##Code of interest

**Phone**

*ViewController*- On the phone side this is where the where WCSession is configured and activated to establish connectivity between the phone and the watch. From here a call is made into the **AuthenticationManager** for an access token (ADAL for iOS), and it is sent to the watch via the **sendMessage:replyHandler:errorHandler:** method. 

**Watch**

*InterfaceController* - In this controller, **session:didReceiveMessageData:replyHandler:** is implemented to receive the access token from the phone, from there it is stored in the **Network\NetworkManager.m** This controller will then make a call out to the Microsoft Graph service to retrieve the logged in user's calendar events (**getEvents**) and display them. User then selects a meeting and the calendar event object is passed to the **AttendeeListController**.

*AttendeeListController* - This controller displays the list of meeting attendees along with their profile pictures. In the call to Microsoft Graph (**getEventAttendees**), an Attendee object is created/initialized with the attendee name, and then passed over to the **ProfileController** when the user selects them. Also, a helper class **ProfilePictureHelper** calls **getPhotoForAttendee:(Attendee *) withcompletion:** to retrieve all meeting participants' profile pictures.
  
*ProfileController* - Finally two additional Microsoft Graph methods (**getUserManager, getUserDirects**) are called to retrieve the selected attendee's manager, job title, direct reports and associated profile pictures.


##Known issues
Again this project is a work in progress, and at this time the access token passed between the phone and the watch is not being refreshed at expiration. For now, once it expires, you'll have to log-in again. On the simulator you can simply redeploy the app, but if deploying to a watch, the app will hang after it expires. You can either redeploy to the device, or shut down the app in the background and relaunch (open app, press side button until the power menu appears, hold down the side button again until that menu disappears, restart app).

## Questions and comments

We'd love to get your feedback about the **Who are you** app. You can send your questions and suggestions to us in the [Issues]() section of this repository.

Questions about Microsoft Graph development in general should be posted to [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API). Make sure that your questions or comments are tagged with [Office365] and [MicrosoftGraph].

## Contributing
You will need to sign a [Contributor License Agreement](https://cla.microsoft.com/) before submitting your pull request. To complete the Contributor License Agreement (CLA), you will need to submit a request via the form and then electronically sign the CLA when you receive the email containing the link to the document.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Additional resources

* [Microsoft Graph overview page](https://graph.microsoft.io)
* [Using CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## Copyright
Copyright (c) 2016 Microsoft. All rights reserved.

