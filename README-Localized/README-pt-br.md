# <a name="who-are-you?---microsoft-graph-and-apple-watch-sample"></a>Quem é você? – Exemplo para Microsoft Graph e Apple Watch

**Quem é você?** é um exemplo para relógio que permite saber mais sobre um colega em uma reunião. Ele foi concebido para ser uma forma divertida de usar um dispositivo portátil, como um Apple Watch, com o Microsoft Graph, um ponto de extremidade unificado para acessar dados, relacionamentos e ideias vindos da Microsoft Cloud.

O cenário gira em torno da participação em uma reunião em que não conhecemos uma determinada pessoa, mas gostaríamos de saber um pouco mais sobre ela de maneira discreta. No Apple Watch, é possível abrir a lista de participantes da reunião e exibir informações de perfil, como cargo, gerente, subordinados diretos e todas as imagens de perfil associadas.

![Relógio](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/WatchScene.jpg)


> Observação: Este exemplo é apenas uma ideia e destina-se unicamente a abrir as possibilidades de integração do Microsoft Graph em várias situações diferentes. Como sempre, ao criar seu próprio aplicativo na organização, é preciso garantir a implementação de suas próprias diretrizes de segurança (autenticação e permissões do aplicativo) e o design do aplicativo. Além disso, vejas as [Diretrizes da interface humana do watchOS](https://developer.apple.com/watch/human-interface-guidelines/) da Apple.

Para concluir, esse trabalho ainda está em andamento e adoraríamos contar com suas contribuições e aprimoramentos, conforme necessário. **Quem é você?** é um exemplo do WatchOS 2.2 que usa a Biblioteca de Autenticação do Active Directory para iOS para autenticação e o ponto de extremidade do Microsoft Graph para coletar informações específicas do perfil de usuários. 

## <a name="prerequisites"></a>Pré-requisitos
* [Xcode](https://developer.apple.com/xcode/downloads/) da Apple (testado na versão 7.3.1 com suporte para WatchOS 2.2.
* Instalação do [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) como um gerente de dependências.
* Uma conta comercial da Microsoft como o Office 365 que oferece suporte ao Microsoft Exchange.  Inscreva-se em uma [Assinatura de avaliação do Office 365 Enterprise](https://products.office.com/en-us/business/office-365-enterprise-e5-business-software) que inclui os recursos necessários para começar a criar aplicativos do Office 365. Também inclui 25 licenças para serem aplicadas aos usuários.

     > Observação: Este exemplo depende de contas organizacionais licenciadas com informações limitadas de perfil preenchidas como cargo do funcionário, o nome para exibição, gerente, subordinados diretos e imagem do perfil. Se essas informações não forem preenchidas, elas não serão exibidas no aplicativo.    
* Um locatário do Microsoft Azure para registrar o seu aplicativo. O Azure Active Directory fornece serviços de identidade que os aplicativos usam para autenticação e autorização. Você pode adquirir uma assinatura de avaliação aqui: [Microsoft Azure](https://account.windowsazure.com/SignUp).

**Importante**: Você também deve garantir que a assinatura do Azure esteja vinculada ao seu locatário do Office 365. Para fazer isso, veja a seção Adicionar um novo diretório, na postagem de blog da equipe do Active Directory: [Criar e gerenciar vários Azure Active Directories](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx). Para saber mais, leia o tópico [Configurar o acesso ao Azure Active Directory para o Site do Desenvolvedor](http://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription).

## <a name="register-your-app-with-microsoft-azure"></a>Registrar seu aplicativo com o Microsoft Azure
1. Entre no [Portal do Azure](https://portal.azure.com/).
2. Na barra superior, clique em sua conta; em seguida, na lista **Directory**, escolha o locatário do Azure Active Directory em que deseja registrar o aplicativo.
3. Clique em **Mais Serviços**, na barra de navegação à esquerda, e escolha **Azure Active Directory**.
4. Clique em **Registros de aplicativos** e escolha **Adicionar**.
5. Insira um nome amigável para o aplicativo, como **Projeto de Relógio**, e escolha **Nativo** como Tipo de Aplicativo. Para o **URI de Redirecionamento**, insira **https://localhost**. Clique em **Criar** para criar o aplicativo.
6. Ainda no Portal do Azure, escolha o aplicativo, clique em **Configurações** e escolha **Propriedades**.
7. Localize o valor da **ID do Aplicativo** e copie-o para a Área de Transferência. Esse é o valor da ID do cliente que vamos adicionar posteriormente ao projeto.
8. Configure **Permissões** para o aplicativo – no menu **Configurações**, escolha a seção **Permissões necessárias**, clique em**Adicionar** em **Selecionar uma API** e digite "Microsoft Graph" na caixa de texto. Em seguida, clique em **Selecionar Permissões** e escolha:
   * Ler os perfis completos de todos os usuários
   * Entrar e ler o perfil do usuário
   * Ler calendários do usuário

9. Clique em **Selecionar**


## <a name="running-this-sample-in-xcode"></a>Executando este exemplo em Xcode

1. Clone este repositório.
2. Use o CocoaPods para importar a dependência de autenticação ADAL. Este aplicativo de exemplo já contém um podfile que colocará os pods no projeto. Simplesmente navegue até o projeto do **Terminal** e execute:

        pod install

     Para saber mais, confira o artigo **Usar o CocoaPods** em [Recursos Adicionais](#AdditionalResources)

3. Abrir o **iOS-ObjectiveC-MicrosoftGraph-WatchSample.xcworkspace**
4. Abra o **ViewController.m**. Você verá que os valores de **ClientID** (a ID do Aplicativo obtida na seção de pré-requisitos) e **URI de Redirecionamento** do processo de registro podem ser adicionados na parte superior do arquivo:

        // You will set your application's clientId and redirect URI.
        NSString * const kRedirectUri = @"ENTER_REDIRECT_URI_HERE";
        NSString * const kClientId    = @"ENTER_CLIENT_ID_HERE";
        NSString * const kAuthority   = @"https://login.microsoftonline.com/common";
        NSString * const kResourceId  = @"https://graph.microsoft.com";

5. Execute o exemplo e verifique se o destino está definido como o esquema WatchKit App iPhone/Apple Watch. ![Destino](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/target.jpg)
6. Verifique se o aplicativo do iOS e os simuladores de aplicativo do relógio estão visíveis. No aplicativo do telefone, clique em *Conectar* e você será solicitado a autenticar em uma conta de email comercial. Forneça suas credenciais. ![Autenticação](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/blob/master/Images/Authentication.jpg)
6. Após autenticar, o aplicativo do relógio tentará imediatamente recuperar eventos recentes do calendário do usuário conectado. Você verá um indicador **Recuperando...** ser exibido no relógio. A partir daí pode realizar uma busca detalhada na lista de participantes, encontrar alguém de seu interesse e exibir detalhes do perfil: cargo, gerente, subordinados diretos e imagens de perfil.

    > Observação: Repetimos novamente que é preciso ter uma reunião criada no locatário do Office 365, participantes licenciados adicionados e alguns detalhes do perfil inseridos no aplicativo para que ele retorne resultados. Verifique se há uma reunião criada com seu nome de exibição e cargo no console de admin do Office 365. Os subordinados diretos e o gerente podem ser atribuídos no centro de administração do Exchange (destinatários/caixas de correio) no Office 365. Além disso, consulte abaixo o problema com o token de acesso na sessão **Problemas conhecidos**.

##<a name="code-of-interest"></a>Código de interesse

**Telefone**

*ViewController* – O WCSession é configurado e ativado na lateral do telefone para estabelecer a conectividade entre o telefone e o relógio. A partir daí, uma chamada é feita no controlador **AuthenticationManager** para obter um token de acesso (ADAL para iOS) e enviá-lo para o relógio pelo método **sendMessage:replyHandler:errorHandler:** 

**Relógio**

*InterfaceController* – neste controlador, o método **session:didReceiveMessageData:replyHandler:** é implementado para receber o token de acesso do telefone no qual ele será armazenado em **Network\NetworkManager.m**. Em seguida, este controlador realizará uma chamada para o serviço do Microsoft Graph para recuperar os eventos do calendário do usuário conectado (**getEvents**) e exibi-los. Em seguida, o usuário escolhe uma reunião e o objeto de eventos do calendário é passado para o controlador **AttendeeListController**.

*AttendeeListController* – Este controlador exibe a lista de participantes da reunião juntamente com suas imagens de perfil. Na chamada para o Microsoft Graph (**getEventAttendees**), o sistema cria e inicializa um objeto Attendee com o nome do participante; em seguida, passa-o pelo **ProfileController** quando o usuário o escolhe. Além disso, uma Classe do Auxiliar **ProfilePictureHelper** chama **getPhotoForAttendee:(Attendee *) withcompletion:** para recuperar as imagens de perfil de todos os participantes da reunião.
  
*ProfileController* – Por fim, dois outros métodos do Microsoft Graph (**getUserManager, getUserDirects**) são chamados para recuperar o gerente, cargo, subordinados diretos e imagens associadas de perfil do participante selecionado.


##<a name="known-issues"></a>Problemas conhecidos
Repetimos mais uma vez, esse projeto ainda encontra-se em andamento e, desta vez, o token de acesso passado entre o telefone e o relógio não está sendo atualizado quando o aplicativo expira. Por enquanto, quando ele expirar, será necessário efetuar login novamente. No simulador, basta reimplantar o aplicativo. No entanto, se você estiver implantando em um relógio, o aplicativo travará após a expiração. Você pode implantar no dispositivo novamente ou encerrar o aplicativo no plano de fundo e reiniciar (abra o aplicativo, pressione o botão lateral até que o menu de energia seja exibido, pressione o botão lateral novamente até esse menu desaparecer e reinicie o aplicativo).

## <a name="questions-and-comments"></a>Perguntas e comentários

Gostaríamos de saber sua opinião sobre o aplicativo **Quem é você**. Para falar conosco, envie perguntas e sugestões por meio da seção [Issues](https://github.com/microsoftgraph/iOS-objectiveC-apple-watch-sample/issues) deste repositório.

As perguntas sobre o desenvolvimento do Microsoft Graph em geral devem ser postadas no [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API). Não deixe de marcar as perguntas ou comentários com [Office365] e [MicrosoftGraph].

## <a name="contributing"></a>Colaboração
Será preciso assinar um [Contributor License Agreement (Contrato de Licença de Colaborador)](https://cla.microsoft.com/) antes de enviar a solicitação pull. Para concluir o CLA (Contributor License Agreement), você deve enviar uma solicitação através do formulário e assinar eletronicamente o CLA quando receber o email com o link para o documento.

Este projeto adotou o [Código de Conduta do Código Aberto da Microsoft](https://opensource.microsoft.com/codeofconduct/). Para saber mais, confira as [Perguntas frequentes do Código de Conduta](https://opensource.microsoft.com/codeofconduct/faq/) ou contate [opencode@microsoft.com](mailto:opencode@microsoft.com) se tiver outras dúvidas ou comentários.

## <a name="additional-resources"></a>Recursos adicionais

* [Página de visão geral do Microsoft Graph](https://graph.microsoft.io)
* [Usando o CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## <a name="copyright"></a>Direitos autorais
Copyright © 2016 Microsoft. Todos os direitos reservados.

