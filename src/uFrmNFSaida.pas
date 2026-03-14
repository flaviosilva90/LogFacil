unit uFrmNFSaida;

{
  uFrmNFSaida.pas
  Emissão de Nota Fiscal de Saída (NF-e).
  Suporta: criação manual, importação a partir de uma Venda.
  Calcula impostos automaticamente com base nos dados fiscais dos produtos.
  Gera XML estruturado conforme padrão SEFAZ (layout simplificado para integração).
}

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
  FireDAC.Comp.Client, system.math, system.StrUtils;

type
  TFrmNFSaida = class(TForm)
    pnlTopo: TPanel;       lblTitulo: TLabel;
    pnlFiltro: TPanel;
    edtFiltro: TEdit;      cboStatusNF: TComboBox;
    btnBuscar: TButton;    btnNova: TButton;    btnDeVenda: TButton;
    sgdLista: TStringGrid;
    pgcNF: TPageControl;
    tabCabecalho: TTabSheet;
    tabDestinatario: TTabSheet;
    tabItens: TTabSheet;
    tabTotais: TTabSheet;
    tabTransporte: TTabSheet;
    { Cabeçalho }
    lblNumNF: TLabel;       edtNumNF: TEdit;
    lblSerie: TLabel;       edtSerie: TEdit;
    lblDtEmissao: TLabel;   edtDtEmissao: TDateTimePicker;
    lblNatureza: TLabel;    edtNatureza: TEdit;
    lblFinalidade: TLabel;  cboFinalidade: TComboBox;
    lblAmbiente: TLabel;    cboAmbiente: TComboBox;
    lblStatusNFEd: TLabel;  edtStatusNFEd: TEdit;
    lblVendaRef: TLabel;    edtVendaID: TEdit; edtVendaNum: TEdit; btnBuscarVenda: TButton;
    lblInfoCompl: TLabel;   mmoInfoCompl: TMemo;
    { Destinatário }
    lblDestNome: TLabel;    edtDestNome: TEdit;
    lblDestCNPJ: TLabel;    edtDestCNPJ: TEdit;
    lblDestCPF: TLabel;     edtDestCPF: TEdit;
    lblDestIE: TLabel;      edtDestIE: TEdit;
    lblDestIndicIE: TLabel; cboDestIndicIE: TComboBox;
    lblDestEnd: TLabel;     edtDestLogr: TEdit;
    lblDestNum: TLabel;     edtDestNum: TEdit;
    lblDestBairro: TLabel;  edtDestBairro: TEdit;
    lblDestCidade: TLabel;  edtDestCidade: TEdit;
    lblDestUF: TLabel;      edtDestUF: TEdit;
    lblDestCEP: TLabel;     edtDestCEP: TEdit;
    lblDestFone: TLabel;    edtDestFone: TEdit;
    lblClienteRef: TLabel;  edtClienteID: TEdit; edtClienteNome: TEdit; btnBuscarCli: TButton;
    { Itens }
    sgdItens: TStringGrid;
    pnlAddItemNF: TPanel;
    lblAddProd: TLabel;     edtAddProdID: TEdit; edtAddProdNome: TEdit; btnAddProd: TButton;
    lblAddQtd: TLabel;      edtAddQtd: TEdit;
    lblAddVlUnit: TLabel;   edtAddVlUnit: TEdit;
    lblAddCFOP: TLabel;     edtAddCFOP: TEdit;
    btnAddItemNF: TButton;  btnRemItemNF: TButton;
    { Totais fiscais }
    lblTotBCICMS: TLabel;   edtTotBCICMS: TEdit;
    lblTotICMS: TLabel;     edtTotICMS: TEdit;
    lblTotIPI: TLabel;      edtTotIPI: TEdit;
    lblTotPIS: TLabel;      edtTotPIS: TEdit;
    lblTotCOFINS: TLabel;   edtTotCOFINS: TEdit;
    lblTotFrete: TLabel;    edtTotFrete: TEdit;
    lblTotDesc: TLabel;     edtTotDesc: TEdit;
    lblTotProd: TLabel;     edtTotProd: TEdit;
    lblTotNF: TLabel;       edtTotNF: TEdit;
    { Transporte }
    lblModalFrete: TLabel;  cboModalFrete: TComboBox;
    lblTransNome: TLabel;   edtTransNome: TEdit;
    lblTransCNPJ: TLabel;   edtTransCNPJ: TEdit;
    { Botões }
    pnlBotoesNF: TPanel;
    btnSalvarNF: TButton;
    btnGerarXML: TButton;
    btnCancelarNF: TButton;
    btnFecharNF: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnNovaClick(Sender: TObject);
    procedure btnDeVendaClick(Sender: TObject);
    procedure sgdListaClick(Sender: TObject);
    procedure btnBuscarVendaClick(Sender: TObject);
    procedure btnBuscarCliClick(Sender: TObject);
    procedure btnAddProdClick(Sender: TObject);
    procedure btnAddItemNFClick(Sender: TObject);
    procedure btnRemItemNFClick(Sender: TObject);
    procedure btnSalvarNFClick(Sender: TObject);
    procedure btnGerarXMLClick(Sender: TObject);
    procedure btnCancelarNFClick(Sender: TObject);
    procedure btnFecharNFClick(Sender: TObject);
  private
    FIDSelecionado: Integer;
    FStatusAtual: string;
    FIDCliente: Integer;
    FIDVenda: Integer;
    procedure ModoEdicao(AEditar: Boolean);
    procedure LimparEdicao;
    procedure CarregarLista;
    procedure CarregarItens(AIDNF: Integer);
    procedure PreencherDeVenda(AIDVenda: Integer);
    procedure PreencherDestinatario(AIDCliente: Integer);
    procedure RecalcularTotaisNF;
    procedure AtualizarBotoes;
    function  GerarXMLNFe: string;
    procedure PreencherGridLista(Qry: TFDQuery);
  end;

