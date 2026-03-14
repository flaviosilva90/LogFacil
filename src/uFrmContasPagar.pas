unit uFrmContasPagar;

{
  uFrmContasPagar.pas
  Contas a Pagar: cadastro, listagem e registro de pagamentos.
  Integra com Formas de Pagamento, Fornecedores e Fluxo de Caixa.
}

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
  FireDAC.Comp.Client, system.math, system.StrUtils;

type
  TFrmContasPagar = class(TForm)
    pnlTopo: TPanel;        lblTitulo: TLabel;
    { Filtros }
    pnlFiltro: TPanel;
    edtFiltro: TEdit;
    edtDtDe: TDateTimePicker;
    edtDtAte: TDateTimePicker;
    cboStatusFiltro: TComboBox;
    btnBuscar: TButton;
    btnNova: TButton;
    { Resumo }
    pnlResumo: TPanel;
    lblTotAberto: TLabel;
    lblTotVencido: TLabel;
    lblTotPago: TLabel;
    { Lista }
    sgdLista: TStringGrid;
    { Edição }
    pnlEdicao: TPanel;
    lblDescricao: TLabel;       edtDescricao: TEdit;
    lblFornecedor: TLabel;      edtFornecID: TEdit; edtFornecNome: TEdit; btnBuscarFornec: TButton;
    lblDtEmissao: TLabel;       edtDtEmissao: TDateTimePicker;
    lblDtVencimento: TLabel;    edtDtVenc: TDateTimePicker;
    lblVlOriginal: TLabel;      edtVlOriginal: TEdit;
    lblParcela: TLabel;         edtParcela: TEdit;
    lblTotalParcelas: TLabel;   edtTotalParcelas: TEdit;
    lblFormaPgto: TLabel;       cboFormaPgto: TComboBox;
    lblNFNum: TLabel;           edtNFNum: TEdit;
    lblHistorico: TLabel;       edtHistorico: TEdit;
    lblObs: TLabel;             mmoObs: TMemo;
    lblStatusEd: TLabel;        edtStatusEd: TEdit;
    { Histórico de pagamentos }
    lblPagamentos: TLabel;
    sgdPagamentos: TStringGrid;
    btnPagar: TButton;
    btnSalvar: TButton;
    btnExcluir: TButton;
    btnCancelarEd: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnNovaClick(Sender: TObject);
    procedure sgdListaClick(Sender: TObject);
    procedure btnBuscarFornecClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnPagarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCancelarEdClick(Sender: TObject);
  private
    FIDSelecionado: Integer;
    FStatusAtual: string;
    procedure CarregarLista;
    procedure CarregarPagamentos(AIDConta: Integer);
    procedure ModoEdicao(AEditar: Boolean);
    procedure LimparEdicao;
    procedure AtualizarResumo;
    procedure PreencherFormasPgto;
    procedure PreencherGridLista(Qry: TFDQuery);
    function  GetIDFormaSel: Integer;
  end;

  { Diálogo de pagamento embutido }
  TFrmPagarDlg = class(TForm)
    lblValorDev: TLabel;    edtValorDev: TEdit;
    lblDtPgto: TLabel;      edtDtPgto: TDateTimePicker;
    lblVlPago: TLabel;      edtVlPago: TEdit;
    lblJuros: TLabel;       edtJuros: TEdit;
    lblMulta: TLabel;       edtMulta: TEdit;
    lblDescPgto: TLabel;    edtDescPgto: TEdit;
    lblForma: TLabel;       cboForma: TComboBox;
    lblHistPgto: TLabel;    edtHistPgto: TEdit;
    btnConfirmar: TButton;
    btnCancelarDlg: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarDlgClick(Sender: TObject);
  public
    IDConta: Integer;
    VlDevido: Double;
    procedure PreencherFormas;
  end;

implementation

{$R *.dfm}

uses uGlobal, uDMPrincipal;

{ ──────────────────────────────────────────────
  TFrmPagarDlg
  ────────────────────────────────────────────── }
