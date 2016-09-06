# Quem é você – Exemplo para Microsoft Graph e Apple Watch

**Quem é você?** é um exemplo para relógio que permite saber mais sobre um colega em uma reunião. Ele foi concebido para ser uma forma divertida de usar um dispositivo portátil, como um Apple Watch, com o Microsoft Graph, um ponto de extremidade unificado para acessar dados, relacionamentos e ideias vindos da Microsoft Cloud.

O cenário gira em torno da participação em uma reunião em que não conhecemos uma determinada pessoa, mas gostaríamos de saber um pouco mais sobre ela de maneira discreta. No Apple Watch, é possível abrir a lista de participantes da reunião e exibir informações de perfil, como cargo, gerente, subordinados diretos e todas as imagens de perfil associadas.

![Relógio](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/WatchScene.jpg)


> Observação: Este exemplo é apenas uma ideia e destina-se unicamente a abrir as possibilidades de integração do Microsoft Graph em várias situações diferentes. Como sempre, ao criar seu próprio aplicativo na organização, é preciso garantir a implementação de suas próprias diretrizes de segurança (autenticação e permissões do aplicativo) e o design do aplicativo. Além disso, vejas as [Diretrizes da interface humana do watchOS](https://developer.apple.com/watch/human-interface-guidelines/) da Apple.

Para concluir, esse trabalho ainda está em andamento e adoraríamos contar com suas contribuições e aprimoramentos, conforme necessário. **Quem é você?** é um exemplo do WatchOS 2.2 que usa a Biblioteca de Autenticação do Active Directory para iOS para autenticação e o ponto de extremidade do Microsoft Graph para coletar informações específicas do perfil de usuários. 

## Pré-requisitos
* [Xcode](https://developer.apple.com/xcode/downloads/) da Apple (testado na versão 7.3.1 com suporte para WatchOS 2.2.
* Instalação do [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) como um gerente de dependências.
* Uma conta comercial da Microsoft como o Office 365 que oferece suporte ao Microsoft Exchange.  Inscreva-se em uma [Assinatura de avaliação do Office 365 Enterprise](https://products.office.com/en-us/business/office-365-enterprise-e5-business-software) que inclui os recursos necessários para começar a criar aplicativos do Office 365. Também inclui 25 licenças para serem aplicadas aos usuários.

     > Observação: Este exemplo depende de contas organizacionais licenciadas com informações limitadas de perfil preenchidas como cargo do funcionário, o nome para exibição, gerente, subordinados diretos e imagem do perfil. Se essas informações não forem preenchidas, elas não serão exibidas no aplicativo.    
* Um locatário do Microsoft Azure para registrar o seu aplicativo. O Azure Active Directory fornece serviços de identidade que os aplicativos usam para autenticação e autorização. Você pode adquirir uma assinatura de avaliação aqui: [Microsoft Azure](https://account.windowsazure.com/SignUp).

**Importante**: Você também deve garantir que a assinatura do Azure esteja vinculada ao seu locatário do Office 365. Para fazer isso, veja a seção Adicionar um novo diretório na postagem de blog da equipe do Active Directory: [Criar e gerenciar vários Azure Active Directories](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx). Você também pode ler [Configurar o acesso ao Azure Active Directory para seu Site do Desenvolvedor](http://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription) para saber mais.


## Registrar seu aplicativo com o Microsoft Azure
1.  Entre no [Portal de Gerenciamento do Azure](https://manage.windowsazure.com) usando as credenciais do Azure AD.
2.  Escolha **Todos os Itens** no menu à esquerda e escolha o diretório para o site do desenvolvedor do Office 365.
3.  No menu superior, escolha **Aplicativos**.
4.  Escolha **Adicionar** no menu inferior.
5.  Na página **O que você deseja fazer?**, escolha **Adicionar um aplicativo que minha organização esteja desenvolvendo**.
6.  Na página **Conte-nos sobre seu aplicativo**, especifique **iOS-Watch** como nome do aplicativo e escolha **APLICATIVO CLIENTE NATIVO** como tipo.
7.  Escolha o ícone de seta no canto inferior direito da página.
8.  Na página **Informações sobre o aplicativo**, especifique um **URI de redirecionamento**. Neste exemplo, você pode especificar **https://localhost** e, em seguida, escolher **ícone de marca de seleção** no canto inferior direito da página. Lembre-se esse valor para a seção **Executar este exemplo em Xcode**.
9.  Após adicionar o aplicativo com êxito, você será direcionado para a página início rápido do aplicativo. Escolha **Configurar** no menu superior.
10. Role até a seção intitulada **Permissões para Outros Aplicativos**.
11. Clique em **Adicionar aplicativo**.
12. Clique em **Microsoft Graph**. 
13. Clique no **ícone de marca de seleção** na parte inferior da página.
14. A partir de **Permissões Delegadas**, escolha **Entrar e ler o perfil do usuário**, **Ler os perfis completos de todos os usuários** e **Ler calendários de usuários**.
15. Clique no botão **Salvar** na parte inferior da página.
16. Copie os valores de **ID do Cliente** e **URIs de redirecionamento** na página **Configurar**. Lembre-se desses valores para a seção **Executar este exemplo em Xcode**.

## Executar este exemplo em Xcode

1. Clone este repositório.
2. Use o CocoaPods para importar a dependência de autenticação ADAL. Este aplicativo de exemplo já contém um podfile que colocará os pods no projeto. Simplesmente navegue até o projeto do **Terminal** e execute:

        pod install

     Para saber mais, confira o artigo **Usar o CocoaPods** em [Recursos Adicionais](#recursos-adicionais)

3. Abrir o **iOS-ObjectiveC-MicrosoftGraph-WatchSample.xcworkspace**
4. Abra o **ViewController.m**. Você verá que os valores de **ID de Cliente** e **URI de redirecionamento** do processo de registro poderão ser adicionados na parte superior do arquivo:

        // You will set your application's clientId and redirect URI.
        NSString * const kRedirectUri = @"ENTER_REDIRECT_URI_HERE";
        NSString * const kClientId    = @"ENTER_CLIENT_ID_HERE";
        NSString * const kAuthority   = @"https://login.microsoftonline.com/common";
        NSString * const kResourceId  = @"https://graph.microsoft.com";

5. Execute o exemplo e verifique se o destino está definido como o esquema WatchKit App iPhone/Apple Watch.
![Destino](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/target.jpg)
6. Verifique se o aplicativo do iOS e os simuladores de aplicativo do relógio estão visíveis. No aplicativo do telefone, clique em *Conectar* e você será solicitado a autenticar em uma conta de email comercial. Forneça suas credenciais.
![Autenticação](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/Authentication.jpg)
6. Após autenticar, o aplicativo do relógio tentará imediatamente recuperar eventos recentes do calendário do usuário conectado. Você verá um indicador **Recuperando...** ser exibido no relógio. A partir daí pode realizar uma busca detalhada na lista de participantes, encontrar alguém de seu interesse e exibir detalhes do perfil: cargo, gerente, subordinados diretos e imagens de perfil.

    > Observação: Repetimos novamente que é preciso ter uma reunião criada no locatário do Office 365, participantes licenciados adicionados e alguns detalhes do perfil inseridos no aplicativo para que ele retorne resultados. Verifique se há uma reunião criada com seu nome de exibição e cargo no console de admin do Office 365. Os subordinados diretos e o gerente podem ser atribuídos no centro de administração do Exchange (destinatários/caixas de correio) no Office 365. Além disso, consulte abaixo o problema com o token de acesso na sessão **Problemas conhecidos**.

##Código de interesse

**Telefone**

*ViewController* – O WCSession é configurado e ativado na lateral do telefone para estabelecer a conectividade entre o telefone e o relógio. Daqui, uma chamada é feita para o controlador **AuthenticationManager** que obtém um token de acesso (ADAL para iOS) que é enviado para o relógio pelo método **sendMessage:replyHandler:errorHandler:**. 

**Relógio**

*InterfaceController* – neste controlador, o método **session:didReceiveMessageData:replyHandler:** é implementado para receber o token de acesso do telefone no qual ele será armazenado em **Network\NetworkManager.m**. Em seguida, este controlador realizará uma chamada para o serviço do Microsoft Graph para recuperar os eventos do calendário do usuário conectado (**getEvents**) e exibi-los. Em seguida, o usuário escolhe uma reunião e o objeto de eventos do calendário é passado para o controlador **AttendeeListController**.

*AttendeeListController* – Este controlador exibe a lista de participantes da reunião juntamente com suas imagens de perfil. Na chamada para o Microsoft Graph (**getEventAttendees**), um objeto Participante é criado/inicializado com o nome do participante e então passado para **ProfileController** quando o usuário seleciona-o. Além disso, uma classe auxiliar **ProfilePictureHelper** chama **getPhotoForAttendee:(Attendee *) withcompletion:** para recuperar as imagens de perfil de todos os participantes da reunião.
  
*ProfileController* – Por fim, dois outros métodos do Microsoft Graph (**getUserManager, getUserDirects**) são chamados para recuperar o gerente, cargo, subordinados diretos e imagens associadas de perfil do participante selecionado.


##Problemas conhecidos
Repetimos mais uma vez, esse projeto ainda encontra-se em andamento e, desta vez, o token de acesso passado entre o telefone e o relógio não está sendo atualizado quando o aplicativo expira. Por enquanto, quando ele expirar, será necessário efetuar login novamente. No simulador, basta reimplantar o aplicativo. No entanto, se você estiver implantando em um relógio, o aplicativo travará após a expiração. Você pode implantar no dispositivo novamente ou encerrar o aplicativo no plano de fundo e reiniciar (abra o aplicativo, pressione o botão lateral até que o menu de energia seja exibido, pressione o botão lateral novamente até esse menu desaparecer e reinicie o aplicativo).

## Perguntas e comentários

Gostaríamos de saber sua opinião sobre o aplicativo **Quem é você**. Você pode nos enviar suas perguntas e sugestões por meio da seção [Issues](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/issues) deste repositório.

As perguntas sobre o desenvolvimento do Microsoft Graph em geral devem ser postadas no [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API). Não deixe de marcar as perguntas ou comentários com [Office365] e [MicrosoftGraph].

## Colaboração
Será preciso assinar um [Contributor License Agreement (Contrato de Licença de Colaborador)](https://cla.microsoft.com/) antes de enviar a solicitação pull. Para concluir o CLA (Contributor License Agreement), você deve enviar uma solicitação através do formulário e assinar eletronicamente o CLA quando receber o email com o link para o documento.

Este projeto adotou o [Código de Conduta do Código Aberto da Microsoft](https://opensource.microsoft.com/codeofconduct/). Para saber mais, confira as [Perguntas frequentes do Código de Conduta](https://opensource.microsoft.com/codeofconduct/faq/) ou contate [opencode@microsoft.com](mailto:opencode@microsoft.com) se tiver outras dúvidas ou comentários.

## Recursos adicionais

* [Página de visão geral do Microsoft Graph](https://graph.microsoft.io)
* [Usando o CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## Direitos autorais
Copyright © 2016 Microsoft. Todos os direitos reservados.
