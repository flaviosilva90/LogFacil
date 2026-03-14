unit uFrmContasReceber;

{
  uFrmContasReceber.pas
  Contas a Receber: cadastro, listagem e registro de recebimentos.
  Integra com Clientes, Formas de Pagamento e Fluxo de Caixa.
}

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
  FireDAC.Comp.Client, System.Math, system.StrUtils;

type
  TFrmContasReceber = class(TForm)
    pnlTopo: TPanel;        lblTitulo: TLabel;
    pnlFiltro: TPanel;
    edtFiltro: TEdit;
    edtDtDe: TDateTimePicker;
    edtDtAte: TDateTimePicker;
    cboStatusFiltro: TComboBox;
    btnBuscar: TButton;
    btnNova: TButton;
    pnlResumo: TPanel;
    lblTotAberto: TLabel;
    lblTotVencido: TLabel;
    lblTotRecebido: TLabel;
    sgdLista: TStringGrid;
    pnlEdicao: TPanel;
    lblDescricao: TLabel;       edtDescricao: TEdit;
    lblCliente: TLabel;         edtClienteID: TEdit; edtClienteNome: TEdit; btnBuscarCli: TButton;
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
    lblRecebimentos: TLabel;
    sgdRecebimentos: TStringGrid;
    btnReceber: TButton;
    btnSalvar: TButton;
    btnExcluir: TButton;
    btnCancelarEd: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnNovaClick(Sender: TObject);
    procedure sgdListaClick(Sender: TObject);
    procedure btnBuscarCliClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnReceberClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCancelarEdClick(Sender: TObject);
  private
    FIDSelecionado: Integer;
    FStatusAtual: string;
    procedure CarregarLista;
    procedure CarregarRecebimentos(AIDConta: Integer);
    procedure ModoEdicao(AEditar: Boolean);
    procedure LimparEdicao;
    procedure AtualizarResumo;
    procedure PreencherFormasPgto;
    procedure PreencherGridLista(Qry: TFDQuery);
    function  GetIDFormaSel: Integer;
    procedure RegistrarRecebimento(AIDConta: Integer; AVlDevido: Double);
  end;

implementation

{$R *.dfm}

uses uGlobal, uDMPrincipal;

procedure TFrmContasReceber.FormCreate(Sender: TObject);
begin
  FIDSelecionado := 0; FStatusAtual := '';
  sgdLista.ColCount := 10; //sgdLista.FixedRows := 1;
  sgdLista.Options := sgdLista.Options + [goColSizing, goRowSelect];
  sgdLista.ColWidths[0]:=50; sgdLista.ColWidths[1]:=200;
  sgdLista.ColWidths[2]:=160; sgdLista.ColWidths[3]:=90;
  sgdLista.ColWidths[4]:=90; sgdLista.ColWidths[5]:=100;
  sgdLista.ColWidths[6]:=100; sgdLista.ColWidths[7]:=100;
  sgdLista.ColWidths[8]:=90; sgdLista.ColWidths[9]:=80;
  sgdLista.Cells[0,0]:='ID';       sgdLista.Cells[1,0]:='Descrição';
  sgdLista.Cells[2,0]:='Cliente';  sgdLista.Cells[3,0]:='Emissão';
  sgdLista.Cells[4,0]:='Vencimento'; sgdLista.Cells[5,0]:='Vl.Original';
  sgdLista.Cells[6,0]:='Recebido'; sgdLista.Cells[7,0]:='Saldo';
  sgdLista.Cells[8,0]:='Status';   sgdLista.Cells[9,0]:='Parcela';
  sgdRecebimentos.ColCount := 6; //sgdRecebimentos.FixedRows := 1;
  sgdRecebimentos.Options := sgdRecebimentos.Options + [goColSizing, goRowSelect];
  sgdRecebimentos.ColWidths[0]:=90; sgdRecebimentos.ColWidths[1]:=160;
  sgdRecebimentos.ColWidths[2]:=100; sgdRecebimentos.ColWidths[3]:=80;
  sgdRecebimentos.ColWidths[4]:=80; sgdRecebimentos.ColWidths[5]:=200;
  sgdRecebimentos.Cells[0,0]:='Data';     sgdRecebimentos.Cells[1,0]:='Forma';
  sgdRecebimentos.Cells[2,0]:='Recebido'; sgdRecebimentos.Cells[3,0]:='Juros';
  sgdRecebimentos.Cells[4,0]:='Desconto'; sgdRecebimentos.Cells[5,0]:='Histórico';
  cboStatusFiltro.Items.Add('(Todos)');
  cboStatusFiltro.Items.Add('ABERTA');
  cboStatusFiltro.Items.Add('RECEBIDA_PARCIAL');
  cboStatusFiltro.Items.Add('VENCIDA');
  cboStatusFiltro.Items.Add('RECEBIDA');
  cboStatusFiltro.Items.Add('CANCELADA');
  cboStatusFiltro.ItemIndex := 0;
  edtDtDe.Date  := Date - 30;
  edtDtAte.Date := Date + 60;
  PreencherFormasPgto;
  ModoEdicao(False);
  CarregarLista;
