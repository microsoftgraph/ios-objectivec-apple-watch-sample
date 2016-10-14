# <a name="who-are-you?---microsoft-graph-and-apple-watch-sample"></a>您是誰？- Microsoft Graph 和 Apple Watch 範例

**您是誰？**是可讓您了解更多關於會議的同事的手錶範例。它是您可以與穿戴式裝置 (例如具有 Microsoft Graph 的 Apple Watch) 交流的一種樂趣、存取資料的統一端點、來自 Microsoft 雲端的關係和見解。

圍繞在我們如何進入不認識與會人員的會議的案例，我們希望以慎重的方式取得有關他們的情報。您可以從 Apple Watch 提取會議出席者的清單，以及檢視設定檔資訊，例如他們的職稱、經理、直屬員工和所有相關的設定檔圖片。

![Watch](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/WatchScene.jpg)


> 附註：這個範例只是構想，且只是要開啟將 Microsoft Graph 整合至數個不同案例的可能性。如往常一般，在您的組織建構您自己的應用程式時，您應該確定您自己關於安全性的指導方針 (驗證和應用程式權限)，並實作應用程式設計。此外，請參閱 Apple 的 [watchOS 人類介面指導方針](https://developer.apple.com/watch/human-interface-guidelines/)。

最後，這是進行中的工作，我們希望您能夠做出貢獻，視需要改善它。**您是誰？**是 WatchOS 2.2 範例，使用 Active Directory Authentication Library for iOS 以進行驗證，使用 Microsoft Graph 端點以收集使用者設定檔詳細資料。 

## <a name="prerequisites"></a>必要條件
* 來自 Apple 的 [Xcode](https://developer.apple.com/xcode/downloads/) (在版本 7.3.1 測試，並且支援 WatchOS 2.2。
* 安裝 [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) 做為相依性管理員。
* Microsoft 工作帳戶，例如支援 Microsoft Exchange 的 Office 365。您可以註冊 [Office 365 企業試用訂用帳戶](https://products.office.com/en-us/business/office-365-enterprise-e5-business-software)，其中包含開始建置 Office 365 應用程式所需的資源。這也包括套用到使用者的 25 個授權。

     > 附註：這個範例依賴擁有授權的組織帳戶，已填寫有限的設定檔資訊，例如員工的職稱、顯示名稱、經理、直屬員工，以及設定檔圖片。如果這項資訊未填入，它不會在應用程式中顯示。    
* 用來註冊您的應用程式的 Microsoft Azure 租用戶。Azure Active Directory 會提供識別服務，以便應用程式用於驗證和授權。在這裡可以取得試用版的訂用帳戶：[Microsoft Azure](https://account.windowsazure.com/SignUp).

**重要事項**：您還需要確定您的 Azure 訂用帳戶已繫結至您的 Office 365 租用戶。若要執行這項操作，請參閱 Active Directory 小組的部落格文章中新增的新目錄區段：[建立和管理多個 Windows Azure Active Directory](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx)。您也可以參閱[為您的開發人員網站設定 Azure Active Directory 存取權](http://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription)以取得詳細資訊。

## <a name="register-your-app-with-microsoft-azure"></a>向 Microsoft Azure 註冊您的應用程式
1. 登入 [Azure 入口網站](https://portal.azure.com/)。
2. 在上方列中，按一下您的帳戶，然後在 [目錄]**** 清單中選擇想要註冊您的應用程式所在的 Active Directory 租用戶。
3. 按一下左側導覽列中的 [更多服務]****，然後選擇 [Azure Active Directory]****。
4. 按一下 [應用程式註冊]****，然後選擇 [新增]****。
5. 輸入應用程式的好記名稱，例如**監看專案**，選取 [原生]**** 做為應用程式類型。對於**重新導向 URI**，輸入 **https://localhost**。按一下 [建立]**** 以建立應用程式。
6. 仍在 Azure 入口網站時，請選擇您的應用程式，按一下 [設定]****，然後選擇 [內容]****。
7. 尋找**應用程式識別碼**值，並將它複製到剪貼簿。這是我們稍後會新增至專案的用戶端識別碼值。
8. 設定您的應用程式的**權限** - 在 [設定]**** 功能表中，選擇 [必要的權限]**** 區段，按一下 [新增]****，然後 [選取 API]****，並在文字方塊中輸入 "Microsoft Graph"。然後按一下 [選取權限]****，並選取：
   * 讀取所有使用者的完整設定檔
   * 登入並讀取使用者設定檔
   * 讀取使用者連絡人

9. 按一下 [選取]****。


## <a name="running-this-sample-in-xcode"></a>在 Xcode 中執行這個範例

1. 複製此儲存機制。
2. 使用 CocoaPods 來匯入 ADAL 驗證相依性。此範例應用程式已經包含可將 pods 放入專案的 podfile。只需從 **Terminal** 瀏覽至專案並執行：

        pod install

     如需詳細資訊，請參閱[其他資訊](#AdditionalResources)中的**使用 CocoaPods**

3. 開啟 **iOS-ObjectiveC-MicrosoftGraph-WatchSample.xcworkspace**
4. 開啟 **ViewController.m**。您會發現註冊程序的 **ClientID** (您從必要條件區段中收到的應用程式識別碼) 和**重新導向 URI** 可以新增至檔案頂端：

        // You will set your application's clientId and redirect URI.
        NSString * const kRedirectUri = @"ENTER_REDIRECT_URI_HERE";
        NSString * const kClientId    = @"ENTER_CLIENT_ID_HERE";
        NSString * const kAuthority   = @"https://login.microsoftonline.com/common";
        NSString * const kResourceId  = @"https://graph.microsoft.com";

5. 執行此範例，並確定目標設為 WatchKit 應用程式 iPhone/Apple Watch 配置。![目標](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/target.jpg)
6. 請確定您看到 iOS 應用程式和手錶應用程式模擬器。在手機應用程式上，按一下 [連接]**，系統會要求您驗證工作郵件帳戶。提供您的認證。![驗證](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/Authentication.jpg)
6. 驗證之後，手錶應用程式會立即嘗試從登入使用者的行事曆擷取最近的事件。您會在手錶上看到 [正在擷取...]**** 指標顯示。您可以從那裡向下鑽研至出席者清單、尋找感興趣的人員，並且檢視設定檔詳細資料：職稱、經理、直屬員工和設定檔圖片。

    > 附註：同樣地，您必須在您的 Office 365 租用戶中建立會議、授權新增的出席者，其中某些出席者的設定檔詳細資料已針對應用程式輸入以傳回任何項目。請確定其中一個會在 Office 365 管理主控台中建立，具有其顯示名稱和職稱。直屬員工和經理可以在 Office 365 中的 Exchange 系統管理員中心 (收件者/信箱) 中指派。另請參閱**已知問題**區段中，存取底下權杖的相關問題。

##<a name="code-of-interest"></a>感興趣的程式碼

**電話**

*ViewController* - 在電話端這是設定 WCSession 在哪裡的位置，並且啟動以建立電話與手錶之間的連線。從這裡針對存取權杖 (ADAL for iOS)，對 **AuthenticationManager** 進行呼叫，它會透過 **sendMessage:replyHandler:errorHandler:** 方法傳送至手錶。 

**手錶**

*InterfaceController* - 在這個控制站，**session:didReceiveMessageData:replyHandler:** 會實作以接收來自電話的存取權杖，並將它儲存在 **Network\NetworkManager.m**。這個控制站接著便可呼叫 Microsoft Graph 服務來擷取已登入使用者的行事曆事件 (**getEvents**) 並將它們顯示。然後使用者選取會議，行事曆事件物件就會傳送至 **AttendeeListController**。

*AttendeeListController* - 這個控制站會顯示會議出席者清單，以及其設定檔圖片。在對 Microsoft Graph 的呼叫中 (**getEventAttendees**)，出席者物件是以出席者名稱建立/初始化，然後在使用者選取它們時傳遞至 **ProfileController**。此外，協助程式類別 **ProfilePictureHelper** 會呼叫 **getPhotoForAttendee:(Attendee *) withcompletion:** 以擷取所有會議參與者的設定檔圖片。
  
*ProfileController* - 最後兩個其他的 Microsoft Graph 方法 (**getUserManager、getUserDirects**) 會呼叫以擷取選取的出席者的經理、職稱、直屬員工和相關聯的設定檔圖片。


##<a name="known-issues"></a>已知問題
再次聲明，此專案正在進行中，目前電話和手錶之間傳遞的存取權杖不會在到期時重新整理。現在，一旦到期，您必須再次登入。在模擬器上您可以只重新部署應用程式，但是如果部署至手錶，在它到期後，應用程式會停止回應。您可以重新部署至裝置，或在背景中關閉應用程式並重新啟動 (開啟應用程式，按側邊按鈕，直到出現 [電源] 功能表，再次按住側邊按鈕直到該功能表消失，重新啟動應用程式)。

## <a name="questions-and-comments"></a>問題和建議

我們很樂於收到您對於**您是誰？**應用程式的意見反應。您可以在此儲存機制的[問題](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/issues)區段中，將您的問題及建議傳送給我們。

請在 [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API) 提出有關 Microsoft Graph 開發的一般問題。務必以 [Office365] 和 [MicrosoftGraph] 標記您的問題或意見。

## <a name="contributing"></a>參與
您必須在提交您的提取要求之前，先簽署[投稿者授權合約](https://cla.microsoft.com/)。若要完成投稿者授權合約 (CLA)，您必須透過表單提交要求，然後在您收到含有文件連結的電子郵件時以電子方式簽署 CLA。

此專案已採用 [Microsoft 開放原始碼執行](https://opensource.microsoft.com/codeofconduct/)。如需詳細資訊，請參閱[程式碼執行常見問題集](https://opensource.microsoft.com/codeofconduct/faq/)，如果有其他問題或意見，請連絡 [opencode@microsoft.com](mailto:opencode@microsoft.com)。

## <a name="additional-resources"></a>其他資源

* [Microsoft Graph 概觀頁面](https://graph.microsoft.io)
* [使用 CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## <a name="copyright"></a>著作權
Copyright (c) 2016 Microsoft.著作權所有，並保留一切權利。

