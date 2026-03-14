unit uFrmProdutos;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  FireDAC.Comp.Client, system.math, system.StrUtils;

type
  TFrmProdutos = class(TForm)
    pnlTopo: TPanel;         lblTitulo: TLabel;
    pnlFiltro: TPanel;
    edtFiltro: TEdit;        chkSoAtivos: TCheckBox;
    btnBuscar: TButton;      btnNovo: TButton;
    sgdLista: TStringGrid;
    pnlEdicao: TPanel;
    lblCodigo: TLabel;       edtCodigo: TEdit;
    lblCodBar: TLabel;       edtCodBar: TEdit;
    lblDesc: TLabel;         edtDesc: TEdit;
    lblDescComp: TLabel;     mmoDescComp: TMemo;
    lblCategoria: TLabel;    cboCategoria: TComboBox;
    lblUnidade: TLabel;      cboUnidade: TComboBox;
    lblPrecoCusto: TLabel;   edtPrecoCusto: TEdit;
    lblPrecoVenda: TLabel;   edtPrecoVenda: TEdit;
    lblMargem: TLabel;       lblMargemVal: TLabel;
    lblEstAtual: TLabel;     edtEstAtual: TEdit;
    lblEstMin: TLabel;       edtEstMin: TEdit;
    lblEstMax: TLabel;       edtEstMax: TEdit;
    lblNCM: TLabel;          edtNCM: TEdit;
    lblCFOP: TLabel;         edtCFOP: TEdit;
    lblAtivo: TLabel;        cboAtivo: TComboBox;
    lblObs: TLabel;          mmoObs: TMemo;
    btnSalvar: TButton;      btnExcluir: TButton;    btnCancelar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure sgdListaClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure edtPrecoVendaChange(Sender: TObject);
    procedure edtPrecoCustoChange(Sender: TObject);
  private
    FIDSelecionado: Integer;
    procedure CarregarLista;
    procedure ModoEdicao(AEditar: Boolean);
    procedure LimparEdicao;
    procedure AtualizarMargem;
    procedure PreencherGrid(Qry: TFDQuery);
  end;

implementation

{$R *.dfm}

uses uGlobal, uDMPrincipal;

procedure TFrmProdutos.FormCreate(Sender: TObject);
begin
  FIDSelecionado := 0;
  sgdLista.ColCount := 8; //sgdLista.FixedRows := 1;
  sgdLista.Options := sgdLista.Options + [goColSizing, goRowSelect];
  sgdLista.ColWidths[0]:=50; sgdLista.ColWidths[1]:=100;
  sgdLista.ColWidths[2]:=220; sgdLista.ColWidths[3]:=60;
  sgdLista.ColWidths[4]:=90; sgdLista.ColWidths[5]:=90;
  sgdLista.ColWidths[6]:=90; sgdLista.ColWidths[7]:=90;
  sgdLista.Cells[0,0]:='ID'; sgdLista.Cells[1,0]:='Código';
  sgdLista.Cells[2,0]:='Descrição'; sgdLista.Cells[3,0]:='UN';
  sgdLista.Cells[4,0]:='Preço Venda'; sgdLista.Cells[5,0]:='Estoque';
  sgdLista.Cells[6,0]:='Est.Mín'; sgdLista.Cells[7,0]:='Situação';
  DMPrincipal.CarregarUnidades(cboUnidade);
  DMPrincipal.CarregarCategorias(cboCategoria, 'P');
  cboAtivo.Items.CommaText := 'S,N';
  ModoEdicao(False);
  CarregarLista;
end;

