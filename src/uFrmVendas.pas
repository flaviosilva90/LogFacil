unit uFrmVendas;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
  FireDAC.Comp.Client, system.Math, system.StrUtils;

type
  TFrmVendas = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    pnlFiltro: TPanel;
    edtFiltro: TEdit;
    cboStatus: TComboBox;
    btnBuscar: TButton;
    btnNova: TButton;
    sgdLista: TStringGrid;
    pnlEdicao: TPanel;
    lblNumero: TLabel;     edtNumero: TEdit;
    lblCliente: TLabel;    edtClienteID: TEdit;    edtClienteNome: TEdit;   btnBuscarCli: TButton;
    lblEmissao: TLabel;    edtEmissao: TDateTimePicker;
    lblEntrega: TLabel;    edtEntrega: TDateTimePicker;
    lblStatus: TLabel;     edtStatusLabel: TEdit;
    lblNF: TLabel;         edtNF: TEdit;
    lblCondPagto: TLabel;  edtCondPagto: TEdit;
    lblObs: TLabel;        mmoObs: TMemo;
    lblItens: TLabel;
    sgdItens: TStringGrid;
    pnlAddItem: TPanel;
    lblAddProd: TLabel;    edtAddProdID: TEdit;    edtAddProdNome: TEdit;   btnBuscarProd: TButton;
    lblAddQtd: TLabel;     edtAddQtd: TEdit;
    lblAddVlUnit: TLabel;  edtAddVlUnit: TEdit;
    lblAddDesc: TLabel;    edtAddDesc: TEdit;
    btnAddItem: TButton;
    btnRemItem: TButton;
    pnlTotais: TPanel;
    lblFrete: TLabel;      edtFrete: TEdit;
    lblDescGlobal: TLabel; edtDescGlobal: TEdit;
    lblTotalLabel: TLabel; edtTotal: TEdit;
    pnlBotoes: TPanel;
    btnSalvar: TButton;
    btnConfirmar: TButton;
    btnFaturar: TButton;
    btnEntregar: TButton;
    btnCancelarDoc: TButton;
    btnFechar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnNovaClick(Sender: TObject);
    procedure sgdListaClick(Sender: TObject);
    procedure btnBuscarCliClick(Sender: TObject);
    procedure btnBuscarProdClick(Sender: TObject);
    procedure btnAddItemClick(Sender: TObject);
    procedure btnRemItemClick(Sender: TObject);
    procedure edtFreteChange(Sender: TObject);
    procedure edtDescGlobalChange(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnFaturarClick(Sender: TObject);
    procedure btnEntregarClick(Sender: TObject);
    procedure btnCancelarDocClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
  private
    FIDSelecionado: Integer;
    FStatusAtual: string;
    procedure ModoEdicao(AEditar: Boolean);
    procedure LimparEdicao;
    procedure CarregarLista;
    procedure CarregarItens(AIDVenda: Integer);
    procedure RecalcularTotais;
    procedure AlterarStatus(const ANovoStatus: string);
    procedure AtualizarBotoes;
    function  ValidarEstoque: Boolean;
    procedure PreencherGridLista(Qry: TFDQuery);
  end;

implementation

{$R *.dfm}

uses uGlobal, uDMPrincipal;

procedure TFrmVendas.FormCreate(Sender: TObject);
begin
  FIDSelecionado:=0; FStatusAtual:='';
  sgdLista.ColCount:=8; sgdLista.FixedRows:=1;
  sgdLista.Options:=sgdLista.Options+[goColSizing,goRowSelect];
  sgdLista.ColWidths[0]:=50; sgdLista.ColWidths[1]:=60;
  sgdLista.ColWidths[2]:=200; sgdLista.ColWidths[3]:=90;
  sgdLista.ColWidths[4]:=90; sgdLista.ColWidths[5]:=90;
  sgdLista.ColWidths[6]:=90; sgdLista.ColWidths[7]:=100;
  sgdLista.Cells[0,0]:='ID';    sgdLista.Cells[1,0]:='Nº';
  sgdLista.Cells[2,0]:='Cliente'; sgdLista.Cells[3,0]:='Emissão';
  sgdLista.Cells[4,0]:='Entrega';  sgdLista.Cells[5,0]:='Total';
  sgdLista.Cells[6,0]:='Status';   sgdLista.Cells[7,0]:='NF';
  sgdItens.ColCount:=7; sgdItens.FixedRows:=1;
  sgdItens.Options:=sgdItens.Options+[goColSizing,goRowSelect];
  sgdItens.ColWidths[0]:=40; sgdItens.ColWidths[1]:=60;
  sgdItens.ColWidths[2]:=240; sgdItens.ColWidths[3]:=60;
  sgdItens.ColWidths[4]:=80; sgdItens.ColWidths[5]:=90; sgdItens.ColWidths[6]:=90;
  sgdItens.Cells[0,0]:='#'; sgdItens.Cells[1,0]:='ID Prod';
  sgdItens.Cells[2,0]:='Produto'; sgdItens.Cells[3,0]:='UN';
  sgdItens.Cells[4,0]:='Qtd'; sgdItens.Cells[5,0]:='Vl.Unit'; sgdItens.Cells[6,0]:='Total';
  cboStatus.Items.Add('(Todos)');
  cboStatus.Items.Add(STV_ORCAMENTO);
  cboStatus.Items.Add(STV_CONFIRMADA);
  cboStatus.Items.Add(STV_FATURADA);
  cboStatus.Items.Add(STV_ENTREGUE);
  cboStatus.Items.Add(STV_CANCELADA);
  cboStatus.ItemIndex:=0;
  ModoEdicao(False);
  CarregarLista;
end;

procedure TFrmVendas.CarregarLista;
var Qry: TFDQuery; W: string;
begin
  Qry:=DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text:=
      'SELECT V.ID,V.NUMERO,C.NOME AS CLIENTE,V.DT_EMISSAO,' +
      'V.DT_ENTREGA,V.VL_TOTAL,V.STATUS,V.NF_NUMERO ' +
      'FROM VENDAS V JOIN CLIENTES C ON C.ID=V.ID_CLIENTE ';
    W:='';
    if cboStatus.ItemIndex>0 then
      W:='V.STATUS='''+cboStatus.Items[cboStatus.ItemIndex]+'''';
    if Trim(edtFiltro.Text)<>'' then
    begin
      if W<>'' then W:=W+' AND ';
      W:=W+'(UPPER(C.NOME) CONTAINING UPPER(:F) OR CAST(V.NUMERO AS VARCHAR(10)) CONTAINING :F)';
    end;
    if W<>'' then Qry.SQL.Add('WHERE '+W);
    Qry.SQL.Add('ORDER BY V.NUMERO DESC');
    if Trim(edtFiltro.Text)<>'' then Qry.ParamByName('F').AsString:=edtFiltro.Text;
    Qry.Open;
    PreencherGridLista(Qry);
  finally Qry.Free; end;
end;

procedure TFrmVendas.PreencherGridLista(Qry: TFDQuery);
var R: Integer;
begin
  sgdLista.RowCount:= Qry.RecordCount+1;
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

procedure TFrmVendas.CarregarItens(AIDVenda: Integer);
var Qry: TFDQuery; R: Integer;
begin
  sgdItens.RowCount:=2;
  for R:=1 to sgdItens.RowCount-1 do sgdItens.Rows[R].Clear;
  if AIDVenda=0 then Exit;
  Qry:=DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text:=
      'SELECT VI.ITEM,VI.ID_PRODUTO,P.DESCRICAO,U.SIGLA,' +
      'VI.QUANTIDADE,VI.VL_UNITARIO,VI.VL_TOTAL ' +
      'FROM VENDAS_ITENS VI ' +
      'JOIN PRODUTOS P ON P.ID=VI.ID_PRODUTO ' +
      'JOIN UNIDADES U ON U.ID=P.ID_UNIDADE ' +
      'WHERE VI.ID_VENDA=:ID ORDER BY VI.ITEM';
    Qry.ParamByName('ID').AsInteger:=AIDVenda; Qry.Open;
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

procedure TFrmVendas.RecalcularTotais;
var R: Integer; VlProd,Frete,Desc,Total: Double;
begin
  VlProd:=0;
  for R:=1 to sgdItens.RowCount-1 do
    if sgdItens.Cells[0,R]<>'' then VlProd:=VlProd+StrMoeda(sgdItens.Cells[6,R]);
  Frete:=StrMoeda(edtFrete.Text); Desc:=StrMoeda(edtDescGlobal.Text);
  Total:=VlProd+Frete-Desc; if Total<0 then Total:=0;
  edtTotal.Text:=MoedaStr(Total);
end;

procedure TFrmVendas.ModoEdicao(AEditar: Boolean);
begin
  pnlEdicao.Visible:=AEditar;
  pnlFiltro.Enabled:=not AEditar;
  sgdLista.Enabled :=not AEditar;
  btnNova.Enabled  :=not AEditar;
end;

procedure TFrmVendas.LimparEdicao;
var R: Integer;
begin
  FIDSelecionado:=0; FStatusAtual:='';
  edtNumero.Text:='(automático)';
  edtClienteID.Text:=''; edtClienteNome.Text:='';
  edtEmissao.Date:=Date; edtEntrega.Date:=Date+7;
  edtStatusLabel.Text:='ORÇAMENTO'; edtNF.Text:='';
  edtCondPagto.Text:=''; mmoObs.Lines.Clear;
  sgdItens.RowCount:=2;
  for R:=1 to sgdItens.RowCount-1 do sgdItens.Rows[R].Clear;
  edtAddProdID.Text:=''; edtAddProdNome.Text:='';
  edtAddQtd.Text:='1,000'; edtAddVlUnit.Text:='0,00'; edtAddDesc.Text:='0,00';
  edtFrete.Text:='0,00'; edtDescGlobal.Text:='0,00'; edtTotal.Text:='0,00';
  AtualizarBotoes;
end;

procedure TFrmVendas.AtualizarBotoes;
var EhNovo, EdicaoAtiva: Boolean;
begin
  EhNovo      := FIDSelecionado=0;
  EdicaoAtiva := pnlEdicao.Visible;
  btnSalvar.Enabled     := EdicaoAtiva and ((FStatusAtual='') or (FStatusAtual=STV_ORCAMENTO) or (FStatusAtual=STV_CONFIRMADA));
  btnConfirmar.Enabled  := EdicaoAtiva and (FStatusAtual=STV_ORCAMENTO);
  btnFaturar.Enabled    := EdicaoAtiva and (FStatusAtual=STV_CONFIRMADA);
  btnEntregar.Enabled   := EdicaoAtiva and (FStatusAtual=STV_FATURADA);
  btnCancelarDoc.Enabled:= EdicaoAtiva and ((FStatusAtual=STV_ORCAMENTO) or (FStatusAtual=STV_CONFIRMADA) or (FStatusAtual=STV_FATURADA));
  edtClienteID.ReadOnly :=not(EhNovo) or (FStatusAtual=STV_ORCAMENTO);
  btnBuscarCli.Enabled  := EhNovo or (FStatusAtual=STV_ORCAMENTO);
  btnBuscarProd.Enabled := EhNovo or (FStatusAtual=STV_ORCAMENTO);
  btnAddItem.Enabled    := EhNovo or (FStatusAtual=STV_ORCAMENTO);
  btnRemItem.Enabled    := EhNovo or (FStatusAtual=STV_ORCAMENTO);
end;

function TFrmVendas.ValidarEstoque: Boolean;
var R: Integer; IDProd: Integer; Qtd,EstAtual: Double; Qry: TFDQuery;
begin
  Result:=True;
  Qry:=DMPrincipal.NovaQuery;
  try
    for R:=1 to sgdItens.RowCount-1 do
    begin
      if sgdItens.Cells[0,R]='' then Continue;
      IDProd:=StrToIntDef(sgdItens.Cells[1,R],0);
      Qtd   :=StrToFloatDef(StringReplace(sgdItens.Cells[4,R],',','.',[rfReplaceAll]),0);
      Qry.Close;
      Qry.SQL.Text:='SELECT ESTOQUE_ATUAL FROM PRODUTOS WHERE ID=:ID';
      Qry.ParamByName('ID').AsInteger:=IDProd; Qry.Open;
      EstAtual:=0;
      if not Qry.IsEmpty then EstAtual:=Qry.Fields[0].AsFloat;
      if EstAtual < Qtd then
      begin
        ShowMessage(MSG_EST_INSUF+sgdItens.Cells[2,R]+
          sLineBreak+'Disponível: '+QtdStr(EstAtual)+' | Solicitado: '+QtdStr(Qtd));
        Result:=False; Exit;
      end;
    end;
  finally Qry.Free; end;
end;

procedure TFrmVendas.btnBuscarClick(Sender: TObject);
begin CarregarLista; end;

procedure TFrmVendas.btnNovaClick(Sender: TObject);
begin LimparEdicao; ModoEdicao(True); edtClienteID.SetFocus; end;

procedure TFrmVendas.sgdListaClick(Sender: TObject);
var R,ID: Integer; Qry: TFDQuery;
begin
  R:=sgdLista.Row;
  if (R<1) or (sgdLista.Cells[0,R]='') then Exit;
  ID:=StrToIntDef(sgdLista.Cells[0,R],0); if ID=0 then Exit;
  Qry:=DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text:=
      'SELECT V.*,C.NOME AS CNOME FROM VENDAS V ' +
      'JOIN CLIENTES C ON C.ID=V.ID_CLIENTE WHERE V.ID=:ID';
    Qry.ParamByName('ID').AsInteger:=ID; Qry.Open;
    if Qry.IsEmpty then Exit;
    FIDSelecionado:=ID;
    FStatusAtual:=Qry.FieldByName('STATUS').AsString;
    edtNumero.Text      :=Qry.FieldByName('NUMERO').AsString;
    edtClienteID.Text   :=Qry.FieldByName('ID_CLIENTE').AsString;
    edtClienteNome.Text :=Qry.FieldByName('CNOME').AsString;
    edtEmissao.Date     :=Qry.FieldByName('DT_EMISSAO').AsDateTime;
    if not Qry.FieldByName('DT_ENTREGA').IsNull then
      edtEntrega.Date:=Qry.FieldByName('DT_ENTREGA').AsDateTime;
    edtStatusLabel.Text :=FStatusAtual;
    edtNF.Text          :=Qry.FieldByName('NF_NUMERO').AsString;
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

procedure TFrmVendas.btnBuscarCliClick(Sender: TObject);
var SID: string; ID: Integer; Qry: TFDQuery;
begin
  SID:=InputBox('Cliente','Informe o ID do cliente:','');
  ID:=StrToIntDef(SID,0); if ID=0 then Exit;
  Qry:=DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text:='SELECT ID,NOME FROM CLIENTES WHERE ID=:ID AND ATIVO=''S''';
    Qry.ParamByName('ID').AsInteger:=ID; Qry.Open;
    if Qry.IsEmpty then begin ShowMessage('Cliente não encontrado!'); Exit; end;
    edtClienteID.Text  :=Qry.Fields[0].AsString;
    edtClienteNome.Text:=Qry.Fields[1].AsString;
  finally Qry.Free; end;
end;

procedure TFrmVendas.btnBuscarProdClick(Sender: TObject);
var SID: string; ID: Integer; Qry: TFDQuery;
begin
  SID:=InputBox('Produto','Informe o ID do produto:','');
  ID:=StrToIntDef(SID,0); if ID=0 then Exit;
  Qry:=DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text:=
      'SELECT P.ID,P.DESCRICAO,U.SIGLA,P.PRECO_VENDA,P.ESTOQUE_ATUAL ' +
      'FROM PRODUTOS P JOIN UNIDADES U ON U.ID=P.ID_UNIDADE ' +
      'WHERE P.ID=:ID AND P.ATIVO=''S''';
    Qry.ParamByName('ID').AsInteger:=ID; Qry.Open;
    if Qry.IsEmpty then begin ShowMessage('Produto não encontrado!'); Exit; end;
    edtAddProdID.Text  :=Qry.Fields[0].AsString;
    edtAddProdNome.Text:=Qry.Fields[1].AsString;
    edtAddVlUnit.Text  :=MoedaStr(Qry.Fields[3].AsFloat);
    ShowMessage('Estoque disponível: '+QtdStr(Qry.Fields[4].AsFloat));
  finally Qry.Free; end;
end;

procedure TFrmVendas.btnAddItemClick(Sender: TObject);
var ID_Prod,R: Integer; Qtd,VlUnit,VlDesc,VlTotal: Double;
    NomeProd,Unidade: string; Qry: TFDQuery;
begin
  ID_Prod:=StrToIntDef(edtAddProdID.Text,0);
  if ID_Prod=0 then begin ShowMessage('Informe o produto.'); Exit; end;
  Qtd    :=StrToFloatDef(StringReplace(edtAddQtd.Text,   ',','.',[rfReplaceAll]),0);
  VlUnit :=StrToFloatDef(StringReplace(edtAddVlUnit.Text,',','.',[rfReplaceAll]),0);
  VlDesc :=StrToFloatDef(StringReplace(edtAddDesc.Text,  ',','.',[rfReplaceAll]),0);
  if Qtd<=0    then begin ShowMessage('Qtd deve ser maior que zero.'); Exit; end;
  if VlUnit<=0 then begin ShowMessage('Valor unitário deve ser maior que zero.'); Exit; end;
  VlTotal:=(Qtd*VlUnit)-VlDesc; if VlTotal<0 then VlTotal:=0;
  NomeProd:=edtAddProdNome.Text; Unidade:='';
  Qry:=DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text:='SELECT U.SIGLA FROM PRODUTOS P JOIN UNIDADES U ON U.ID=P.ID_UNIDADE WHERE P.ID=:ID';
    Qry.ParamByName('ID').AsInteger:=ID_Prod; Qry.Open;
    if not Qry.IsEmpty then Unidade:=Qry.Fields[0].AsString;
  finally Qry.Free; end;
  R:=sgdItens.RowCount; sgdItens.RowCount:=R+1;
  sgdItens.Cells[0,R]:=IntToStr(R);
  sgdItens.Cells[1,R]:=IntToStr(ID_Prod);
  sgdItens.Cells[2,R]:=NomeProd;
  sgdItens.Cells[3,R]:=Unidade;
  sgdItens.Cells[4,R]:=FormatFloat('0.###',Qtd);
  sgdItens.Cells[5,R]:=MoedaStr(VlUnit);
  sgdItens.Cells[6,R]:=MoedaStr(VlTotal);
  edtAddProdID.Text:=''; edtAddProdNome.Text:='';
  edtAddQtd.Text:='1,000'; edtAddVlUnit.Text:='0,00'; edtAddDesc.Text:='0,00';
  RecalcularTotais;
end;

procedure TFrmVendas.btnRemItemClick(Sender: TObject);
var R,I: Integer;
begin
  R:=sgdItens.Row;
  if (R<1) or (sgdItens.Cells[0,R]='') then Exit;
  for I:=R to sgdItens.RowCount-2 do sgdItens.Rows[I].Assign(sgdItens.Rows[I+1]);
  sgdItens.RowCount:=sgdItens.RowCount-1;
  for I:=1 to sgdItens.RowCount-1 do
    if sgdItens.Cells[0,I]<>'' then sgdItens.Cells[0,I]:=IntToStr(I);
  RecalcularTotais;
end;

procedure TFrmVendas.edtFreteChange(Sender: TObject);
begin RecalcularTotais; end;

procedure TFrmVendas.edtDescGlobalChange(Sender: TObject);
begin RecalcularTotais; end;

procedure TFrmVendas.btnSalvarClick(Sender: TObject);
var Qry: TFDQuery; IDCli,IDVenda,NItem,R: Integer;
    VlProd,VlFrete,VlDesc,VlTotal,Qtd,VlUnit,VlItemTotal: Double;
begin
  IDCli:=StrToIntDef(edtClienteID.Text,0);
  if IDCli=0 then begin ShowMessage('Selecione o cliente.'); Exit; end;
  NItem:=0;
  for R:=1 to sgdItens.RowCount-1 do if sgdItens.Cells[0,R]<>'' then Inc(NItem);
  if NItem=0 then begin ShowMessage(MSG_SEM_ITENS); Exit; end;
  VlProd:=0;
  for R:=1 to sgdItens.RowCount-1 do
    if sgdItens.Cells[0,R]<>'' then VlProd:=VlProd+StrMoeda(sgdItens.Cells[6,R]);
  VlFrete:=StrMoeda(edtFrete.Text); VlDesc:=StrMoeda(edtDescGlobal.Text);
  VlTotal:=VlProd+VlFrete-VlDesc; if VlTotal<0 then VlTotal:=0;
  Qry:=DMPrincipal.NovaQuery;
  try
    DMPrincipal.IniciarTran;
    try
      if FIDSelecionado=0 then
        Qry.SQL.Text:=
          'INSERT INTO VENDAS (ID_CLIENTE,ID_USUARIO,DT_EMISSAO,DT_ENTREGA,STATUS,' +
          'NF_NUMERO,VL_PRODUTOS,VL_FRETE,VL_DESCONTO,VL_TOTAL,COND_PAGTO,OBS) ' +
          'VALUES (:IC,:IU,:EM,:EN,:ST,:NF,:VP,:VF,:VD,:VT,:CP,:OB) RETURNING ID'
      else
        Qry.SQL.Text:=
          'UPDATE VENDAS SET ID_CLIENTE=:IC,DT_EMISSAO=:EM,DT_ENTREGA=:EN,' +
          'NF_NUMERO=:NF,VL_PRODUTOS=:VP,VL_FRETE=:VF,VL_DESCONTO=:VD,' +
          'VL_TOTAL=:VT,COND_PAGTO=:CP,OBS=:OB WHERE ID=:ID';
      Qry.ParamByName('IC').AsInteger:=IDCli;
      Qry.ParamByName('IU').AsInteger:=SessaoID;
      Qry.ParamByName('EM').AsDateTime:=edtEmissao.Date;
      Qry.ParamByName('EN').AsDateTime:=edtEntrega.Date;
      if FIDSelecionado=0 then Qry.ParamByName('ST').AsString:=STV_ORCAMENTO;
      Qry.ParamByName('NF').AsString:=edtNF.Text;
      Qry.ParamByName('VP').AsFloat:=VlProd; Qry.ParamByName('VF').AsFloat:=VlFrete;
      Qry.ParamByName('VD').AsFloat:=VlDesc; Qry.ParamByName('VT').AsFloat:=VlTotal;
      Qry.ParamByName('CP').AsString:=edtCondPagto.Text;
      Qry.ParamByName('OB').AsString:=mmoObs.Text;
      if FIDSelecionado=0 then
      begin Qry.Open; IDVenda:=Qry.FieldByName('ID').AsInteger; end
      else
      begin
        Qry.ParamByName('ID').AsInteger:=FIDSelecionado;
        Qry.ExecSQL; IDVenda:=FIDSelecionado;
        DMPrincipal.ExecSQL('DELETE FROM VENDAS_ITENS WHERE ID_VENDA='+IntToStr(IDVenda));
      end;
      for R:=1 to sgdItens.RowCount-1 do
      begin
        if sgdItens.Cells[0,R]='' then Continue;
        Qtd       :=StrToFloatDef(StringReplace(sgdItens.Cells[4,R],',','.',[rfReplaceAll]),0);
        VlUnit    :=StrMoeda(sgdItens.Cells[5,R]);
        VlItemTotal:=StrMoeda(sgdItens.Cells[6,R]);
        Qry.Close;
        Qry.SQL.Text:=
          'INSERT INTO VENDAS_ITENS (ID_VENDA,ITEM,ID_PRODUTO,QUANTIDADE,VL_UNITARIO,VL_DESCONTO,VL_TOTAL) ' +
          'VALUES (:IV,:IT,:IP,:QT,:VU,:VD,:VT)';
        Qry.ParamByName('IV').AsInteger:=IDVenda;
        Qry.ParamByName('IT').AsInteger:=R;
        Qry.ParamByName('IP').AsInteger:=StrToIntDef(sgdItens.Cells[1,R],0);
        Qry.ParamByName('QT').AsFloat:=Qtd; Qry.ParamByName('VU').AsFloat:=VlUnit;
        Qry.ParamByName('VD').AsFloat:=0;   Qry.ParamByName('VT').AsFloat:=VlItemTotal;
        Qry.ExecSQL;
      end;
      DMPrincipal.CommitTran;
      if FIDSelecionado=0 then
      begin
        FIDSelecionado:=IDVenda; FStatusAtual:=STV_ORCAMENTO;
        edtNumero.Text:=IntToStr(IDVenda); edtStatusLabel.Text:=STV_ORCAMENTO;
      end;
      AtualizarBotoes; ShowMessage(MSG_SALVO); CarregarLista;
    except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
  finally Qry.Free; end;
end;

procedure TFrmVendas.AlterarStatus(const ANovoStatus: string);
begin
  if FIDSelecionado=0 then Exit;
  try
    DMPrincipal.IniciarTran;
    DMPrincipal.ExecSQL(
      'UPDATE VENDAS SET STATUS='''+ANovoStatus+''',ID_USUARIO='+IntToStr(SessaoID)+
      ' WHERE ID='+IntToStr(FIDSelecionado));
    DMPrincipal.CommitTran;
    FStatusAtual:=ANovoStatus; edtStatusLabel.Text:=ANovoStatus;
    AtualizarBotoes; CarregarLista;
    ShowMessage('Status alterado para: '+ANovoStatus);
  except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
end;

procedure TFrmVendas.btnConfirmarClick(Sender: TObject);
begin
  if MessageDlg('Confirmar esta venda?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
    AlterarStatus(STV_CONFIRMADA);
end;

procedure TFrmVendas.btnFaturarClick(Sender: TObject);
begin
  if not ValidarEstoque then Exit;
  if MessageDlg('Faturar venda? O estoque será debitado automaticamente.',
    mtConfirmation,[mbYes,mbNo],0)=mrYes then
    AlterarStatus(STV_FATURADA);
end;

procedure TFrmVendas.btnEntregarClick(Sender: TObject);
begin
  if MessageDlg('Registrar entrega?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
    AlterarStatus(STV_ENTREGUE);
end;

procedure TFrmVendas.btnCancelarDocClick(Sender: TObject);
begin
  if MessageDlg('Cancelar esta venda?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
    AlterarStatus(STV_CANCELADA);
end;

procedure TFrmVendas.btnFecharClick(Sender: TObject);
begin ModoEdicao(False); LimparEdicao; end;

end.
