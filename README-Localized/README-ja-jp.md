# 出席者情報 - Microsoft Graph と Apple Watch のサンプル

**出席者情報** は、会議に出席している同僚に関する詳細情報を確認できる Watch のサンプルです。 これは、Apple Watch などのウェアラブル デバイスを、Microsoft Cloud からのデータ、リレーションシップおよびインサイトにアクセスするための統合エンドポイントである Microsoft Graph と組み合わせる方法に楽しさをプラスするためのものです。

シナリオでは、出席者が誰だかわからない会議に参加できるようにする方法を中心に展開します。また出席者に関するもう少し詳細な情報を適切な方法で取得します。 Apple Watch から、会議の出席者の一覧を取得して、役職、上司、直属の部下およびすべての関連するプロフィール画像などのプロファイル情報を表示できます。

![ウォッチ](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/WatchScene.jpg)


> 注:このサンプルはアイデアの一例であり、Microsoft Graph を多種多様なシナリオに統合するための可能性を広げるためだけのものです。 従来どおり、組織内に独自のアプリを構築する場合は、必ずセキュリティ (認証とアプリのアクセス許可) とアプリの設計を中心とする独自のガイドラインを実装する必要があります。 また、Apple の「[watchOS Human interface Guidelines](https://developer.apple.com/watch/human-interface-guidelines/)」も参照してください。

最後に、この作業は現在進行中であり、投稿をお待ちしております。お客様の投稿に基づいて必要に応じて改良していきます。 **出席者情報**は、認証用の iOS 版 Active Directory 認証ライブラリと、ユーザー プロファイル特性の収集用の Microsoft Graph エンドポイントを使用する WatchOS 2.2 のサンプルです。 

## 前提条件
* WatchOS 2.2 がサポートされているバージョン 7.3.1 でテストされた Apple の [Xcode](https://developer.apple.com/xcode/downloads/)。
* 依存関係マネージャーとしての [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) のインストール。
* Microsoft Exchange をサポートする Office 365 などの Microsoft の職場アカウント。  Office 365 アプリのビルドを開始するために必要なリソースを含む、[Office 365 Enterprise 試用版サブスクリプション](https://products.office.com/en-us/business/office-365-enterprise-e5-business-software)にサインアップできます。 これには、ユーザーに適用される 25 のライセンスも含まれています。

     > 注:このサンプルでは、従業員の役職、表示名、上司、部下、およびプロフィール画像などが記入された制限付きのプロフィール情報を含むライセンスを受けた組織のアカウントを持っていることを必要としています。 この情報が設定されていない場合は、アプリに表示されません。    
* アプリケーションを登録する Microsoft Azure テナント。Azure Active Directory は、アプリケーションが認証と承認に使用する ID サービスを提供します。ここでは、試用版サブスクリプションを取得できます。[Microsoft Azure](https://account.windowsazure.com/SignUp)。

**重要**:Azure サブスクリプションが Office 365 テナントにバインドされていることを確認する必要もあります。 確認する方法については、Active Directory チームのブログ投稿の「[複数の Windows Azure Active Directory を作成して管理する](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx)」の「新しいディレクトリの追加」セクションをご覧ください。 また、詳細については、「[開発者向けサイトに Azure Active Directory へのアクセスを設定する](http://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription)」も参照してください。


## Microsoft Azure にアプリを登録する
1.  Azure AD 資格情報を使用して、[Azure 管理ポータル](https://manage.windowsazure.com)にサインインします。
2.  左側のメニューで **[すべてのアイテム]** を選択してから、Office 365 開発者向けサイトのディレクトリを選択します。
3.  上部のメニューで、**[アプリケーション]** を選択します。
4.  下部のメニューから、**[追加]** を選択します。
5.  **[何を行いますか]** ページで、**[所属組織が開発しているアプリケーションの追加]** を選択します。
6.  **[アプリケーションについてお聞かせください]** ページで、アプリケーション名に「**iOS-Watch**」と指定し、種類に **[ネイティブ クライアント アプリケーション]** を選択します。
7.  ページの右下隅にある矢印アイコンを選びます。
8.  **[アプリケーション情報]** ページで、**リダイレクト URI** を指定します。 この例では、**https://localhost** を指定し、ページの右下隅にある**チェック マーク アイコン**を選択します。 この値は「**Xcode でこのサンプルを実行する**」セクションで使用しますので、保存しておいてください。
9.  アプリケーションが正常に追加されたら、アプリケーションの [クイック スタート] ページに移動します。 上部のメニューにある **[構成]** を選びます。
10. **[他のアプリケーションへのアクセス許可]** というタイトルのセクションまでスクロールします。
11. **[アプリケーションの追加]** をクリックします。
12. **[Microsoft Graph]** をクリックします。 
13. ページの下部にある**チェック マーク アイコン**をクリックします。
14. **[委任されたアクセス許可]** から、**[サインインおよびユーザー プロファイルの読み取り]**、**[すべてのユーザーの完全なプロファイルの読み取り]**、**[ユーザーの予定表の読み取り]** を選択します。
15. ページの下部にある **[保存]** ボタンをクリックします。
16. **[構成]** ページで、**クライアント ID** と **リダイレクト URI** の各値をコピーします。 これらの値は「**Xcode でこのサンプルを実行する**」セクションで使用しますので、保存しておいてください。

## Xcode でこのサンプルを実行する

1. このリポジトリの複製を作成します。
2. CocoaPods を使用して、ADAL 認証の依存関係をインポートします。 このサンプル アプリには、プロジェクトに pod を取り込む podfile がすでに含まれています。 **ターミナル**からプロジェクトに移動して次を実行するだけです:

        pod install

     詳細については、[その他の技術情報](#その他の技術情報)の「**CocoaPods を使う**」を参照してください

3. **iOS-ObjectiveC-MicrosoftGraph-WatchSample.xcworkspace** を開きます
4. **ViewController.m** を開きます。 登録プロセスの **ClientID** と **リダイレクト URI** がファイルの一番上に追加されていることが分かります:

        // You will set your application's clientId and redirect URI.
        NSString * const kRedirectUri = @"ENTER_REDIRECT_URI_HERE";
        NSString * const kClientId    = @"ENTER_CLIENT_ID_HERE";
        NSString * const kAuthority   = @"https://login.microsoftonline.com/common";
        NSString * const kResourceId  = @"https://graph.microsoft.com";

5. サンプルを実行し、ターゲットが WatchKit App iPhone/Apple Watch スキームに設定されていることを確認します。
![ターゲット](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/target.jpg)
6. IOS アプリとウォッチ アプリの各シミュレーターが表示されていることを確認します。 Phone アプリで、*[接続]* をクリックすると、職場のメール アカウントへの認証を求められます。 資格情報を入力します。
![認証](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/Authentication.jpg)
6. 認証後、ウォッチ アプリは即座にログインしているユーザーの予定表から最新のイベントを取得しようとします。 **[取得しています...]** インジケーターがウォッチに表示されます。 そこから、出席者一覧を絞り込んで、対象者を検索し、プロファイルの特性 (役職、上司、直属の部下、およびプロファイル画像) を表示します。

    > 注:Office 365 テナントに会議を作成して、ライセンスを付与された出席者を追加し、アプリが任意の項目を返せるように出席者のプロファイル特性をいくつか入力する必要があることに、再度ご注意ください。 必ず、Office 365 管理者コンソールで表示名と役職を指定して作成してください。 直属の部下と上司は、Office 365 の Exchange 管理センター (受信者/メールボックス) に割り当てられます。 また、以下の「**既知の問題**」 セクションでアクセス トークンに関する問題も参照してください。

##目的のコード

**電話**

*ViewController*- 電話側では、これは WCSession を構成する場所であり、電話とウォッチ間の接続を確立するためにアクティブ化されます。 ここから、アクセス トークン (iOS 版 ADAL) の **AuthenticationManager** に対して呼び出しが実行され、**sendMessage:replyHandler:errorHandler:** メソッドを経由してウォッチに送信されます。 

**ウォッチ**

*InterfaceController* - このコントローラーでは、**session:didReceiveMessageData:replyHandler:** を実装して電話からアクセス トークンを受け取り、ここから **Network\NetworkManager.m** に保存します。このコントローラーは Microsoft Graph サービスに対して呼び出しを実行し、ログインしているユーザーの予定表イベント (**getEvents**) を取得して表示します。 ユーザーが会議を選択すると、予定表のイベント オブジェクトが **AttendeeListController** に渡されます。

*AttendeeListController* - このコントローラーには、会議の出席者の一覧が出席者のプロフィール画像と共に表示されます。 Microsoft Graph (**getEventAttendees**) への呼び出しでは、Attendee オブジェクトは出席者名を使用して作成/初期化され、ユーザーがそれらを選択すると **ProfileController** に渡されます。 また、ヘルパー クラス **ProfilePictureHelper** は、**getPhotoForAttendee:(Attendee *) withcompletion:** を呼び出して、すべての会議参加者のプロフィール画像も取得します。
  
*ProfileController* - 最後に 2 つの追加の Microsoft Graph メソッド (**getUserManager、getUserDirects**) が呼び出され、選択した出席者の上司、役職、直属の部下および関連するプロフィール画像を取得します。


##既知の問題
このプロジェクトでは作業は進行中であり、現段階では、電話とウォッチ間で渡されるアクセストークンは有効期限切れになっても更新されませんので、改めてご注意ください。 現時点では、有効期限切れになった場合は、再度とログインする必要があります。 シミュレーターでは、アプリを再展開するだけですが、ウォッチに展開する場合は、アプリの有効期限が切れるとアプリがハングアップします。 デバイスに再展開するか、またはバック グラウンドでアプリをシャットダウンして再起動する (アプリを開き、電源メニューが表示されるまでサイド ボタンを押して、そのメニューが消えるまでもう一度サイド ボタンを押し続け、アプリを再起動します) ことができます。

## 質問とコメント

**出席者情報**アプリに関するフィードバックをお寄せください。 質問や提案につきましては、このリポジトリの「[問題](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/issues)」セクションで送信できます。

Microsoft Graph 開発全般の質問につきましては、「[スタック オーバーフロー](http://stackoverflow.com/questions/tagged/Office365+API)」に投稿してください。 質問やコメントには、必ず [Office365] と [MicrosoftGraph] のタグを付けてください。

## 投稿
プル要求を送信する前に、[投稿者のライセンス契約](https://cla.microsoft.com/)に署名する必要があります。 投稿者のライセンス契約 (CLA) を完了するには、ドキュメントへのリンクを含むメールを受信した際に、フォームから要求を送信し、CLA に電子的に署名する必要があります。

このプロジェクトでは、[Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/) が採用されています。詳細については、「[規範に関する FAQ](https://opensource.microsoft.com/codeofconduct/faq/)」を参照してください。または、その他の質問やコメントがあれば、[opencode@microsoft.com](mailto:opencode@microsoft.com) までにお問い合わせください。

## その他のリソース

* [Microsoft Graph の概要ページ](https://graph.microsoft.io)
* [CocoaPods を使う](https://guides.cocoapods.org/using/using-cocoapods.html)

## 著作権
Copyright (c) 2016 Microsoft. All rights reserved.
