unit uFrmImportNFXML;

{
  uFrmImportNFXML.pas
  Importação de Nota Fiscal de Entrada via arquivo XML (NF-e padrão SEFAZ).
  Lê os dados do XML e preenche automaticamente:
    - Dados do fornecedor (CNPJ, razão social, endereço)
    - Itens da compra (código, descrição, quantidade, valor unitário)
    - Dados da nota (número, série, data de emissão, chave de acesso)
  Após importação, cria ou atualiza a Compra no sistema.
}

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.IOUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.ComCtrls,
  Xml.XMLDoc, Xml.XMLIntf,
  FireDAC.Comp.Client, system.math, system.StrUtils;

type
  TNFItemImport = record
    CodigoProd   : string;
    Descricao    : string;
    NCM          : string;
    CFOP         : string;
    Unidade      : string;
    Quantidade   : Double;
    VlUnitario   : Double;
    VlTotal      : Double;
    IDMatPrima   : Integer; { vinculação manual ao MP do sistema }
  end;

  TFrmImportNFXML = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    { Seleção de arquivo }
    pnlArquivo: TPanel;
    lblArquivo: TLabel;
    edtArquivo: TEdit;
    btnSelArquivo: TButton;
    btnLerXML: TButton;
    { Dados da NF }
    grpNF: TGroupBox;
    lblChave: TLabel;      edtChave: TEdit;
    lblNumNF: TLabel;      edtNumNF: TEdit;
    lblSerieNF: TLabel;    edtSerieNF: TEdit;
    lblDtEmissao: TLabel;  edtDtEmissao: TEdit;
    lblVlTotal: TLabel;    edtVlTotalNF: TEdit;
    lblAmbiente: TLabel;   edtAmbiente: TEdit;
    { Dados do Emitente (Fornecedor) }
    grpEmitente: TPanel;
    lblEmiCNPJ: TLabel;    edtEmiCNPJ: TEdit;
    lblEmiRazao: TLabel;   edtEmiRazao: TEdit;
    lblEmiIE: TLabel;      edtEmiIE: TEdit;
    lblEmiFone: TLabel;    edtEmiFone: TEdit;
    lblFornecSistema: TLabel; edtFornecID: TEdit; edtFornecNome: TEdit; btnBuscarFornec: TButton;
    { Itens da NF }
    grpItens: TGroupBox;
    sgdItens: TStringGrid;
    lblVincularMP: TLabel;
    { Painel de vinculação }
    pnlVincular: TPanel;
    lblLinSel: TLabel;
    edtMPID: TEdit;
    edtMPNome: TEdit;
    btnBuscarMP: TButton;
    btnVincular: TButton;
    { Totais da NF }
    grpTotais: TGroupBox;
    lblVlProd: TLabel;     edtVlProd: TEdit;
    lblVlIPI: TLabel;      edtVlIPI: TEdit;
    lblVlICMS: TLabel;     edtVlICMS: TEdit;
    lblVlFrete: TLabel;    edtVlFrete: TEdit;
    lblVlDescNF: TLabel;   edtVlDescNF: TEdit;
    lblVlNF: TLabel;       edtVlNF: TEdit;
    { Ações }
    pnlBotoes: TPanel;
    btnImportar: TButton;
    btnCancelar: TButton;
    lblStatus: TLabel;
    dlgAbrir: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnSelArquivoClick(Sender: TObject);
    procedure btnLerXMLClick(Sender: TObject);
    procedure btnBuscarFornecClick(Sender: TObject);
    procedure btnBuscarMPClick(Sender: TObject);
    procedure btnVincularClick(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure sgdItensClick(Sender: TObject);
  private
    FItens      : array of TNFItemImport;
    FNItens     : Integer;
    FIDFornec   : Integer;
    FChaveNF    : string;
    FNumNF      : string;
    FSerieNF    : string;
    FDtEmissao  : TDate;
    FVlTotal    : Double;
    FVlFrete    : Double;
    FVlIPI      : Double;
    FVlICMS     : Double;
    FVlDesconto : Double;
    FVlProd     : Double;
    procedure LerXML(const AArquivo: string);
    function  GetNodeText(ANode: IXMLNode; const APath: string): string;
    procedure PreencherGridItens;
    procedure AtualizarStatus(const AMsg: string; AErro: Boolean = False);
    procedure BuscarFornecPorCNPJ(const ACNPJ: string);
  public
    IDCompraImportada: Integer; { retorna ID da compra criada }
  end;

implementation

{$R *.dfm}

uses uGlobal, uDMPrincipal;

procedure TFrmImportNFXML.FormCreate(Sender: TObject);
begin
  FNItens := 0;
  FIDFornec := 0;
  IDCompraImportada := 0;
  { Grid de itens }
  sgdItens.ColCount := 9;
  //sgdItens.FixedRows := 1;
  sgdItens.Options := sgdItens.Options + [goColSizing, goRowSelect];
  sgdItens.ColWidths[0] := 35;
  sgdItens.ColWidths[1] := 90;
  sgdItens.ColWidths[2] := 220;
  sgdItens.ColWidths[3] := 50;
  sgdItens.ColWidths[4] := 50;
  sgdItens.ColWidths[5] := 80;
  sgdItens.ColWidths[6] := 80;
  sgdItens.ColWidths[7] := 80;
  sgdItens.ColWidths[8] := 160;
  sgdItens.Cells[0,0] := '#';
  sgdItens.Cells[1,0] := 'Cód.Prod';
  sgdItens.Cells[2,0] := 'Descrição XML';
  sgdItens.Cells[3,0] := 'UN';
  sgdItens.Cells[4,0] := 'NCM';
  sgdItens.Cells[5,0] := 'Qtd';
  sgdItens.Cells[6,0] := 'Vl.Unit';
  sgdItens.Cells[7,0] := 'Vl.Total';
  sgdItens.Cells[8,0] := 'MP Vinculada (Sistema)';
  dlgAbrir.Filter := 'XML NF-e (*.xml)|*.xml|Todos os arquivos (*.*)|*.*';
  dlgAbrir.Title  := 'Selecionar XML de NF-e';
  btnLerXML.Enabled    := False;
  btnImportar.Enabled  := False;
  btnVincular.Enabled  := False;
end;

function TFrmImportNFXML.GetNodeText(ANode: IXMLNode; const APath: string): string;
var Parts: TArray<string>;
    N: IXMLNode;
    P: string;
begin
  Result := '';
  if ANode = nil then Exit;
  Parts := APath.Split(['/']);
  N := ANode;
  for P in Parts do
  begin
    if Trim(P) = '' then Continue;
    try N := N.ChildNodes[P]; except Exit; end;
    if N = nil then Exit;
  end;
  try Result := N.Text; except end;
end;

procedure TFrmImportNFXML.LerXML(const AArquivo: string);
var Doc: IXMLDocument;
    Root, NFe, infNFe, Emit, Dest, Det, Prod, Imposto, ICMS, ICMSTag,
    PIS, PIStag, COFINS, COFINStag, IPI, IPItag, Total, ICMSTot,
    Transp: IXMLNode;
    I, N: Integer;
    sAmbiente: string;
begin
  FNItens := 0;
  SetLength(FItens, 0);
  AtualizarStatus('Lendo arquivo XML...');

  Doc := TXMLDocument.Create(nil);
  try
    Doc.LoadFromFile(AArquivo);
    Doc.Active := True;

    Root := Doc.DocumentElement;
    { Suporta nfeProc (com envelope) e NFeProc ou NFe direto }
    NFe := nil;
    if Root.NodeName = 'nfeProc' then
    begin
      try NFe := Root.ChildNodes['NFe']; except end;
    end
    else if Root.NodeName = 'NFe' then NFe := Root
    else
    begin
      { Tenta encontrar NFe em qualquer nível }
      try NFe := Root.ChildNodes['NFe']; except end;
    end;

    if NFe = nil then
      raise Exception.Create('Estrutura XML inválida: nó NFe não encontrado.');

    infNFe := NFe.ChildNodes['infNFe'];
    if infNFe = nil then
      raise Exception.Create('Nó infNFe não encontrado no XML.');

    { Chave de acesso }
    FChaveNF := '';
    try FChaveNF := infNFe.Attributes['Id']; except end;
    if FChaveNF.StartsWith('NFe') then
      FChaveNF := Copy(FChaveNF, 4, 44);

    { IDE }
    FNumNF   := GetNodeText(infNFe, 'ide/nNF');
    FSerieNF := GetNodeText(infNFe, 'ide/serie');
    sAmbiente:= GetNodeText(infNFe, 'ide/tpAmb');
    try
      FDtEmissao := StrToDate(
        Copy(GetNodeText(infNFe,'ide/dhEmi'),9,2)+'/'+
        Copy(GetNodeText(infNFe,'ide/dhEmi'),6,2)+'/'+
        Copy(GetNodeText(infNFe,'ide/dhEmi'),1,4));
    except
      FDtEmissao := Date;
    end;

    edtChave.Text    := FChaveNF;
    edtNumNF.Text    := FNumNF;
    edtSerieNF.Text  := FSerieNF;
    edtDtEmissao.Text:= FormatDateTime('dd/mm/yyyy', FDtEmissao);
    edtAmbiente.Text := IfThen(sAmbiente = '1', 'PRODUÇÃO', 'HOMOLOGAÇÃO');

    { Emitente }
    Emit := infNFe.ChildNodes['emit'];
    if Emit <> nil then
    begin
      edtEmiCNPJ.Text  := GetNodeText(Emit, 'CNPJ');
      edtEmiRazao.Text := GetNodeText(Emit, 'xNome');
      edtEmiIE.Text    := GetNodeText(Emit, 'IE');
      edtEmiFone.Text  := GetNodeText(Emit, 'enderEmit/fone');
      BuscarFornecPorCNPJ(edtEmiCNPJ.Text);
    end;

    { Conta itens }
    N := 0;
    try
      for I := 0 to infNFe.ChildNodes.Count - 1 do
        if infNFe.ChildNodes[I].NodeName = 'det' then Inc(N);
    except end;
    SetLength(FItens, N);
    FNItens := N;

    { Lê itens }
    N := 0;
    for I := 0 to infNFe.ChildNodes.Count - 1 do
    begin
      Det := infNFe.ChildNodes[I];
      if Det.NodeName <> 'det' then Continue;
      Prod := Det.ChildNodes['prod'];
      if Prod = nil then Continue;
      FItens[N].CodigoProd  := GetNodeText(Prod, 'cProd');
      FItens[N].Descricao   := GetNodeText(Prod, 'xProd');
      FItens[N].NCM         := GetNodeText(Prod, 'NCM');
      FItens[N].CFOP        := GetNodeText(Prod, 'CFOP');
      FItens[N].Unidade     := GetNodeText(Prod, 'uCom');
      FItens[N].Quantidade  := StrToFloatDef(GetNodeText(Prod,'qCom'), 0);
      FItens[N].VlUnitario  := StrToFloatDef(GetNodeText(Prod,'vUnCom'), 0);
      FItens[N].VlTotal     := StrToFloatDef(GetNodeText(Prod,'vProd'), 0);
      FItens[N].IDMatPrima  := 0;
      Inc(N);
    end;

    { Totais }
    Total := infNFe.ChildNodes['total'];
    if Total <> nil then
    begin
      ICMSTot := Total.ChildNodes['ICMSTot'];
      if ICMSTot <> nil then
      begin
        FVlProd     := StrToFloatDef(GetNodeText(ICMSTot,'vProd'), 0);
        FVlIPI      := StrToFloatDef(GetNodeText(ICMSTot,'vIPI'), 0);
        FVlICMS     := StrToFloatDef(GetNodeText(ICMSTot,'vICMS'), 0);
        FVlFrete    := StrToFloatDef(GetNodeText(ICMSTot,'vFrete'), 0);
        FVlDesconto := StrToFloatDef(GetNodeText(ICMSTot,'vDesc'), 0);
        FVlTotal    := StrToFloatDef(GetNodeText(ICMSTot,'vNF'), 0);
        edtVlProd.Text  := MoedaStr(FVlProd);
        edtVlIPI.Text   := MoedaStr(FVlIPI);
        edtVlICMS.Text  := MoedaStr(FVlICMS);
        edtVlFrete.Text := MoedaStr(FVlFrete);
        edtVlDescNF.Text:= MoedaStr(FVlDesconto);
        edtVlNF.Text    := MoedaStr(FVlTotal);
        edtVlTotalNF.Text:= MoedaStr(FVlTotal);
      end;
    end;

    PreencherGridItens;
    btnImportar.Enabled := (FNItens > 0);
    AtualizarStatus(Format('XML lido com sucesso! %d itens encontrados.', [FNItens]));

  except
    on E: Exception do
    begin
      AtualizarStatus('Erro ao ler XML: ' + E.Message, True);
      ShowMessage('Erro ao processar XML:' + sLineBreak + E.Message);
    end;
  end;
end;

procedure TFrmImportNFXML.PreencherGridItens;
var I: Integer;
begin
  sgdItens.RowCount := Max(FNItens + 1, 2);
  for I := 0 to FNItens - 1 do
  begin
    sgdItens.Cells[0, I+1] := IntToStr(I+1);
    sgdItens.Cells[1, I+1] := FItens[I].CodigoProd;
    sgdItens.Cells[2, I+1] := FItens[I].Descricao;
    sgdItens.Cells[3, I+1] := FItens[I].Unidade;
    sgdItens.Cells[4, I+1] := FItens[I].NCM;
    sgdItens.Cells[5, I+1] := FormatFloat('0.###', FItens[I].Quantidade);
    sgdItens.Cells[6, I+1] := MoedaStr(FItens[I].VlUnitario);
    sgdItens.Cells[7, I+1] := MoedaStr(FItens[I].VlTotal);
    if FItens[I].IDMatPrima > 0 then
      sgdItens.Cells[8, I+1] := '['+IntToStr(FItens[I].IDMatPrima)+'] Vinculada'
    else
      sgdItens.Cells[8, I+1] := '(não vinculada)';
  end;
end;

procedure TFrmImportNFXML.BuscarFornecPorCNPJ(const ACNPJ: string);
var Qry: TFDQuery; CNPJ: string;
begin
  CNPJ := SoNumeros(ACNPJ);
  Qry  := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT ID, NOME FROM FORNECEDORES ' +
      'WHERE REPLACE(REPLACE(REPLACE(CNPJ,''.'',''''),''/'',' +
      '''''),''- '','''') = :CNPJ';
    { Simplificado: busca sem formatação }
    Qry.SQL.Text :=
      'SELECT ID, NOME FROM FORNECEDORES WHERE CNPJ CONTAINING :CNPJ';
    Qry.ParamByName('CNPJ').AsString := Copy(CNPJ,1,8); { primeiros 8 dígitos }
    Qry.Open;
    if not Qry.IsEmpty then
    begin
      FIDFornec       := Qry.FieldByName('ID').AsInteger;
      edtFornecID.Text:= IntToStr(FIDFornec);
      edtFornecNome.Text:= Qry.FieldByName('NOME').AsString;
      AtualizarStatus('Fornecedor localizado no sistema: ' + edtFornecNome.Text);
    end
    else
    begin
      FIDFornec := 0;
      edtFornecID.Text := '';
      edtFornecNome.Text := '(CNPJ não cadastrado — vincule manualmente)';
      AtualizarStatus('Fornecedor não encontrado. Vincule manualmente.', True);
    end;
  finally Qry.Free; end;
end;

procedure TFrmImportNFXML.AtualizarStatus(const AMsg: string; AErro: Boolean);
begin
  lblStatus.Caption := AMsg;
  //lblStatus.Font.Color := IfThen(AErro, ['clRed'], ['clGreen']);
end;

procedure TFrmImportNFXML.btnSelArquivoClick(Sender: TObject);
begin
  if dlgAbrir.Execute then
  begin
    edtArquivo.Text := dlgAbrir.FileName;
    btnLerXML.Enabled := True;
    AtualizarStatus('Arquivo selecionado: ' + ExtractFileName(dlgAbrir.FileName));
  end;
end;

procedure TFrmImportNFXML.btnLerXMLClick(Sender: TObject);
begin
  if not FileExists(edtArquivo.Text) then
  begin ShowMessage('Arquivo não encontrado!'); Exit; end;
  LerXML(edtArquivo.Text);
end;

procedure TFrmImportNFXML.btnBuscarFornecClick(Sender: TObject);
var SID: string; ID: Integer; Qry: TFDQuery;
begin
  SID := InputBox('Fornecedor', 'Informe o ID do fornecedor:', '');
  ID  := StrToIntDef(SID, 0);
  if ID = 0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT ID, NOME FROM FORNECEDORES WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger := ID; Qry.Open;
    if Qry.IsEmpty then begin ShowMessage('Fornecedor não encontrado!'); Exit; end;
    FIDFornec := ID;
    edtFornecID.Text   := Qry.Fields[0].AsString;
    edtFornecNome.Text := Qry.Fields[1].AsString;
    AtualizarStatus('Fornecedor vinculado: ' + edtFornecNome.Text);
  finally Qry.Free; end;
end;

procedure TFrmImportNFXML.sgdItensClick(Sender: TObject);
var R: Integer;
begin
  R := sgdItens.Row;
  if (R < 1) or (sgdItens.Cells[0,R] = '') then Exit;
  lblLinSel.Caption := 'Linha selecionada: ' + sgdItens.Cells[2, R];
  edtMPID.Text   := '';
  edtMPNome.Text := '';
  btnVincular.Enabled := True;
end;

procedure TFrmImportNFXML.btnBuscarMPClick(Sender: TObject);
var SID: string; ID: Integer; Qry: TFDQuery;
begin
  SID := InputBox('Matéria-Prima', 'Informe o ID da matéria-prima:', '');
  ID  := StrToIntDef(SID, 0);
  if ID = 0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT ID, DESCRICAO FROM MAT_PRIMAS WHERE ID=:ID AND ATIVO=''S''';
    Qry.ParamByName('ID').AsInteger := ID; Qry.Open;
    if Qry.IsEmpty then begin ShowMessage('MP não encontrada!'); Exit; end;
    edtMPID.Text   := Qry.Fields[0].AsString;
    edtMPNome.Text := Qry.Fields[1].AsString;
  finally Qry.Free; end;
