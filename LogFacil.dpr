program LogFacil;

uses
  Vcl.Forms,
  uDMPrincipal      in 'src\uDMPrincipal.pas'      {DMPrincipal: TDataModule},
  uGlobal           in 'src\uGlobal.pas',
  uFrmLogin         in 'src\uFrmLogin.pas'          {FrmLogin},
  uFrmPrincipal     in 'src\uFrmPrincipal.pas'      {FrmPrincipal},
  uFrmUsuarios      in 'src\uFrmUsuarios.pas'        {FrmUsuarios},
  uFrmClientes      in 'src\uFrmClientes.pas'        {FrmClientes},
  uFrmFornecedores  in 'src\uFrmFornecedores.pas'   {FrmFornecedores},
  uFrmMatPrimas     in 'src\uFrmMatPrimas.pas'       {FrmMatPrimas},
  uFrmProdutos      in 'src\uFrmProdutos.pas'        {FrmProdutos},
  uFrmOrcamentos    in 'src\uFrmOrcamentos.pas'      {FrmOrcamentos},
  uFrmCompras       in 'src\uFrmCompras.pas'         {FrmCompras},
  uFrmVendas        in 'src\uFrmVendas.pas'          {FrmVendas},
  uFrmImportNFXML   in 'src\uFrmImportNFXML.pas'    {FrmImportNFXML},
  uFrmNFSaida       in 'src\uFrmNFSaida.pas'         {FrmNFSaida},
  uFrmEstoque       in 'src\uFrmEstoque.pas'         {FrmEstoque},
  uFrmAjusteEstoque in 'src\uFrmAjusteEstoque.pas'  {FrmAjusteEstoque},
  uFrmContasPagar   in 'src\uFrmContasPagar.pas'    {FrmContasPagar},
  uFrmContasReceber in 'src\uFrmContasReceber.pas'  {FrmContasReceber},
  uFrmFluxoCaixa    in 'src\uFrmFluxoCaixa.pas'     {FrmFluxoCaixa};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'LogF'#225'cil ERP v3.0';
  Application.CreateForm(TDMPrincipal, DMPrincipal);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.
