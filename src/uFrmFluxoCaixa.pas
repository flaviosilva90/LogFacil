unit uFrmFluxoCaixa;

{
  uFrmFluxoCaixa.pas
  Fluxo de Caixa:
    - Saldo atual do caixa
    - Movimentações (entradas/saídas) por período
    - Lançamento manual de entradas e saídas
    - Projeção: contas a pagar e a receber nos próximos dias
    - Resumo financeiro do período
}

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
  FireDAC.Comp.Client, system.Math, system.StrUtils;

type
  TFrmFluxoCaixa = class(TForm)
    pnlTopo: TPanel;          lblTitulo: TLabel;
    { Painel de saldo }
    pnlSaldo: TPanel;
    lblSaldoAtual: TLabel;
    lblSaldoValor: TLabel;
    lblEntradas: TLabel;
    lblSaidas: TLabel;
    lblSaldoPeriodo: TLabel;
    { Filtros }
    pnlFiltro: TPanel;
    lblDe: TLabel;    edtDe: TDateTimePicker;
    lblAte: TLabel;   edtAte: TDateTimePicker;
    cboTipoMov: TComboBox;
    btnBuscar: TButton;
    btnLancamento: TButton;
    { Abas }
    pgcFluxo: TPageControl;
    tabMovimentos: TTabSheet;
    tabProjecao: TTabSheet;
    tabResumo: TTabSheet;
    { Movimentos }
    sgdMovimentos: TStringGrid;
    { Projeção }
    pnlProjHeader: TPanel;
    lblProjPagar: TLabel;
    lblProjReceber: TLabel;
    lblProjSaldo: TLabel;
    sgdProjecao: TStringGrid;
    { Resumo }
    sgdResumo: TStringGrid;
    btnFechar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnLancamentoClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure pgcFluxoChange(Sender: TObject);
  private
    procedure CarregarSaldo;
    procedure CarregarMovimentos;
    procedure CarregarProjecao;
    procedure CarregarResumo;
    procedure LancarMovimentoManual;
  end;

implementation

{$R *.dfm}

uses uGlobal, uDMPrincipal;

procedure TFrmFluxoCaixa.FormCreate(Sender: TObject);
begin
  edtDe.Date  := Date - 30;
  edtAte.Date := Date + 7;
  { Grid movimentos }
  sgdMovimentos.ColCount := 7; //sgdMovimentos.FixedRows := 1;
  sgdMovimentos.Options := sgdMovimentos.Options + [goColSizing, goRowSelect];
  sgdMovimentos.ColWidths[0]:=140; sgdMovimentos.ColWidths[1]:=30;
  sgdMovimentos.ColWidths[2]:=300; sgdMovimentos.ColWidths[3]:=80;
  sgdMovimentos.ColWidths[4]:=100; sgdMovimentos.ColWidths[5]:=100;
  sgdMovimentos.ColWidths[6]:=100;
  sgdMovimentos.Cells[0,0]:='Data/Hora';      sgdMovimentos.Cells[1,0]:='T';
  sgdMovimentos.Cells[2,0]:='Descrição';      sgdMovimentos.Cells[3,0]:='Origem';
  sgdMovimentos.Cells[4,0]:='Valor';          sgdMovimentos.Cells[5,0]:='Saldo Ant.';
  sgdMovimentos.Cells[6,0]:='Saldo Dep.';
  { Grid projeção }
  sgdProjecao.ColCount := 6; //sgdProjecao.FixedRows := 1;
  sgdProjecao.Options := sgdProjecao.Options + [goColSizing, goRowSelect];
  sgdProjecao.ColWidths[0]:=90; sgdProjecao.ColWidths[1]:=30;
  sgdProjecao.ColWidths[2]:=280; sgdProjecao.ColWidths[3]:=120;
  sgdProjecao.ColWidths[4]:=100; sgdProjecao.ColWidths[5]:=90;
  sgdProjecao.Cells[0,0]:='Vencimento'; sgdProjecao.Cells[1,0]:='T';
  sgdProjecao.Cells[2,0]:='Descrição';  sgdProjecao.Cells[3,0]:='Parceiro';
  sgdProjecao.Cells[4,0]:='Valor';      sgdProjecao.Cells[5,0]:='Status';
  { Grid resumo }
  sgdResumo.ColCount := 3; //sgdResumo.FixedRows := 1;
  sgdResumo.Options := sgdResumo.Options + [goColSizing];
  sgdResumo.ColWidths[0]:=260; sgdResumo.ColWidths[1]:=150; sgdResumo.ColWidths[2]:=150;
  sgdResumo.Cells[0,0]:='Categoria'; sgdResumo.Cells[1,0]:='Valor'; sgdResumo.Cells[2,0]:='%';
  cboTipoMov.Items.Add('(Todos)');
  cboTipoMov.Items.Add('E - Entradas');
  cboTipoMov.Items.Add('S - Saídas');
  cboTipoMov.ItemIndex := 0;
  CarregarSaldo;
  CarregarMovimentos;
  CarregarProjecao;