implementation

{$R *.dfm}

uses uGlobal, uDMPrincipal;

procedure TFrmNFSaida.FormCreate(Sender: TObject);
begin
  FIDSelecionado := 0; FStatusAtual := '';
  FIDCliente := 0; FIDVenda := 0;
  { Grid lista }
  sgdLista.ColCount := 9; //sgdLista.FixedRows := 1;
  sgdLista.Options := sgdLista.Options + [goColSizing, goRowSelect];
  sgdLista.ColWidths[0]:=50; sgdLista.ColWidths[1]:=60; sgdLista.ColWidths[2]:=40;
  sgdLista.ColWidths[3]:=200; sgdLista.ColWidths[4]:=90; sgdLista.ColWidths[5]:=90;
  sgdLista.ColWidths[6]:=100; sgdLista.ColWidths[7]:=80; sgdLista.ColWidths[8]:=100;
  sgdLista.Cells[0,0]:='ID'; sgdLista.Cells[1,0]:='Nº NF';
  sgdLista.Cells[2,0]:='Sr'; sgdLista.Cells[3,0]:='Destinatário';
  sgdLista.Cells[4,0]:='Emissão'; sgdLista.Cells[5,0]:='Total';
  sgdLista.Cells[6,0]:='Status'; sgdLista.Cells[7,0]:='Venda';
  sgdLista.Cells[8,0]:='Chave (parcial)';
  { Grid itens NF }
  sgdItens.ColCount := 9; //sgdItens.FixedRows := 1;
  sgdItens.Options := sgdItens.Options + [goColSizing, goRowSelect];
  sgdItens.ColWidths[0]:=35; sgdItens.ColWidths[1]:=180; sgdItens.ColWidths[2]:=50;
  sgdItens.ColWidths[3]:=50; sgdItens.ColWidths[4]:=60; sgdItens.ColWidths[5]:=70;
  sgdItens.ColWidths[6]:=70; sgdItens.ColWidths[7]:=70; sgdItens.ColWidths[8]:=70;
  sgdItens.Cells[0,0]:='#'; sgdItens.Cells[1,0]:='Produto';
  sgdItens.Cells[2,0]:='UN'; sgdItens.Cells[3,0]:='CFOP';
  sgdItens.Cells[4,0]:='Qtd'; sgdItens.Cells[5,0]:='Vl.Unit';
  sgdItens.Cells[6,0]:='Vl.Prod'; sgdItens.Cells[7,0]:='ICMS';
  sgdItens.Cells[8,0]:='Total';
  { Combos }
  cboStatusNF.Items.Add('(Todos)');
  cboStatusNF.Items.Add('DIGITACAO');
  cboStatusNF.Items.Add('VALIDADA');
  cboStatusNF.Items.Add('AUTORIZADA');
  cboStatusNF.Items.Add('CANCELADA');
  cboStatusNF.ItemIndex := 0;
  cboFinalidade.Items.CommaText := '1-Normal,2-Complementar,3-Ajuste,4-Devolução';
  cboFinalidade.ItemIndex := 0;
  cboAmbiente.Items.CommaText := '2-Homologação,1-Produção';
  cboAmbiente.ItemIndex := 0;
  cboDestIndicIE.Items.CommaText := '1-Contribuinte,2-Isento,9-Não Contribuinte';
  cboDestIndicIE.ItemIndex := 2;
  cboModalFrete.Items.CommaText := '9-Sem Frete,0-Por conta Emitente,1-Por conta Destinatário';
  cboModalFrete.ItemIndex := 0;
  ModoEdicao(False);
  CarregarLista;
end;

