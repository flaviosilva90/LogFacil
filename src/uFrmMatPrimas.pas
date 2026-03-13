unit uFrmMatPrimas;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  FireDAC.Comp.Client;

type
  TFrmMatPrimas = class(TForm)
    pnlTopo: TPanel;         lblTitulo: TLabel;
    pnlFiltro: TPanel;
    edtFiltro: TEdit;        chkSoAtivos: TCheckBox;
    btnBuscar: TButton;      btnNovo: TButton;
    sgdLista: TStringGrid;
    pnlEdicao: TPanel;
    lblCodigo: TLabel;       edtCodigo: TEdit;
    lblDesc: TLabel;         edtDesc: TEdit;
    lblCategoria: TLabel;    cboCategoria: TComboBox;
    lblUnidade: TLabel;      cboUnidade: TComboBox;
    lblCustoMedio: TLabel;   edtCustoMedio: TEdit;
    lblEstAtual: TLabel;     edtEstAtual: TEdit;
    lblEstMin: TLabel;       edtEstMin: TEdit;
    lblEstMax: TLabel;       edtEstMax: TEdit;
    lblLocalizacao: TLabel;  edtLocalizacao: TEdit;
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
  private
    FIDSelecionado: Integer;
    procedure CarregarLista;
    procedure ModoEdicao(AEditar: Boolean);
    procedure LimparEdicao;
    procedure PreencherGrid(Qry: TFDQuery);
  end;

implementation

{$R *.dfm}

uses uGlobal, uDMPrincipal;

procedure TFrmMatPrimas.FormCreate(Sender: TObject);
begin
  FIDSelecionado := 0;
  sgdLista.ColCount := 7; sgdLista.FixedRows := 1;
  sgdLista.Options := sgdLista.Options + [goColSizing, goRowSelect];
  sgdLista.ColWidths[0]:=50; sgdLista.ColWidths[1]:=100;
  sgdLista.ColWidths[2]:=220; sgdLista.ColWidths[3]:=60;
  sgdLista.ColWidths[4]:=90; sgdLista.ColWidths[5]:=90; sgdLista.ColWidths[6]:=80;
  sgdLista.Cells[0,0]:='ID'; sgdLista.Cells[1,0]:='Código';
  sgdLista.Cells[2,0]:='Descrição'; sgdLista.Cells[3,0]:='UN';
  sgdLista.Cells[4,0]:='Estoque'; sgdLista.Cells[5,0]:='Est.Mín';
  sgdLista.Cells[6,0]:='Situação';
  DMPrincipal.CarregarUnidades(cboUnidade);
  DMPrincipal.CarregarCategorias(cboCategoria, 'M');
  cboAtivo.Items.CommaText := 'S,N';
  ModoEdicao(False);
  CarregarLista;
end;

procedure TFrmMatPrimas.CarregarLista;
var Qry: TFDQuery; W: string;
begin
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT MP.ID,MP.CODIGO,MP.DESCRICAO,U.SIGLA,' +
      'MP.ESTOQUE_ATUAL,MP.ESTOQUE_MIN,MP.ATIVO,' +
      'CASE WHEN MP.ESTOQUE_ATUAL<=0 THEN ''SEM ESTOQUE'' ' +
      'WHEN MP.ESTOQUE_ATUAL<MP.ESTOQUE_MIN THEN ''ESTOQUE BAIXO'' ELSE ''NORMAL'' END AS SIT ' +
      'FROM MAT_PRIMAS MP LEFT JOIN UNIDADES U ON U.ID=MP.ID_UNIDADE ';
    W := '';
    if chkSoAtivos.Checked then W := 'MP.ATIVO=''S''';
    if Trim(edtFiltro.Text) <> '' then
    begin
      if W<>'' then W:=W+' AND ';
      W:=W+'(UPPER(MP.DESCRICAO) CONTAINING UPPER(:F) OR MP.CODIGO CONTAINING :F)';
    end;
    if W <> '' then Qry.SQL.Add('WHERE '+W);
    Qry.SQL.Add('ORDER BY MP.DESCRICAO');
    if Trim(edtFiltro.Text)<>'' then Qry.ParamByName('F').AsString := edtFiltro.Text;
    Qry.Open;
    PreencherGrid(Qry);
  finally Qry.Free; end;
end;

