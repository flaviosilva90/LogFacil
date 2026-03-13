unit uFrmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Imaging.jpeg;

type
  TFrmLogin = class(TForm)
    pnlFundo: TPanel;
    pnlCard: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    lblLogin: TLabel;
    edtLogin: TEdit;
    lblSenha: TLabel;
    edtSenha: TEdit;
    btnEntrar: TButton;
    lblVersao: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnEntrarClick(Sender: TObject);
    procedure edtSenhaKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    FTentativas: Integer;
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

uses uGlobal, uDMPrincipal, uFrmPrincipal;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  FTentativas := 0;
  Caption := APP_NOME + ' - Login';
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  edtLogin.SetFocus;
  edtLogin.Text := '';
  edtSenha.Text := '';
end;

procedure TFrmLogin.edtSenhaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then btnEntrarClick(nil);
end;

procedure TFrmLogin.btnEntrarClick(Sender: TObject);
begin
  if Trim(edtLogin.Text) = '' then
  begin
    ShowMessage('Informe o login!');
    edtLogin.SetFocus;
    Exit;
  end;
  if Trim(edtSenha.Text) = '' then
  begin
    ShowMessage('Informe a senha!');
    edtSenha.SetFocus;
    Exit;
  end;

  try
    if not DMPrincipal.Conectado then
      if not DMPrincipal.Conectar then
      begin
        ShowMessage(MSG_LOGIN_INVALIDO);
        Exit;
      end;

    if DMPrincipal.Autenticar(Trim(edtLogin.Text), edtSenha.Text) then
    begin
      FTentativas := 0;
      FrmPrincipal := TFrmPrincipal.Create(Application);
      FrmPrincipal.Show;
      Hide;
    end
    else
    begin
      Inc(FTentativas);
      ShowMessage(MSG_LOGIN_INVALIDO);
      edtSenha.Text := '';
      edtLogin.SetFocus;
      if FTentativas >= 5 then
        Application.Terminate;
    end;
  except
    on E: Exception do
      ShowMessage('Erro: ' + E.Message);
  end;
end;

end.
