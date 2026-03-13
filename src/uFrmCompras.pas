unit uFrmCompras;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
  FireDAC.Comp.Client, system.Math, system.StrUtils;

type
  TFrmCompras = class(TForm)
    { ── Painel superior ── }
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    { ── Filtro / Lista ── }
    pnlFiltro: TPanel;
    edtFiltro: TEdit;
    cboStatus: TComboBox;
    btnBuscar: TButton;
    btnNova: TButton;
    sgdLista: TStringGrid;
    { ── Painel de edição ── }
    pnlEdicao: TPanel;
    { Cabeçalho }
    lblNumero: TLabel;     edtNumero: TEdit;
    lblFornec: TLabel;     edtFornecID: TEdit;   edtFornecNome: TEdit;   btnBuscarFornec: TButton;
    lblEmissao: TLabel;    edtEmissao: TDateTimePicker;
    lblPrevisao: TLabel;   edtPrevisao: TDateTimePicker;
    lblStatus: TLabel;     edtStatusLabel: TEdit;
    lblNF: TLabel;         edtNF: TEdit;
    lblSerie: TLabel;      edtSerie: TEdit;
    lblCondPagto: TLabel;  edtCondPagto: TEdit;
    lblObs: TLabel;        mmoObs: TMemo;
    { Grid de itens }
    lblItens: TLabel;
    sgdItens: TStringGrid;
    { Linha de adição de item }
    pnlAddItem: TPanel;
    lblAddMP: TLabel;       edtAddMPID: TEdit;    edtAddMPNome: TEdit;   btnBuscarMP: TButton;
    lblAddQtd: TLabel;      edtAddQtd: TEdit;
    lblAddVlUnit: TLabel;   edtAddVlUnit: TEdit;
    lblAddDesc: TLabel;     edtAddDesc: TEdit;
    btnAddItem: TButton;
    btnRemItem: TButton;
    { Totais }
    pnlTotais: TPanel;
    lblFrete: TLabel;       edtFrete: TEdit;
    lblDescGlobal: TLabel;  edtDescGlobal: TEdit;
    lblTotalLabel: TLabel;  edtTotal: TEdit;
    { Botões de ação }
    pnlBotoes: TPanel;
    btnSalvar: TButton;
    btnConfirmar: TButton;
    btnReceber: TButton;
    btnCancelarDoc: TButton;
    btnFechar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnNovaClick(Sender: TObject);
    procedure sgdListaClick(Sender: TObject);
    procedure btnBuscarFornecClick(Sender: TObject);
    procedure btnBuscarMPClick(Sender: TObject);
    procedure btnAddItemClick(Sender: TObject);
    procedure btnRemItemClick(Sender: TObject);
    procedure edtFreteChange(Sender: TObject);
    procedure edtDescGlobalChange(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnReceberClick(Sender: TObject);
    procedure btnCancelarDocClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
  private
    FIDSelecionado: Integer;
    FStatusAtual: string;
    procedure ModoEdicao(AEditar: Boolean);
    procedure LimparEdicao;
    procedure CarregarLista;
    procedure CarregarItens(AIDCompra: Integer);
    procedure RecalcularTotais;
    procedure AlterarStatus(const ANovoStatus: string);
    procedure AtualizarBotoes;
    procedure PreencherGridLista(Qry: TFDQuery);
  end;

implementation

{$R *.dfm}

uses uGlobal, uDMPrincipal;

procedure TFrmCompras.FormCreate(Sender: TObject);
begin
  FIDSelecionado := 0;
  FStatusAtual := '';
  { Grid lista }
  sgdLista.ColCount := 8; //sgdLista.FixedRows := 1;
  sgdLista.Options := sgdLista.Options + [goColSizing, goRowSelect];
  sgdLista.ColWidths[0]:=50; sgdLista.ColWidths[1]:=60;
  sgdLista.ColWidths[2]:=220; sgdLista.ColWidths[3]:=90;
  sgdLista.ColWidths[4]:=90; sgdLista.ColWidths[5]:=90;
  sgdLista.ColWidths[6]:=90; sgdLista.ColWidths[7]:=100;
  sgdLista.Cells[0,0]:='ID';    sgdLista.Cells[1,0]:='Nº';
  sgdLista.Cells[2,0]:='Fornecedor'; sgdLista.Cells[3,0]:='Emissão';
  sgdLista.Cells[4,0]:='Previsão';   sgdLista.Cells[5,0]:='Total';
  sgdLista.Cells[6,0]:='Status';     sgdLista.Cells[7,0]:='NF';
  { Grid itens }
  sgdItens.ColCount := 7; //sgdItens.FixedRows := 1;
  sgdItens.Options := sgdItens.Options + [goColSizing, goRowSelect];
  sgdItens.ColWidths[0]:=40; sgdItens.ColWidths[1]:=60;
  sgdItens.ColWidths[2]:=240; sgdItens.ColWidths[3]:=60;
  sgdItens.ColWidths[4]:=80; sgdItens.ColWidths[5]:=80; sgdItens.ColWidths[6]:=90;
  sgdItens.Cells[0,0]:='#'; sgdItens.Cells[1,0]:='ID MP';
  sgdItens.Cells[2,0]:='Matéria-Prima'; sgdItens.Cells[3,0]:='UN';
  sgdItens.Cells[4,0]:='Qtd'; sgdItens.Cells[5,0]:='Vl.Unit';
  sgdItens.Cells[6,0]:='Total';
  { ComboBox status filtro }
  cboStatus.Items.Add('(Todos)');
  cboStatus.Items.Add(STC_PENDENTE);
  cboStatus.Items.Add(STC_CONFIRMADA);
  cboStatus.Items.Add(STC_RECEBIDA);
  cboStatus.Items.Add(STC_CANCELADA);
  cboStatus.ItemIndex := 0;
  ModoEdicao(False);
  CarregarLista;
end;

procedure TFrmCompras.CarregarLista;
var Qry: TFDQuery; W: string;
begin
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT C.ID, C.NUMERO, F.NOME AS FORNECEDOR, C.DT_EMISSAO, ' +
      'C.DT_PREVISAO, C.VL_TOTAL, C.STATUS, C.NF_NUMERO ' +
      'FROM COMPRAS C JOIN FORNECEDORES F ON F.ID=C.ID_FORNECEDOR ';
    W := '';
    if (cboStatus.ItemIndex > 0) then
      W := 'C.STATUS=''' + cboStatus.Items[cboStatus.ItemIndex] + '''';
    if Trim(edtFiltro.Text) <> '' then
    begin
      if W<>'' then W:=W+' AND ';
      W:=W+'(UPPER(F.NOME) CONTAINING UPPER(:F) OR CAST(C.NUMERO AS VARCHAR(10)) CONTAINING :F)';
    end;
    if W<>'' then Qry.SQL.Add('WHERE '+W);
    Qry.SQL.Add('ORDER BY C.NUMERO DESC');
    if Trim(edtFiltro.Text)<>'' then Qry.ParamByName('F').AsString:=edtFiltro.Text;
    Qry.Open;
    PreencherGridLista(Qry);
  finally Qry.Free; end;
end;

procedure TFrmCompras.PreencherGridLista(Qry: TFDQuery);
var R: Integer;
begin
  sgdLista.RowCount := Qry.RecordCount+1;
  R:=1; Qry.First;
  while not Qry.Eof do
  begin
    sgdLista.Cells[0,R]:=Qry.Fields[0].AsString;
    sgdLista.Cells[1,R]:=Qry.Fields[1].AsString;
    sgdLista.Cells[2,R]:=Qry.Fields[2].AsString;
    sgdLista.Cells[3,R]:=FormatDateTime('dd/mm/yyyy',Qry.Fields[3].AsDateTime);
    sgdLista.Cells[4,R]:=IfThen(Qry.Fields[4].IsNull,'',FormatDateTime('dd/mm/yyyy',Qry.Fields[4].AsDateTime));
    sgdLista.Cells[5,R]:=MoedaStr(Qry.Fields[5].AsFloat);
    sgdLista.Cells[6,R]:=Qry.Fields[6].AsString;
    sgdLista.Cells[7,R]:=Qry.Fields[7].AsString;
    Inc(R); Qry.Next;
  end;
  while R<=sgdLista.RowCount-1 do begin sgdLista.Rows[R].Clear; Inc(R); end;
end;

procedure TFrmCompras.CarregarItens(AIDCompra: Integer);
var Qry: TFDQuery; R: Integer;
begin
  sgdItens.RowCount := 2;
  for R:=1 to sgdItens.RowCount-1 do sgdItens.Rows[R].Clear;
  if AIDCompra=0 then Exit;
  Qry:=DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text:=
      'SELECT CI.ITEM, CI.ID_MAT_PRIMA, MP.DESCRICAO, U.SIGLA, ' +
      'CI.QUANTIDADE, CI.VL_UNITARIO, CI.VL_TOTAL ' +
      'FROM COMPRAS_ITENS CI ' +
      'JOIN MAT_PRIMAS MP ON MP.ID=CI.ID_MAT_PRIMA ' +
      'JOIN UNIDADES U ON U.ID=MP.ID_UNIDADE ' +
      'WHERE CI.ID_COMPRA=:ID ORDER BY CI.ITEM';
    Qry.ParamByName('ID').AsInteger:=AIDCompra;
    Qry.Open;
    if Qry.IsEmpty then Exit;
    sgdItens.RowCount:=Qry.RecordCount+1;
    R:=1; Qry.First;
    while not Qry.Eof do
    begin
      sgdItens.Cells[0,R]:=Qry.Fields[0].AsString;
      sgdItens.Cells[1,R]:=Qry.Fields[1].AsString;
      sgdItens.Cells[2,R]:=Qry.Fields[2].AsString;
      sgdItens.Cells[3,R]:=Qry.Fields[3].AsString;
      sgdItens.Cells[4,R]:=FormatFloat('0.###',Qry.Fields[4].AsFloat);
      sgdItens.Cells[5,R]:=MoedaStr(Qry.Fields[5].AsFloat);
      sgdItens.Cells[6,R]:=MoedaStr(Qry.Fields[6].AsFloat);
      Inc(R); Qry.Next;
    end;
  finally Qry.Free; end;
end;

procedure TFrmCompras.RecalcularTotais;
var R: Integer; VlProd,Frete,Desc,Total: Double;
begin
  VlProd:=0;
  for R:=1 to sgdItens.RowCount-1 do
    if sgdItens.Cells[0,R]<>'' then
      VlProd:=VlProd+StrMoeda(sgdItens.Cells[6,R]);
  Frete:=StrMoeda(edtFrete.Text);
  Desc :=StrMoeda(edtDescGlobal.Text);
  Total:=VlProd+Frete-Desc;
  if Total<0 then Total:=0;
  edtTotal.Text:=MoedaStr(Total);
end;

procedure TFrmCompras.ModoEdicao(AEditar: Boolean);
begin
  pnlEdicao.Visible := AEditar;
  pnlFiltro.Enabled := not AEditar;
  sgdLista.Enabled  := not AEditar;
  btnNova.Enabled   := not AEditar;
end;

procedure TFrmCompras.LimparEdicao;
var R: Integer;
begin
  FIDSelecionado:=0; FStatusAtual:='';
  edtNumero.Text:='(automático)';
  edtFornecID.Text:=''; edtFornecNome.Text:='';
  edtEmissao.Date:=Date; edtPrevisao.Date:=Date+7;
  edtStatusLabel.Text:='PENDENTE';
  edtNF.Text:=''; edtSerie.Text:=''; edtCondPagto.Text:=''; mmoObs.Lines.Clear;
  sgdItens.RowCount:=2;
  for R:=1 to sgdItens.RowCount-1 do sgdItens.Rows[R].Clear;
  edtAddMPID.Text:=''; edtAddMPNome.Text:='';
  edtAddQtd.Text:='1,000'; edtAddVlUnit.Text:='0,00'; edtAddDesc.Text:='0,00';
  edtFrete.Text:='0,00'; edtDescGlobal.Text:='0,00'; edtTotal.Text:='0,00';
  AtualizarBotoes;
end;

procedure TFrmCompras.AtualizarBotoes;
var EhNovo, EdicaoAtiva: Boolean;
begin
  EhNovo       := FIDSelecionado=0;
  EdicaoAtiva  := pnlEdicao.Visible;
  btnSalvar.Enabled      := EdicaoAtiva and ((FStatusAtual='') or (FStatusAtual=STC_PENDENTE) or (FStatusAtual=STC_CONFIRMADA));
  btnConfirmar.Enabled   := EdicaoAtiva and (FStatusAtual=STC_PENDENTE);
  btnReceber.Enabled     := EdicaoAtiva and (FStatusAtual=STC_CONFIRMADA);
  btnCancelarDoc.Enabled := EdicaoAtiva and ((FStatusAtual=STC_PENDENTE) or (FStatusAtual=STC_CONFIRMADA));
  { Campos editáveis somente em PENDENTE ou novo }
  edtFornecID.ReadOnly   := not(EhNovo) or (FStatusAtual=STC_PENDENTE);
  edtFornecNome.ReadOnly := not(EhNovo) or (FStatusAtual=STC_PENDENTE);
  edtAddMPID.ReadOnly    := not(EhNovo) or (FStatusAtual=STC_PENDENTE);
  btnBuscarMP.Enabled    := EhNovo or (FStatusAtual=STC_PENDENTE);
  btnAddItem.Enabled     := EhNovo or (FStatusAtual=STC_PENDENTE);
  btnRemItem.Enabled     := EhNovo or (FStatusAtual=STC_PENDENTE);
end;

procedure TFrmCompras.btnBuscarClick(Sender: TObject);
begin CarregarLista; end;

procedure TFrmCompras.btnNovaClick(Sender: TObject);
begin
  LimparEdicao;
  ModoEdicao(True);
  edtFornecID.SetFocus;
end;

procedure TFrmCompras.sgdListaClick(Sender: TObject);
var R,ID: Integer; Qry: TFDQuery;
begin
  R:=sgdLista.Row;
  if (R<1) or (sgdLista.Cells[0,R]='') then Exit;
  ID:=StrToIntDef(sgdLista.Cells[0,R],0);
  if ID=0 then Exit;
  Qry:=DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text:=
      'SELECT C.*, F.NOME AS FNOME FROM COMPRAS C ' +
      'JOIN FORNECEDORES F ON F.ID=C.ID_FORNECEDOR WHERE C.ID=:ID';
    Qry.ParamByName('ID').AsInteger:=ID; Qry.Open;
    if Qry.IsEmpty then Exit;
    FIDSelecionado:=ID;
    FStatusAtual:=Qry.FieldByName('STATUS').AsString;
    edtNumero.Text      :=Qry.FieldByName('NUMERO').AsString;
    edtFornecID.Text    :=Qry.FieldByName('ID_FORNECEDOR').AsString;
    edtFornecNome.Text  :=Qry.FieldByName('FNOME').AsString;
    edtEmissao.Date     :=Qry.FieldByName('DT_EMISSAO').AsDateTime;
    if not Qry.FieldByName('DT_PREVISAO').IsNull then
      edtPrevisao.Date  :=Qry.FieldByName('DT_PREVISAO').AsDateTime;
    edtStatusLabel.Text :=FStatusAtual;
    edtNF.Text          :=Qry.FieldByName('NF_NUMERO').AsString;
    edtSerie.Text       :=Qry.FieldByName('NF_SERIE').AsString;
    edtCondPagto.Text   :=Qry.FieldByName('COND_PAGTO').AsString;
    mmoObs.Text         :=Qry.FieldByName('OBS').AsString;
    edtFrete.Text       :=MoedaStr(Qry.FieldByName('VL_FRETE').AsFloat);
    edtDescGlobal.Text  :=MoedaStr(Qry.FieldByName('VL_DESCONTO').AsFloat);
    edtTotal.Text       :=MoedaStr(Qry.FieldByName('VL_TOTAL').AsFloat);
    CarregarItens(ID);
    AtualizarBotoes;
    ModoEdicao(True);
  finally Qry.Free; end;
end;

procedure TFrmCompras.btnBuscarFornecClick(Sender: TObject);
var SID: string; ID: Integer; Qry: TFDQuery;
begin
  SID:=InputBox('Fornecedor','Informe o ID do fornecedor:','');
  ID:=StrToIntDef(SID,0);
  if ID=0 then Exit;
  Qry:=DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text:='SELECT ID,NOME FROM FORNECEDORES WHERE ID=:ID AND ATIVO=''S''';
    Qry.ParamByName('ID').AsInteger:=ID; Qry.Open;
    if Qry.IsEmpty then begin ShowMessage('Fornecedor não encontrado!'); Exit; end;
    edtFornecID.Text  :=Qry.Fields[0].AsString;
    edtFornecNome.Text:=Qry.Fields[1].AsString;
  finally Qry.Free; end;
end;

procedure TFrmCompras.btnBuscarMPClick(Sender: TObject);
var SID: string; ID: Integer; Qry: TFDQuery;
begin
  SID:=InputBox('Matéria-Prima','Informe o ID da matéria-prima:','');
  ID:=StrToIntDef(SID,0);
  if ID=0 then Exit;
  Qry:=DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text:=
      'SELECT MP.ID, MP.DESCRICAO, U.SIGLA, MP.CUSTO_MEDIO ' +
      'FROM MAT_PRIMAS MP JOIN UNIDADES U ON U.ID=MP.ID_UNIDADE ' +
      'WHERE MP.ID=:ID AND MP.ATIVO=''S''';
    Qry.ParamByName('ID').AsInteger:=ID; Qry.Open;
    if Qry.IsEmpty then begin ShowMessage('Matéria-prima não encontrada!'); Exit; end;
    edtAddMPID.Text  :=Qry.Fields[0].AsString;
    edtAddMPNome.Text:=Qry.Fields[1].AsString;
    edtAddVlUnit.Text:=MoedaStr(Qry.Fields[3].AsFloat);
  finally Qry.Free; end;
end;

procedure TFrmCompras.btnAddItemClick(Sender: TObject);
var ID_MP,R: Integer; Qtd,VlUnit,VlDesc,VlTotal: Double;
    NomeMP,Unidade: string; Qry: TFDQuery;
begin
  ID_MP:=StrToIntDef(edtAddMPID.Text,0);
  if ID_MP=0 then begin ShowMessage('Informe a matéria-prima.'); Exit; end;
  Qtd  :=StrToFloatDef(StringReplace(edtAddQtd.Text,  ',','.',[rfReplaceAll]),0);
  VlUnit:=StrToFloatDef(StringReplace(edtAddVlUnit.Text,',','.',[rfReplaceAll]),0);
  VlDesc:=StrToFloatDef(StringReplace(edtAddDesc.Text, ',','.',[rfReplaceAll]),0);
  if Qtd<=0   then begin ShowMessage('Qtd deve ser maior que zero.'); Exit; end;
  if VlUnit<=0 then begin ShowMessage('Valor unitário deve ser maior que zero.'); Exit; end;
  VlTotal:=(Qtd*VlUnit)-VlDesc; if VlTotal<0 then VlTotal:=0;
  NomeMP:=edtAddMPNome.Text; Unidade:='';
  Qry:=DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text:='SELECT U.SIGLA FROM MAT_PRIMAS MP JOIN UNIDADES U ON U.ID=MP.ID_UNIDADE WHERE MP.ID=:ID';
    Qry.ParamByName('ID').AsInteger:=ID_MP; Qry.Open;
    if not Qry.IsEmpty then Unidade:=Qry.Fields[0].AsString;
  finally Qry.Free; end;
  { Adiciona ao grid }
  R:=sgdItens.RowCount;
  sgdItens.RowCount:=R+1;
  sgdItens.Cells[0,R]:=IntToStr(R);
  sgdItens.Cells[1,R]:=IntToStr(ID_MP);
  sgdItens.Cells[2,R]:=NomeMP;
  sgdItens.Cells[3,R]:=Unidade;
  sgdItens.Cells[4,R]:=FormatFloat('0.###',Qtd);
  sgdItens.Cells[5,R]:=MoedaStr(VlUnit);
  sgdItens.Cells[6,R]:=MoedaStr(VlTotal);
  edtAddMPID.Text:=''; edtAddMPNome.Text:='';
  edtAddQtd.Text:='1,000'; edtAddVlUnit.Text:='0,00'; edtAddDesc.Text:='0,00';
  RecalcularTotais;
end;

procedure TFrmCompras.btnRemItemClick(Sender: TObject);
var R,I: Integer;
begin
  R:=sgdItens.Row;
  if (R<1) or (sgdItens.Cells[0,R]='') then Exit;
  for I:=R to sgdItens.RowCount-2 do
    sgdItens.Rows[I].Assign(sgdItens.Rows[I+1]);
  sgdItens.RowCount:=sgdItens.RowCount-1;
  { Renumerar itens }
  for I:=1 to sgdItens.RowCount-1 do
    if sgdItens.Cells[0,I]<>'' then sgdItens.Cells[0,I]:=IntToStr(I);
  RecalcularTotais;
end;

procedure TFrmCompras.edtFreteChange(Sender: TObject);
begin RecalcularTotais; end;

procedure TFrmCompras.edtDescGlobalChange(Sender: TObject);
begin RecalcularTotais; end;

procedure TFrmCompras.btnSalvarClick(Sender: TObject);
var Qry: TFDQuery; IDFornec,IDCompra,NItem: Integer; R: Integer;
    VlProd,VlFrete,VlDesc,VlTotal,Qtd,VlUnit,VlItemDesc,VlItemTotal: Double;
begin
  IDFornec:=StrToIntDef(edtFornecID.Text,0);
  if IDFornec=0 then begin ShowMessage('Selecione o fornecedor.'); Exit; end;
  { Verifica itens }
  NItem:=0;
  for R:=1 to sgdItens.RowCount-1 do if sgdItens.Cells[0,R]<>'' then Inc(NItem);
  if NItem=0 then begin ShowMessage(MSG_SEM_ITENS); Exit; end;
  VlProd:=0;
  for R:=1 to sgdItens.RowCount-1 do
    if sgdItens.Cells[0,R]<>'' then VlProd:=VlProd+StrMoeda(sgdItens.Cells[6,R]);
  VlFrete:=StrMoeda(edtFrete.Text);
  VlDesc :=StrMoeda(edtDescGlobal.Text);
  VlTotal:=VlProd+VlFrete-VlDesc; if VlTotal<0 then VlTotal:=0;
  Qry:=DMPrincipal.NovaQuery;
  try
    DMPrincipal.IniciarTran;
    try
      if FIDSelecionado=0 then
      begin
        Qry.SQL.Text:=
          'INSERT INTO COMPRAS (ID_FORNECEDOR,ID_USUARIO,DT_EMISSAO,DT_PREVISAO,STATUS,' +
          'NF_NUMERO,NF_SERIE,VL_PRODUTOS,VL_FRETE,VL_DESCONTO,VL_TOTAL,COND_PAGTO,OBS) ' +
          'VALUES (:IF,:IU,:EM,:PRE,:ST,:NF,:SE,:VP,:VF,:VD,:VT,:CP,:OB) RETURNING ID';
      end
      else
      begin
        Qry.SQL.Text:=
          'UPDATE COMPRAS SET ID_FORNECEDOR=:IF,DT_EMISSAO=:EM,DT_PREVISAO=:PRE,' +
          'NF_NUMERO=:NF,NF_SERIE=:SE,VL_PRODUTOS=:VP,VL_FRETE=:VF,VL_DESCONTO=:VD,' +
          'VL_TOTAL=:VT,COND_PAGTO=:CP,OBS=:OB WHERE ID=:ID';
      end;
      Qry.ParamByName('IF').AsInteger:=IDFornec;
      Qry.ParamByName('IU').AsInteger:=SessaoID;
      Qry.ParamByName('EM').AsDateTime:=edtEmissao.Date;
      Qry.ParamByName('PRE').AsDateTime:=edtPrevisao.Date;
      if FIDSelecionado=0 then
        Qry.ParamByName('ST').AsString:=STC_PENDENTE;
      Qry.ParamByName('NF').AsString:=edtNF.Text;
      Qry.ParamByName('SE').AsString:=edtSerie.Text;
      Qry.ParamByName('VP').AsFloat:=VlProd;
      Qry.ParamByName('VF').AsFloat:=VlFrete;
      Qry.ParamByName('VD').AsFloat:=VlDesc;
      Qry.ParamByName('VT').AsFloat:=VlTotal;
      Qry.ParamByName('CP').AsString:=edtCondPagto.Text;
      Qry.ParamByName('OB').AsString:=mmoObs.Text;
      if FIDSelecionado=0 then
      begin Qry.Open; IDCompra:=Qry.FieldByName('ID').AsInteger; end
      else
      begin
        Qry.ParamByName('ID').AsInteger:=FIDSelecionado;
        Qry.ExecSQL; IDCompra:=FIDSelecionado;
        { Apaga itens antigos }
        DMPrincipal.ExecSQL('DELETE FROM COMPRAS_ITENS WHERE ID_COMPRA='+IntToStr(IDCompra));
      end;
      { Insere itens }
      for R:=1 to sgdItens.RowCount-1 do
      begin
        if sgdItens.Cells[0,R]='' then Continue;
        Qtd      :=StrToFloatDef(StringReplace(sgdItens.Cells[4,R],',','.',[rfReplaceAll]),0);
        VlUnit   :=StrMoeda(sgdItens.Cells[5,R]);
        VlItemDesc:=0;
        VlItemTotal:=StrMoeda(sgdItens.Cells[6,R]);
        Qry.Close;
        Qry.SQL.Text:=
          'INSERT INTO COMPRAS_ITENS (ID_COMPRA,ITEM,ID_MAT_PRIMA,QUANTIDADE,VL_UNITARIO,VL_DESCONTO,VL_TOTAL) ' +
          'VALUES (:IC,:IT,:IMP,:QT,:VU,:VD,:VT)';
        Qry.ParamByName('IC').AsInteger:=IDCompra;
        Qry.ParamByName('IT').AsInteger:=R;
        Qry.ParamByName('IMP').AsInteger:=StrToIntDef(sgdItens.Cells[1,R],0);
        Qry.ParamByName('QT').AsFloat:=Qtd;
        Qry.ParamByName('VU').AsFloat:=VlUnit;
        Qry.ParamByName('VD').AsFloat:=VlItemDesc;
        Qry.ParamByName('VT').AsFloat:=VlItemTotal;
        Qry.ExecSQL;
      end;
      DMPrincipal.CommitTran;
      if FIDSelecionado=0 then
      begin
        FIDSelecionado:=IDCompra;
        FStatusAtual:=STC_PENDENTE;
        edtNumero.Text:=IntToStr(IDCompra);
        edtStatusLabel.Text:=STC_PENDENTE;
      end;
      AtualizarBotoes;
      ShowMessage(MSG_SALVO);
      CarregarLista;
    except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
  finally Qry.Free; end;
end;

procedure TFrmCompras.AlterarStatus(const ANovoStatus: string);
begin
  if FIDSelecionado=0 then Exit;
  try
    DMPrincipal.IniciarTran;
    DMPrincipal.ExecSQL(
      'UPDATE COMPRAS SET STATUS='''+ANovoStatus+''', ID_USUARIO='+IntToStr(SessaoID)+
      ' WHERE ID='+IntToStr(FIDSelecionado));
    DMPrincipal.CommitTran;
    FStatusAtual:=ANovoStatus;
    edtStatusLabel.Text:=ANovoStatus;
    AtualizarBotoes;
    CarregarLista;
    ShowMessage('Status alterado para: '+ANovoStatus);
  except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
end;

procedure TFrmCompras.btnConfirmarClick(Sender: TObject);
begin
  if MessageDlg('Confirmar esta compra?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
    AlterarStatus(STC_CONFIRMADA);
end;

procedure TFrmCompras.btnReceberClick(Sender: TObject);
begin
  if MessageDlg('Registrar recebimento? O estoque será atualizado automaticamente.',
    mtConfirmation,[mbYes,mbNo],0)=mrYes then
    AlterarStatus(STC_RECEBIDA);
end;

procedure TFrmCompras.btnCancelarDocClick(Sender: TObject);
begin
  if MessageDlg('Cancelar esta compra?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
    AlterarStatus(STC_CANCELADA);
end;

procedure TFrmCompras.btnFecharClick(Sender: TObject);
begin
  ModoEdicao(False);
  LimparEdicao;
end;

end.