end;

procedure TFrmFluxoCaixa.CarregarSaldo;
var Qry: TFDQuery;
    TotEnt, TotSai: Double;
begin
  Qry := DMPrincipal.NovaQuery;
  try
    { Saldo atual }
    Qry.SQL.Text := 'SELECT SALDO_ATUAL FROM CAIXAS WHERE ATIVO=''S'' ORDER BY ID ROWS 1';
    Qry.Open;
    if not Qry.IsEmpty then
    begin
      lblSaldoValor.Caption := MoedaStr(Qry.Fields[0].AsFloat);
      {if Qry.Fields[0].AsFloat >= 0 then
        lblSaldoValor.Font.Color := clGreen
      else
        lblSaldoValor.Font.Color := clRed;}
    end;
    { Entradas e saídas do período }
    Qry.Close;
    Qry.SQL.Text :=
      'SELECT ' +
      'SUM(CASE WHEN TIPO=''E'' THEN VALOR ELSE 0 END),' +
      'SUM(CASE WHEN TIPO=''S'' THEN VALOR ELSE 0 END) ' +
      'FROM CAIXA_MOV ' +
      'WHERE CAST(DT_MOV AS DATE) BETWEEN :DE AND :ATE';
    Qry.ParamByName('DE').AsDateTime  := edtDe.Date;
    Qry.ParamByName('ATE').AsDateTime := edtAte.Date;
    Qry.Open;
    if not Qry.IsEmpty then
    begin
      TotEnt := Qry.Fields[0].AsFloat;
      TotSai := Qry.Fields[1].AsFloat;
      lblEntradas.Caption   := 'Entradas: ' + MoedaStr(TotEnt);
      lblSaidas.Caption     := 'Saídas: '   + MoedaStr(TotSai);
      lblSaldoPeriodo.Caption := 'Saldo Período: ' + MoedaStr(TotEnt - TotSai);
      {if (TotEnt - TotSai) >= 0 then
        lblSaldoPeriodo.Font.Color := clGreen
      else
        lblSaldoPeriodo.Font.Color := clRed;}
    end;
  finally Qry.Free; end;
end;

procedure TFrmFluxoCaixa.CarregarMovimentos;
var Qry: TFDQuery; R: Integer; W: string;
begin
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT CM.DT_MOV, CM.TIPO, CM.DESCRICAO, CM.ORIGEM, ' +
      'CM.VALOR, CM.SALDO_ANTES, CM.SALDO_DEPOIS ' +
      'FROM CAIXA_MOV CM ' +
      'WHERE CAST(CM.DT_MOV AS DATE) BETWEEN :DE AND :ATE ';
    Qry.ParamByName('DE').AsDateTime  := edtDe.Date;
    Qry.ParamByName('ATE').AsDateTime := edtAte.Date;
    case cboTipoMov.ItemIndex of
      1: Qry.SQL.Add('AND CM.TIPO=''E'' ');
      2: Qry.SQL.Add('AND CM.TIPO=''S'' ');
    end;
    Qry.SQL.Add('ORDER BY CM.DT_MOV DESC');
    Qry.Open;
    sgdMovimentos.RowCount := Qry.RecordCount+1;
    R := 1; Qry.First;
    while not Qry.Eof do
    begin
      sgdMovimentos.Cells[0,R] := FormatDateTime('dd/mm/yyyy hh:nn', Qry.Fields[0].AsDateTime);
      sgdMovimentos.Cells[1,R] := Qry.Fields[1].AsString;
      sgdMovimentos.Cells[2,R] := Qry.Fields[2].AsString;
      sgdMovimentos.Cells[3,R] := Qry.Fields[3].AsString;
      sgdMovimentos.Cells[4,R] := MoedaStr(Qry.Fields[4].AsFloat);
      sgdMovimentos.Cells[5,R] := MoedaStr(Qry.Fields[5].AsFloat);
      sgdMovimentos.Cells[6,R] := MoedaStr(Qry.Fields[6].AsFloat);
      Inc(R); Qry.Next;
    end;
    while R <= sgdMovimentos.RowCount-1 do begin sgdMovimentos.Rows[R].Clear; Inc(R); end;
  finally Qry.Free; end;
end;