procedure TFrmPagarDlg.FormCreate(Sender: TObject);
begin
  Caption := 'Registrar Pagamento';
  edtDtPgto.Date := Date;
  edtJuros.Text  := '0,00';
  edtMulta.Text  := '0,00';
  edtDescPgto.Text:= '0,00';
end;

procedure TFrmPagarDlg.PreencherFormas;
var Qry: TFDQuery;
begin
  cboForma.Items.Clear;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT ID, DESCRICAO FROM FORMAS_PGTO WHERE ATIVO=''S'' ORDER BY DESCRICAO';
    Qry.Open;
    while not Qry.Eof do
    begin
      cboForma.Items.AddObject(Qry.Fields[1].AsString, TObject(Qry.Fields[0].AsInteger));
      Qry.Next;
    end;
    if cboForma.Items.Count > 0 then cboForma.ItemIndex := 0;
  finally Qry.Free; end;
end;

procedure TFrmPagarDlg.btnConfirmarClick(Sender: TObject);
var Qry: TFDQuery; IDForma: Integer;
    VlPago, VlJuros, VlMulta, VlDesc, VlTotal: Double;
    SaldoCaixa: Double;
begin
  VlPago := StrToFloatDef(StringReplace(edtVlPago.Text, ',', '.', [rfReplaceAll]), 0);
  if VlPago <= 0 then begin ShowMessage('Informe o valor pago.'); Exit; end;
  if cboForma.ItemIndex < 0 then begin ShowMessage('Selecione a forma de pagamento.'); Exit; end;
  IDForma := Integer(cboForma.Items.Objects[cboForma.ItemIndex]);
  VlJuros := StrToFloatDef(StringReplace(edtJuros.Text,   ',','.', [rfReplaceAll]), 0);
  VlMulta := StrToFloatDef(StringReplace(edtMulta.Text,   ',','.', [rfReplaceAll]), 0);
  VlDesc  := StrToFloatDef(StringReplace(edtDescPgto.Text,',','.', [rfReplaceAll]), 0);
  VlTotal := VlPago + VlJuros + VlMulta - VlDesc;
  Qry := DMPrincipal.NovaQuery;
  try
    DMPrincipal.IniciarTran;
    try
      { Registra pagamento }
      Qry.SQL.Text :=
        'INSERT INTO PAGAMENTOS (ID_CONTA, ID_FORMA_PGTO, ID_USUARIO, DT_PAGAMENTO, ' +
        'VL_PAGO, VL_JUROS, VL_MULTA, VL_DESCONTO, HISTORICO) ' +
        'VALUES (:IC, :IF, :IU, :DT, :VP, :VJ, :VM, :VD, :HI)';
      Qry.ParamByName('IC').AsInteger  := IDConta;
      Qry.ParamByName('IF').AsInteger  := IDForma;
      Qry.ParamByName('IU').AsInteger  := SessaoID;
      Qry.ParamByName('DT').AsDateTime := edtDtPgto.Date;
      Qry.ParamByName('VP').AsFloat    := VlPago;
      Qry.ParamByName('VJ').AsFloat    := VlJuros;
      Qry.ParamByName('VM').AsFloat    := VlMulta;
      Qry.ParamByName('VD').AsFloat    := VlDesc;
      Qry.ParamByName('HI').AsString   := edtHistPgto.Text;
      Qry.ExecSQL;
      { Atualiza conta a pagar }
      Qry.Close;
      Qry.SQL.Text :=
        'UPDATE CONTAS_PAGAR SET ' +
        'VL_PAGO = COALESCE(VL_PAGO,0) + :VP, ' +
        'VL_JUROS = COALESCE(VL_JUROS,0) + :VJ, ' +
        'VL_MULTA = COALESCE(VL_MULTA,0) + :VM, ' +
        'DT_PAGAMENTO = :DT, ' +
        'STATUS = CASE WHEN (COALESCE(VL_PAGO,0) + :VP2) >= VL_ORIGINAL THEN ''PAGA'' ' +
        '         ELSE ''PAGA_PARCIAL'' END ' +
        'WHERE ID = :ID';
      Qry.ParamByName('VP').AsFloat    := VlTotal;
      Qry.ParamByName('VJ').AsFloat    := VlJuros;
      Qry.ParamByName('VM').AsFloat    := VlMulta;
      Qry.ParamByName('DT').AsDateTime := edtDtPgto.Date;
      Qry.ParamByName('VP2').AsFloat   := VlTotal;
      Qry.ParamByName('ID').AsInteger  := IDConta;
      Qry.ExecSQL;
      { Movimenta caixa — busca caixa principal }
      Qry.Close;
      Qry.SQL.Text := 'SELECT ID, SALDO_ATUAL FROM CAIXAS WHERE ATIVO=''S'' ORDER BY ID ROWS 1';
      Qry.Open;
      if not Qry.IsEmpty then
      begin
        SaldoCaixa := Qry.Fields[1].AsFloat;
        Qry.Close;
        Qry.SQL.Text :=
          'INSERT INTO CAIXA_MOV (ID_CAIXA, ID_USUARIO, TIPO, ORIGEM, ID_ORIGEM, ' +
          'DESCRICAO, VALOR, SALDO_ANTES, SALDO_DEPOIS) ' +
          'VALUES (1, :IU, ''S'', ''PAGAMENTO'', :IO, :DC, :VL, :SA, :SD)';
        Qry.ParamByName('IU').AsInteger := SessaoID;
        Qry.ParamByName('IO').AsInteger := IDConta;
        Qry.ParamByName('DC').AsString  := 'Pagamento Conta #' + IntToStr(IDConta) +
          IfThen(edtHistPgto.Text<>'',' - '+edtHistPgto.Text,'');
        Qry.ParamByName('VL').AsFloat   := VlTotal;
        Qry.ParamByName('SA').AsFloat   := SaldoCaixa;
        Qry.ParamByName('SD').AsFloat   := SaldoCaixa - VlTotal;
        Qry.ExecSQL;
      end;
      DMPrincipal.CommitTran;
      ShowMessage('Pagamento registrado com sucesso!');
      ModalResult := mrOk;
    except
      on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end;
    end;
  finally Qry.Free; end;
