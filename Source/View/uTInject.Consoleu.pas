﻿{####################################################################################################################
                              TINJECT - Componente de comunicação (Não Oficial)
                                           www.tinject.com.br
                                            Novembro de 2019
####################################################################################################################
    Owner.....: Mike W. Lustosa            - mikelustosa@gmail.com   - +55 81 9.9630-2385
    Developer.: Joathan Theiller           - jtheiller@hotmail.com   -
####################################################################################################################
  Obs:
     - Código aberto a comunidade Delphi, desde que mantenha os dados dos autores e mantendo sempre o nome do IDEALIZADOR
       Mike W. Lustosa;
     - Colocar na evolução as Modificação juntamente com as informaçoes do colaborador: Data, Nova Versao, Autor;
     - Mantenha sempre a versao mais atual acima das demais;
     - Todo Commit ao repositório deverá ser declarado as mudança na UNIT e ainda o Incremento da Versão de
       compilação (último digito);
####################################################################################################################
                                  Evolução do Código
####################################################################################################################
  Autor........:
  Email........:
  Data.........:
  Identificador:
  Modificação..:
####################################################################################################################
}
unit uTInject.Consoleu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms , StrUtils,

  uCEFWinControl, uCEFChromiumCore,   uCEFTypes,
  uCEFInterfaces, uCEFConstants,      uCEFWindowParent, uCEFChromium,

  //units adicionais obrigatórias
  uTInject.Classes,  uTInject.constant, uTInject.Diversos,


    System.ImageList , System.JSON,
  Vcl.Buttons, Vcl.Imaging.pngimage, Rest.Json,
  Vcl.Imaging.jpeg, uCEFSentinel,{$ifndef tinject_unigui} uTInject.FrmQRCodeu {$else} uTInject.FrmQRCode {$endif},
  Vcl.WinXCtrls, uniGUIBaseClasses, uniGUIClasses, uniTimer, uniPanel, uniLabel, uniImage, uniGUITypes, uniGUIAbstractClasses,
uniGUIForm, uniGUIApplication;