end;

procedure TFrmImportNFXML.btnVincularClick(Sender: TObject);
var R, IDX: Integer;
begin
  R := sgdItens.Row;
  if (R < 1) or (sgdItens.Cells[0,R] = '') then Exit;
  IDX := StrToIntDef(sgdItens.Cells[0,R], 0) - 1;
  if (IDX < 0) or (IDX >= FNItens) then Exit;
  FItens[IDX].IDMatPrima := StrToIntDef(edtMPID.Text, 0);
  sgdItens.Cells[8, R] := '[' + edtMPID.Text + '] ' + edtMPNome.Text;
  AtualizarStatus('Item ' + IntToStr(R) + ' vinculado à MP: ' + edtMPNome.Text);
end;

procedure TFrmImportNFXML.btnImportarClick(Sender: TObject);
var Qry: TFDQuery; IDCompra, I: Integer;
    VlTotalItens: Double;
begin
  if FIDFornec = 0 then
  begin ShowMessage('Vincule um fornecedor antes de importar.'); Exit; end;

  { Verifica itens sem vínculo }
  for I := 0 to FNItens - 1 do
    if FItens[I].IDMatPrima = 0 then
    begin
      if MessageDlg(
        Format('O item "%s" não está vinculado a uma matéria-prima do sistema.'+
               sLineBreak+'Deseja importar mesmo assim (o item será ignorado)?',
               [FItens[I].Descricao]),
        mtWarning, [mbYes, mbNo], 0) = mrNo then Exit;
    end;

  Qry := DMPrincipal.NovaQuery;
  try
    DMPrincipal.IniciarTran;
    try
      { Calcula total dos itens vinculados }
      VlTotalItens := 0;
      for I := 0 to FNItens - 1 do
        if FItens[I].IDMatPrima > 0 then
          VlTotalItens := VlTotalItens + FItens[I].VlTotal;

      { Cria a Compra }
      Qry.SQL.Text :=
        'INSERT INTO COMPRAS (ID_FORNECEDOR, ID_USUARIO, DT_EMISSAO, STATUS, ' +
        'NF_NUMERO, NF_SERIE, VL_PRODUTOS, VL_FRETE, VL_DESCONTO, VL_TOTAL, OBS) ' +
        'VALUES (:IF, :IU, :EM, ''RECEBIDA'', :NF, :SE, :VP, :VF, :VD, :VT, :OB) ' +
        'RETURNING ID';
      Qry.ParamByName('IF').AsInteger  := FIDFornec;
      Qry.ParamByName('IU').AsInteger  := SessaoID;
      Qry.ParamByName('EM').AsDateTime := FDtEmissao;
      Qry.ParamByName('NF').AsString   := FNumNF;
      Qry.ParamByName('SE').AsString   := FSerieNF;
      Qry.ParamByName('VP').AsFloat    := FVlProd;
      Qry.ParamByName('VF').AsFloat    := FVlFrete;
      Qry.ParamByName('VD').AsFloat    := FVlDesconto;
      Qry.ParamByName('VT').AsFloat    := FVlTotal;
      Qry.ParamByName('OB').AsString   :=
        'Importado via XML NF-e. Chave: ' + Copy(FChaveNF,1,44);
      Qry.Open;
      IDCompra := Qry.FieldByName('ID').AsInteger;

      { Insere itens vinculados e atualiza estoque }
      for I := 0 to FNItens - 1 do
      begin
        if FItens[I].IDMatPrima = 0 then Continue;

        Qry.Close;
        Qry.SQL.Text :=
          'INSERT INTO COMPRAS_ITENS (ID_COMPRA, ITEM, ID_MAT_PRIMA, QUANTIDADE, ' +
          'VL_UNITARIO, VL_DESCONTO, VL_TOTAL) ' +
          'VALUES (:IC, :IT, :IMP, :QT, :VU, 0, :VT)';
        Qry.ParamByName('IC').AsInteger  := IDCompra;
        Qry.ParamByName('IT').AsInteger  := I + 1;
        Qry.ParamByName('IMP').AsInteger := FItens[I].IDMatPrima;
        Qry.ParamByName('QT').AsFloat    := FItens[I].Quantidade;
        Qry.ParamByName('VU').AsFloat    := FItens[I].VlUnitario;
        Qry.ParamByName('VT').AsFloat    := FItens[I].VlTotal;
        Qry.ExecSQL;
      end;

      { Dispara a atualização de estoque via UPDATE STATUS (trigger fará o trabalho) }
      Qry.Close;
      Qry.SQL.Text :=
        'UPDATE COMPRAS SET STATUS=''RECEBIDA'', DT_RECEBIMENTO=CURRENT_DATE, ' +
        'ID_USUARIO=:IU WHERE ID=:ID AND STATUS=''RECEBIDA''';
      { NOTA: A trigger TAU_COMPRA_RECEBER dispara no UPDATE para RECEBIDA,
        mas como já inserimos como RECEBIDA, precisamos disparar manualmente.
        Alternativa: inserir como PENDENTE e fazer UPDATE para RECEBIDA. }
      { Vamos usar INSERT como PENDENTE + UPDATE para RECEBIDA para acionar trigger }
      { Corrige: apaga e recria como PENDENTE }
      DMPrincipal.ExecSQL('DELETE FROM COMPRAS_ITENS WHERE ID_COMPRA='+IntToStr(IDCompra));
      DMPrincipal.ExecSQL('DELETE FROM COMPRAS WHERE ID='+IntToStr(IDCompra));

      { Recria como PENDENTE }
      Qry.Close;
      Qry.SQL.Text :=
        'INSERT INTO COMPRAS (ID_FORNECEDOR, ID_USUARIO, DT_EMISSAO, STATUS, ' +
        'NF_NUMERO, NF_SERIE, VL_PRODUTOS, VL_FRETE, VL_DESCONTO, VL_TOTAL, OBS) ' +
        'VALUES (:IF, :IU, :EM, ''PENDENTE'', :NF, :SE, :VP, :VF, :VD, :VT, :OB) ' +
        'RETURNING ID';
      Qry.ParamByName('IF').AsInteger  := FIDFornec;
      Qry.ParamByName('IU').AsInteger  := SessaoID;
      Qry.ParamByName('EM').AsDateTime := FDtEmissao;
      Qry.ParamByName('NF').AsString   := FNumNF;
      Qry.ParamByName('SE').AsString   := FSerieNF;
      Qry.ParamByName('VP').AsFloat    := FVlProd;
      Qry.ParamByName('VF').AsFloat    := FVlFrete;
      Qry.ParamByName('VD').AsFloat    := FVlDesconto;
      Qry.ParamByName('VT').AsFloat    := FVlTotal;
      Qry.ParamByName('OB').AsString   :=
        'Importado via XML NF-e. Chave: ' + Copy(FChaveNF,1,44);
      Qry.Open;
      IDCompra := Qry.FieldByName('ID').AsInteger;

      for I := 0 to FNItens - 1 do
      begin
        if FItens[I].IDMatPrima = 0 then Continue;
        Qry.Close;
        Qry.SQL.Text :=
          'INSERT INTO COMPRAS_ITENS (ID_COMPRA,ITEM,ID_MAT_PRIMA,QUANTIDADE,' +
          'VL_UNITARIO,VL_DESCONTO,VL_TOTAL) VALUES (:IC,:IT,:IMP,:QT,:VU,0,:VT)';
        Qry.ParamByName('IC').AsInteger  := IDCompra;
        Qry.ParamByName('IT').AsInteger  := I + 1;
        Qry.ParamByName('IMP').AsInteger := FItens[I].IDMatPrima;
        Qry.ParamByName('QT').AsFloat    := FItens[I].Quantidade;
        Qry.ParamByName('VU').AsFloat    := FItens[I].VlUnitario;
        Qry.ParamByName('VT').AsFloat    := FItens[I].VlTotal;
        Qry.ExecSQL;
      end;

      { Agora atualiza para RECEBIDA — trigger disparará }
      Qry.Close;
      Qry.SQL.Text :=
        'UPDATE COMPRAS SET STATUS=''RECEBIDA'', ID_USUARIO=:IU WHERE ID=:ID';
      Qry.ParamByName('IU').AsInteger := SessaoID;
      Qry.ParamByName('ID').AsInteger := IDCompra;
      Qry.ExecSQL;

      DMPrincipal.CommitTran;
      IDCompraImportada := IDCompra;
      AtualizarStatus(
        Format('NF importada com sucesso! Compra Nº %d criada. Estoque atualizado.', [IDCompra]));
      ShowMessage(
        Format('NF-e importada com sucesso!'#13#10+
               'Compra Nº %d criada no sistema.'#13#10+
               'Estoque das matérias-primas atualizado.', [IDCompra]));
      ModalResult := mrOk;
    except
      on E: Exception do
      begin
        DMPrincipal.RollbackTran;
        AtualizarStatus('Erro na importação: ' + E.Message, True);
        ShowMessage('Erro: ' + E.Message);
      end;
    end;
  finally Qry.Free; end;
end;

procedure TFrmImportNFXML.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