procedure TFrmMatPrimas.PreencherGrid(Qry: TFDQuery);
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
    sgdLista.Cells[4,R]:=FormatFloat('0.###',Qry.Fields[4].AsFloat);
    sgdLista.Cells[5,R]:=FormatFloat('0.###',Qry.Fields[5].AsFloat);
    sgdLista.Cells[6,R]:=Qry.Fields[7].AsString;
    Inc(R); Qry.Next;
  end;
  while R<=sgdLista.RowCount-1 do begin sgdLista.Rows[R].Clear; Inc(R); end;
end;

procedure TFrmMatPrimas.ModoEdicao(AEditar: Boolean);
begin
  pnlEdicao.Visible:=AEditar; btnNovo.Enabled:=not AEditar;
  btnBuscar.Enabled:=not AEditar; sgdLista.Enabled:=not AEditar;
end;

procedure TFrmMatPrimas.LimparEdicao;
begin
  FIDSelecionado:=0; edtCodigo.Text:=''; edtDesc.Text:='';
  cboCategoria.ItemIndex:=0; cboUnidade.ItemIndex:=-1;
  edtCustoMedio.Text:='0,00'; edtEstAtual.Text:='0,000';
  edtEstMin.Text:='0,000'; edtEstMax.Text:='0,000';
  edtLocalizacao.Text:=''; cboAtivo.ItemIndex:=0; mmoObs.Lines.Clear;
  btnExcluir.Enabled:=False;
end;

procedure TFrmMatPrimas.btnBuscarClick(Sender: TObject);
begin CarregarLista; end;

procedure TFrmMatPrimas.btnNovoClick(Sender: TObject);
begin LimparEdicao; ModoEdicao(True); edtCodigo.SetFocus; end;

procedure TFrmMatPrimas.sgdListaClick(Sender: TObject);
var R,ID,I: Integer; Qry: TFDQuery;
begin
  R:=sgdLista.Row;
  if (R<1) or (sgdLista.Cells[0,R]='') then Exit;
  ID:=StrToIntDef(sgdLista.Cells[0,R],0);
  if ID=0 then Exit;
  Qry:=DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text:='SELECT * FROM MAT_PRIMAS WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger:=ID; Qry.Open;
    if Qry.IsEmpty then Exit;
    FIDSelecionado:=ID;
    edtCodigo.Text    :=Qry.FieldByName('CODIGO').AsString;
    edtDesc.Text      :=Qry.FieldByName('DESCRICAO').AsString;
    edtCustoMedio.Text:=FormatFloat('0.00',Qry.FieldByName('CUSTO_MEDIO').AsFloat);
    edtEstAtual.Text  :=FormatFloat('0.000',Qry.FieldByName('ESTOQUE_ATUAL').AsFloat);
    edtEstMin.Text    :=FormatFloat('0.000',Qry.FieldByName('ESTOQUE_MIN').AsFloat);
    edtEstMax.Text    :=FormatFloat('0.000',Qry.FieldByName('ESTOQUE_MAX').AsFloat);
    edtLocalizacao.Text:=Qry.FieldByName('LOCALIZACAO').AsString;
    cboAtivo.ItemIndex:=cboAtivo.Items.IndexOf(Qry.FieldByName('ATIVO').AsString);
    mmoObs.Text:=Qry.FieldByName('OBS').AsString;
    { Seleciona unidade pelo ID }
    for I:=0 to cboUnidade.Items.Count-1 do
      if Integer(cboUnidade.Items.Objects[I])=Qry.FieldByName('ID_UNIDADE').AsInteger then
        begin cboUnidade.ItemIndex:=I; Break; end;
    { Seleciona categoria pelo ID }
    for I:=0 to cboCategoria.Items.Count-1 do
      if Integer(cboCategoria.Items.Objects[I])=Qry.FieldByName('ID_CATEGORIA').AsInteger then
        begin cboCategoria.ItemIndex:=I; Break; end;
    btnExcluir.Enabled:=True; ModoEdicao(True); edtDesc.SetFocus;
  finally Qry.Free; end;
end;