type
  TProcedure = procedure() of object;

  TFrmConsoleu = class(TUniForm)
    Chromium1: TChromium;
    Pnl_Top: TUniPanel;
    Img_Brasil: TUniImage;
    Lbl_Caption: TUniLabel;
    CEFSentinel1: TCEFSentinel;
    Pnl_Geral: TUniPanel;
    CEFWindowParent1: TCEFWindowParent;
    Lbl_Versao: TUniLabel;
    Img_LogoInject: TUniImage;
    procedure Chromium1AfterCreated(Sender: TObject;      const browser: ICefBrowser);
    procedure Chromium1BeforeClose(Sender: TObject; const browser: ICefBrowser);
    procedure Chromium1BeforePopup(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
      targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
      const popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var client: ICefClient; var settings: TCefBrowserSettings;
      var extra_info: ICefDictionaryValue; var noJavascriptAccess,
      Result: Boolean);
    procedure Chromium1Close(Sender: TObject; const browser: ICefBrowser;
      var aAction: TCefCloseBrowserAction);
    procedure Chromium1OpenUrlFromTab(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const targetUrl: ustring; targetDisposition: TCefWindowOpenDisposition;
      userGesture: Boolean; out Result: Boolean);
    procedure Chromium1TitleChange(Sender: TObject; const browser: ICefBrowser;
      const title: ustring);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Chromium1ConsoleMessage(Sender: TObject;   const browser: ICefBrowser; level: Cardinal; const message,
      source: ustring; line: Integer; out Result: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    Procedure ProcessQrCode(Var pClass: TObject);
    procedure CEFSentinel1Close(Sender: TObject);
    Procedure ProcessPhoneBook(PCOmmand: String);
    procedure FormShow(Sender: TObject);
    procedure App_EventMinimize(Sender: TObject);
    procedure Chromium1BeforeDownload(Sender: TObject;
      const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const suggestedName: ustring; const callback: ICefBeforeDownloadCallback);
    procedure Chromium1DownloadUpdated(Sender: TObject;
      const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const callback: ICefDownloadItemCallback);
    procedure Lbl_VersaoMouseEnter(Sender: TObject);
    procedure Chromium1BeforeContextMenu(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  protected
    // You have to handle this two messages to call NotifyMoveOrResizeStarted or some page elements will be misaligned.
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    // You also have to handle these two messages to set GlobalCEFApp.OsmodalLoop
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop (var aMessage: TMessage); message WM_EXITMENULOOP;

    procedure BrowserDestroyMsg(var aMessage : TMessage);  message CEF_DESTROY;
    procedure RequestCloseInject(var aMessage : TMessage); message FrmConsole_Browser_Direto;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;

    Procedure OnTimerMonitoring(Sender: TObject);
    procedure OnTimerConnect(Sender: TObject);
    procedure OnTimerGetQrCode(Sender: TObject);
    Procedure ExecuteCommandConsole(Const PResponse: TResponseConsoleMessage);
  private
    { Private declarations }
    LPaginaId, Fzoom               : integer;
    FCanClose               : Boolean;
    FDirTemp                : String;
    FConectado              : Boolean;
    FTimerConnect           : TUniTimer;
    FTimerMonitoring        : TUniTimer;
    FOnNotificationCenter   : TNotificationCenter;
//    FControlSend            : TControlSend;
    FCountBattery           : Integer;
    FCountBatteryMax        : Integer;
    FrmQRCode               : TFrmQRCode;
    FFormType               : TFormQrCodeType;
    FHeaderAtual            : TTypeHeader;
    FChatList               : TChatList;
    FMonitorLowBattry       : Boolean;
    FgettingContact         : Boolean;
    FgettingChats           : Boolean;
    FOnErrorInternal        : TOnErroInternal;
    FOwner                  : TComponent;
    Procedure ReleaseConnection;
    Procedure Int_FrmQRCodeClose(Sender: TObject);

    Function  GetAutoBatteryLeveL: Boolean;
    Procedure ISLoggedin;
    procedure ExecuteJS(PScript: WideString; PDirect:  Boolean = false; Purl:String = 'about:blank'; pStartline: integer=0);
    procedure ExecuteJSDir(PScript: WideString; Purl:String = 'about:blank'; pStartline: integer=0);

    procedure QRCodeForm_Start;
    procedure QRCodeWeb_Start;
    Procedure ResetEvents;
    procedure SetOwner(const Value: TComponent);
    Procedure SendNotificationCenterDirect(PValor: TTypeHeader; Const PSender : TObject= nil);

    Procedure Form_Start;
    Procedure Form_Normal;
  public
    { Public declarations }
    Function  ConfigureNetWork:Boolean;
    Procedure SetZoom(Pvalue: Integer);
    Property  Conectado: Boolean    Read FConectado;
    Property  OwnerForm: TComponent Read FOwner    Write SetOwner;
    Procedure StartQrCode(PQrCodeType :TFormQrCodeType; PViewForm:Boolean);
    Procedure StopQrCode(PQrCodeType: TFormQrCodeType);

    Property  FormQrCode      : TFrmQRCode                Read FrmQRCode;
    Property  ChatList        : TChatList                 Read FChatList;
    property  OnErrorInternal : TOnErroInternal           Read FOnErrorInternal           Write FOnErrorInternal;
    Property  MonitorLowBattry     : Boolean              Read FMonitorLowBattry          Write FMonitorLowBattry;
    Property  OnNotificationCenter : TNotificationCenter  Read FOnNotificationCenter      Write FOnNotificationCenter;
    Procedure Connect;
    Procedure DisConnect;
    procedure Send(vNum, vText:string);
    procedure SendContact(vNumDest, vNum:string);
    procedure SendBase64(vBase64, vNum, vFileName, vText:string);
    procedure SendLinkPreview(vNum, vLinkPreview, vText: string);
    procedure SendLocation(vNum, vLat, vLng, vText: string);
    procedure Logout();
    procedure ReloaderWeb;
    procedure StopWebBrowser;
    procedure GetAllContacts(PIgnorarLeitura1: Boolean = False);
    procedure GetAllChats;
    procedure GetUnreadMessages;
    procedure GetBatteryLevel;
    procedure CheckIsValidNumber(vNumber:string);
    procedure CheckIsConnected;
    procedure GetMyNumber;

    procedure CheckDelivered;

    //Para monitorar o qrcode via REST
    procedure ReadMessages(vID: string);
    procedure DeleteMessages(vID: string);
    procedure ReadMessagesAndDelete(vID: string);

    procedure StartMonitor(Seconds: Integer);
    procedure StopMonitor;
  end;

var
  FrmConsoleu: TFrmConsoleu;

implementation

uses
  System.NetEncoding, Vcl.Dialogs, uTInject.ConfigCEF, uTInject, uCEFMiscFunctions,
  Data.DB, uTInject.FrmConfigNetWork;

{$R *.dfm}

procedure TFrmConsoleu.App_EventMinimize(Sender: TObject);
begin
  Hide;
end;

procedure TFrmConsoleu.BrowserDestroyMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.Free;
  SleepNoFreeze(10);
  SendNotificationCenterDirect(Th_Disconnected);
  SleepNoFreeze(150);

  SendNotificationCenterDirect(Th_Destroying);
  SleepNoFreeze(10);
end;

procedure TFrmConsoleu.Button1Click(Sender: TObject);
begin
  ExecuteJS('var atual = 0;                                             '+
'var antigo = 0;                                                        '+
'var controle = 0;                                                      '+
'function init() {                                                      '+
'	var groupCount = window.setInterval(function() {                      '+
'		WAPI.getGroupParticipantIDs("558196302385-1580928258@g.us")         '+
'		.then( result =>                                                    '+
'		{if (result.length != antigo)                                       '+
'			{                                                                 '+
'				if (result.length < antigo) {                                   '+
'					window.WAPI.sendMessageToID("558196302385-1580928258@g.us", "🤖  👋🏻 *JA FOI TARDE!* \n\nTEMOS VAGAS NO GRUPO! '+
'https://chat.whatsapp.com/CEAX0vjsqpN1z9jzdeVUNm");  '+
'				} else {                                                                                                                                                               '+
'				window.WAPI.sendMessageToID("558196302385-1580928258@g.us", "🤖 *BEM VINDO NOVO PARTICIPANTE EU SOU O _THÍTTO_*! \n\nLEIAS AS REGRAS NA DESCRIÇÃO DO GRUPO\n\n*GITHUB* OFICIAL:  '+
'https://github.com/mikelustosa/Projeto-TInject\n\n*CURSOS* DO TINJECT: http://mikelustosa.kpages.online/tinject"); '+
'				}                                 '+
'				antigo = result.length;           '+
'                                         '+
'			} else {                            '+
'				antigo = result.length;           '+
'			}                                   '+
'	})                                      '+
'  .catch(error => JSON.stringify(error));'+
'    }, 5000);                            '+
'}                                        '+
'setTimeout(function() {                  '+
'    init();                              '+
'}, 5000);', false);
end;

procedure TFrmConsoleu.Button2Click(Sender: TObject);
begin
  Chromium1.LoadURL(FrmConsole_JS_URL);
end;

procedure TFrmConsoleu.WMMove(var aMessage : TWMMove);
begin
  inherited;
  if (Chromium1 <> nil) then
     Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TFrmConsoleu.WMMoving(var aMessage : TMessage);
begin
  inherited;
  if (Chromium1 <> nil) then
     Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TFrmConsoleu.WMSysCommand(var Message: TWMSysCommand);
begin
  if(Message.CmdType = SC_MINIMIZE)then
    Hide else
    inherited;
end;

procedure TFrmConsoleu.ExecuteJS(PScript: WideString;  PDirect:  Boolean; Purl:String; pStartline: integer);
var
  lThread : TThread;
begin
  if Assigned(GlobalCEFApp) then
  Begin
    if GlobalCEFApp.ErrorInt Then
       Exit;
  end;

  if not FConectado then
     raise Exception.Create(MSG_ConfigCEF_ExceptConnetServ);

  If Chromium1.Browser <> nil then
  begin
     if PDirect Then
     Begin
       Chromium1.Browser.MainFrame.ExecuteJavaScript(PScript, Purl, pStartline);
       Exit;
     end;

     lThread := TThread.CreateAnonymousThread(procedure
        begin
          TThread.Synchronize(nil, procedure
          begin
            if Assigned(FrmConsole) then
               FrmConsole.Chromium1.Browser.MainFrame.ExecuteJavaScript(PScript, Purl, pStartline)
          end);
        end);
     lThread.Start;
  end;
end;

procedure TFrmConsoleu.ExecuteJSDir(PScript: WideString; Purl: String; pStartline: integer);
begin
  Chromium1.Browser.MainFrame.ExecuteJavaScript(PScript, Purl, pStartline)
end;

procedure TFrmConsoleu.QRCodeWeb_Start;
begin
  ExecuteJS(FrmConsole_JS_WEBmonitorQRCode, False);
end;

procedure TFrmConsoleu.QRCodeForm_Start;
begin
  ExecuteJS(FrmConsole_JS_monitorQRCode, False );
end;

procedure TFrmConsoleu.OnTimerConnect(Sender: TObject);
var
  lNovoStatus: Boolean;
begin
  lNovoStatus            := True;
  FTimerConnect.Enabled  := False;
  try
    If TInject(FOwner).Status = Server_Connected then
    Begin
      ExecuteJSDir(TInject(FOwner).InjectJS.JSScript.Text);
      SleepNoFreeze(40);

      If Assigned(TInject(FOwner).OnAfterInjectJs) Then
         TInject(FOwner).OnAfterInjectJs(FOwner);

     //Auto monitorar mensagens não lidas
      StartMonitor(TInject(FOwner).Config.SecondsMonitor);
      SleepNoFreeze(40);

      lNovoStatus    := False;
      SendNotificationCenterDirect(Th_Initializing);
    End;
  finally
    FTimerConnect.Enabled := lNovoStatus;
  end;
end;

procedure TFrmConsoleu.OnTimerGetQrCode(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;
  try
    try
      if (FFormType in [Ft_Desktop, Ft_none]) Then
        QRCodeForm_Start else
        QRCodeWeb_Start;
    Except
    end;
  finally
    TTimer(Sender).Enabled := True;
  end;
end;

procedure TFrmConsoleu.OnTimerMonitoring(Sender: TObject);
begin
  //Testa se existe alguma desconexão por parte do aparelho...
  if Application.Terminated then
     Exit;

  FTimerMonitoring.Enabled := False;
  try
    if not TInject(FOwner).authenticated then
      Exit;

    If MonitorLowBattry THen
    Begin
      if GetAutoBatteryLeveL then
         GetBatteryLevel;
    End;

    //Falta implementar isso...]
    ISLoggedin;
  finally
    FTimerMonitoring.Enabled := FConectado;
  end;
end;

procedure TFrmConsoleu.ProcessPhoneBook(PCOmmand: String);
var
  LAllContacts : TRetornoAllContacts  ;
begin
  LAllContacts        := TRetornoAllContacts.Create(PCommand);
  try
    if Assigned(TInject(FOwner).OnGetAllContactList ) then
       TInject(FOwner).OnGetAllContactList(LAllContacts);
  finally
    FreeAndNil(LAllContacts);
  end;
end;

procedure TFrmConsoleu.ProcessQrCode(var pClass: TObject);
Var
   LResultQrCode   : TResultQRCodeClass   ;
begin
   //Retorno do CODIGO QRCODE..
   //Se a janela estiver aberta ele envia a imagem..
  if not (pClass is TQrCodeClass) then
     Exit;

  if (TQR_Http in TQrCodeClass(pClass).Tags) or (TQR_Img in TQrCodeClass(pClass).Tags) then
  Begin
    FrmQRCode.hide;
    Exit;
  End;

  try
    LResultQrCode := TResultQRCodeClass(TQrCodeClass(pClass).Result);
    //e difente.. portanto.. verificamos se existe imagem la no form.. se existir caimos fora!! se nao segue o fluxo
    if not LResultQrCode.AImageDif then
    Begin
      if FrmQRCode.Timg_QrCode.Picture <> nil Then
         Exit;
    End;
    LResultQrCode.InjectWorking := true;
    FrmQRCode.Timg_QrCode.Picture.Assign(LResultQrCode.AQrCodeImage);
    FrmQRCode.SetView(FrmQRCode.Timg_QrCode);
    If Assigned(TInject(FOwner).OnGetQrCode) then
       TInject(FOwner).OnGetQrCode(self, LResultQrCode);
  Except
    FrmQRCode.SetView(FrmQRCode.Timg_Animacao);
  end;
end;

procedure TFrmConsoleu.GetAllContacts(PIgnorarLeitura1: Boolean = False);
begin
  if PIgnorarLeitura1 then
  Begin
    ReleaseConnection;
    Exit;
  End;
  if FgettingContact then
     Exit;

  FgettingContact := True;
  FrmConsole.ExecuteJS(FrmConsole_JS_GetAllContacts, False);
end;

function TFrmConsoleu.GetAutoBatteryLeveL: Boolean;
begin
  Result        := False;
  if not FConectado then
     Exit;

  Inc(FCountBattery);
  if FCountBattery >  FCountBatteryMax then
  Begin
    Result        := true;
    FCountBattery := 0;
  End;
end;

procedure TFrmConsoleu.GetBatteryLevel;
begin
  ExecuteJS(FrmConsole_JS_GetBatteryLevel, False);
end;

procedure TFrmConsoleu.GetMyNumber;
begin
  ExecuteJS(FrmConsole_JS_GetMyNumber, False);
end;

procedure TFrmConsoleu.GetUnreadMessages;
begin
  ExecuteJS(FrmConsole_JS_GetUnreadMessages, False);
end;


procedure TFrmConsoleu.GetAllChats;
begin
  if FgettingChats then
     Exit;

  FgettingChats := True;
  FrmConsole.ExecuteJS(FrmConsole_JS_GetAllChats, False);
end;

procedure TFrmConsoleu.StartMonitor(Seconds: Integer);
var
  LJS: String;
begin
  LJS := FrmConsole_JS_VAR_StartMonitor;
  ExecuteJSDir(FrmConsole_JS_AlterVar(LJS, '#TEMPO#' , Seconds.ToString));
end;

procedure TFrmConsoleu.StartQrCode(PQrCodeType: TFormQrCodeType; PViewForm: Boolean);
begin
  FFormType := PQrCodeType;
  if PQrCodeType = Ft_Http then
  begin
    FrmQRCode.hide;
    SendNotificationCenterDirect(Th_ConnectingFt_HTTP);
    QRCodeWeb_Start;
    if PViewForm then
       Show;
  end Else
  Begin
    SleepNoFreeze(30);
    if PQrCodeType = Ft_None then
    Begin
      If not Assigned(TInject(FOwner).OnGetQrCode) then
        raise Exception.Create(MSG_ExceptNotAssignedOnGetQrCode);
    End;

    SendNotificationCenterDirect(Th_ConnectingFt_Desktop);
    if not FrmQRCode.Showing then
      FrmQRCode.ShowForm(PQrCodeType);
  end;
end;

procedure TFrmConsoleu.StopMonitor;
begin
  ExecuteJS(FrmConsole_JS_StopMonitor, true);
end;

procedure TFrmConsoleu.StopQrCode(PQrCodeType: TFormQrCodeType);
begin
  FrmQRCode.HIDE;
  if PQrCodeType = Ft_Http then
     DisConnect;
end;

procedure TFrmConsoleu.StopWebBrowser;
begin
  LPaginaId := 0;
  try
    StopMonitor;
  Except
  end;
  FTimerConnect.Enabled    := False;
  FTimerMonitoring.Enabled := False;
  Chromium1.StopLoad;
  Chromium1.Browser.StopLoad;

  SendNotificationCenterDirect(Th_Abort);
  LPaginaId := 0;
end;

procedure TFrmConsoleu.ReadMessages(vID: string);
var
  LJS: String;
begin
  LJS := FrmConsole_JS_VAR_ReadMessages;
  ExecuteJS(FrmConsole_JS_AlterVar(LJS, '#MSG_PHONE#' , Trim(vID)), False);
end;

procedure TFrmConsoleu.DeleteMessages(vID: string);
var
  LJS: String;
begin
  LJS := FrmConsole_JS_VAR_DeleteMessages;
  ExecuteJS(FrmConsole_JS_AlterVar(LJS, '#MSG_PHONE#', Trim(vID)), False);
end;

Procedure TFrmConsoleu.DisConnect;
begin
  try
    if not FConectado then
       Exit;

    try
      if Assigned(FrmQRCode) then
         FrmQRCode.FTimerGetQrCode.Enabled  := False;
    Except
      //Pode nao ter sido destruido na primeira tentativa
    end;

    FTimerConnect.Enabled      := False;
    FTimerMonitoring.Enabled   := False;
    try
      GlobalCEFApp.QuitMessageLoop;
      StopMonitor;
    Except
      //nao manda ERRO
    end;

    ClearLastQrcodeCtr;
    Chromium1.StopLoad;
    Chromium1.Browser.StopLoad;
    Chromium1.CloseBrowser(True);
    SleepNoFreeze(200);
    LPaginaId := 0;
  Except
  end;
  FConectado                       := False;
end;

//Marca como lida e deleta a conversa
procedure TFrmConsoleu.ReadMessagesAndDelete(vID: string);
begin
  ReadMessages  (Trim(vID));
  DeleteMessages(Trim(vID));
end;

procedure TFrmConsoleu.ReleaseConnection;
begin
//  if TInject(FOwner).Status <> Inject_Initialized then
//     Exit;
  FgettingContact := False;
  Application.ProcessMessages;
  SendNotificationCenterDirect(Th_Initialized);
end;

procedure TFrmConsoleu.ReloaderWeb;
begin
  if not FConectado then
     Exit;

  Chromium1.StopLoad;
  Chromium1.Browser.ReloadIgnoreCache;
end;

procedure TFrmConsoleu.RequestCloseInject(var aMessage: TMessage);
begin
  FCanClose := False;
  SendNotificationCenterDirect(Th_Disconnecting);

  ResetEvents;
  GlobalCEFApp.QuitMessageLoop;
  Visible  := False;
  DisConnect;
  Repeat
    SleepNoFreeze(20);
  Until FHeaderAtual = Th_Destroying;
  SleepNoFreeze(200);
  FCanClose := true;
  Close;
end;

procedure TFrmConsoleu.ResetEvents;
begin
  Chromium1.OnBeforeDownload        := nil;
  Chromium1.OnConsoleMessage        := nil;
  Chromium1.OnDownloadUpdated       := nil;
  Chromium1.OnLoadEnd               := nil;
  Chromium1.OnOpenUrlFromTab        := nil;
  Chromium1.OnDownloadImageFinished := nil;
  Chromium1.OnTextResultAvailable   := nil;
  Chromium1.OnTitleChange           := nil;
end;

procedure TFrmConsoleu.SendBase64(vBase64, vNum, vFileName, vText: string);
var
  Ljs, LLine: string;
  LBase64: TStringList;
  i: integer;
begin
  if not FConectado then
    raise Exception.Create(MSG_ConfigCEF_ExceptConnetServ);

  vText           := CaractersWeb(vText);
  vFileName       := ExtractFileName(vFileName); //AjustNameFile(vFileName) Alterado em 20/02/2020 by Lucas
  LBase64         := TStringList.Create;
  TRY
    LBase64.Text := vBase64;
    for i := 0 to LBase64.Count -1  do
       LLine := LLine + LBase64[i];
    vBase64 := LLine;

    LJS := FrmConsole_JS_VAR_SendTyping + FrmConsole_JS_VAR_SendBase64;
    FrmConsole_JS_AlterVar(LJS, '#MSG_PHONE#',       Trim(vNum));
    FrmConsole_JS_AlterVar(LJS, '#MSG_NOMEARQUIVO#', Trim(vFileName));
    FrmConsole_JS_AlterVar(LJS, '#MSG_CORPO#',       Trim(vText));
    FrmConsole_JS_AlterVar(LJS, '#MSG_BASE64#',      Trim(vBase64));
    ExecuteJS(LJS, True);
  FINALLY
    freeAndNil(LBase64);
  END;
end;

procedure TFrmConsoleu.SendContact(vNumDest, vNum: string);
var
  Ljs: string;
begin
  if not FConectado then
    raise Exception.Create(MSG_ConfigCEF_ExceptConnetServ);

  //vText := CaractersWeb(vText);
  LJS   := FrmConsole_JS_VAR_SendTyping + FrmConsole_JS_VAR_SendContact;
  FrmConsole_JS_AlterVar(LJS, '#MSG_PHONE_DEST#',       Trim(vNumDest));
  FrmConsole_JS_AlterVar(LJS, '#MSG_PHONE#',            Trim(vNum));
  ExecuteJS(LJS, true);
end;

procedure TFrmConsoleu.SendLinkPreview(vNum, vLinkPreview, vText: string);
var
  Ljs: string;
begin
  if not FConectado then
    raise Exception.Create(MSG_ConfigCEF_ExceptConnetServ);

  vText := CaractersWeb(vText);
  LJS   := FrmConsole_JS_VAR_SendTyping + FrmConsole_JS_VAR_SendLinkPreview;
  FrmConsole_JS_AlterVar(LJS, '#MSG_PHONE#',      Trim(vNum));
  FrmConsole_JS_AlterVar(LJS, '#MSG_LINK#',       Trim(vLinkPreview));
  FrmConsole_JS_AlterVar(LJS, '#MSG_CORPO#',      Trim(vText));
  ExecuteJS(LJS, true);
end;

procedure TFrmConsoleu.SendLocation(vNum, vLat, vLng, vText: string);
var
  Ljs: string;
begin
  if not FConectado then
    raise Exception.Create(MSG_ConfigCEF_ExceptConnetServ);

  vText := CaractersWeb(vText);
  LJS   := FrmConsole_JS_VAR_SendTyping + FrmConsole_JS_VAR_SendLocation;
  FrmConsole_JS_AlterVar(LJS, '#MSG_PHONE#',     Trim(vNum));
  FrmConsole_JS_AlterVar(LJS, '#MSG_LAT#',       Trim(vLat));
  FrmConsole_JS_AlterVar(LJS, '#MSG_LNG#',       Trim(vLng));
  FrmConsole_JS_AlterVar(LJS, '#MSG_CORPO#',     Trim(vText));
  ExecuteJS(LJS, true);
end;

procedure TFrmConsoleu.SetOwner(const Value: TComponent);
begin
  if FOwner = Value Then
     Exit;

  FOwner := Value;
  if FOwner = Nil then
     Exit;

  if (GlobalCEFApp = nil) or (TInject(FOwner).InjectJS.Ready = false) then
     raise Exception.Create(MSG_ExceptGlobalCef);
end;

procedure TFrmConsoleu.SetZoom(Pvalue: Integer);
var
  I: Integer;
begin
  if Pvalue = Fzoom then
     Exit;

  Fzoom  := Pvalue;
  Chromium1.ResetZoomStep;
  Pvalue := Pvalue * -1;
  for I := 0 to Pvalue-1 do
    Chromium1.DecZoomStep;
end;

procedure TFrmConsoleu.SendNotificationCenterDirect(PValor: TTypeHeader; Const PSender : TObject);
begin
  FHeaderAtual := PValor;
  If Assigned(OnNotificationCenter) then
     OnNotificationCenter(PValor, '', PSender);
  Application.ProcessMessages;
end;

procedure TFrmConsoleu.Send(vNum, vText: string);
var
  Ljs: string;
begin
  if not FConectado then
    raise Exception.Create(MSG_ConfigCEF_ExceptConnetServ);

  vText := CaractersWeb(vText);
  LJS   := FrmConsole_JS_VAR_SendTyping + FrmConsole_JS_VAR_SendMsg;
  FrmConsole_JS_AlterVar(LJS, '#MSG_PHONE#',       Trim(vNum));
  FrmConsole_JS_AlterVar(LJS, '#MSG_CORPO#',       Trim(vText));
  ExecuteJS(LJS, true);
end;


procedure TFrmConsoleu.WMEnterMenuLoop(var aMessage: TMessage);
begin
  inherited;
  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then
     GlobalCEFApp.OsmodalLoop := True;
end;

procedure TFrmConsoleu.WMExitMenuLoop(var aMessage: TMessage);
begin
  inherited;
  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then
     GlobalCEFApp.OsmodalLoop := False;
end;

procedure TFrmConsoleu.CEFSentinel1Close(Sender: TObject);
begin
//  FCanClose := True;
  PostMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure TFrmConsoleu.CheckIsValidNumber(vNumber: string);
var
  Ljs: string;
begin
  if not FConectado then
    raise Exception.Create(MSG_ConfigCEF_ExceptConnetServ);

  LJS   :=  FrmConsole_JS_VAR_CheckIsValidNumber;
  FrmConsole_JS_AlterVar(LJS, '#MSG_PHONE#', Trim(vNumber));
  ExecuteJS(LJS, False);
end;

procedure TFrmConsoleu.Chromium1AfterCreated(Sender: TObject;
  const browser: ICefBrowser);
begin
  { Agora que o navegador está totalmente inicializado, podemos enviar uma mensagem para
    o formulário principal para carregar a página inicial da web.}
  //PostMessage(Handle, CEFBROWSER_CREATED, 0, 0);
  FTimerConnect.Enabled  := True;
  PostMessage(Handle, CEF_AFTERCREATED, 0, 0);
end;

procedure TFrmConsoleu.Chromium1BeforeClose(Sender: TObject;
  const browser: ICefBrowser);
begin
  CEFSentinel1.Start;
end;

procedure TFrmConsoleu.Chromium1BeforeContextMenu(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);
begin
  Model.Clear;
end;

procedure TFrmConsoleu.Chromium1BeforeDownload(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const suggestedName: ustring; const callback: ICefBeforeDownloadCallback);
//Var
//  LNameFile : String;
begin
{
  if not(Chromium1.IsSameBrowser(browser)) or (downloadItem = nil) or not(downloadItem.IsValid) then
     Exit;

   LNameFile := FDownloadFila.SetNewStatus(downloadItem.OriginalUrl, TDw_Start);
   if LNameFile = '' Then
   Begin
     Chromium1.StopLoad;
     browser.StopLoad;
     exit;
   End;

   callback.cont(LNameFile, False);
}
end;

procedure TFrmConsoleu.Chromium1BeforePopup(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const targetUrl,
  targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
  userGesture: Boolean; const popupFeatures: TCefPopupFeatures;
  var windowInfo: TCefWindowInfo; var client: ICefClient;
  var settings: TCefBrowserSettings; var extra_info: ICefDictionaryValue;
  var noJavascriptAccess, Result: Boolean);
begin
// bloqueia todas as janelas pop-up e novas guias
  Result := (targetDisposition in [WOD_NEW_FOREGROUND_TAB, WOD_NEW_BACKGROUND_TAB, WOD_NEW_POPUP, WOD_NEW_WINDOW]);
end;

procedure TFrmConsoleu.Chromium1Close(Sender: TObject;
  const browser: ICefBrowser; var aAction: TCefCloseBrowserAction);
begin
  Chromium1.ShutdownDragAndDrop;
  PostMessage(Handle, CEF_DESTROY, 0, 0);
  aAction := cbaDelay;
end;

procedure TFrmConsoleu.ExecuteCommandConsole( const PResponse: TResponseConsoleMessage);
var
  LOutClass  : TObject;
  LClose     : Boolean;
  LResultStr : String;
begin
  //Nao veio nada
  if (PResponse.JsonString = '') or (PResponse.JsonString = FrmConsole_JS_RetornoVazio) Then
     Exit;

  if (PResponse.TypeHeader = Th_None) then
  Begin
    if LResultStr <> '' then
    Begin
      LogAdd(LResultStr, MSG_WarningClassUnknown);
      FOnErrorInternal(Self, MSG_ExceptJS_ABRUnknown, LResultStr);
    End;
    exit;
  End;

  //Nao veio nada
  LResultStr := PResponse.Result;
  if (LResultStr = FrmConsole_JS_RetornoVazio) Then
  Begin
     LogAdd(PResponse.JsonString, 'CONSOLE');
     Exit;
  End;

   If not (PResponse.TypeHeader in [Th_getQrCodeForm, Th_getQrCodeWEB]) Then
      FrmQRCode.Hide;

   Case PResponse.TypeHeader of
    Th_getAllContacts   : Begin
                            ProcessPhoneBook(LResultStr);
                            Exit;
                          End;

    Th_GetAllChats      : Begin
                            if Assigned(FChatList) then
                               FChatList.Free;

                            FChatList := TChatList.Create(LResultStr);
                            SendNotificationCenterDirect(PResponse.TypeHeader, FChatList);
                            FgettingChats := False;
                          End;

    Th_getUnreadMessages: begin
                            LOutClass := TChatList.Create(LResultStr);
                            try
                              SendNotificationCenterDirect(PResponse.TypeHeader, LOutClass);
                            finally
                              FreeAndNil(LOutClass);
                            end;
                            FgettingChats := False;
                          end;

//    Th_checkDelivered:    begin
//                            LOutClass := TResponseCheckDelivered.Create(LResultStr);
//                            //LOutClass := TChatList.Create(LResultStr);
//                            try
//                              SendNotificationCenterDirect(PResponse.TypeHeader, LOutClass);
//                            finally
//                              FreeAndNil(LOutClass);
//                            end;
//                            FgettingChats := False;
//                          end;


    Th_getQrCodeWEB,
    Th_getQrCodeForm :    Begin
                            LOutClass := TQrCodeClass.Create(PResponse.JsonString, [], []);
                            try
                              ProcessQrCode(LOutClass);
                              SendNotificationCenterDirect(Th_GetQrCodeWEB);
                            finally
                              FreeAndNil(LOutClass);
                            end;
                          End;


    Th_GetBatteryLevel  : begin
                            If Assigned(FOnNotificationCenter) Then
                            Begin
                              LOutClass := TResponseBattery.Create(LResultStr);
                              FOnNotificationCenter(PResponse.TypeHeader, TResponseBattery(LOutClass).Result);
                              FreeAndNil(LOutClass);
                            End;
                          end;

    Th_getMyNumber      : Begin
                            If Assigned(FOnNotificationCenter) Then
                            Begin
                              LOutClass := TResponseMyNumber.Create(LResultStr);
                              FOnNotificationCenter(PResponse.TypeHeader, TResponseMyNumber(LOutClass).Result);
                              FreeAndNil(LOutClass);
                            End;
                          End;


    Th_GetCheckIsValidNumber  : begin
                                  If Assigned(FOnNotificationCenter) Then
                                  Begin
                                    LOutClass := TResponseCheckIsValidNumber.Create(LResultStr);
                                    FOnNotificationCenter(PResponse.TypeHeader, '', LOutClass);
                                    FreeAndNil(LOutClass);
                                  End;
                                end;



    Th_GetCheckIsConnected : begin
                            If Assigned(FOnNotificationCenter) Then
                            Begin
                              LOutClass := TResponseCheckIsConnected.Create(LResultStr);
                              FOnNotificationCenter(PResponse.TypeHeader, '', LOutClass);
                              FreeAndNil(LOutClass);
                            End;
                          end;


    Th_OnChangeConnect  : begin
                            LOutClass := TOnChangeConnect.Create(LResultStr);
                            LClose    := TOnChangeConnect(LOutClass).Result;
                            FreeAndNil(LOutClass);

                            if not LClose Then
                            Begin
                              FTimerConnect.Enabled    := False;
                              FTimerMonitoring.Enabled := False;
                              ResetEvents;
                              FOnNotificationCenter(Th_ForceDisconnect, '');
                              Exit;
                            End;
                          end;
   end;
end;



procedure TFrmConsoleu.Chromium1ConsoleMessage(Sender: TObject;
  const browser: ICefBrowser; level: Cardinal; const message, source: ustring;
  line: Integer; out Result: Boolean);
var
  AResponse  : TResponseConsoleMessage;
begin
 //testa se e um JSON de forma RAPIDA!
  if (Copy(message, 0, 2) <> '{"') then
  Begin
    LogAdd(message, 'CONSOLE IGNORADO');
    Exit;
  End else
  Begin
    if (message = FrmConsole_JS_Ignorar) or (message = FrmConsole_JS_RetornoVazio)  then
       Exit;
  End;

//  LogAdd(message, 'CONSOLE');
  AResponse := TResponseConsoleMessage.Create( message );
  try
    if AResponse = nil then
       Exit;

    ExecuteCommandConsole(AResponse);
//    if Assigned(FControlSend) then
//       FControlSend.Release;
  finally
    FreeAndNil(AResponse);
  end;
end;


procedure TFrmConsoleu.Chromium1DownloadUpdated(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const callback: ICefDownloadItemCallback);
begin

 {
  if not(Chromium1.IsSameBrowser(browser)) then exit;
  if not Assigned(FDownloadFila) then Exit;

  if (not downloadItem.IsComplete) and (not downloadItem.IsCanceled) then
     Exit;

  try
   if downloadItem.IsComplete then
       FDownloadFila.SetNewStatus(downloadItem.Url, TDw_Completed) else
       FDownloadFila.SetNewStatus(downloadItem.Url, TDw_CanceledErro);
  Except
     on E : Exception do
        LogAdd(e.Message, 'ERROR DOWNLOAD ' + downloadItem.FullPath);
  end;
  }
end;

procedure TFrmConsoleu.Chromium1OpenUrlFromTab(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const targetUrl: ustring;
  targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
  out Result: Boolean);
begin
 //Bloqueia popup do windows e novas abas
  Result := (targetDisposition in [WOD_NEW_FOREGROUND_TAB, WOD_NEW_BACKGROUND_TAB, WOD_NEW_POPUP, WOD_NEW_WINDOW]);
end;

procedure TFrmConsoleu.Chromium1TitleChange(Sender: TObject;
  const browser: ICefBrowser; const title: ustring);
begin
  LPaginaId := LPaginaId + 1;
  if (LPaginaId > 3) and (LPaginaId < 10) then
  begin
    Form_Normal;
    If Assigned(OnNotificationCenter) then
       SendNotificationCenterDirect(Th_Connected);
  end;
  if (LPaginaId <= 3) and (FFormType = Ft_Http) then
    SetZoom(-2);
end;

function TFrmConsoleu.ConfigureNetWork: Boolean;
var
  lForm: TFrmConfigNetWork;
begin
  Result := True;
  lForm  := TFrmConfigNetWork.Create(nil);
  try
    case Chromium1.ProxyScheme of
      psSOCKS4 : lForm.ProxySchemeCb.ItemIndex := 1;
      psSOCKS5 : lForm.ProxySchemeCb.ItemIndex := 2;
      else       lForm.ProxySchemeCb.ItemIndex := 0;
    end;

    lForm.ProxyTypeCbx.ItemIndex           := Chromium1.ProxyType;
    lForm.ProxyServerEdt.Text              := Chromium1.ProxyServer;
    lForm.ProxyPortEdt.Text                := inttostr(Chromium1.ProxyPort);
    lForm.ProxyUsernameEdt.Text            := Chromium1.ProxyUsername;
    lForm.ProxyPasswordEdt.Text            := Chromium1.ProxyPassword;
    lForm.ProxyScriptURLEdt.Text           := Chromium1.ProxyScriptURL;
    lForm.ProxyByPassListEdt.Text          := Chromium1.ProxyByPassList;
    lForm.HeaderNameEdt.Text               := Chromium1.CustomHeaderName;
    lForm.HeaderValueEdt.Text              := Chromium1.CustomHeaderValue;
    lForm.MaxConnectionsPerProxyEdt.Value  := Chromium1.MaxConnectionsPerProxy;

    if (lForm.ShowModal = mrOk) then
    begin
      Chromium1.ProxyType              := lForm.ProxyTypeCbx.ItemIndex;
      Chromium1.ProxyServer            := lForm.ProxyServerEdt.Text;
      Chromium1.ProxyPort              := strtoint(lForm.ProxyPortEdt.Text);
      Chromium1.ProxyUsername          := lForm.ProxyUsernameEdt.Text;
      Chromium1.ProxyPassword          := lForm.ProxyPasswordEdt.Text;
      Chromium1.ProxyScriptURL         := lForm.ProxyScriptURLEdt.Text;
      Chromium1.ProxyByPassList        := lForm.ProxyByPassListEdt.Text;

      Chromium1.CustomHeaderName       := lForm.HeaderNameEdt.Text;
      Chromium1.CustomHeaderValue      := lForm.HeaderValueEdt.Text;
      Chromium1.MaxConnectionsPerProxy := lForm.MaxConnectionsPerProxyEdt.Value;

      case lForm.ProxySchemeCb.ItemIndex of
        1  : Chromium1.ProxyScheme := psSOCKS4;
        2  : Chromium1.ProxyScheme := psSOCKS5;
        else Chromium1.ProxyScheme := psHTTP;
      end;

      try
        Chromium1.UpdatePreferences;

        GlobalCEFApp.IniFIle.WriteInteger  ('Config NetWork', 'ProxyType',       Chromium1.ProxyType);
        GlobalCEFApp.IniFIle.WriteString   ('Config NetWork', 'ProxyServer',     Chromium1.ProxyServer);
        GlobalCEFApp.IniFIle.WriteString   ('Config NetWork', 'ProxyPort',       Chromium1.ProxyPort.ToString);
        GlobalCEFApp.IniFIle.WriteString   ('Config NetWork', 'ProxyUsername',   Chromium1.ProxyUsername);
        GlobalCEFApp.IniFIle.WriteString   ('Config NetWork', 'ProxyPassword',   Chromium1.ProxyPassword);
        GlobalCEFApp.IniFIle.WriteString   ('Config NetWork', 'ProxyScriptURL',  Chromium1.ProxyScriptURL);
        GlobalCEFApp.IniFIle.WriteString   ('Config NetWork', 'ProxyByPassList', Chromium1.ProxyByPassList);
        GlobalCEFApp.IniFIle.WriteString   ('Config NetWork', 'CustomHeaderName',  Chromium1.CustomHeaderName);
        GlobalCEFApp.IniFIle.WriteString   ('Config NetWork', 'CustomHeaderValue', Chromium1.CustomHeaderValue);
        GlobalCEFApp.IniFIle.WriteInteger  ('Config NetWork', 'MaxConnectionsPerProxy',  Chromium1.MaxConnectionsPerProxy);
        GlobalCEFApp.IniFIle.WriteInteger  ('Config NetWork', 'ProxyScheme',             lForm.ProxySchemeCb.ItemIndex);
        ReloaderWeb;
      Except
        Result := False;
      end;
    end;

  finally
    FreeAndNil(lForm);
  end;
end;

Procedure TFrmConsoleu.Connect;
var
  LInicio: Cardinal;
begin
  if Assigned(GlobalCEFApp) then
  Begin
    if GlobalCEFApp.ErrorInt Then
       Exit;
  end;

  try
    if FConectado then
       Exit;

    Form_Start;
    SendNotificationCenterDirect(Th_Connecting);
    LInicio    := GetTickCount;
    FConectado := Chromium1.CreateBrowser(CEFWindowParent1);
    Repeat
      FConectado := (Chromium1.Initialized);
      if not FConectado then
      Begin
        Sleep(10);
        Application.ProcessMessages;
        if (GetTickCount - LInicio) >= 15000 then
           Break;
      End;
    Until FConectado;
  finally
    FTimerMonitoring.Enabled  := FConectado;
    if not FConectado then
    begin
      SendNotificationCenterDirect(Th_Disconnected);
      raise Exception.Create(MSG_ConfigCEF_ExceptBrowse);
    end else
    begin
      Chromium1.OnConsoleMessage        := Chromium1ConsoleMessage;
      Chromium1.OnOpenUrlFromTab        := Chromium1OpenUrlFromTab;
      Chromium1.OnTitleChange           := Chromium1TitleChange;
    end;
  end;
end;

procedure TFrmConsoleu.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FCanClose Then
    action  := cafree else
    action  := caHide;
end;

procedure TFrmConsoleu.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := FCanClose;
  if not CanClose then
     Hide;
end;

procedure TFrmConsoleu.FormCreate(Sender: TObject);
var
  Lciclo: Integer;
  lBuffer : Array[0..144] of Char;
begin
  GetTempPath(144,lBuffer);
  FDirTemp  := IncludeTrailingPathDelimiter( StrPas(lBuffer));
  Fzoom     := 1;

  CEFWindowParent1.Visible  := True;
  CEFWindowParent1.Align    := alClient;
  FCanClose                 := False;
  FCountBattery             := 0;
//  FControlSend              := TControlSend.Create(Self);
  FrmQRCode                 := TFrmQRCode.Create(Self);
  FrmQRCode.CLoseForm       := Int_FrmQRCodeClose;
  FrmQRCode.FTimerGetQrCode.OnTimer := OnTimerGetQrCode;
  FrmQRCode.hide;


  GlobalCEFApp.Chromium     := Chromium1;
  Chromium1.DefaultURL      := FrmConsole_JS_URL;
  FTimerMonitoring          := TTimer.Create(nil);
  FTimerMonitoring.Interval := 1000 * 10;  //10 segundos..
  FTimerMonitoring.Enabled  := False;
  FTimerMonitoring.OnTimer  := OnTimerMonitoring;


  FTimerConnect             := TTimer.Create(nil);
  FTimerConnect.Interval    := 1000;
  FTimerConnect.Enabled     := False;
  FTimerConnect.OnTimer     := OnTimerConnect;

  //Pega Qntos ciclos o timer vai ser executado em um MINUTO...
  Lciclo                    := 60 div (FTimerMonitoring.Interval div 1000);
  FCountBatteryMax          := Lciclo * 3; //(Ser executado a +- cada 3minutos)

//Configuracao de proxy (nao testada)
//Carregar COnfiguraão de rede
//  Chromium1.ProxyType              := GlobalCEFApp.IniFIle.ReadInteger  ('Config NetWork', 'ProxyType',       0);
//  Chromium1.ProxyServer            := GlobalCEFApp.IniFIle.ReadString   ('Config NetWork', 'ProxyServer',     '');
//  Chromium1.ProxyPort              := GlobalCEFApp.IniFIle.ReadInteger  ('Config NetWork', 'ProxyPort',       80);
//  Chromium1.ProxyUsername          := GlobalCEFApp.IniFIle.ReadString   ('Config NetWork', 'ProxyUsername',   '');
//  Chromium1.ProxyPassword          := GlobalCEFApp.IniFIle.ReadString   ('Config NetWork', 'ProxyPassword',   '');
//  Chromium1.ProxyScriptURL         := GlobalCEFApp.IniFIle.ReadString   ('Config NetWork', 'ProxyScriptURL',  '');
//  Chromium1.ProxyByPassList        := GlobalCEFApp.IniFIle.ReadString   ('Config NetWork', 'ProxyByPassList', '');
//  Chromium1.CustomHeaderName       := GlobalCEFApp.IniFIle.ReadString   ('Config NetWork', 'CustomHeaderName',  '');
//  Chromium1.CustomHeaderValue      := GlobalCEFApp.IniFIle.ReadString   ('Config NetWork', 'CustomHeaderValue', '');
//  Chromium1.MaxConnectionsPerProxy := GlobalCEFApp.IniFIle.ReadInteger  ('Config NetWork', 'MaxConnectionsPerProxy',  32);
//  Lciclo                           := GlobalCEFApp.IniFIle.ReadInteger  ('Config NetWork', 'ProxyScheme',             0);
//  case Lciclo of
//    1  : Chromium1.ProxyScheme := psSOCKS4;
//    2  : Chromium1.ProxyScheme := psSOCKS5;
//    else Chromium1.ProxyScheme := psHTTP;
//  end;
//  Chromium1.UpdatePreferences;
end;

procedure TFrmConsoleu.FormDestroy(Sender: TObject);
begin
  if Assigned(FrmQRCode) then
  Begin
    FrmQRCode.PodeFechar := True;
//    FrmQRCode.close;
  End;

  if Assigned(FTimerMonitoring) then
  Begin
    FTimerMonitoring.Enabled  := False;
    FreeAndNil(FTimerMonitoring);
  End;

  if Assigned(FTimerConnect) then
  Begin
    FTimerConnect.Enabled  := False;
    FreeAndNil(FTimerConnect);
  End;
  SendNotificationCenterDirect(Th_Destroy);
end;


procedure TFrmConsoleu.FormShow(Sender: TObject);
begin
  Lbl_Caption.Caption      := Text_FrmConsole_Caption;
  Lbl_Versao.Caption       := 'V. ' + TInjectVersion;
end;

procedure TFrmConsoleu.Form_Normal;
begin
  SetZoom(TInject(FOwner).Config.Zoom);
  Pnl_Geral.Enabled        := true;
  Height                   := 605; //580
  Width                    := 1000; //680
  BorderStyle              := bsSizeable;
  LPaginaId                := 20;
end;

procedure TFrmConsoleu.Form_Start;
begin
  LPaginaId                := 0;
  Height                   := 605; //580
  Width                    := 1000; //680
  Pnl_Geral.Enabled        := True;
  BorderStyle              := bsDialog;
end;

procedure TFrmConsoleu.Int_FrmQRCodeClose(Sender: TObject);
begin
  if FFormType = Ft_Desktop then
    StopWebBrowser;
end;


procedure TFrmConsoleu.CheckDelivered;
begin
  ExecuteJS(FrmConsole_JS_CheckDelivered, False);
end;

procedure TFrmConsoleu.CheckIsConnected;
var
  Ljs: string;
begin
  ExecuteJS(FrmConsole_JS_VAR_IsConnected, False);
end;

Procedure TFrmConsoleu.ISLoggedin;
begin
  ExecuteJS(FrmConsole_JS_IsLoggedIn, false);
end;


procedure TFrmConsoleu.Lbl_VersaoMouseEnter(Sender: TObject);
const
  BYTES_PER_MEGABYTE = 1024 * 1024;
var
  LTempMessage : string;
begin
  LTempMessage := Text_System_memUse  + inttostr(GlobalCEFApp.UsedMemory            div BYTES_PER_MEGABYTE) + ' Mb' + #13 +
                  Text_System_memTot  + inttostr(GlobalCEFApp.TotalSystemMemory     div BYTES_PER_MEGABYTE) + ' Mb' + #13 +
                  Text_System_memFree + inttostr(GlobalCEFApp.AvailableSystemMemory div BYTES_PER_MEGABYTE) + ' Mb' + #13 +
                  Text_System_memFree + inttostr(GlobalCEFApp.SystemMemoryLoad) + ' %';
  Lbl_Versao.Hint := LTempMessage;
end;

procedure TFrmConsoleu.Logout;
var
  Ljs: string;
begin
  //if not FConectado then
  //  raise Exception.Create(MSG_ConfigCEF_ExceptConnetServ);

  LJS   := FrmConsole_JS_VAR_Logout;
  ExecuteJS(LJS, true);
end;

end.