procedure TFrmProdutos.CarregarLista;
var Qry: TFDQuery; W: string;
begin
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT P.ID,P.CODIGO,P.DESCRICAO,U.SIGLA,P.PRECO_VENDA,' +
      'P.ESTOQUE_ATUAL,P.ESTOQUE_MIN,P.ATIVO,' +
      'CASE WHEN P.ESTOQUE_ATUAL<=0 THEN ''SEM ESTOQUE'' ' +
      'WHEN P.ESTOQUE_ATUAL<P.ESTOQUE_MIN THEN ''ESTOQUE BAIXO'' ELSE ''NORMAL'' END AS SIT ' +
      'FROM PRODUTOS P LEFT JOIN UNIDADES U ON U.ID=P.ID_UNIDADE ';
    W := '';
    if chkSoAtivos.Checked then W := 'P.ATIVO=''S''';
    if Trim(edtFiltro.Text) <> '' then
    begin
      if W<>'' then W:=W+' AND ';
      W:=W+'(UPPER(P.DESCRICAO) CONTAINING UPPER(:F) OR P.CODIGO CONTAINING :F OR P.CODIGO_BARRAS CONTAINING :F)';
    end;
    if W<>'' then Qry.SQL.Add('WHERE '+W);
    Qry.SQL.Add('ORDER BY P.DESCRICAO');
    if Trim(edtFiltro.Text)<>'' then Qry.ParamByName('F').AsString := edtFiltro.Text;
    Qry.Open;
    PreencherGrid(Qry);
  finally Qry.Free; end;
end;

procedure TFrmProdutos.PreencherGrid(Qry: TFDQuery);
var R: Integer;
begin
  sgdLista.RowCount := Qry.RecordCount+1;
  R:=1; Qry.First;
  while not Qry.Eof do
  begin
    sgdLista.Cells[0,R]:=Qry.Fields[0].AsString;
    sgdLista.Cells[1,R]:=Qry.Fields[1].AsString;
    sgdLista.Cells[2,R]:=Qry.Fields[2].AsString;
    sgdLista.Cells[3,R]:=Qry.Fields[3].AsString;
    sgdLista.Cells[4,R]:=MoedaStr(Qry.Fields[4].AsFloat);
    sgdLista.Cells[5,R]:=QtdStr(Qry.Fields[5].AsFloat);
    sgdLista.Cells[6,R]:=QtdStr(Qry.Fields[6].AsFloat);
    sgdLista.Cells[7,R]:=Qry.Fields[8].AsString;
    Inc(R); Qry.Next;
  end;
  while R<=sgdLista.RowCount-1 do begin sgdLista.Rows[R].Clear; Inc(R); end;
end;

procedure TFrmProdutos.ModoEdicao(AEditar: Boolean);
begin
  pnlEdicao.Visible:=AEditar; btnNovo.Enabled:=not AEditar;
  btnBuscar.Enabled:=not AEditar; sgdLista.Enabled:=not AEditar;
end;

procedure TFrmProdutos.LimparEdicao;
begin
  FIDSelecionado:=0; edtCodigo.Text:=''; edtCodBar.Text:='';
  edtDesc.Text:=''; mmoDescComp.Lines.Clear;
  cboCategoria.ItemIndex:=0; cboUnidade.ItemIndex:=-1;
  edtPrecoCusto.Text:='0,00'; edtPrecoVenda.Text:='0,00';
  lblMargemVal.Caption:='0,00%';
  edtEstAtual.Text:='0,000'; edtEstMin.Text:='0,000'; edtEstMax.Text:='0,000';
  edtNCM.Text:=''; edtCFOP.Text:='';
  cboAtivo.ItemIndex:=0; mmoObs.Lines.Clear;
  btnExcluir.Enabled:=False;
end;

procedure TFrmProdutos.AtualizarMargem;
var Custo, Venda, Margem: Double;
begin
  Custo := StrToFloatDef(StringReplace(edtPrecoCusto.Text,',','.',[rfReplaceAll]),0);
  Venda := StrToFloatDef(StringReplace(edtPrecoVenda.Text,',','.',[rfReplaceAll]),0);
  if Custo > 0 then
    Margem := ((Venda - Custo) / Custo) * 100
  else Margem := 0;
  lblMargemVal.Caption := FormatFloat('0.00', Margem) + '%';
  {if Margem < 0 then lblMargemVal.Font.Color := clRed
  else if Margem < 10 then lblMargemVal.Font.Color := clOlive
  else lblMargemVal.Font.Color := clGreen;}
end;

procedure TFrmProdutos.edtPrecoVendaChange(Sender: TObject);
begin AtualizarMargem; end;

procedure TFrmProdutos.edtPrecoCustoChange(Sender: TObject);
begin AtualizarMargem; end;

procedure TFrmProdutos.btnBuscarClick(Sender: TObject);
begin CarregarLista; end;

procedure TFrmProdutos.btnNovoClick(Sender: TObject);
begin LimparEdicao; ModoEdicao(True); edtCodigo.SetFocus; end;