procedure TFrmFluxoCaixa.CarregarProjecao;
var Qry: TFDQuery; R: Integer;
    TotPagar, TotReceber: Double;
begin
  TotPagar := 0; TotReceber := 0;
  Qry := DMPrincipal.NovaQuery;
  try
    { Contas a pagar abertas nos próximos 60 dias }
    Qry.SQL.Text :=
      'SELECT CP.DT_VENCIMENTO, ''S'' AS TIPO, CP.DESCRICAO, ' +
      'COALESCE(F.NOME,''--'') AS PARCEIRO, ' +
      'CP.VL_ORIGINAL - COALESCE(CP.VL_PAGO,0) AS SALDO, CP.STATUS ' +
      'FROM CONTAS_PAGAR CP LEFT JOIN FORNECEDORES F ON F.ID=CP.ID_FORNECEDOR ' +
      'WHERE CP.STATUS IN (''ABERTA'',''VENCIDA'',''PAGA_PARCIAL'') ' +
      'AND CP.DT_VENCIMENTO <= CURRENT_DATE + 60 ' +
      'UNION ALL ' +
      'SELECT CR.DT_VENCIMENTO, ''E'' AS TIPO, CR.DESCRICAO, ' +
      'COALESCE(C.NOME,''--'') AS PARCEIRO, ' +
      'CR.VL_ORIGINAL - COALESCE(CR.VL_RECEBIDO,0) AS SALDO, CR.STATUS ' +
      'FROM CONTAS_RECEBER CR LEFT JOIN CLIENTES C ON C.ID=CR.ID_CLIENTE ' +
      'WHERE CR.STATUS IN (''ABERTA'',''VENCIDA'',''RECEBIDA_PARCIAL'') ' +
      'AND CR.DT_VENCIMENTO <= CURRENT_DATE + 60 ' +
      'ORDER BY 1';
    Qry.Open;
    sgdProjecao.RowCount := Qry.RecordCount+1;
    R := 1; Qry.First;
    while not Qry.Eof do
    begin
      sgdProjecao.Cells[0,R] := FormatDateTime('dd/mm/yyyy', Qry.Fields[0].AsDateTime);
      sgdProjecao.Cells[1,R] := Qry.Fields[1].AsString;
      sgdProjecao.Cells[2,R] := Qry.Fields[2].AsString;
      sgdProjecao.Cells[3,R] := Qry.Fields[3].AsString;
      sgdProjecao.Cells[4,R] := MoedaStr(Qry.Fields[4].AsFloat);
      sgdProjecao.Cells[5,R] := Qry.Fields[5].AsString;
      if Qry.Fields[1].AsString = 'S' then TotPagar := TotPagar + Qry.Fields[4].AsFloat
      else TotReceber := TotReceber + Qry.Fields[4].AsFloat;
      Inc(R); Qry.Next;
    end;
    while R <= sgdProjecao.RowCount-1 do begin sgdProjecao.Rows[R].Clear; Inc(R); end;
    lblProjPagar.Caption   := 'A Pagar (60d): '   + MoedaStr(TotPagar);
    lblProjReceber.Caption := 'A Receber (60d): ' + MoedaStr(TotReceber);
    lblProjSaldo.Caption   := 'Saldo Projetado: ' + MoedaStr(TotReceber - TotPagar);
    //if (TotReceber - TotPagar) >= 0 then lblProjSaldo.Font.Color := clGreen
    //else lblProjSaldo.Font.Color := clRed;
  finally Qry.Free; end;
end;