end;

procedure TFrmPagarDlg.btnCancelarDlgClick(Sender: TObject);
begin ModalResult := mrCancel; end;

{ ──────────────────────────────────────────────
  TFrmContasPagar
  ────────────────────────────────────────────── }
procedure TFrmContasPagar.FormCreate(Sender: TObject);
begin
  FIDSelecionado := 0; FStatusAtual := '';
  { Grid lista }
  sgdLista.ColCount := 10; //sgdLista.FixedRows := 1;
  sgdLista.Options := sgdLista.Options + [goColSizing, goRowSelect];
  sgdLista.ColWidths[0]:=50; sgdLista.ColWidths[1]:=200;
  sgdLista.ColWidths[2]:=180; sgdLista.ColWidths[3]:=90;
  sgdLista.ColWidths[4]:=90; sgdLista.ColWidths[5]:=100;
  sgdLista.ColWidths[6]:=100; sgdLista.ColWidths[7]:=100;
  sgdLista.ColWidths[8]:=90; sgdLista.ColWidths[9]:=90;
  sgdLista.Cells[0,0]:='ID';       sgdLista.Cells[1,0]:='Descrição';
  sgdLista.Cells[2,0]:='Fornecedor'; sgdLista.Cells[3,0]:='Emissão';
  sgdLista.Cells[4,0]:='Vencimento'; sgdLista.Cells[5,0]:='Vl.Original';
  sgdLista.Cells[6,0]:='Vl.Pago';   sgdLista.Cells[7,0]:='Saldo';
  sgdLista.Cells[8,0]:='Status';    sgdLista.Cells[9,0]:='Parcela';
  { Grid pagamentos histórico }
  sgdPagamentos.ColCount := 6; //sgdPagamentos.FixedRows := 1;
  sgdPagamentos.Options := sgdPagamentos.Options + [goColSizing, goRowSelect];
  sgdPagamentos.ColWidths[0]:=90; sgdPagamentos.ColWidths[1]:=180;
  sgdPagamentos.ColWidths[2]:=100; sgdPagamentos.ColWidths[3]:=80;
  sgdPagamentos.ColWidths[4]:=80; sgdPagamentos.ColWidths[5]:=200;
  sgdPagamentos.Cells[0,0]:='Data';      sgdPagamentos.Cells[1,0]:='Forma';
  sgdPagamentos.Cells[2,0]:='Vl.Pago';  sgdPagamentos.Cells[3,0]:='Juros';
  sgdPagamentos.Cells[4,0]:='Desconto'; sgdPagamentos.Cells[5,0]:='Histórico';
  { Combos }
  cboStatusFiltro.Items.Add('(Todos)');
  cboStatusFiltro.Items.Add('ABERTA');
  cboStatusFiltro.Items.Add('PAGA_PARCIAL');
  cboStatusFiltro.Items.Add('VENCIDA');
  cboStatusFiltro.Items.Add('PAGA');
  cboStatusFiltro.Items.Add('CANCELADA');
  cboStatusFiltro.ItemIndex := 0;
  edtDtDe.Date  := Date - 30;
  edtDtAte.Date := Date + 60;
  PreencherFormasPgto;
  ModoEdicao(False);
  CarregarLista;