procedure TFrmProdutos.sgdListaClick(Sender: TObject);
var R,ID,I: Integer; Qry: TFDQuery;
begin
  R:=sgdLista.Row;
  if (R<1) or (sgdLista.Cells[0,R]='') then Exit;
  ID:=StrToIntDef(sgdLista.Cells[0,R],0);
  if ID=0 then Exit;
  Qry:=DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text:='SELECT * FROM PRODUTOS WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger:=ID; Qry.Open;
    if Qry.IsEmpty then Exit;
    FIDSelecionado:=ID;
    edtCodigo.Text    :=Qry.FieldByName('CODIGO').AsString;
    edtCodBar.Text    :=Qry.FieldByName('CODIGO_BARRAS').AsString;
    edtDesc.Text      :=Qry.FieldByName('DESCRICAO').AsString;
    mmoDescComp.Text  :=Qry.FieldByName('DESCRICAO_COMPLETA').AsString;
    edtPrecoCusto.Text:=FormatFloat('0.00',Qry.FieldByName('PRECO_CUSTO').AsFloat);
    edtPrecoVenda.Text:=FormatFloat('0.00',Qry.FieldByName('PRECO_VENDA').AsFloat);
    edtEstAtual.Text  :=FormatFloat('0.000',Qry.FieldByName('ESTOQUE_ATUAL').AsFloat);
    edtEstMin.Text    :=FormatFloat('0.000',Qry.FieldByName('ESTOQUE_MIN').AsFloat);
    edtEstMax.Text    :=FormatFloat('0.000',Qry.FieldByName('ESTOQUE_MAX').AsFloat);
    edtNCM.Text :=Qry.FieldByName('NCM').AsString;
    edtCFOP.Text:=Qry.FieldByName('CFOP').AsString;
    cboAtivo.ItemIndex:=cboAtivo.Items.IndexOf(Qry.FieldByName('ATIVO').AsString);
    mmoObs.Text:=Qry.FieldByName('OBS').AsString;
    for I:=0 to cboUnidade.Items.Count-1 do
      if Integer(cboUnidade.Items.Objects[I])=Qry.FieldByName('ID_UNIDADE').AsInteger then
        begin cboUnidade.ItemIndex:=I; Break; end;
    for I:=0 to cboCategoria.Items.Count-1 do
      if Integer(cboCategoria.Items.Objects[I])=Qry.FieldByName('ID_CATEGORIA').AsInteger then
        begin cboCategoria.ItemIndex:=I; Break; end;
    AtualizarMargem;
    btnExcluir.Enabled:=True; ModoEdicao(True); edtDesc.SetFocus;
  finally Qry.Free; end;
end;