procedure TFrmNFSaida.CarregarLista;
var Qry: TFDQuery; W: string;
begin
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT NF.ID,NF.NUMERO,NF.SERIE,C.NOME,NF.DT_EMISSAO,' +
      'NF.VL_TOTAL_NF,NF.STATUS_NF,NF.ID_VENDA,' +
      'SUBSTRING(NF.CHAVE_NF FROM 1 FOR 22) AS CHAVE_PARC ' +
      'FROM NF_SAIDA NF JOIN CLIENTES C ON C.ID=NF.ID_CLIENTE ';
    W := '';
    if cboStatusNF.ItemIndex > 0 then
      W := 'NF.STATUS_NF=''' + cboStatusNF.Items[cboStatusNF.ItemIndex] + '''';
    if Trim(edtFiltro.Text) <> '' then
    begin
      if W <> '' then W := W + ' AND ';
      W := W + '(UPPER(C.NOME) CONTAINING UPPER(:F) OR CAST(NF.NUMERO AS VARCHAR(10)) CONTAINING :F)';
    end;
    if W <> '' then Qry.SQL.Add('WHERE '+W);
    Qry.SQL.Add('ORDER BY NF.NUMERO DESC');
    if Trim(edtFiltro.Text) <> '' then Qry.ParamByName('F').AsString := edtFiltro.Text;
    Qry.Open;
    PreencherGridLista(Qry);
  finally Qry.Free; end;
end;

procedure TFrmNFSaida.PreencherGridLista(Qry: TFDQuery);
var R: Integer;
begin
  sgdLista.RowCount := Qry.RecordCount+1;
  R := 1; Qry.First;
  while not Qry.Eof do
  begin
    sgdLista.Cells[0,R] := Qry.Fields[0].AsString;
    sgdLista.Cells[1,R] := Qry.Fields[1].AsString;
    sgdLista.Cells[2,R] := Qry.Fields[2].AsString;
    sgdLista.Cells[3,R] := Qry.Fields[3].AsString;
    sgdLista.Cells[4,R] := FormatDateTime('dd/mm/yyyy', Qry.Fields[4].AsDateTime);
    sgdLista.Cells[5,R] := MoedaStr(Qry.Fields[5].AsFloat);
    sgdLista.Cells[6,R] := Qry.Fields[6].AsString;
    sgdLista.Cells[7,R] := IfThen(Qry.Fields[7].IsNull, '', Qry.Fields[7].AsString);
    sgdLista.Cells[8,R] := Qry.Fields[8].AsString;
    Inc(R); Qry.Next;
  end;
  while R <= sgdLista.RowCount-1 do begin sgdLista.Rows[R].Clear; Inc(R); end;
end;

procedure TFrmNFSaida.CarregarItens(AIDNF: Integer);
var Qry: TFDQuery; R: Integer;
begin
  sgdItens.RowCount := 2; sgdItens.Rows[1].Clear;
  if AIDNF = 0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT NI.ITEM, NI.DESCRICAO, NI.UNIDADE, NI.CFOP, ' +
      'NI.QUANTIDADE, NI.VL_UNITARIO, NI.VL_PRODUTOS, NI.VL_ICMS, NI.VL_TOTAL_ITEM ' +
      'FROM NF_SAIDA_ITENS NI WHERE NI.ID_NF=:ID ORDER BY NI.ITEM';
    Qry.ParamByName('ID').AsInteger := AIDNF; Qry.Open;
    if Qry.IsEmpty then Exit;
    sgdItens.RowCount := Qry.RecordCount + 1;
    R := 1; Qry.First;
    while not Qry.Eof do
    begin
      sgdItens.Cells[0,R] := Qry.Fields[0].AsString;
      sgdItens.Cells[1,R] := Qry.Fields[1].AsString;
      sgdItens.Cells[2,R] := Qry.Fields[2].AsString;
      sgdItens.Cells[3,R] := Qry.Fields[3].AsString;
      sgdItens.Cells[4,R] := FormatFloat('0.###', Qry.Fields[4].AsFloat);
      sgdItens.Cells[5,R] := MoedaStr(Qry.Fields[5].AsFloat);
      sgdItens.Cells[6,R] := MoedaStr(Qry.Fields[6].AsFloat);
      sgdItens.Cells[7,R] := MoedaStr(Qry.Fields[7].AsFloat);
      sgdItens.Cells[8,R] := MoedaStr(Qry.Fields[8].AsFloat);
      Inc(R); Qry.Next;
    end;
  finally Qry.Free; end;
end;

procedure TFrmNFSaida.PreencherDestinatario(AIDCliente: Integer);
var Qry: TFDQuery;
begin
  if AIDCliente = 0 then Exit;
  FIDCliente := AIDCliente;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT * FROM CLIENTES WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger := AIDCliente; Qry.Open;
    if Qry.IsEmpty then Exit;
    edtClienteID.Text   := IntToStr(AIDCliente);
    edtClienteNome.Text := Qry.FieldByName('NOME').AsString;
    edtDestNome.Text    := Qry.FieldByName('NOME').AsString;
    edtDestCNPJ.Text    := Qry.FieldByName('CNPJ').AsString;
    edtDestCPF.Text     := Qry.FieldByName('CPF').AsString;
    edtDestIE.Text      := Qry.FieldByName('IE').AsString;
    edtDestLogr.Text    := Qry.FieldByName('LOGRADOURO').AsString;
    edtDestNum.Text     := Qry.FieldByName('NUMERO').AsString;
    edtDestBairro.Text  := Qry.FieldByName('BAIRRO').AsString;
    edtDestCidade.Text  := Qry.FieldByName('CIDADE').AsString;
    edtDestUF.Text      := Qry.FieldByName('UF').AsString;
    edtDestCEP.Text     := Qry.FieldByName('CEP').AsString;
    edtDestFone.Text    := Qry.FieldByName('FONE1').AsString;
  finally Qry.Free; end;
end;

procedure TFrmNFSaida.PreencherDeVenda(AIDVenda: Integer);
var Qry: TFDQuery; R: Integer; IDProd: Integer;
    Desc, Unid, CFOP, CodP, NCM: string;
    Qtd, VlUnit, VlProd, AliqICMS, VlICMS, VlTotal: Double;
begin
  Qry := DMPrincipal.NovaQuery;
  try
    { Busca dados da venda }
    Qry.SQL.Text := 'SELECT * FROM VENDAS WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger := AIDVenda; Qry.Open;
    if Qry.IsEmpty then begin ShowMessage('Venda não encontrada!'); Exit; end;
    FIDVenda := AIDVenda;
    edtVendaID.Text  := IntToStr(AIDVenda);
    edtVendaNum.Text := Qry.FieldByName('NUMERO').AsString;
    PreencherDestinatario(Qry.FieldByName('ID_CLIENTE').AsInteger);
    { Itens da venda }
    Qry.Close;
    Qry.SQL.Text :=
      'SELECT VI.ITEM, VI.ID_PRODUTO, P.DESCRICAO, U.SIGLA, P.CFOP, ' +
      'P.CODIGO, P.NCM, VI.QUANTIDADE, VI.VL_UNITARIO, VI.VL_TOTAL, ' +
      'P.ALIQ_ICMS, P.BASE_ICMS ' +
      'FROM VENDAS_ITENS VI ' +
      'JOIN PRODUTOS P ON P.ID=VI.ID_PRODUTO ' +
      'JOIN UNIDADES U ON U.ID=P.ID_UNIDADE ' +
      'WHERE VI.ID_VENDA=:ID ORDER BY VI.ITEM';
    Qry.ParamByName('ID').AsInteger := AIDVenda; Qry.Open;
    if Qry.IsEmpty then Exit;
    sgdItens.RowCount := Qry.RecordCount + 1;
    { Armazena dados nos campos ocultos: usa Tags do grid }
    R := 1; Qry.First;
    while not Qry.Eof do
    begin
      IDProd    := Qry.Fields[1].AsInteger;
      Desc      := Qry.Fields[2].AsString;
      Unid      := Qry.Fields[3].AsString;
      CFOP      := Qry.Fields[4].AsString;
      CodP      := Qry.Fields[5].AsString;
      NCM       := Qry.Fields[6].AsString;
      Qtd       := Qry.Fields[7].AsFloat;
      VlUnit    := Qry.Fields[8].AsFloat;
      VlProd    := Qry.Fields[9].AsFloat;
      AliqICMS  := Qry.Fields[10].AsFloat;
      { Calcula ICMS simplificado }
      VlICMS    := VlProd * (AliqICMS / 100);
      VlTotal   := VlProd + VlICMS;
      sgdItens.Cells[0,R] := IntToStr(R);
      sgdItens.Cells[1,R] := Desc;
      sgdItens.Cells[2,R] := Unid;
      sgdItens.Cells[3,R] := CFOP;
      sgdItens.Cells[4,R] := FormatFloat('0.###', Qtd);
      sgdItens.Cells[5,R] := MoedaStr(VlUnit);
      sgdItens.Cells[6,R] := MoedaStr(VlProd);
      sgdItens.Cells[7,R] := MoedaStr(VlICMS);
      sgdItens.Cells[8,R] := MoedaStr(VlTotal);
      { Guarda ID do produto na coluna oculta via Object }
      sgdItens.Objects[0,R] := TObject(IDProd);
      Inc(R); Qry.Next;
    end;
    RecalcularTotaisNF;
  finally Qry.Free; end;
end;

procedure TFrmNFSaida.RecalcularTotaisNF;
var R: Integer;
    TotProd, TotICMS, TotTotal: Double;
begin
  TotProd := 0; TotICMS := 0; TotTotal := 0;
  for R := 1 to sgdItens.RowCount - 1 do
  begin
    if sgdItens.Cells[0,R] = '' then Continue;
    TotProd  := TotProd  + StrMoeda(sgdItens.Cells[6,R]);
    TotICMS  := TotICMS  + StrMoeda(sgdItens.Cells[7,R]);
    TotTotal := TotTotal + StrMoeda(sgdItens.Cells[8,R]);
  end;
  edtTotProd.Text  := MoedaStr(TotProd);
  edtTotICMS.Text  := MoedaStr(TotICMS);
  edtTotBCICMS.Text:= MoedaStr(TotProd);
  edtTotNF.Text    := MoedaStr(TotTotal + StrMoeda(edtTotFrete.Text) - StrMoeda(edtTotDesc.Text));
end;

procedure TFrmNFSaida.ModoEdicao(AEditar: Boolean);
begin
  pgcNF.Visible     := AEditar;
  pnlBotoesNF.Visible := AEditar;
  pnlFiltro.Enabled := not AEditar;
  sgdLista.Enabled  := not AEditar;
  btnNova.Enabled   := not AEditar;
  btnDeVenda.Enabled:= not AEditar;
end;

procedure TFrmNFSaida.LimparEdicao;
var R: Integer;
begin
  FIDSelecionado := 0; FStatusAtual := '';
  FIDCliente := 0; FIDVenda := 0;
  edtNumNF.Text := '(automático)'; edtSerie.Text := '1';
  edtDtEmissao.Date := Date;
  edtNatureza.Text  := 'VENDA DE MERCADORIA';
  cboFinalidade.ItemIndex := 0; cboAmbiente.ItemIndex := 0;
  edtStatusNFEd.Text := STNF_DIGITACAO;
  edtVendaID.Text := ''; edtVendaNum.Text := '';
  mmoInfoCompl.Lines.Clear;
  edtDestNome.Text:=''; edtDestCNPJ.Text:=''; edtDestCPF.Text:='';
  edtDestIE.Text:=''; edtDestLogr.Text:=''; edtDestNum.Text:='';
  edtDestBairro.Text:=''; edtDestCidade.Text:=''; edtDestUF.Text:='';
  edtDestCEP.Text:=''; edtDestFone.Text:='';
  edtClienteID.Text:=''; edtClienteNome.Text:='';
  sgdItens.RowCount := 2;
  for R := 1 to sgdItens.RowCount-1 do sgdItens.Rows[R].Clear;
  edtAddProdID.Text:=''; edtAddProdNome.Text:='';
  edtAddQtd.Text:='1,000'; edtAddVlUnit.Text:='0,00'; edtAddCFOP.Text:='5102';
  edtTotBCICMS.Text:='R$ 0,00'; edtTotICMS.Text:='R$ 0,00';
  edtTotIPI.Text:='R$ 0,00'; edtTotPIS.Text:='R$ 0,00';
  edtTotCOFINS.Text:='R$ 0,00'; edtTotFrete.Text:='R$ 0,00';
  edtTotDesc.Text:='R$ 0,00'; edtTotProd.Text:='R$ 0,00'; edtTotNF.Text:='R$ 0,00';
  AtualizarBotoes;
end;

procedure TFrmNFSaida.AtualizarBotoes;
begin
  btnSalvarNF.Enabled  := (FStatusAtual='') or (FStatusAtual=STNF_DIGITACAO);
  btnGerarXML.Enabled  := (FIDSelecionado>0) and ((FStatusAtual=STNF_DIGITACAO) or (FStatusAtual=STNF_VALIDADA));
  btnCancelarNF.Enabled:= (FIDSelecionado>0) and (FStatusAtual=STNF_AUTORIZADA);
end;

function TFrmNFSaida.GerarXMLNFe: string;
{ Gera XML simplificado da NF-e para integração com WebService SEFAZ ou ACBr }
var SB: TStringBuilder; R: Integer;
    DtEmissao: string;
begin
  DtEmissao := FormatDateTime('yyyy-mm-dd', edtDtEmissao.Date) + 'T00:00:00-03:00';
  SB := TStringBuilder.Create;
  try
    SB.AppendLine('<?xml version="1.0" encoding="UTF-8"?>');
    SB.AppendLine('<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">');
    SB.AppendLine('<NFe xmlns="http://www.portalfiscal.inf.br/nfe">');
    SB.AppendLine('<infNFe versao="4.00" Id="NFe' + StringOfChar('0', 44) + '">');
    SB.AppendLine('<ide>');
    SB.AppendLine('  <cUF>35</cUF>'); { SP padrão — alterar conforme UF emitente }
    SB.AppendLine('  <cNF>00000001</cNF>');
    SB.AppendLine('  <natOp>' + edtNatureza.Text + '</natOp>');
    SB.AppendLine('  <mod>55</mod>');
    SB.AppendLine('  <serie>' + edtSerie.Text + '</serie>');
    SB.AppendLine('  <nNF>' + edtNumNF.Text + '</nNF>');
    SB.AppendLine('  <dhEmi>' + DtEmissao + '</dhEmi>');
    SB.AppendLine('  <tpNF>1</tpNF>');
    SB.AppendLine('  <idDest>1</idDest>');
    SB.AppendLine('  <cMunFG>3550308</cMunFG>');
    SB.AppendLine('  <tpImp>1</tpImp>');
    SB.AppendLine('  <tpEmis>1</tpEmis>');
    SB.AppendLine('  <cDV>0</cDV>');
    SB.AppendLine('  <tpAmb>' + Copy(cboAmbiente.Items[cboAmbiente.ItemIndex],1,1) + '</tpAmb>');
    SB.AppendLine('  <finNFe>' + Copy(cboFinalidade.Items[cboFinalidade.ItemIndex],1,1) + '</finNFe>');
    SB.AppendLine('  <indFinal>1</indFinal>');
    SB.AppendLine('  <indPres>1</indPres>');
    SB.AppendLine('  <procEmi>0</procEmi>');
    SB.AppendLine('  <verProc>LogFacil 3.0</verProc>');
    SB.AppendLine('</ide>');
    { Emitente — preencher com dados reais da empresa }
    SB.AppendLine('<emit>');
    SB.AppendLine('  <CNPJ>00000000000000</CNPJ>');
    SB.AppendLine('  <xNome>EMPRESA EMITENTE LTDA</xNome>');
    SB.AppendLine('  <IE>000000000000</IE>');
    SB.AppendLine('  <CRT>3</CRT>');
    SB.AppendLine('</emit>');
    { Destinatário }
    SB.AppendLine('<dest>');
    if edtDestCNPJ.Text <> '' then
      SB.AppendLine('  <CNPJ>' + SoNumeros(edtDestCNPJ.Text) + '</CNPJ>')
    else
      SB.AppendLine('  <CPF>' + SoNumeros(edtDestCPF.Text) + '</CPF>');
    SB.AppendLine('  <xNome>' + edtDestNome.Text + '</xNome>');
    SB.AppendLine('  <enderDest>');
    SB.AppendLine('    <xLgr>' + edtDestLogr.Text + '</xLgr>');
    SB.AppendLine('    <nro>' + edtDestNum.Text + '</nro>');
    SB.AppendLine('    <xBairro>' + edtDestBairro.Text + '</xBairro>');
    SB.AppendLine('    <xMun>' + edtDestCidade.Text + '</xMun>');
    SB.AppendLine('    <UF>' + edtDestUF.Text + '</UF>');
    SB.AppendLine('    <CEP>' + SoNumeros(edtDestCEP.Text) + '</CEP>');
    SB.AppendLine('    <cPais>1058</cPais>');
    SB.AppendLine('    <xPais>Brasil</xPais>');
    SB.AppendLine('  </enderDest>');
    SB.AppendLine('  <indIEDest>' + Copy(cboDestIndicIE.Items[cboDestIndicIE.ItemIndex],1,1) + '</indIEDest>');
    if edtDestIE.Text <> '' then
      SB.AppendLine('  <IE>' + edtDestIE.Text + '</IE>');
    SB.AppendLine('</dest>');
    { Itens }
    for R := 1 to sgdItens.RowCount - 1 do
    begin
      if sgdItens.Cells[0,R] = '' then Continue;
      SB.AppendLine('<det nItem="' + sgdItens.Cells[0,R] + '">');
      SB.AppendLine('  <prod>');
      SB.AppendLine('    <cProd>' + sgdItens.Cells[0,R] + '</cProd>');
      SB.AppendLine('    <xProd>' + sgdItens.Cells[1,R] + '</xProd>');
      SB.AppendLine('    <CFOP>' + sgdItens.Cells[3,R] + '</CFOP>');
      SB.AppendLine('    <uCom>' + sgdItens.Cells[2,R] + '</uCom>');
      SB.AppendLine('    <qCom>' + StringReplace(sgdItens.Cells[4,R],',','.',[rfReplaceAll]) + '</qCom>');
      SB.AppendLine('    <vUnCom>' + FormatFloat('0.00', StrMoeda(sgdItens.Cells[5,R])) + '</vUnCom>');
      SB.AppendLine('    <vProd>' + FormatFloat('0.00', StrMoeda(sgdItens.Cells[6,R])) + '</vProd>');
      SB.AppendLine('    <indTot>1</indTot>');
      SB.AppendLine('  </prod>');
      SB.AppendLine('  <imposto>');
      SB.AppendLine('    <ICMS><ICMS00>');
      SB.AppendLine('      <orig>0</orig><CST>00</CST><modBC>3</modBC>');
      SB.AppendLine('      <vBC>' + FormatFloat('0.00', StrMoeda(sgdItens.Cells[6,R])) + '</vBC>');
      SB.AppendLine('      <pICMS>12.00</pICMS>');
      SB.AppendLine('      <vICMS>' + FormatFloat('0.00', StrMoeda(sgdItens.Cells[7,R])) + '</vICMS>');
      SB.AppendLine('    </ICMS00></ICMS>');
      SB.AppendLine('  </imposto>');
      SB.AppendLine('</det>');
    end;
    { Totais }
    SB.AppendLine('<total><ICMSTot>');
    SB.AppendLine('  <vBC>'     + FormatFloat('0.00', StrMoeda(edtTotBCICMS.Text)) + '</vBC>');
    SB.AppendLine('  <vICMS>'   + FormatFloat('0.00', StrMoeda(edtTotICMS.Text))   + '</vICMS>');
    SB.AppendLine('  <vProd>'   + FormatFloat('0.00', StrMoeda(edtTotProd.Text))   + '</vProd>');
    SB.AppendLine('  <vFrete>'  + FormatFloat('0.00', StrMoeda(edtTotFrete.Text))  + '</vFrete>');
    SB.AppendLine('  <vDesc>'   + FormatFloat('0.00', StrMoeda(edtTotDesc.Text))   + '</vDesc>');
    SB.AppendLine('  <vNF>'     + FormatFloat('0.00', StrMoeda(edtTotNF.Text))     + '</vNF>');
    SB.AppendLine('</ICMSTot></total>');
    { Transporte }
    SB.AppendLine('<transp>');
    SB.AppendLine('  <modFrete>' + Copy(cboModalFrete.Items[cboModalFrete.ItemIndex],1,1) + '</modFrete>');
    SB.AppendLine('</transp>');
    if Trim(mmoInfoCompl.Text) <> '' then
    begin
      SB.AppendLine('<infAdic>');
      SB.AppendLine('  <infCpl>' + mmoInfoCompl.Text + '</infCpl>');
      SB.AppendLine('</infAdic>');
    end;
    SB.AppendLine('</infNFe></NFe></nfeProc>');
    Result := SB.ToString;
  finally SB.Free; end;
end;

procedure TFrmNFSaida.btnBuscarClick(Sender: TObject);
begin CarregarLista; end;

procedure TFrmNFSaida.btnNovaClick(Sender: TObject);
begin LimparEdicao; ModoEdicao(True); pgcNF.ActivePageIndex := 0; end;

procedure TFrmNFSaida.btnDeVendaClick(Sender: TObject);
var SID: string;
begin
  SID := InputBox('NF a partir de Venda', 'Informe o ID da Venda:', '');
  if StrToIntDef(SID, 0) = 0 then Exit;
  LimparEdicao;
  ModoEdicao(True);
  PreencherDeVenda(StrToIntDef(SID, 0));
  pgcNF.ActivePageIndex := 0;
end;

procedure TFrmNFSaida.btnBuscarVendaClick(Sender: TObject);
var SID: string;
begin
  SID := InputBox('Vincular Venda', 'Informe o ID da Venda:', '');
  if StrToIntDef(SID, 0) = 0 then Exit;
  PreencherDeVenda(StrToIntDef(SID, 0));
end;

procedure TFrmNFSaida.btnBuscarCliClick(Sender: TObject);
var SID: string; ID: Integer;
begin
  SID := InputBox('Cliente','ID do cliente:','');
  ID := StrToIntDef(SID, 0);
  if ID > 0 then PreencherDestinatario(ID);
end;

procedure TFrmNFSaida.btnAddProdClick(Sender: TObject);
var SID: string; ID: Integer; Qry: TFDQuery;
begin
  SID := InputBox('Produto', 'ID do produto:', '');
  ID  := StrToIntDef(SID, 0);
  if ID = 0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT P.ID,P.DESCRICAO,U.SIGLA,P.PRECO_VENDA,P.CFOP ' +
      'FROM PRODUTOS P JOIN UNIDADES U ON U.ID=P.ID_UNIDADE WHERE P.ID=:ID';
    Qry.ParamByName('ID').AsInteger := ID; Qry.Open;
    if Qry.IsEmpty then begin ShowMessage('Produto não encontrado!'); Exit; end;
    edtAddProdID.Text  := Qry.Fields[0].AsString;
    edtAddProdNome.Text:= Qry.Fields[1].AsString;
    edtAddVlUnit.Text  := MoedaStr(Qry.Fields[3].AsFloat);
    edtAddCFOP.Text    := Qry.Fields[4].AsString;
  finally Qry.Free; end;
end;

procedure TFrmNFSaida.btnAddItemNFClick(Sender: TObject);
var ID_Prod,R: Integer; Qtd,VlUnit,VlProd,AliqICMS,VlICMS,VlTotal: Double; Qry: TFDQuery;
begin
  ID_Prod := StrToIntDef(edtAddProdID.Text, 0);
  if ID_Prod = 0 then begin ShowMessage('Informe o produto.'); Exit; end;
  Qtd    := StrToFloatDef(StringReplace(edtAddQtd.Text,   ',','.',[rfReplaceAll]),0);
  VlUnit := StrToFloatDef(StringReplace(edtAddVlUnit.Text,',','.',[rfReplaceAll]),0);
  if Qtd<=0 then begin ShowMessage('Qtd > 0.'); Exit; end;
  VlProd := Qtd * VlUnit;
  AliqICMS := 0;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT ALIQ_ICMS FROM PRODUTOS WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger := ID_Prod; Qry.Open;
    if not Qry.IsEmpty then AliqICMS := Qry.Fields[0].AsFloat;
  finally Qry.Free; end;
  VlICMS := VlProd * (AliqICMS / 100);
  VlTotal:= VlProd + VlICMS;
  R := sgdItens.RowCount; sgdItens.RowCount := R + 1;
  sgdItens.Cells[0,R] := IntToStr(R);
  sgdItens.Cells[1,R] := edtAddProdNome.Text;
  sgdItens.Cells[2,R] := '';
  sgdItens.Cells[3,R] := edtAddCFOP.Text;
  sgdItens.Cells[4,R] := FormatFloat('0.###', Qtd);
  sgdItens.Cells[5,R] := MoedaStr(VlUnit);
  sgdItens.Cells[6,R] := MoedaStr(VlProd);
  sgdItens.Cells[7,R] := MoedaStr(VlICMS);
  sgdItens.Cells[8,R] := MoedaStr(VlTotal);
  sgdItens.Objects[0,R] := TObject(ID_Prod);
  edtAddProdID.Text:=''; edtAddProdNome.Text:='';
  edtAddQtd.Text:='1,000'; edtAddVlUnit.Text:='0,00';
  RecalcularTotaisNF;
end;

procedure TFrmNFSaida.btnRemItemNFClick(Sender: TObject);
var R,I: Integer;
begin
  R := sgdItens.Row;
  if (R<1) or (sgdItens.Cells[0,R]='') then Exit;
  for I:=R to sgdItens.RowCount-2 do sgdItens.Rows[I].Assign(sgdItens.Rows[I+1]);
  sgdItens.RowCount := sgdItens.RowCount - 1;
  RecalcularTotaisNF;
end;

procedure TFrmNFSaida.sgdListaClick(Sender: TObject);
var R,ID: Integer; Qry: TFDQuery;
begin
  R := sgdLista.Row;
  if (R<1) or (sgdLista.Cells[0,R]='') then Exit;
  ID := StrToIntDef(sgdLista.Cells[0,R],0); if ID=0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT NF.*,C.NOME AS CNOME FROM NF_SAIDA NF JOIN CLIENTES C ON C.ID=NF.ID_CLIENTE WHERE NF.ID=:ID';
    Qry.ParamByName('ID').AsInteger := ID; Qry.Open;
    if Qry.IsEmpty then Exit;
    FIDSelecionado := ID;
    FStatusAtual := Qry.FieldByName('STATUS_NF').AsString;
    edtNumNF.Text       := Qry.FieldByName('NUMERO').AsString;
    edtSerie.Text       := Qry.FieldByName('SERIE').AsString;
    edtDtEmissao.Date   := Qry.FieldByName('DT_EMISSAO').AsDateTime;
    edtNatureza.Text    := Qry.FieldByName('NATUREZA_OP').AsString;
    edtStatusNFEd.Text  := FStatusAtual;
    edtClienteID.Text   := Qry.FieldByName('ID_CLIENTE').AsString;
    edtClienteNome.Text := Qry.FieldByName('CNOME').AsString;
    edtVendaID.Text     := IfThen(Qry.FieldByName('ID_VENDA').IsNull,'',Qry.FieldByName('ID_VENDA').AsString);
    edtTotNF.Text       := MoedaStr(Qry.FieldByName('VL_TOTAL_NF').AsFloat);
    mmoInfoCompl.Text   := Qry.FieldByName('INFO_COMPL').AsString;
    FIDVenda    := Qry.FieldByName('ID_VENDA').AsInteger;
    FIDCliente  := Qry.FieldByName('ID_CLIENTE').AsInteger;
    PreencherDestinatario(FIDCliente);
    CarregarItens(ID);
    RecalcularTotaisNF;
    AtualizarBotoes;
    ModoEdicao(True);
    pgcNF.ActivePageIndex := 0;
  finally Qry.Free; end;
end;

procedure TFrmNFSaida.btnSalvarNFClick(Sender: TObject);
var Qry: TFDQuery; IDNF, R, IDProd: Integer;
    VlProd, VlICMS, VlTotal, Qtd, VlUnit, TotProd, TotICMS, TotTotal: Double;
begin
  if FIDCliente = 0 then begin ShowMessage('Informe o destinatário.'); Exit; end;
  TotProd := 0; TotICMS := 0; TotTotal := 0;
  for R := 1 to sgdItens.RowCount-1 do
    if sgdItens.Cells[0,R] <> '' then
    begin
      TotProd  := TotProd  + StrMoeda(sgdItens.Cells[6,R]);
      TotICMS  := TotICMS  + StrMoeda(sgdItens.Cells[7,R]);
      TotTotal := TotTotal + StrMoeda(sgdItens.Cells[8,R]);
    end;
  Qry := DMPrincipal.NovaQuery;
  try
    DMPrincipal.IniciarTran;
    try
      if FIDSelecionado = 0 then
      begin
        Qry.SQL.Text :=
          'INSERT INTO NF_SAIDA (ID_CLIENTE,ID_VENDA,ID_USUARIO,DT_EMISSAO,' +
          'NATUREZA_OP,SERIE,AMBIENTE,STATUS_NF,' +
          'VL_BC_ICMS,VL_ICMS,VL_PRODUTOS,VL_TOTAL_NF,INFO_COMPL) ' +
          'VALUES (:IC,:IV,:IU,CURRENT_TIMESTAMP,:NO,:SE,:AMB,:ST,' +
          ':BCICMS,:ICMS,:VP,:VT,:IC2) RETURNING ID';
        Qry.ParamByName('IV').AsInteger  := IfThen(FIDVenda>0, FIDVenda, 0);
        Qry.ParamByName('IU').AsInteger  := SessaoID;
        Qry.ParamByName('NO').AsString   := edtNatureza.Text;
        Qry.ParamByName('SE').AsString   := edtSerie.Text;
        Qry.ParamByName('AMB').AsString  := Copy(cboAmbiente.Items[cboAmbiente.ItemIndex],1,1);
        Qry.ParamByName('ST').AsString   := STNF_DIGITACAO;
        Qry.ParamByName('IC').AsInteger  := FIDCliente;
        Qry.ParamByName('BCICMS').AsFloat:= TotProd;
        Qry.ParamByName('ICMS').AsFloat  := TotICMS;
        Qry.ParamByName('VP').AsFloat    := TotProd;
        Qry.ParamByName('VT').AsFloat    := TotTotal + StrMoeda(edtTotFrete.Text) - StrMoeda(edtTotDesc.Text);
        Qry.ParamByName('IC2').AsString  := mmoInfoCompl.Text;
        Qry.Open;
        IDNF := Qry.FieldByName('ID').AsInteger;
      end
      else
      begin
        DMPrincipal.ExecSQL('DELETE FROM NF_SAIDA_ITENS WHERE ID_NF='+IntToStr(FIDSelecionado));
        IDNF := FIDSelecionado;
        DMPrincipal.ExecSQL(
          'UPDATE NF_SAIDA SET ID_CLIENTE='+IntToStr(FIDCliente)+
          ', VL_PRODUTOS='+FloatToStr(TotProd)+
          ', VL_TOTAL_NF='+FloatToStr(TotTotal)+
          ' WHERE ID='+IntToStr(IDNF));
      end;
      { Itens }
      for R := 1 to sgdItens.RowCount - 1 do
      begin
        if sgdItens.Cells[0,R] = '' then Continue;
        IDProd  := Integer(sgdItens.Objects[0,R]);
        Qtd     := StrToFloatDef(StringReplace(sgdItens.Cells[4,R],',','.',[rfReplaceAll]),0);
        VlUnit  := StrMoeda(sgdItens.Cells[5,R]);
        VlProd  := StrMoeda(sgdItens.Cells[6,R]);
        VlICMS  := StrMoeda(sgdItens.Cells[7,R]);
        VlTotal := StrMoeda(sgdItens.Cells[8,R]);
        Qry.Close;
        Qry.SQL.Text :=
          'INSERT INTO NF_SAIDA_ITENS (ID_NF,ITEM,ID_PRODUTO,DESCRICAO,CFOP,UNIDADE,' +
          'QUANTIDADE,VL_UNITARIO,VL_PRODUTOS,VL_BC_ICMS,VL_ICMS,VL_TOTAL_ITEM) ' +
          'VALUES (:IN,:IT,:IP,:DC,:CF,:UN,:QT,:VU,:VP,:BC,:ICMS,:VT)';
        Qry.ParamByName('IN').AsInteger := IDNF;
        Qry.ParamByName('IT').AsInteger := R;
        Qry.ParamByName('IP').AsInteger := IDProd;
        Qry.ParamByName('DC').AsString  := sgdItens.Cells[1,R];
        Qry.ParamByName('CF').AsString  := sgdItens.Cells[3,R];
        Qry.ParamByName('UN').AsString  := sgdItens.Cells[2,R];
        Qry.ParamByName('QT').AsFloat   := Qtd;
        Qry.ParamByName('VU').AsFloat   := VlUnit;
        Qry.ParamByName('VP').AsFloat   := VlProd;
        Qry.ParamByName('BC').AsFloat   := VlProd;
        Qry.ParamByName('ICMS').AsFloat := VlICMS;
        Qry.ParamByName('VT').AsFloat   := VlTotal;
        Qry.ExecSQL;
      end;
      DMPrincipal.CommitTran;
      if FIDSelecionado = 0 then
      begin
        FIDSelecionado := IDNF; FStatusAtual := STNF_DIGITACAO;
        edtNumNF.Text := IntToStr(IDNF); edtStatusNFEd.Text := STNF_DIGITACAO;
      end;
      AtualizarBotoes; ShowMessage(MSG_SALVO); CarregarLista;
    except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
  finally Qry.Free; end;
end;

procedure TFrmNFSaida.btnGerarXMLClick(Sender: TObject);
var XML: string; DlgSalvar: TSaveDialog; FS: TFileStream; SL: TStringList;
begin
  XML := GerarXMLNFe;
  { Atualiza XML no banco }
  if FIDSelecionado > 0 then
  begin
    try
      DMPrincipal.IniciarTran;
      { Salva XML como BLOB }
      DMPrincipal.ExecSQL(
        'UPDATE NF_SAIDA SET STATUS_NF=''VALIDADA'' WHERE ID='+IntToStr(FIDSelecionado));
      DMPrincipal.CommitTran;
      FStatusAtual := STNF_VALIDADA;
      edtStatusNFEd.Text := STNF_VALIDADA;
      AtualizarBotoes;
    except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
  end;
  { Oferecer download do XML }
  DlgSalvar := TSaveDialog.Create(nil);
  try
    DlgSalvar.Title   := 'Salvar XML da NF-e';
    DlgSalvar.Filter  := 'XML (*.xml)|*.xml';
    DlgSalvar.FileName:= 'NFe_'+edtNumNF.Text+'_'+edtSerie.Text+'.xml';
    if DlgSalvar.Execute then
    begin
      SL := TStringList.Create;
      try
        SL.Text := XML;
        SL.SaveToFile(DlgSalvar.FileName, TEncoding.UTF8);
        ShowMessage('XML gerado com sucesso!'#13#10+DlgSalvar.FileName+
          #13#10#13#10'Utilize o ACBr ou SEFAZ Web para transmissão.');
      finally SL.Free; end;
    end;
  finally DlgSalvar.Free; end;
end;

procedure TFrmNFSaida.btnCancelarNFClick(Sender: TObject);
begin
  if FIDSelecionado = 0 then Exit;
  if MessageDlg('Cancelar esta NF-e?',mtConfirmation,[mbYes,mbNo],0) <> mrYes then Exit;
  try
    DMPrincipal.IniciarTran;
    DMPrincipal.ExecSQL('UPDATE NF_SAIDA SET STATUS_NF=''CANCELADA'' WHERE ID='+IntToStr(FIDSelecionado));
    DMPrincipal.CommitTran;
    FStatusAtual := STNF_CANCELADA; edtStatusNFEd.Text := STNF_CANCELADA;
    AtualizarBotoes; CarregarLista;
    ShowMessage('NF-e cancelada.');
  except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
end;

procedure TFrmNFSaida.btnFecharNFClick(Sender: TObject);
begin
  if pgcNF.Visible then begin ModoEdicao(False); LimparEdicao; end
  else Close;
end;

end.