procedure TFrmFluxoCaixa.CarregarResumo;
var Qry: TFDQuery; R: Integer; TotEnt, TotSai: Double;
begin
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT ORIGEM, TIPO, SUM(VALOR) AS TOTAL ' +
      'FROM CAIXA_MOV ' +
      'WHERE CAST(DT_MOV AS DATE) BETWEEN :DE AND :ATE ' +
      'GROUP BY ORIGEM, TIPO ORDER BY TIPO, ORIGEM';
    Qry.ParamByName('DE').AsDateTime  := edtDe.Date;
    Qry.ParamByName('ATE').AsDateTime := edtAte.Date;
    Qry.Open;
    { Calcula totais }
    TotEnt := 0; TotSai := 0;
    Qry.First;
    while not Qry.Eof do
    begin
      if Qry.Fields[1].AsString = 'E' then TotEnt := TotEnt + Qry.Fields[2].AsFloat
      else TotSai := TotSai + Qry.Fields[2].AsFloat;
      Qry.Next;
    end;
    Qry.First;
    sgdResumo.RowCount := Qry.RecordCount + 4;
    R := 1;
    while not Qry.Eof do
    begin
      sgdResumo.Cells[0,R] := IfThen(Qry.Fields[1].AsString='E','► ','◄ ') + Qry.Fields[0].AsString;
      sgdResumo.Cells[1,R] := MoedaStr(Qry.Fields[2].AsFloat);
      if TotEnt + TotSai > 0 then
        sgdResumo.Cells[2,R] := FormatFloat('0.0', (Qry.Fields[2].AsFloat/(TotEnt+TotSai))*100) + '%'
      else
        sgdResumo.Cells[2,R] := '0%';
      Inc(R); Qry.Next;
    end;
    { Linha totais }
    sgdResumo.Cells[0,R]:='─────────────────────────────';
    sgdResumo.Cells[1,R]:='─────────────';
    sgdResumo.Cells[2,R]:='─────────────';
    Inc(R);
    sgdResumo.Cells[0,R]:='TOTAL ENTRADAS'; sgdResumo.Cells[1,R]:=MoedaStr(TotEnt); sgdResumo.Cells[2,R]:='';
    Inc(R);
    sgdResumo.Cells[0,R]:='TOTAL SAÍDAS';   sgdResumo.Cells[1,R]:=MoedaStr(TotSai); sgdResumo.Cells[2,R]:='';
    Inc(R);
    sgdResumo.Cells[0,R]:='RESULTADO DO PERÍODO'; sgdResumo.Cells[1,R]:=MoedaStr(TotEnt-TotSai); sgdResumo.Cells[2,R]:='';
  finally Qry.Free; end;
end;

procedure TFrmFluxoCaixa.LancarMovimentoManual;
var Tipo, Desc, VlStr: string; Vl, SaldoAtual: Double; Qry: TFDQuery;
begin
  Tipo := IfThen(MessageDlg('Tipo de lançamento:'+sLineBreak+'Sim = ENTRADA   Não = SAÍDA',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes, 'E', 'S');
  Desc := InputBox('Lançamento Manual', 'Descrição:', '');
  if Trim(Desc) = '' then Exit;
  VlStr := InputBox('Lançamento Manual', 'Valor (ex: 150.00):', '');
  Vl := StrToFloatDef(StringReplace(VlStr,',','.',[rfReplaceAll]), 0);
  if Vl <= 0 then begin ShowMessage('Valor inválido.'); Exit; end;
  Qry := DMPrincipal.NovaQuery;
  try
    DMPrincipal.IniciarTran;
    try
      Qry.SQL.Text := 'SELECT SALDO_ATUAL FROM CAIXAS WHERE ATIVO=''S'' ORDER BY ID ROWS 1';
      Qry.Open;
      SaldoAtual := IfThen(not Qry.IsEmpty, Qry.Fields[0].AsFloat, 0);
      Qry.Close;
      Qry.SQL.Text :=
        'INSERT INTO CAIXA_MOV (ID_CAIXA,ID_USUARIO,TIPO,ORIGEM,DESCRICAO,VALOR,SALDO_ANTES,SALDO_DEPOIS) ' +
        'VALUES (1,:IU,:TP,''MANUAL'',:DC,:VL,:SA,:SD)';
      Qry.ParamByName('IU').AsInteger := SessaoID;
      Qry.ParamByName('TP').AsString  := Tipo;
      Qry.ParamByName('DC').AsString  := Desc;
      Qry.ParamByName('VL').AsFloat   := Vl;
      Qry.ParamByName('SA').AsFloat   := SaldoAtual;
      Qry.ParamByName('SD').AsFloat   := IfThen(Tipo='E', SaldoAtual+Vl, SaldoAtual-Vl);
      Qry.ExecSQL;
      DMPrincipal.CommitTran;
      CarregarSaldo;
      CarregarMovimentos;
      ShowMessage('Lançamento realizado com sucesso!');
    except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
  finally Qry.Free; end;
end;

procedure TFrmFluxoCaixa.btnBuscarClick(Sender: TObject);
begin
  CarregarSaldo;
  CarregarMovimentos;
  CarregarProjecao;
  if pgcFluxo.ActivePageIndex = 2 then CarregarResumo;
end;

procedure TFrmFluxoCaixa.btnLancamentoClick(Sender: TObject);
begin LancarMovimentoManual; end;

procedure TFrmFluxoCaixa.btnFecharClick(Sender: TObject);
begin Close; end;

procedure TFrmFluxoCaixa.pgcFluxoChange(Sender: TObject);
begin
  case pgcFluxo.ActivePageIndex of
    0: CarregarMovimentos;
    1: CarregarProjecao;
    2: CarregarResumo;
  end;
end;

end.
