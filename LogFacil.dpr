program LogFacil;

uses
  Vcl.Forms,
  uDMPrincipal  in 'src\uDMPrincipal.pas'  {DMPrincipal: TDataModule},
  uFrmLogin     in 'src\uFrmLogin.pas'     {FrmLogin},
  uFrmPrincipal in 'src\uFrmPrincipal.pas' {FrmPrincipal},
  uFrmUsuarios  in 'src\uFrmUsuarios.pas'  {FrmUsuarios},
  uFrmClientes  in 'src\uFrmClientes.pas'  {FrmClientes},
  uFrmFornecedores in 'src\uFrmFornecedores.pas' {FrmFornecedores},
  uFrmMatPrimas in 'src\uFrmMatPrimas.pas' {FrmMatPrimas},
  uFrmProdutos  in 'src\uFrmProdutos.pas'  {FrmProdutos},
  uFrmCompras   in 'src\uFrmCompras.pas'   {FrmCompras},
  uFrmVendas    in 'src\uFrmVendas.pas'    {FrmVendas},
  uFrmEstoque   in 'src\uFrmEstoque.pas'   {FrmEstoque},
  uFrmAjusteEstoque in 'src\uFrmAjusteEstoque.pas' {FrmAjusteEstoque},
  uGlobal       in 'src\uGlobal.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'LogFácil - Sistema ERP';
  Application.CreateForm(TDMPrincipal, DMPrincipal);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.