end;

procedure TFrmContasReceber.PreencherFormasPgto;
var Qry: TFDQuery;
begin
  cboFormaPgto.Items.Clear;
  cboFormaPgto.Items.AddObject('(Nenhuma)', TObject(0));
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT ID,DESCRICAO FROM FORMAS_PGTO WHERE ATIVO=''S'' ORDER BY DESCRICAO';
    Qry.Open;
    while not Qry.Eof do
    begin
      cboFormaPgto.Items.AddObject(Qry.Fields[1].AsString, TObject(Qry.Fields[0].AsInteger));
      Qry.Next;
    end;
    cboFormaPgto.ItemIndex := 0;
  finally Qry.Free; end;
end;

function TFrmContasReceber.GetIDFormaSel: Integer;
begin
  Result := 0;
  if cboFormaPgto.ItemIndex >= 0 then
    Result := Integer(cboFormaPgto.Items.Objects[cboFormaPgto.ItemIndex]);
end;

procedure TFrmContasReceber.CarregarLista;
var Qry: TFDQuery; W: string;
begin
  DMPrincipal.ExecSQL(
    'UPDATE CONTAS_RECEBER SET STATUS=''VENCIDA'' ' +
    'WHERE STATUS=''ABERTA'' AND DT_VENCIMENTO < CURRENT_DATE');
  DMPrincipal.CommitTran;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT CR.ID, CR.DESCRICAO, COALESCE(C.NOME,''--'') AS CLI, ' +
      'CR.DT_EMISSAO, CR.DT_VENCIMENTO, CR.VL_ORIGINAL, ' +
      'COALESCE(CR.VL_RECEBIDO,0), CR.VL_ORIGINAL - COALESCE(CR.VL_RECEBIDO,0), ' +
      'CR.STATUS, CR.PARCELA||''/''||CR.TOTAL_PARCELAS AS PARC ' +
      'FROM CONTAS_RECEBER CR ' +
      'LEFT JOIN CLIENTES C ON C.ID=CR.ID_CLIENTE ' +
      'WHERE CR.DT_VENCIMENTO BETWEEN :DE AND :ATE ';
    Qry.ParamByName('DE').AsDateTime  := edtDtDe.Date;
    Qry.ParamByName('ATE').AsDateTime := edtDtAte.Date;
    W := '';
    if cboStatusFiltro.ItemIndex > 0 then
      W := 'AND CR.STATUS=''' + cboStatusFiltro.Items[cboStatusFiltro.ItemIndex] + ''' ';
    if Trim(edtFiltro.Text) <> '' then
      W := W + 'AND UPPER(CR.DESCRICAO) CONTAINING UPPER('''+edtFiltro.Text+''') ';
    if W <> '' then Qry.SQL.Add(W);
    Qry.SQL.Add('ORDER BY CR.DT_VENCIMENTO');
    Qry.Open;
    PreencherGridLista(Qry);
    AtualizarResumo;
  finally Qry.Free; end;
end;

procedure TFrmContasReceber.PreencherGridLista(Qry: TFDQuery);
var R: Integer;
begin
  sgdLista.RowCount := Qry.RecordCount+1;
  R := 1; Qry.First;
  while not Qry.Eof do
  begin
    sgdLista.Cells[0,R] := Qry.Fields[0].AsString;
    sgdLista.Cells[1,R] := Qry.Fields[1].AsString;
    sgdLista.Cells[2,R] := Qry.Fields[2].AsString;
    sgdLista.Cells[3,R] := FormatDateTime('dd/mm/yyyy', Qry.Fields[3].AsDateTime);
    sgdLista.Cells[4,R] := FormatDateTime('dd/mm/yyyy', Qry.Fields[4].AsDateTime);
    sgdLista.Cells[5,R] := MoedaStr(Qry.Fields[5].AsFloat);
    sgdLista.Cells[6,R] := MoedaStr(Qry.Fields[6].AsFloat);
    sgdLista.Cells[7,R] := MoedaStr(Qry.Fields[7].AsFloat);
    sgdLista.Cells[8,R] := Qry.Fields[8].AsString;
    sgdLista.Cells[9,R] := Qry.Fields[9].AsString;
    Inc(R); Qry.Next;
  end;
  while R <= sgdLista.RowCount-1 do begin sgdLista.Rows[R].Clear; Inc(R); end;
end;

procedure TFrmContasReceber.AtualizarResumo;
var Qry: TFDQuery;
begin
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT ' +
      'SUM(CASE WHEN STATUS IN (''ABERTA'',''RECEBIDA_PARCIAL'') THEN VL_ORIGINAL-COALESCE(VL_RECEBIDO,0) ELSE 0 END),' +
      'SUM(CASE WHEN STATUS=''VENCIDA'' THEN VL_ORIGINAL-COALESCE(VL_RECEBIDO,0) ELSE 0 END),' +
      'SUM(CASE WHEN STATUS=''RECEBIDA'' THEN VL_RECEBIDO ELSE 0 END) ' +
      'FROM CONTAS_RECEBER';
    Qry.Open;
    if not Qry.IsEmpty then
    begin
      lblTotAberto.Caption   := 'A Receber: '  + MoedaStr(Qry.Fields[0].AsFloat);
      lblTotVencido.Caption  := 'Vencidas: '   + MoedaStr(Qry.Fields[1].AsFloat);
      lblTotRecebido.Caption := 'Recebido: '   + MoedaStr(Qry.Fields[2].AsFloat);
    end;
  finally Qry.Free; end;
end;

procedure TFrmContasReceber.CarregarRecebimentos(AIDConta: Integer);
var Qry: TFDQuery; R: Integer;
begin
  sgdRecebimentos.RowCount := 2; sgdRecebimentos.Rows[1].Clear;
  if AIDConta = 0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT R.DT_RECEBIMENTO, FP.DESCRICAO, R.VL_RECEBIDO, R.VL_JUROS, R.VL_DESCONTO, R.HISTORICO ' +
      'FROM RECEBIMENTOS R JOIN FORMAS_PGTO FP ON FP.ID=R.ID_FORMA_PGTO ' +
      'WHERE R.ID_CONTA=:ID ORDER BY R.DT_RECEBIMENTO';
    Qry.ParamByName('ID').AsInteger := AIDConta; Qry.Open;
    if Qry.IsEmpty then Exit;
    sgdRecebimentos.RowCount := Qry.RecordCount + 1;
    R := 1; Qry.First;
    while not Qry.Eof do
    begin
      sgdRecebimentos.Cells[0,R] := FormatDateTime('dd/mm/yyyy', Qry.Fields[0].AsDateTime);
      sgdRecebimentos.Cells[1,R] := Qry.Fields[1].AsString;
      sgdRecebimentos.Cells[2,R] := MoedaStr(Qry.Fields[2].AsFloat);
      sgdRecebimentos.Cells[3,R] := MoedaStr(Qry.Fields[3].AsFloat);
      sgdRecebimentos.Cells[4,R] := MoedaStr(Qry.Fields[4].AsFloat);
      sgdRecebimentos.Cells[5,R] := Qry.Fields[5].AsString;
      Inc(R); Qry.Next;
    end;
  finally Qry.Free; end;
end;

procedure TFrmContasReceber.ModoEdicao(AEditar: Boolean);
begin
  pnlEdicao.Visible := AEditar;
  pnlFiltro.Enabled := not AEditar;
  sgdLista.Enabled  := not AEditar;
  btnNova.Enabled   := not AEditar;
end;

procedure TFrmContasReceber.LimparEdicao;
begin
  FIDSelecionado := 0; FStatusAtual := '';
  edtDescricao.Text:=''; edtClienteID.Text:=''; edtClienteNome.Text:='';
  edtDtEmissao.Date:=Date; edtDtVenc.Date:=Date+30;
  edtVlOriginal.Text:='0,00'; edtParcela.Text:='1'; edtTotalParcelas.Text:='1';
  cboFormaPgto.ItemIndex:=0; edtNFNum.Text:=''; edtHistorico.Text:='';
  mmoObs.Lines.Clear; edtStatusEd.Text:='ABERTA';
  sgdRecebimentos.RowCount:=2; sgdRecebimentos.Rows[1].Clear;
  btnReceber.Enabled:=False; btnExcluir.Enabled:=False;
end;

procedure TFrmContasReceber.btnBuscarClick(Sender: TObject);
begin CarregarLista; end;

procedure TFrmContasReceber.btnNovaClick(Sender: TObject);
begin LimparEdicao; ModoEdicao(True); edtDescricao.SetFocus; end;

procedure TFrmContasReceber.sgdListaClick(Sender: TObject);
var R, ID, I: Integer; Qry: TFDQuery;
begin
  R := sgdLista.Row;
  if (R<1) or (sgdLista.Cells[0,R]='') then Exit;
  ID := StrToIntDef(sgdLista.Cells[0,R],0); if ID=0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT * FROM CONTAS_RECEBER WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger := ID; Qry.Open;
    if Qry.IsEmpty then Exit;
    FIDSelecionado := ID;
    FStatusAtual := Qry.FieldByName('STATUS').AsString;
    edtDescricao.Text    := Qry.FieldByName('DESCRICAO').AsString;
    edtClienteID.Text    := Qry.FieldByName('ID_CLIENTE').AsString;
    edtDtEmissao.Date    := Qry.FieldByName('DT_EMISSAO').AsDateTime;
    edtDtVenc.Date       := Qry.FieldByName('DT_VENCIMENTO').AsDateTime;
    edtVlOriginal.Text   := MoedaStr(Qry.FieldByName('VL_ORIGINAL').AsFloat);
    edtParcela.Text      := Qry.FieldByName('PARCELA').AsString;
    edtTotalParcelas.Text:= Qry.FieldByName('TOTAL_PARCELAS').AsString;
    edtNFNum.Text        := Qry.FieldByName('NF_NUMERO').AsString;
    edtHistorico.Text    := Qry.FieldByName('HISTORICO').AsString;
    mmoObs.Text          := Qry.FieldByName('OBS').AsString;
    edtStatusEd.Text     := FStatusAtual;
    for I := 0 to cboFormaPgto.Items.Count-1 do
      if Integer(cboFormaPgto.Items.Objects[I]) = Qry.FieldByName('ID_FORMA_PGTO').AsInteger then
        begin cboFormaPgto.ItemIndex := I; Break; end;
    if Qry.FieldByName('ID_CLIENTE').AsInteger > 0 then
    begin
      Qry.Close;
      Qry.SQL.Text:='SELECT NOME FROM CLIENTES WHERE ID=:ID';
      Qry.ParamByName('ID').AsInteger := StrToIntDef(edtClienteID.Text,0); Qry.Open;
      if not Qry.IsEmpty then edtClienteNome.Text := Qry.Fields[0].AsString;
    end;
    btnReceber.Enabled  := (FStatusAtual = 'ABERTA') or (FStatusAtual = 'RECEBIDA_PARCIAL') or (FStatusAtual = 'VENCIDA');
    btnExcluir.Enabled  := FStatusAtual = 'ABERTA';
    CarregarRecebimentos(ID);
    ModoEdicao(True); edtDescricao.SetFocus;
  finally Qry.Free; end;
end;

procedure TFrmContasReceber.btnBuscarCliClick(Sender: TObject);
var SID: string; ID: Integer; Qry: TFDQuery;
begin
  SID := InputBox('Cliente','ID do cliente:','');
  ID := StrToIntDef(SID,0); if ID=0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text:='SELECT ID,NOME FROM CLIENTES WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger:=ID; Qry.Open;
    if Qry.IsEmpty then begin ShowMessage('Cliente não encontrado!'); Exit; end;
    edtClienteID.Text  :=Qry.Fields[0].AsString;
    edtClienteNome.Text:=Qry.Fields[1].AsString;
  finally Qry.Free; end;
end;

procedure TFrmContasReceber.btnSalvarClick(Sender: TObject);
var Qry: TFDQuery; VlOrig: Double; IDCli, IDForma: Integer;
begin
  if Trim(edtDescricao.Text)='' then begin ShowMessage('Informe a descrição.'); Exit; end;
  VlOrig := StrToFloatDef(StringReplace(edtVlOriginal.Text,',','.',[rfReplaceAll]),0);
  if VlOrig <= 0 then begin ShowMessage('Informe o valor original.'); Exit; end;
  IDCli  := StrToIntDef(edtClienteID.Text, 0);
  IDForma:= GetIDFormaSel;
  Qry := DMPrincipal.NovaQuery;
  try
    DMPrincipal.IniciarTran;
    try
      if FIDSelecionado = 0 then
        Qry.SQL.Text :=
          'INSERT INTO CONTAS_RECEBER (DESCRICAO,ID_CLIENTE,ID_FORMA_PGTO,ID_USUARIO,' +
          'DT_EMISSAO,DT_VENCIMENTO,PARCELA,TOTAL_PARCELAS,VL_ORIGINAL,NF_NUMERO,HISTORICO,OBS) ' +
          'VALUES (:DC,:IC,:IFP,:IU,:EM,:VN,:PA,:TP,:VO,:NF,:HI,:OB) RETURNING ID'
      else
        Qry.SQL.Text :=
          'UPDATE CONTAS_RECEBER SET DESCRICAO=:DC,ID_CLIENTE=:IC,ID_FORMA_PGTO=:IFP,' +
          'DT_EMISSAO=:EM,DT_VENCIMENTO=:VN,PARCELA=:PA,TOTAL_PARCELAS=:TP,' +
          'VL_ORIGINAL=:VO,NF_NUMERO=:NF,HISTORICO=:HI,OBS=:OB WHERE ID=:ID';
      Qry.ParamByName('DC').AsString  := edtDescricao.Text;
      Qry.ParamByName('IC').AsInteger := IDCli;
      Qry.ParamByName('IFP').AsInteger:= IDForma;
      Qry.ParamByName('IU').AsInteger := SessaoID;
      Qry.ParamByName('EM').AsDateTime:= edtDtEmissao.Date;
      Qry.ParamByName('VN').AsDateTime:= edtDtVenc.Date;
      Qry.ParamByName('PA').AsInteger := StrToIntDef(edtParcela.Text,1);
      Qry.ParamByName('TP').AsInteger := StrToIntDef(edtTotalParcelas.Text,1);
      Qry.ParamByName('VO').AsFloat   := VlOrig;
      Qry.ParamByName('NF').AsString  := edtNFNum.Text;
      Qry.ParamByName('HI').AsString  := edtHistorico.Text;
      Qry.ParamByName('OB').AsString  := mmoObs.Text;
      if FIDSelecionado=0 then
      begin Qry.Open; FIDSelecionado := Qry.FieldByName('ID').AsInteger; end
      else begin Qry.ParamByName('ID').AsInteger := FIDSelecionado; Qry.ExecSQL; end;
      DMPrincipal.CommitTran;
      FStatusAtual := 'ABERTA'; edtStatusEd.Text := 'ABERTA';
      btnReceber.Enabled := True;
      ShowMessage(MSG_SALVO); CarregarLista;
    except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
  finally Qry.Free; end;
end;

procedure TFrmContasReceber.RegistrarRecebimento(AIDConta: Integer; AVlDevido: Double);
var VlRec, VlJuros, VlDesc, VlTotal, SaldoCaixa: Double;
    IDForma: Integer; DtRec: TDate; Hist: string;
    Qry: TFDQuery;
    FormaPgtoIdx: Integer;
begin
  { Diálogo inline simples via InputBox }
  VlRec := AVlDevido;
  VlJuros := 0; VlDesc := 0;
  { Seleciona forma via combo }
  IDForma := 1; { padrão primeiro }
  DtRec := Date;
  Hist  := InputBox('Recebimento','Histórico / Observação:','');
  VlTotal := VlRec + VlJuros - VlDesc;
  Qry := DMPrincipal.NovaQuery;
  try
    DMPrincipal.IniciarTran;
    try
      Qry.SQL.Text :=
        'INSERT INTO RECEBIMENTOS (ID_CONTA,ID_FORMA_PGTO,ID_USUARIO,DT_RECEBIMENTO,' +
        'VL_RECEBIDO,VL_JUROS,VL_DESCONTO,HISTORICO) ' +
        'VALUES (:IC,:IF,:IU,:DT,:VR,:VJ,:VD,:HI)';
      Qry.ParamByName('IC').AsInteger  := AIDConta;
      Qry.ParamByName('IF').AsInteger  := IDForma;
      Qry.ParamByName('IU').AsInteger  := SessaoID;
      Qry.ParamByName('DT').AsDateTime := DtRec;
      Qry.ParamByName('VR').AsFloat    := VlTotal;
      Qry.ParamByName('VJ').AsFloat    := VlJuros;
      Qry.ParamByName('VD').AsFloat    := VlDesc;
      Qry.ParamByName('HI').AsString   := Hist;
      Qry.ExecSQL;
      Qry.Close;
      Qry.SQL.Text :=
        'UPDATE CONTAS_RECEBER SET ' +
        'VL_RECEBIDO = COALESCE(VL_RECEBIDO,0) + :VR, ' +
        'DT_RECEBIMENTO = :DT, ' +
        'STATUS = CASE WHEN (COALESCE(VL_RECEBIDO,0) + :VR2) >= VL_ORIGINAL ' +
        '         THEN ''RECEBIDA'' ELSE ''RECEBIDA_PARCIAL'' END ' +
        'WHERE ID = :ID';
      Qry.ParamByName('VR').AsFloat    := VlTotal;
      Qry.ParamByName('DT').AsDateTime := DtRec;
      Qry.ParamByName('VR2').AsFloat   := VlTotal;
      Qry.ParamByName('ID').AsInteger  := AIDConta;
      Qry.ExecSQL;
      { Caixa: entrada }
      Qry.Close;
      Qry.SQL.Text := 'SELECT ID, SALDO_ATUAL FROM CAIXAS WHERE ATIVO=''S'' ORDER BY ID ROWS 1';
      Qry.Open;
      if not Qry.IsEmpty then
      begin
        SaldoCaixa := Qry.Fields[1].AsFloat;
        Qry.Close;
        Qry.SQL.Text :=
          'INSERT INTO CAIXA_MOV (ID_CAIXA,ID_USUARIO,TIPO,ORIGEM,ID_ORIGEM,' +
          'DESCRICAO,VALOR,SALDO_ANTES,SALDO_DEPOIS) ' +
          'VALUES (1,:IU,''E'',''RECEBIMENTO'',:IO,:DC,:VL,:SA,:SD)';
        Qry.ParamByName('IU').AsInteger := SessaoID;
        Qry.ParamByName('IO').AsInteger := AIDConta;
        Qry.ParamByName('DC').AsString  := 'Recebimento Conta #'+IntToStr(AIDConta)+
          IfThen(Hist<>'',' - '+Hist,'');
        Qry.ParamByName('VL').AsFloat   := VlTotal;
        Qry.ParamByName('SA').AsFloat   := SaldoCaixa;
        Qry.ParamByName('SD').AsFloat   := SaldoCaixa + VlTotal;
        Qry.ExecSQL;
      end;
      DMPrincipal.CommitTran;
      ShowMessage('Recebimento registrado com sucesso!');
    except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
  finally Qry.Free; end;
end;

procedure TFrmContasReceber.btnReceberClick(Sender: TObject);
var VlDev: Double; Qry: TFDQuery;
begin
  if FIDSelecionado = 0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT VL_ORIGINAL-COALESCE(VL_RECEBIDO,0) FROM CONTAS_RECEBER WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger := FIDSelecionado; Qry.Open;
    VlDev := IfThen(not Qry.IsEmpty, Qry.Fields[0].AsFloat, 0);
  finally Qry.Free; end;
  RegistrarRecebimento(FIDSelecionado, VlDev);
  CarregarLista;
  CarregarRecebimentos(FIDSelecionado);
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT STATUS FROM CONTAS_RECEBER WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger := FIDSelecionado; Qry.Open;
    if not Qry.IsEmpty then
    begin FStatusAtual := Qry.Fields[0].AsString; edtStatusEd.Text := FStatusAtual; end;
  finally Qry.Free; end;
  btnReceber.Enabled := (FStatusAtual = 'ABERTA') or (FStatusAtual = 'RECEBIDA_PARCIAL') or (FStatusAtual = 'VENCIDA');
end;

procedure TFrmContasReceber.btnExcluirClick(Sender: TObject);
begin
  if FIDSelecionado=0 then Exit;
  if MessageDlg(MSG_CONF_EXCLUIR,mtConfirmation,[mbYes,mbNo],0)<>mrYes then Exit;
  try
    DMPrincipal.IniciarTran;
    DMPrincipal.ExecSQL('DELETE FROM CONTAS_RECEBER WHERE ID='+IntToStr(FIDSelecionado));
    DMPrincipal.CommitTran; ShowMessage(MSG_EXCLUIDO);
    ModoEdicao(False); LimparEdicao; CarregarLista;
  except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
end;

procedure TFrmContasReceber.btnCancelarEdClick(Sender: TObject);
begin ModoEdicao(False); LimparEdicao; end;

end.
