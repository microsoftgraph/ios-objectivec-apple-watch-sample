# 你是谁？ - Microsoft Graph 和 Apple Watch 示例

“**你是谁？**”是观看示例，可让你了解会议中同事的更多信息。 它应是将可穿戴的 Apple Watch 与 Microsoft Graph 相交的有趣的方法，是访问数据、关系和来自 Microsoft 云的数据分析的统一终结点。

该方案围绕我们如何参与到不知道与会者身份的会议中，并以严谨的方式对其进行更深入的介绍。 你可以从 Apple Watch 拉取与会者列表并查看个人资料信息，如与会者职务、经理、直接下属以及所有与其关联的个人资料图片。

![Watch](../https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/WatchScene.jpg)


> 注意：此示例只是一个构想，旨在仅探索将 Microsoft Graph 集成到多种不同方案的可能性。 与往常一样，在你的组织中构建自己的应用时，应确保周围的安全准则（身份验证和应用权限）以及应用设计的实现。 另外，请参考 Apple 的 [watchOS 人工界面准则](https://developer.apple.com/watch/human-interface-guidelines/)。

最后，此示例正在进行中，我们乐于看到你的参与或对其所做的改进。 “**你是谁？**”是用于身份验证的使用适用于 iOS 的 Active Directory 身份验证库的 WatchOS 2.2 示例，而 Microsoft Graph 终结点用于收集用户个人资料详细信息。 

## 先决条件
* 来自 Apple 的 [Xcode](https://developer.apple.com/xcode/downloads/)（在支持 WatchOS 2.2 的版本 7.3.1 上进行了测试）。
* 安装 [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) 成为依存关系管理器。
* 支持 Microsoft Exchange 的 Microsoft 工作帐户（例如 Office 365）。  你可以注册 [Office 365 企业版试用订阅](https://products.office.com/en-us/business/office-365-enterprise-e5-business-software)，其中包含你开始构建 Office 365 应用所需的资源。 这还包括向用户应用的 25 个许可。

     > 注意：此示例依赖于拥有授权的组织帐户（该帐户填充了有限的个人资料信息），如员工的职务、显示名称、经理、直接下属和个人资料图片。 如果不对该信息进行填充，则它将不会显示在应用中。    
* 用于注册你的应用程序的 Microsoft Azure 租户。 Azure Active Directory 为应用程序提供了用于进行身份验证和授权的标识服务。 你还可在此处获得试用订阅：[Microsoft Azure](https://account.windowsazure.com/SignUp)。

**重要说明**：你还需要确保你的 Azure 订阅已绑定到 Office 365 租户。 要执行这一操作，请参阅 Active Directory 团队的博客文章中的添加新的目录部分，[创建和管理多个 Windows Azure Active Directory](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx)。 有关详细信息，还可参阅 [为你的开发人员网站设置 Azure Active Directory 访问](http://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription)。


## 使用 Microsoft Azure 注册你的应用
1.  使用你的 Azure AD 凭据登录到 [Azure 管理门户](https://manage.windowsazure.com)。
2.  选择左侧菜单上的“**所有项目**”，然后选择 Office 365 开发人员网站的目录。
3.  在顶部菜单中，选择“**应用程序**”。
4.  选择底部菜单中的“**添加**”。
5.  在“**希望执行何种操作**”页面上选择“**添加我的组织正在开发的应用程序**”。
6.  在“**告诉我们你的应用程序**”页上，为该应用程序名称指定 **iOS-Watch**，并选择“**本机客户端应用程序**”类型。
7.  选择页面右下角的箭头图标。
8.  在“**应用程序信息**”页上，指定“**重定向 URI**”。 对于此示例，可以指定 **https://localhost**，然后选择页面右下角的“**复选标记图标**”。 请记住“**在 Xcode 中运行此示例**”部分的该值。
9.  成功添加应用程序后，你将被带到应用程序的“快速启动”页面。 在顶部菜单中选择“**配置**”。
10. 滚动到名为“**其他应用程序的权限**”的部分。
11. 单击“**添加应用程序**”。
12. 单击“**Microsoft Graph**” 
13. 单击页面底部的“**复选标记图标**”。
14. 从“**委托的权限**”选择“**登录并读取用户个人资料**”、“**读取所有用户的完整个人资料**”和“**读取用户日历**”。
15. 单击页面底部的“**保存**”按钮。
16. 复制“**客户端 ID**”的值并在“**配置**”页上“**重定向 URIS**”。 请记住“**在 Xcode 中运行此示例**”部分的这些值。

## 在 Xcode 中运行此示例

1. 克隆该存储库。
2. 使用 CocoaPods 导入 ADAL 身份验证依赖项。 该示例应用已包含可将 pod 导入到项目中的 pod 文件。 只需从**终端**导航到项目并运行：

        pod install

     更多详细信息，请参阅 [其他资源](#其他资源) 中的“**使用 CocoaPods**”

3. 打开 **iOS-ObjectiveC-MicrosoftGraph-WatchSample.xcworkspace**
4. 打开 **ViewController.m** 你会发现，注册过程的 **ClientID** 和**重定向 URI** 可以添加到文件顶部：

        // You will set your application's clientId and redirect URI.
        NSString * const kRedirectUri = @"ENTER_REDIRECT_URI_HERE";
        NSString * const kClientId    = @"ENTER_CLIENT_ID_HERE";
        NSString * const kAuthority   = @"https://login.microsoftonline.com/common";
        NSString * const kResourceId  = @"https://graph.microsoft.com";

5. 运行示例并确保目标设置为 WatchKit App iPhone/Apple Watch scheme。
![目标](../https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/target.jpg)
6. 请确保 iOS 应用和 watch 应用模拟器是可见的。 在电话应用上，单击“*连接*”，系统将要求你验证工作邮件帐户。 提供你的凭据。
![身份验证](../https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/Authentication.jpg)
6. 完成身份验证后，watch 应用将立即尝试从已登录用户的日历中检索最近事件。 你将在 watch 表盘上看到“**检索...**”指示器。 从这里，你可以深入了解与会者列表，查找相关人员，并查看个人资料细节：职务、经理、直接下属和个人资料图片。

    > 注意：需在 Office 365 租户中再次创建会议、授权添加的与会者以及与其相关的个人资料详细信息，以使应用返回任何内容。 确保在 Office 365 管理控制台中使用其显示名称和职务对其进行了创建。 可在 Office 365 中的 Exchange 管理员中心（收件人/邮箱）中分配直接下属和经理。 同时，请在以下“**已知问题**”部分参阅有关访问令牌的问题。

##相关代码

**电话**

*ViewController*- 在电话的一侧，这是对 WCSession 进行配置和激活以在电话和 watch 之间建立连接的位置。 从此处，为访问令牌（适用于 iOS 的 ADAL）调入 **AuthenticationManager**，它将通过 **sendMessage:replyHandler:errorHandler:** 方法发送到 watch。 

**Watch**

*InterfaceController* -在此控制器中，**session:didReceiveMessageData:replyHandler:** 实现接收来自来自电话的访问令牌，它在此处存储在 **Network\NetworkManager.m** 此控制器然后将对 Microsoft Graph 服务进行调用，以检索已登录用户的日历事件 (**getEvents**) 并显示它们。 然后，用户选择会议，日历事件对象传递至 **AttendeeListController**。

*AttendeeListController* - 该控制器显示与会者及其个人资料图片列表。 在对 Microsoft Graph (**getEventAttendees**) 的调用中，创建/初始化具有与会者名称的与会者对象，然后在用户对其进行选择时传递到 **ProfileController**。 另外，帮助程序类 **ProfilePictureHelper** 调用 **getPhotoForAttendee:(Attendee *) withcompletion:** 以检索所有与会人员的个人资料图片。
  
*ProfileController* - 最终两种其他 Microsoft Graph 方法 (**getUserManager, getUserDirects**) 被调用以检索所选与会者的经理、职务、直接下属和相关联的个人资料图片。


##已知问题
需再次说明，此项目正在进行中，目前，手机和 watch 间传递的访问令牌在到期时不会被刷新。 现在，一旦过期，你将需要重新登录。 在模拟器上，只需重新部署应用，但要部署到 watch，应用在到期后将挂起。 你可以重新部署到该设备，或在背景中关闭应用并重新启动（打开应用、按侧按钮直到显示电源菜单、再次按住侧按钮直到该菜单消失，重新启动应用）。

## 问题和意见

我们乐意倾听你有关“**你是谁**”应用的反馈。 你可以在该存储库中的 [问题](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/issues) 部分将问题和建议发送给我们。

与 Microsoft Graph 开发相关的一般问题应发布到 [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API)。 确保你的问题或意见使用了 [Office365] 和 [MicrosoftGraph] 标记。

## 参与
你需要在提交拉取请求之前签署 [参与者许可协议](https://cla.microsoft.com/)。 要完成参与者许可协议 (CLA)，你需要通过表格提交请求，并在收到包含文件链接的电子邮件时在 CLA 上提交电子签名。

此项目采用 [Microsoft 开源行为准则](https://opensource.microsoft.com/codeofconduct/)。有关详细信息，请参阅 [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/)（行为准则常见问题解答），有任何其他问题或意见，也可联系 [opencode@microsoft.com](mailto:opencode@microsoft.com)。

## 其他资源

* [Microsoft Graph 概述页](https://graph.microsoft.io)
* [使用 CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## 版权
版权所有 (c) 2016 Microsoft。保留所有权利。
