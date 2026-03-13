unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TFrmPrincipal = class(TForm)
    MainMenu: TMainMenu;
    mnuCadastros: TMenuItem;
    mnuUsuarios: TMenuItem;
    mnuClientes: TMenuItem;
    mnuFornecedores: TMenuItem;
    mnuMatPrimas: TMenuItem;
    mnuProdutos: TMenuItem;
    mnuMovimentos: TMenuItem;
    mnuCompras: TMenuItem;
    mnuVendas: TMenuItem;
    mnuEstoque: TMenuItem;
    mnuEstoqueProd: TMenuItem;
    mnuEstoqueMP: TMenuItem;
    mnuAjuste: TMenuItem;
    mnuSistema: TMenuItem;
    mnuSair: TMenuItem;
    StatusBar: TStatusBar;
    tmrRelogio: TTimer;
    pnlTopo: TPanel;
    lblBemVindo: TLabel;
    lblPerfil: TLabel;
    sep1: TMenuItem;
    sep2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmrRelogioTimer(Sender: TObject);
    procedure mnuUsuariosClick(Sender: TObject);
    procedure mnuClientesClick(Sender: TObject);
    procedure mnuFornecedoresClick(Sender: TObject);
    procedure mnuMatPrimasClick(Sender: TObject);
    procedure mnuProdutosClick(Sender: TObject);
    procedure mnuComprasClick(Sender: TObject);
    procedure mnuVendasClick(Sender: TObject);
    procedure mnuEstoqueProdClick(Sender: TObject);
    procedure mnuEstoqueMPClick(Sender: TObject);
    procedure mnuAjusteClick(Sender: TObject);
    procedure mnuSairClick(Sender: TObject);
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses
  uGlobal,
  uFrmUsuarios, uFrmClientes, uFrmFornecedores,
  uFrmMatPrimas, uFrmProdutos,
  uFrmCompras, uFrmVendas,
  uFrmEstoque,// uFrmAjusteEstoque,
  uFrmLogin;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  Caption := APP_NOME + ' - Sistema ERP';
  lblBemVindo.Caption := 'Bem-vindo, ' + SessaoNome;
  lblPerfil.Caption   := '[' + SessaoPerfil + ']';
  { Usuários visível somente para admin }
  mnuUsuarios.Visible := IsAdmin;
  StatusBar.Panels[0].Text := ' ' + APP_NOME + ' v' + APP_VERSAO;
  StatusBar.Panels[1].Text := ' Usuário: ' + SessaoLogin;
  tmrRelogio.Enabled := True;
end;

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  FrmLogin.Show;
end;

procedure TFrmPrincipal.tmrRelogioTimer(Sender: TObject);
begin
  StatusBar.Panels[2].Text := ' ' + FormatDateTime('dd/mm/yyyy  hh:nn:ss', Now);
end;

procedure TFrmPrincipal.mnuUsuariosClick(Sender: TObject);
begin
  with TFrmUsuarios.Create(Self) do
  try ShowModal; finally Free; end;
end;

procedure TFrmPrincipal.mnuClientesClick(Sender: TObject);
begin
  with TFrmClientes.Create(Self) do
  try ShowModal; finally Free; end;
end;

procedure TFrmPrincipal.mnuFornecedoresClick(Sender: TObject);
begin
  with TFrmFornecedores.Create(Self) do
  try ShowModal; finally Free; end;
end;

procedure TFrmPrincipal.mnuMatPrimasClick(Sender: TObject);
begin
  with TFrmMatPrimas.Create(Self) do
  try ShowModal; finally Free; end;
end;

procedure TFrmPrincipal.mnuProdutosClick(Sender: TObject);
begin
  with TFrmProdutos.Create(Self) do
  try ShowModal; finally Free; end;
end;

procedure TFrmPrincipal.mnuComprasClick(Sender: TObject);
begin
  with TFrmCompras.Create(Self) do
  try ShowModal; finally Free; end;
end;

procedure TFrmPrincipal.mnuVendasClick(Sender: TObject);
begin
  with TFrmVendas.Create(Self) do
  try ShowModal; finally Free; end;
end;

procedure TFrmPrincipal.mnuEstoqueProdClick(Sender: TObject);
begin
  with TFrmEstoque.Create(Self) do
  begin
    TipoEstoque := 'P';
    try ShowModal; finally Free; end;
  end;
end;

procedure TFrmPrincipal.mnuEstoqueMPClick(Sender: TObject);
begin
  with TFrmEstoque.Create(Self) do
  begin
    TipoEstoque := 'M';
    try ShowModal; finally Free; end;
  end;
end;

procedure TFrmPrincipal.mnuAjusteClick(Sender: TObject);
begin
 // with TFrmAjusteEstoque.Create(Self) do
 // try ShowModal; finally Free; end;
end;

procedure TFrmPrincipal.mnuSairClick(Sender: TObject);
begin
  Close;
end;

end.