procedure TFrmProdutos.btnSalvarClick(Sender: TObject);
var Qry: TFDQuery; IDUnid,IDCat: Integer; Custo,Venda,Margem: Double;
begin
  if Trim(edtCodigo.Text)='' then begin ShowMessage('Informe o código.'); Exit; end;
  if Trim(edtDesc.Text)=''   then begin ShowMessage('Informe a descrição.'); Exit; end;
  if cboUnidade.ItemIndex<0  then begin ShowMessage('Selecione a unidade.'); Exit; end;
  if DMPrincipal.ContarReg('PRODUTOS',
    'UPPER(CODIGO)=UPPER('''+edtCodigo.Text+''') AND ID<>'+IntToStr(FIDSelecionado))>0 then
  begin ShowMessage('Código já cadastrado!'); Exit; end;
  IDUnid:=Integer(cboUnidade.Items.Objects[cboUnidade.ItemIndex]);
  IDCat :=Integer(cboCategoria.Items.Objects[cboCategoria.ItemIndex]);
  Custo :=StrToFloatDef(StringReplace(edtPrecoCusto.Text,',','.',[rfReplaceAll]),0);
  Venda :=StrToFloatDef(StringReplace(edtPrecoVenda.Text,',','.',[rfReplaceAll]),0);
  Margem:=IfThen(Custo>0,((Venda-Custo)/Custo)*100,0);
  Qry:=DMPrincipal.NovaQuery;
  try
    DMPrincipal.IniciarTran;
    try
      if FIDSelecionado=0 then
        Qry.SQL.Text:=
          'INSERT INTO PRODUTOS (CODIGO,CODIGO_BARRAS,DESCRICAO,DESCRICAO_COMPLETA,' +
          'ID_CATEGORIA,ID_UNIDADE,PRECO_CUSTO,PRECO_VENDA,MARGEM_LUCRO,' +
          'ESTOQUE_ATUAL,ESTOQUE_MIN,ESTOQUE_MAX,NCM,CFOP,OBS,ATIVO) ' +
          'VALUES (:COD,:CB,:DESC,:DC,:CAT,:UNID,:PC,:PV,:ML,:EA,:EMIN,:EMAX,:NCM,:CFOP,:OBS,:AT) RETURNING ID'
      else
        Qry.SQL.Text:=
          'UPDATE PRODUTOS SET CODIGO=:COD,CODIGO_BARRAS=:CB,DESCRICAO=:DESC,DESCRICAO_COMPLETA=:DC,' +
          'ID_CATEGORIA=:CAT,ID_UNIDADE=:UNID,PRECO_CUSTO=:PC,PRECO_VENDA=:PV,MARGEM_LUCRO=:ML,' +
          'ESTOQUE_ATUAL=:EA,ESTOQUE_MIN=:EMIN,ESTOQUE_MAX=:EMAX,NCM=:NCM,CFOP=:CFOP,OBS=:OBS,ATIVO=:AT' +
          ' WHERE ID=:ID';
      Qry.ParamByName('COD').AsString :=edtCodigo.Text;
      Qry.ParamByName('CB').AsString  :=edtCodBar.Text;
      Qry.ParamByName('DESC').AsString:=edtDesc.Text;
      Qry.ParamByName('DC').AsString  :=mmoDescComp.Text;
      Qry.ParamByName('CAT').AsInteger:=IDCat;
      Qry.ParamByName('UNID').AsInteger:=IDUnid;
      Qry.ParamByName('PC').AsFloat   :=Custo;
      Qry.ParamByName('PV').AsFloat   :=Venda;
      Qry.ParamByName('ML').AsFloat   :=Margem;
      Qry.ParamByName('EA').AsFloat   :=StrToFloatDef(StringReplace(edtEstAtual.Text,',','.',[rfReplaceAll]),0);
      Qry.ParamByName('EMIN').AsFloat :=StrToFloatDef(StringReplace(edtEstMin.Text,',','.',[rfReplaceAll]),0);
      Qry.ParamByName('EMAX').AsFloat :=StrToFloatDef(StringReplace(edtEstMax.Text,',','.',[rfReplaceAll]),0);
      Qry.ParamByName('NCM').AsString :=edtNCM.Text;
      Qry.ParamByName('CFOP').AsString:=edtCFOP.Text;
      Qry.ParamByName('OBS').AsString :=mmoObs.Text;
      Qry.ParamByName('AT').AsString  :=cboAtivo.Items[cboAtivo.ItemIndex];
      if FIDSelecionado=0 then Qry.Open
      else begin Qry.ParamByName('ID').AsInteger:=FIDSelecionado; Qry.ExecSQL; end;
      DMPrincipal.CommitTran; ShowMessage(MSG_SALVO);
      ModoEdicao(False); LimparEdicao; CarregarLista;
    except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
  finally Qry.Free; end;
end;

procedure TFrmProdutos.btnExcluirClick(Sender: TObject);
begin
  if FIDSelecionado=0 then Exit;
  if DMPrincipal.ContarReg('VENDAS_ITENS','ID_PRODUTO='+IntToStr(FIDSelecionado))>0 then
  begin ShowMessage('Produto usado em vendas e não pode ser excluído!'); Exit; end;
  if MessageDlg(MSG_CONF_EXCLUIR,mtConfirmation,[mbYes,mbNo],0)<>mrYes then Exit;
  try
    DMPrincipal.IniciarTran;
    DMPrincipal.ExecSQL('DELETE FROM PRODUTOS WHERE ID='+IntToStr(FIDSelecionado));
    DMPrincipal.CommitTran; ShowMessage(MSG_EXCLUIDO);
    ModoEdicao(False); LimparEdicao; CarregarLista;
  except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
end;

procedure TFrmProdutos.btnCancelarClick(Sender: TObject);
begin ModoEdicao(False); LimparEdicao; end;

end.