end;

procedure TFrmContasPagar.PreencherFormasPgto;
var Qry: TFDQuery;
begin
  cboFormaPgto.Items.Clear;
  cboFormaPgto.Items.AddObject('(Nenhuma)', TObject(0));
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT ID, DESCRICAO FROM FORMAS_PGTO WHERE ATIVO=''S'' ORDER BY DESCRICAO';
    Qry.Open;
    while not Qry.Eof do
    begin
      cboFormaPgto.Items.AddObject(Qry.Fields[1].AsString, TObject(Qry.Fields[0].AsInteger));
      Qry.Next;
    end;
    cboFormaPgto.ItemIndex := 0;
  finally Qry.Free; end;
end;

function TFrmContasPagar.GetIDFormaSel: Integer;
begin
  Result := 0;
  if cboFormaPgto.ItemIndex >= 0 then
    Result := Integer(cboFormaPgto.Items.Objects[cboFormaPgto.ItemIndex]);
end;

procedure TFrmContasPagar.CarregarLista;
var Qry: TFDQuery; W: string;
begin
  { Marca automático vencidas }
  DMPrincipal.ExecSQL(
    'UPDATE CONTAS_PAGAR SET STATUS=''VENCIDA'' ' +
    'WHERE STATUS=''ABERTA'' AND DT_VENCIMENTO < CURRENT_DATE');
  DMPrincipal.CommitTran;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT CP.ID, CP.DESCRICAO, COALESCE(F.NOME,''--'') AS FORNEC, ' +
      'CP.DT_EMISSAO, CP.DT_VENCIMENTO, CP.VL_ORIGINAL, ' +
      'COALESCE(CP.VL_PAGO,0), CP.VL_ORIGINAL - COALESCE(CP.VL_PAGO,0), ' +
      'CP.STATUS, CP.PARCELA||''/''||CP.TOTAL_PARCELAS AS PARC ' +
      'FROM CONTAS_PAGAR CP ' +
      'LEFT JOIN FORNECEDORES F ON F.ID=CP.ID_FORNECEDOR ' +
      'WHERE CP.DT_VENCIMENTO BETWEEN :DE AND :ATE ';
    Qry.ParamByName('DE').AsDateTime := edtDtDe.Date;
    Qry.ParamByName('ATE').AsDateTime:= edtDtAte.Date;
    W := '';
    if cboStatusFiltro.ItemIndex > 0 then
      W := 'AND CP.STATUS=''' + cboStatusFiltro.Items[cboStatusFiltro.ItemIndex] + ''' ';
    if Trim(edtFiltro.Text) <> '' then
      W := W + 'AND UPPER(CP.DESCRICAO) CONTAINING UPPER('''+edtFiltro.Text+''') ';
    if W <> '' then Qry.SQL.Add(W);
    Qry.SQL.Add('ORDER BY CP.DT_VENCIMENTO');
    Qry.Open;
    PreencherGridLista(Qry);
    AtualizarResumo;
  finally Qry.Free; end;
end;

procedure TFrmContasPagar.PreencherGridLista(Qry: TFDQuery);
var R: Integer; Status: string;
begin
  sgdLista.RowCount := Max(Qry.RecordCount+1, 2);
  R := 1; Qry.First;
  while not Qry.Eof do
  begin
    Status := Qry.Fields[8].AsString;
    sgdLista.Cells[0,R] := Qry.Fields[0].AsString;
    sgdLista.Cells[1,R] := Qry.Fields[1].AsString;
    sgdLista.Cells[2,R] := Qry.Fields[2].AsString;
    sgdLista.Cells[3,R] := FormatDateTime('dd/mm/yyyy', Qry.Fields[3].AsDateTime);
    sgdLista.Cells[4,R] := FormatDateTime('dd/mm/yyyy', Qry.Fields[4].AsDateTime);
    sgdLista.Cells[5,R] := MoedaStr(Qry.Fields[5].AsFloat);
    sgdLista.Cells[6,R] := MoedaStr(Qry.Fields[6].AsFloat);
    sgdLista.Cells[7,R] := MoedaStr(Qry.Fields[7].AsFloat);
    sgdLista.Cells[8,R] := Status;
    sgdLista.Cells[9,R] := Qry.Fields[9].AsString;
    Inc(R); Qry.Next;
  end;
  while R <= sgdLista.RowCount-1 do begin sgdLista.Rows[R].Clear; Inc(R); end;
end;

procedure TFrmContasPagar.AtualizarResumo;
var Qry: TFDQuery;
begin
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT ' +
      'SUM(CASE WHEN STATUS IN (''ABERTA'',''PAGA_PARCIAL'') THEN VL_ORIGINAL - COALESCE(VL_PAGO,0) ELSE 0 END),' +
      'SUM(CASE WHEN STATUS=''VENCIDA'' THEN VL_ORIGINAL - COALESCE(VL_PAGO,0) ELSE 0 END),' +
      'SUM(CASE WHEN STATUS=''PAGA'' THEN VL_PAGO ELSE 0 END) ' +
      'FROM CONTAS_PAGAR';
    Qry.Open;
    if not Qry.IsEmpty then
    begin
      lblTotAberto.Caption  := 'Em Aberto: '  + MoedaStr(Qry.Fields[0].AsFloat);
      lblTotVencido.Caption := 'Vencidas: '   + MoedaStr(Qry.Fields[1].AsFloat);
      lblTotPago.Caption    := 'Pago (total): '+ MoedaStr(Qry.Fields[2].AsFloat);
    end;
  finally Qry.Free; end;
end;

procedure TFrmContasPagar.CarregarPagamentos(AIDConta: Integer);
var Qry: TFDQuery; R: Integer;
begin
  sgdPagamentos.RowCount := 2; sgdPagamentos.Rows[1].Clear;
  if AIDConta = 0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT P.DT_PAGAMENTO, FP.DESCRICAO, P.VL_PAGO, P.VL_JUROS, P.VL_DESCONTO, P.HISTORICO ' +
      'FROM PAGAMENTOS P JOIN FORMAS_PGTO FP ON FP.ID=P.ID_FORMA_PGTO ' +
      'WHERE P.ID_CONTA=:ID ORDER BY P.DT_PAGAMENTO';
    Qry.ParamByName('ID').AsInteger := AIDConta; Qry.Open;
    if Qry.IsEmpty then Exit;
    sgdPagamentos.RowCount := Qry.RecordCount + 1;
    R := 1; Qry.First;
    while not Qry.Eof do
    begin
      sgdPagamentos.Cells[0,R] := FormatDateTime('dd/mm/yyyy', Qry.Fields[0].AsDateTime);
      sgdPagamentos.Cells[1,R] := Qry.Fields[1].AsString;
      sgdPagamentos.Cells[2,R] := MoedaStr(Qry.Fields[2].AsFloat);
      sgdPagamentos.Cells[3,R] := MoedaStr(Qry.Fields[3].AsFloat);
      sgdPagamentos.Cells[4,R] := MoedaStr(Qry.Fields[4].AsFloat);
      sgdPagamentos.Cells[5,R] := Qry.Fields[5].AsString;
      Inc(R); Qry.Next;
    end;
  finally Qry.Free; end;
end;

procedure TFrmContasPagar.ModoEdicao(AEditar: Boolean);
begin
  pnlEdicao.Visible  := AEditar;
  pnlFiltro.Enabled  := not AEditar;
  sgdLista.Enabled   := not AEditar;
  btnNova.Enabled    := not AEditar;
end;

procedure TFrmContasPagar.LimparEdicao;
begin
  FIDSelecionado := 0; FStatusAtual := '';
  edtDescricao.Text := ''; edtFornecID.Text := ''; edtFornecNome.Text := '';
  edtDtEmissao.Date := Date; edtDtVenc.Date := Date + 30;
  edtVlOriginal.Text:= '0,00'; edtParcela.Text := '1';
  edtTotalParcelas.Text := '1'; cboFormaPgto.ItemIndex := 0;
  edtNFNum.Text := ''; edtHistorico.Text := ''; mmoObs.Lines.Clear;
  edtStatusEd.Text := 'ABERTA';
  sgdPagamentos.RowCount := 2; sgdPagamentos.Rows[1].Clear;
  btnPagar.Enabled   := False;
  btnExcluir.Enabled := False;
end;

procedure TFrmContasPagar.btnBuscarClick(Sender: TObject);
begin CarregarLista; end;

procedure TFrmContasPagar.btnNovaClick(Sender: TObject);
begin LimparEdicao; ModoEdicao(True); edtDescricao.SetFocus; end;

procedure TFrmContasPagar.sgdListaClick(Sender: TObject);
var R, ID, I: Integer; Qry: TFDQuery;
begin
  R := sgdLista.Row;
  if (R<1) or (sgdLista.Cells[0,R]='') then Exit;
  ID := StrToIntDef(sgdLista.Cells[0,R],0); if ID=0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT * FROM CONTAS_PAGAR WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger := ID; Qry.Open;
    if Qry.IsEmpty then Exit;
    FIDSelecionado := ID;
    FStatusAtual := Qry.FieldByName('STATUS').AsString;
    edtDescricao.Text  := Qry.FieldByName('DESCRICAO').AsString;
    edtFornecID.Text   := Qry.FieldByName('ID_FORNECEDOR').AsString;
    edtDtEmissao.Date  := Qry.FieldByName('DT_EMISSAO').AsDateTime;
    edtDtVenc.Date     := Qry.FieldByName('DT_VENCIMENTO').AsDateTime;
    edtVlOriginal.Text := MoedaStr(Qry.FieldByName('VL_ORIGINAL').AsFloat);
    edtParcela.Text    := Qry.FieldByName('PARCELA').AsString;
    edtTotalParcelas.Text := Qry.FieldByName('TOTAL_PARCELAS').AsString;
    edtNFNum.Text      := Qry.FieldByName('NF_NUMERO').AsString;
    edtHistorico.Text  := Qry.FieldByName('HISTORICO').AsString;
    mmoObs.Text        := Qry.FieldByName('OBS').AsString;
    edtStatusEd.Text   := FStatusAtual;
    { Forma de pagamento }
    for I := 0 to cboFormaPgto.Items.Count-1 do
      if Integer(cboFormaPgto.Items.Objects[I]) = Qry.FieldByName('ID_FORMA_PGTO').AsInteger then
        begin cboFormaPgto.ItemIndex := I; Break; end;
    { Busca nome fornecedor }
    if Qry.FieldByName('ID_FORNECEDOR').AsInteger > 0 then
    begin
      Qry.Close;
      Qry.SQL.Text := 'SELECT NOME FROM FORNECEDORES WHERE ID=:ID';
      Qry.ParamByName('ID').AsInteger := StrToIntDef(edtFornecID.Text,0); Qry.Open;
      if not Qry.IsEmpty then edtFornecNome.Text := Qry.Fields[0].AsString;
    end;
    btnPagar.Enabled   := (FStatusAtual = 'ABERTA') or (FStatusAtual = 'PAGA_PARCIAL') or (FStatusAtual = 'VENCIDA');
    btnExcluir.Enabled := FStatusAtual = 'ABERTA';
    CarregarPagamentos(ID);
    ModoEdicao(True);
    edtDescricao.SetFocus;
  finally Qry.Free; end;
end;

procedure TFrmContasPagar.btnBuscarFornecClick(Sender: TObject);
var SID: string; ID: Integer; Qry: TFDQuery;
begin
  SID := InputBox('Fornecedor','ID do fornecedor:','');
  ID  := StrToIntDef(SID,0); if ID=0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT ID,NOME FROM FORNECEDORES WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger := ID; Qry.Open;
    if Qry.IsEmpty then begin ShowMessage('Fornecedor não encontrado!'); Exit; end;
    edtFornecID.Text   := Qry.Fields[0].AsString;
    edtFornecNome.Text := Qry.Fields[1].AsString;
  finally Qry.Free; end;
end;

procedure TFrmContasPagar.btnSalvarClick(Sender: TObject);
var Qry: TFDQuery;
    VlOrig: Double; IDFornec, IDForma: Integer;
begin
  if Trim(edtDescricao.Text) = '' then begin ShowMessage('Informe a descrição.'); Exit; end;
  VlOrig   := StrToFloatDef(StringReplace(edtVlOriginal.Text,',','.',[rfReplaceAll]),0);
  if VlOrig <= 0 then begin ShowMessage('Informe o valor original.'); Exit; end;
  IDFornec := StrToIntDef(edtFornecID.Text, 0);
  IDForma  := GetIDFormaSel;
  Qry := DMPrincipal.NovaQuery;
  try
    DMPrincipal.IniciarTran;
    try
      if FIDSelecionado = 0 then
        Qry.SQL.Text :=
          'INSERT INTO CONTAS_PAGAR (DESCRICAO,ID_FORNECEDOR,ID_FORMA_PGTO,ID_USUARIO,' +
          'DT_EMISSAO,DT_VENCIMENTO,PARCELA,TOTAL_PARCELAS,VL_ORIGINAL,NF_NUMERO,HISTORICO,OBS) ' +
          'VALUES (:DC,:IF,:IFP,:IU,:EM,:VN,:PA,:TP,:VO,:NF,:HI,:OB) RETURNING ID'
      else
        Qry.SQL.Text :=
          'UPDATE CONTAS_PAGAR SET DESCRICAO=:DC,ID_FORNECEDOR=:IF,ID_FORMA_PGTO=:IFP,' +
          'DT_EMISSAO=:EM,DT_VENCIMENTO=:VN,PARCELA=:PA,TOTAL_PARCELAS=:TP,' +
          'VL_ORIGINAL=:VO,NF_NUMERO=:NF,HISTORICO=:HI,OBS=:OB WHERE ID=:ID';
      Qry.ParamByName('DC').AsString   := edtDescricao.Text;
      Qry.ParamByName('IF').AsInteger  := IDFornec;
      Qry.ParamByName('IFP').AsInteger := IDForma;
      Qry.ParamByName('IU').AsInteger  := SessaoID;
      Qry.ParamByName('EM').AsDateTime := edtDtEmissao.Date;
      Qry.ParamByName('VN').AsDateTime := edtDtVenc.Date;
      Qry.ParamByName('PA').AsInteger  := StrToIntDef(edtParcela.Text,1);
      Qry.ParamByName('TP').AsInteger  := StrToIntDef(edtTotalParcelas.Text,1);
      Qry.ParamByName('VO').AsFloat    := VlOrig;
      Qry.ParamByName('NF').AsString   := edtNFNum.Text;
      Qry.ParamByName('HI').AsString   := edtHistorico.Text;
      Qry.ParamByName('OB').AsString   := mmoObs.Text;
      if FIDSelecionado = 0 then
      begin Qry.Open; FIDSelecionado := Qry.FieldByName('ID').AsInteger; end
      else
      begin Qry.ParamByName('ID').AsInteger := FIDSelecionado; Qry.ExecSQL; end;
      DMPrincipal.CommitTran;
      FStatusAtual := 'ABERTA'; edtStatusEd.Text := 'ABERTA';
      btnPagar.Enabled := True;
      ShowMessage(MSG_SALVO); CarregarLista;
    except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
  finally Qry.Free; end;
end;

procedure TFrmContasPagar.btnPagarClick(Sender: TObject);
var Dlg: TFrmPagarDlg; VlDev: Double; Qry: TFDQuery;
begin
  if FIDSelecionado = 0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT VL_ORIGINAL - COALESCE(VL_PAGO,0) AS SALDO FROM CONTAS_PAGAR WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger := FIDSelecionado; Qry.Open;
    VlDev := IfThen(not Qry.IsEmpty, Qry.Fields[0].AsFloat, 0);
  finally Qry.Free; end;
  Dlg := TFrmPagarDlg.Create(Self);
  try
    Dlg.IDConta := FIDSelecionado;
    Dlg.VlDevido := VlDev;
    Dlg.edtValorDev.Text := MoedaStr(VlDev);
    Dlg.edtVlPago.Text   := MoedaStr(VlDev);
    Dlg.PreencherFormas;
    if Dlg.ShowModal = mrOk then
    begin
      CarregarLista;
      CarregarPagamentos(FIDSelecionado);
      { Atualiza status exibido }
      Qry := DMPrincipal.NovaQuery;
      try
        Qry.SQL.Text := 'SELECT STATUS FROM CONTAS_PAGAR WHERE ID=:ID';
        Qry.ParamByName('ID').AsInteger := FIDSelecionado; Qry.Open;
        if not Qry.IsEmpty then
        begin FStatusAtual := Qry.Fields[0].AsString; edtStatusEd.Text := FStatusAtual; end;
      finally Qry.Free; end;
      btnPagar.Enabled := (FStatusAtual = 'ABERTA') or (FStatusAtual = 'PAGA_PARCIAL') or (FStatusAtual = 'VENCIDA');
    end;
  finally Dlg.Free; end;
end;

procedure TFrmContasPagar.btnExcluirClick(Sender: TObject);
begin
  if FIDSelecionado = 0 then Exit;
  if MessageDlg(MSG_CONF_EXCLUIR,mtConfirmation,[mbYes,mbNo],0) <> mrYes then Exit;
  try
    DMPrincipal.IniciarTran;
    DMPrincipal.ExecSQL('DELETE FROM CONTAS_PAGAR WHERE ID='+IntToStr(FIDSelecionado));
    DMPrincipal.CommitTran; ShowMessage(MSG_EXCLUIDO);
    ModoEdicao(False); LimparEdicao; CarregarLista;
  except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
end;

procedure TFrmContasPagar.btnCancelarEdClick(Sender: TObject);
begin ModoEdicao(False); LimparEdicao; end;

end.