procedure TFrmMatPrimas.btnSalvarClick(Sender: TObject);
var Qry: TFDQuery; IDUnid, IDCat: Integer;
begin
  if Trim(edtCodigo.Text)='' then begin ShowMessage('Informe o código.'); Exit; end;
  if Trim(edtDesc.Text)=''   then begin ShowMessage('Informe a descrição.'); Exit; end;
  if cboUnidade.ItemIndex<0  then begin ShowMessage('Selecione a unidade.'); Exit; end;
  IDUnid:=Integer(cboUnidade.Items.Objects[cboUnidade.ItemIndex]);
  IDCat :=Integer(cboCategoria.Items.Objects[cboCategoria.ItemIndex]);
  { Código único }
  if DMPrincipal.ContarReg('MAT_PRIMAS',
    'UPPER(CODIGO)=UPPER('''+edtCodigo.Text+''') AND ID<>'+IntToStr(FIDSelecionado))>0 then
  begin ShowMessage('Código já cadastrado!'); Exit; end;
  Qry:=DMPrincipal.NovaQuery;
  try
    DMPrincipal.IniciarTran;
    try
      if FIDSelecionado=0 then
        Qry.SQL.Text:=
          'INSERT INTO MAT_PRIMAS (CODIGO,DESCRICAO,ID_CATEGORIA,ID_UNIDADE,' +
          'CUSTO_MEDIO,ESTOQUE_ATUAL,ESTOQUE_MIN,ESTOQUE_MAX,LOCALIZACAO,OBS,ATIVO) ' +
          'VALUES (:COD,:DESC,:CAT,:UNID,:CM,:EA,:EMIN,:EMAX,:LOC,:OBS,:AT) RETURNING ID'
      else
        Qry.SQL.Text:=
          'UPDATE MAT_PRIMAS SET CODIGO=:COD,DESCRICAO=:DESC,ID_CATEGORIA=:CAT,' +
          'ID_UNIDADE=:UNID,CUSTO_MEDIO=:CM,ESTOQUE_ATUAL=:EA,ESTOQUE_MIN=:EMIN,' +
          'ESTOQUE_MAX=:EMAX,LOCALIZACAO=:LOC,OBS=:OBS,ATIVO=:AT WHERE ID=:ID';
      Qry.ParamByName('COD').AsString :=edtCodigo.Text;
      Qry.ParamByName('DESC').AsString:=edtDesc.Text;
      Qry.ParamByName('CAT').AsInteger:=IDCat;
      Qry.ParamByName('UNID').AsInteger:=IDUnid;
      Qry.ParamByName('CM').AsFloat  :=StrToFloatDef(StringReplace(edtCustoMedio.Text,',','.',[rfReplaceAll]),0);
      Qry.ParamByName('EA').AsFloat  :=StrToFloatDef(StringReplace(edtEstAtual.Text,',','.',[rfReplaceAll]),0);
      Qry.ParamByName('EMIN').AsFloat:=StrToFloatDef(StringReplace(edtEstMin.Text,',','.',[rfReplaceAll]),0);
      Qry.ParamByName('EMAX').AsFloat:=StrToFloatDef(StringReplace(edtEstMax.Text,',','.',[rfReplaceAll]),0);
      Qry.ParamByName('LOC').AsString:=edtLocalizacao.Text;
      Qry.ParamByName('OBS').AsString:=mmoObs.Text;
      Qry.ParamByName('AT').AsString :=cboAtivo.Items[cboAtivo.ItemIndex];
      if FIDSelecionado=0 then Qry.Open
      else begin Qry.ParamByName('ID').AsInteger:=FIDSelecionado; Qry.ExecSQL; end;
      DMPrincipal.CommitTran; ShowMessage(MSG_SALVO);
      ModoEdicao(False); LimparEdicao; CarregarLista;
    except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
  finally Qry.Free; end;
end;

procedure TFrmMatPrimas.btnExcluirClick(Sender: TObject);
begin
  if FIDSelecionado=0 then Exit;
  if DMPrincipal.ContarReg('COMPRAS_ITENS','ID_MAT_PRIMA='+IntToStr(FIDSelecionado))>0 then
  begin ShowMessage('Matéria-prima usada em compras e não pode ser excluída!'); Exit; end;
  if MessageDlg(MSG_CONF_EXCLUIR,mtConfirmation,[mbYes,mbNo],0)<>mrYes then Exit;
  try
    DMPrincipal.IniciarTran;
    DMPrincipal.ExecSQL('DELETE FROM MAT_PRIMAS WHERE ID='+IntToStr(FIDSelecionado));
    DMPrincipal.CommitTran; ShowMessage(MSG_EXCLUIDO);
    ModoEdicao(False); LimparEdicao; CarregarLista;
  except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
end;

procedure TFrmMatPrimas.btnCancelarClick(Sender: TObject);
begin ModoEdicao(False); LimparEdicao; end;

end.
