unit uFrmAjusteEstoque;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
  FireDAC.Comp.Client, system.math, system.StrUtils;

type
  TFrmAjusteEstoque = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    { Lista de ajustes }
    pnlFiltro: TPanel;
    edtFiltro: TEdit;
    cboTipoEst: TComboBox;
    btnBuscar: TButton;
    btnNovo: TButton;
    sgdLista: TStringGrid;
    { Edição }
    pnlEdicao: TPanel;
    lblNumero: TLabel;      edtNumero: TEdit;
    lblData: TLabel;        edtData: TDateTimePicker;
    lblTipoEstLbl: TLabel;  cboTipoEstEd: TComboBox;
    lblMotivo: TLabel;      edtMotivo: TEdit;
    lblObs: TLabel;         mmoObs: TMemo;
    { Grid de itens do ajuste }
    lblItens: TLabel;
    sgdItens: TStringGrid;
    { Linha de adição }
    pnlAddItem: TPanel;
    lblAddID: TLabel;       edtAddID: TEdit;
    edtAddNome: TEdit;
    btnBuscarItem: TButton;
    lblAddTipoMov: TLabel;  cboAddTipoMov: TComboBox;
    lblAddQtdNova: TLabel;  edtAddQtdNova: TEdit;
    lblAddVlUnit: TLabel;   edtAddVlUnit: TEdit;
    lblAddObs: TLabel;      edtAddObs: TEdit;
    btnAddItem: TButton;
    btnRemItem: TButton;
    { Botões }
    pnlBotoes: TPanel;
    btnSalvar: TButton;
    btnFechar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure sgdListaClick(Sender: TObject);
    procedure btnBuscarItemClick(Sender: TObject);
    procedure btnAddItemClick(Sender: TObject);
    procedure btnRemItemClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure cboTipoEstEdChange(Sender: TObject);
  private
    FIDSelecionado: Integer;
    procedure CarregarLista;
    procedure CarregarItens(AID: Integer);
    procedure ModoEdicao(AEditar: Boolean);
    procedure LimparEdicao;
    procedure PreencherGridLista(Qry: TFDQuery);
  end;

implementation

{$R *.dfm}

uses uGlobal, uDMPrincipal;

procedure TFrmAjusteEstoque.FormCreate(Sender: TObject);
begin
  FIDSelecionado := 0;
  { Grid lista }
  sgdLista.ColCount := 6; sgdLista.FixedRows := 1;
  sgdLista.Options := sgdLista.Options + [goColSizing, goRowSelect];
  sgdLista.ColWidths[0]:=50; sgdLista.ColWidths[1]:=60;
  sgdLista.ColWidths[2]:=90; sgdLista.ColWidths[3]:=40;
  sgdLista.ColWidths[4]:=280; sgdLista.ColWidths[5]:=60;
  sgdLista.Cells[0,0]:='ID'; sgdLista.Cells[1,0]:='Nº';
  sgdLista.Cells[2,0]:='Data'; sgdLista.Cells[3,0]:='Tipo';
  sgdLista.Cells[4,0]:='Motivo'; sgdLista.Cells[5,0]:='Itens';
  { Grid itens }
  sgdItens.ColCount := 7; sgdItens.FixedRows := 1;
  sgdItens.Options := sgdItens.Options + [goColSizing, goRowSelect];
  sgdItens.ColWidths[0]:=40; sgdItens.ColWidths[1]:=60;
  sgdItens.ColWidths[2]:=220; sgdItens.ColWidths[3]:=40;
  sgdItens.ColWidths[4]:=80; sgdItens.ColWidths[5]:=80;
  sgdItens.ColWidths[6]:=200;
  sgdItens.Cells[0,0]:='#'; sgdItens.Cells[1,0]:='ID';
  sgdItens.Cells[2,0]:='Item'; sgdItens.Cells[3,0]:='Tp';
  sgdItens.Cells[4,0]:='Qtd Nova'; sgdItens.Cells[5,0]:='Vl.Unit';
  sgdItens.Cells[6,0]:='Obs';
  { Combos }
  cboTipoEst.Items.Add('(Todos)');
  cboTipoEst.Items.Add('P - Produtos');
  cboTipoEst.Items.Add('M - Mat.Primas');
  cboTipoEst.ItemIndex := 0;
  cboTipoEstEd.Items.Add('P - Produtos');
  cboTipoEstEd.Items.Add('M - Mat.Primas');
  cboTipoEstEd.ItemIndex := 0;
  cboAddTipoMov.Items.Add('E - Entrada');
  cboAddTipoMov.Items.Add('S - Saída');
  cboAddTipoMov.Items.Add('A - Ajuste');
  cboAddTipoMov.ItemIndex := 0;
  ModoEdicao(False);
  CarregarLista;
end;

procedure TFrmAjusteEstoque.CarregarLista;
var Qry: TFDQuery; W: string;
begin
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT A.ID, A.NUMERO, A.DT_AJUSTE, A.TIPO_EST, A.MOTIVO, ' +
      '(SELECT COUNT(*) FROM AJUSTES_ITENS AI WHERE AI.ID_AJUSTE=A.ID) AS NITENS ' +
      'FROM AJUSTES_ESTOQUE A ';
    W := '';
    if cboTipoEst.ItemIndex = 1 then W := 'A.TIPO_EST=''P''';
    if cboTipoEst.ItemIndex = 2 then W := 'A.TIPO_EST=''M''';
    if Trim(edtFiltro.Text) <> '' then
    begin
      if W <> '' then W := W + ' AND ';
      W := W + 'UPPER(A.MOTIVO) CONTAINING UPPER(''' + edtFiltro.Text + ''')';
    end;
    if W <> '' then Qry.SQL.Add('WHERE ' + W);
    Qry.SQL.Add('ORDER BY A.NUMERO DESC');
    Qry.Open;
    PreencherGridLista(Qry);
  finally Qry.Free; end;
end;

procedure TFrmAjusteEstoque.PreencherGridLista(Qry: TFDQuery);
var R: Integer;
begin
  sgdLista.RowCount := Qry.RecordCount+1;
  R := 1; Qry.First;
  while not Qry.Eof do
  begin
    sgdLista.Cells[0,R] := Qry.Fields[0].AsString;
    sgdLista.Cells[1,R] := Qry.Fields[1].AsString;
    sgdLista.Cells[2,R] := FormatDateTime('dd/mm/yyyy', Qry.Fields[2].AsDateTime);
    sgdLista.Cells[3,R] := Qry.Fields[3].AsString;
    sgdLista.Cells[4,R] := Qry.Fields[4].AsString;
    sgdLista.Cells[5,R] := Qry.Fields[5].AsString;
    Inc(R); Qry.Next;
  end;
  while R <= sgdLista.RowCount-1 do begin sgdLista.Rows[R].Clear; Inc(R); end;
end;

procedure TFrmAjusteEstoque.CarregarItens(AID: Integer);
var Qry: TFDQuery; R: Integer; Nome: string;
begin
  sgdItens.RowCount := 2;
  sgdItens.Rows[1].Clear;
  if AID = 0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT AI.ITEM, AI.ID_PRODUTO, AI.ID_MAT_PRIMA, AI.DESCRICAO, ' +
      'AI.TIPO_MOV, AI.QTD_NOVA, AI.VL_UNITARIO, AI.OBS, AI.TIPO_EST ' +
      'FROM AJUSTES_ITENS AI WHERE AI.ID_AJUSTE=:ID ORDER BY AI.ITEM';
    Qry.ParamByName('ID').AsInteger := AID;
    Qry.Open;
    if Qry.IsEmpty then Exit;
    sgdItens.RowCount := Qry.RecordCount + 1;
    R := 1; Qry.First;
    while not Qry.Eof do
    begin
      sgdItens.Cells[0,R] := Qry.Fields[0].AsString;
      { ID do item (produto ou MP) }
      if Qry.Fields[8].AsString = 'P' then
        sgdItens.Cells[1,R] := Qry.Fields[1].AsString
      else
        sgdItens.Cells[1,R] := Qry.Fields[2].AsString;
      sgdItens.Cells[2,R] := Qry.Fields[3].AsString;
      sgdItens.Cells[3,R] := Qry.Fields[4].AsString;
      sgdItens.Cells[4,R] := FormatFloat('0.###', Qry.Fields[5].AsFloat);
      sgdItens.Cells[5,R] := MoedaStr(Qry.Fields[6].AsFloat);
      sgdItens.Cells[6,R] := Qry.Fields[7].AsString;
      Inc(R); Qry.Next;
    end;
  finally Qry.Free; end;
end;

procedure TFrmAjusteEstoque.ModoEdicao(AEditar: Boolean);
begin
  pnlEdicao.Visible := AEditar;
  pnlFiltro.Enabled := not AEditar;
  sgdLista.Enabled  := not AEditar;
  btnNovo.Enabled   := not AEditar;
end;

procedure TFrmAjusteEstoque.LimparEdicao;
var R: Integer;
begin
  FIDSelecionado := 0;
  edtNumero.Text := '(automático)';
  edtData.Date   := Date;
  cboTipoEstEd.ItemIndex := 0;
  edtMotivo.Text := ''; mmoObs.Lines.Clear;
  sgdItens.RowCount := 2;
  for R := 1 to sgdItens.RowCount-1 do sgdItens.Rows[R].Clear;
  edtAddID.Text := ''; edtAddNome.Text := '';
  cboAddTipoMov.ItemIndex := 0;
  edtAddQtdNova.Text := '0,000';
  edtAddVlUnit.Text  := '0,00';
  edtAddObs.Text     := '';
end;

procedure TFrmAjusteEstoque.cboTipoEstEdChange(Sender: TObject);
begin
  { Limpa item sendo adicionado ao trocar tipo }
  edtAddID.Text := ''; edtAddNome.Text := '';
end;

procedure TFrmAjusteEstoque.btnBuscarClick(Sender: TObject);
begin CarregarLista; end;

procedure TFrmAjusteEstoque.btnNovoClick(Sender: TObject);
begin
  LimparEdicao;
  ModoEdicao(True);
  cboTipoEstEd.SetFocus;
end;

procedure TFrmAjusteEstoque.sgdListaClick(Sender: TObject);
var R, ID: Integer; Qry: TFDQuery;
begin
  R := sgdLista.Row;
  if (R < 1) or (sgdLista.Cells[0,R] = '') then Exit;
  ID := StrToIntDef(sgdLista.Cells[0,R], 0);
  if ID = 0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT * FROM AJUSTES_ESTOQUE WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger := ID; Qry.Open;
    if Qry.IsEmpty then Exit;
    FIDSelecionado := ID;
    edtNumero.Text := Qry.FieldByName('NUMERO').AsString;
    edtData.Date   := Qry.FieldByName('DT_AJUSTE').AsDateTime;
    cboTipoEstEd.ItemIndex := IfThen(Qry.FieldByName('TIPO_EST').AsString='P', 0, 1);
    edtMotivo.Text := Qry.FieldByName('MOTIVO').AsString;
    mmoObs.Text    := Qry.FieldByName('OBS').AsString;
    CarregarItens(ID);
    { Ajuste já salvo: somente visualização }
    btnSalvar.Enabled := False;
    btnAddItem.Enabled := False;
    btnRemItem.Enabled := False;
    pnlAddItem.Enabled := False;
    ModoEdicao(True);
  finally Qry.Free; end;
end;

procedure TFrmAjusteEstoque.btnBuscarItemClick(Sender: TObject);
var SID: string; ID: Integer; Qry: TFDQuery; TipoEst: string;
begin
  SID := InputBox('Buscar Item', 'Informe o ID do item:', '');
  ID  := StrToIntDef(SID, 0);
  if ID = 0 then Exit;
  TipoEst := IfThen(cboTipoEstEd.ItemIndex = 0, 'P', 'M');
  Qry := DMPrincipal.NovaQuery;
  try
    if TipoEst = 'P' then
    begin
      Qry.SQL.Text :=
        'SELECT P.ID, P.DESCRICAO, P.ESTOQUE_ATUAL, P.PRECO_CUSTO ' +
        'FROM PRODUTOS P WHERE P.ID=:ID AND P.ATIVO=''S''';
    end
    else
    begin
      Qry.SQL.Text :=
        'SELECT MP.ID, MP.DESCRICAO, MP.ESTOQUE_ATUAL, MP.CUSTO_MEDIO ' +
        'FROM MAT_PRIMAS MP WHERE MP.ID=:ID AND MP.ATIVO=''S''';
    end;
    Qry.ParamByName('ID').AsInteger := ID; Qry.Open;
    if Qry.IsEmpty then begin ShowMessage('Item não encontrado!'); Exit; end;
    edtAddID.Text   := Qry.Fields[0].AsString;
    edtAddNome.Text := Qry.Fields[1].AsString;
    edtAddVlUnit.Text := MoedaStr(Qry.Fields[3].AsFloat);
    ShowMessage('Estoque atual: ' + FormatFloat('0.###', Qry.Fields[2].AsFloat));
  finally Qry.Free; end;
end;

procedure TFrmAjusteEstoque.btnAddItemClick(Sender: TObject);
var ID_Item, R: Integer; Qtd, VlUnit: Double; TpMov: string;
begin
  ID_Item := StrToIntDef(edtAddID.Text, 0);
  if ID_Item = 0 then begin ShowMessage('Informe o item.'); Exit; end;
  if Trim(edtAddNome.Text) = '' then begin ShowMessage('Busque o item antes de adicionar.'); Exit; end;
  Qtd   := StrToFloatDef(StringReplace(edtAddQtdNova.Text, ',', '.', [rfReplaceAll]), 0);
  VlUnit:= StrToFloatDef(StringReplace(edtAddVlUnit.Text,  ',', '.', [rfReplaceAll]), 0);
  if Qtd <= 0 then begin ShowMessage('Qtd deve ser maior que zero.'); Exit; end;
  case cboAddTipoMov.ItemIndex of
    0: TpMov := 'E';
    1: TpMov := 'S';
    else TpMov := 'A';
  end;
  R := sgdItens.RowCount;
  sgdItens.RowCount := R + 1;
  sgdItens.Cells[0,R] := IntToStr(R);
  sgdItens.Cells[1,R] := IntToStr(ID_Item);
  sgdItens.Cells[2,R] := edtAddNome.Text;
  sgdItens.Cells[3,R] := TpMov;
  sgdItens.Cells[4,R] := FormatFloat('0.###', Qtd);
  sgdItens.Cells[5,R] := MoedaStr(VlUnit);
  sgdItens.Cells[6,R] := edtAddObs.Text;
  { Limpa linha de adição }
  edtAddID.Text := ''; edtAddNome.Text := '';
  edtAddQtdNova.Text := '0,000'; edtAddVlUnit.Text := '0,00'; edtAddObs.Text := '';
end;

procedure TFrmAjusteEstoque.btnRemItemClick(Sender: TObject);
var R, I: Integer;
begin
  R := sgdItens.Row;
  if (R < 1) or (sgdItens.Cells[0,R] = '') then Exit;
  for I := R to sgdItens.RowCount-2 do
    sgdItens.Rows[I].Assign(sgdItens.Rows[I+1]);
  sgdItens.RowCount := sgdItens.RowCount - 1;
  for I := 1 to sgdItens.RowCount-1 do
    if sgdItens.Cells[0,I] <> '' then sgdItens.Cells[0,I] := IntToStr(I);
end;

procedure TFrmAjusteEstoque.btnSalvarClick(Sender: TObject);
var Qry: TFDQuery; IDAdj, R, IDItem: Integer;
    TipoEst, TpMov, NomeItem: string;
    Qtd, VlUnit, EstAnt, EstDep: Double;
    NItem: Integer;
begin
  if Trim(edtMotivo.Text) = '' then begin ShowMessage('Informe o motivo do ajuste.'); Exit; end;
  NItem := 0;
  for R := 1 to sgdItens.RowCount-1 do if sgdItens.Cells[0,R] <> '' then Inc(NItem);
  if NItem = 0 then begin ShowMessage(MSG_SEM_ITENS); Exit; end;
  TipoEst := IfThen(cboTipoEstEd.ItemIndex = 0, 'P', 'M');
  Qry := DMPrincipal.NovaQuery;
  try
    DMPrincipal.IniciarTran;
    try
      { Cria cabeçalho do ajuste }
      Qry.SQL.Text :=
        'INSERT INTO AJUSTES_ESTOQUE (ID_USUARIO, DT_AJUSTE, TIPO_EST, MOTIVO, OBS) ' +
        'VALUES (:IU, :DT, :TE, :MO, :OB) RETURNING ID';
      Qry.ParamByName('IU').AsInteger := SessaoID;
      Qry.ParamByName('DT').AsDateTime:= edtData.Date;
      Qry.ParamByName('TE').AsString  := TipoEst;
      Qry.ParamByName('MO').AsString  := edtMotivo.Text;
      Qry.ParamByName('OB').AsString  := mmoObs.Text;
      Qry.Open;
      IDAdj := Qry.FieldByName('ID').AsInteger;

      { Processa cada item }
      for R := 1 to sgdItens.RowCount-1 do
      begin
        if sgdItens.Cells[0,R] = '' then Continue;
        IDItem   := StrToIntDef(sgdItens.Cells[1,R], 0);
        NomeItem := sgdItens.Cells[2,R];
        TpMov    := sgdItens.Cells[3,R];
        Qtd      := StrToFloatDef(StringReplace(sgdItens.Cells[4,R], ',', '.', [rfReplaceAll]), 0);
        VlUnit   := StrMoeda(sgdItens.Cells[5,R]);

        { Busca estoque atual }
        Qry.Close;
        if TipoEst = 'P' then
          Qry.SQL.Text := 'SELECT ESTOQUE_ATUAL FROM PRODUTOS WHERE ID=:ID'
        else
          Qry.SQL.Text := 'SELECT ESTOQUE_ATUAL FROM MAT_PRIMAS WHERE ID=:ID';
        Qry.ParamByName('ID').AsInteger := IDItem; Qry.Open;
        EstAnt := IfThen(not Qry.IsEmpty, Qry.Fields[0].AsFloat, 0);

        { Calcula novo estoque }
        case TpMov[1] of
          'E': EstDep := EstAnt + Qtd;
          'S': EstDep := EstAnt - Qtd;
          else  EstDep := Qtd; { A = Ajuste direto: define valor absoluto }
        end;
        if EstDep < 0 then EstDep := 0;

        { Atualiza estoque }
        Qry.Close;
        if TipoEst = 'P' then
          Qry.SQL.Text := 'UPDATE PRODUTOS SET ESTOQUE_ATUAL=:E WHERE ID=:ID'
        else
          Qry.SQL.Text := 'UPDATE MAT_PRIMAS SET ESTOQUE_ATUAL=:E WHERE ID=:ID';
        Qry.ParamByName('E').AsFloat    := EstDep;
        Qry.ParamByName('ID').AsInteger := IDItem;
        Qry.ExecSQL;

        { Registra na tabela de movimentação }
        Qry.Close;
        if TipoEst = 'P' then
          Qry.SQL.Text :=
            'INSERT INTO ESTOQUE_MOV (ID_PRODUTO,ID_USUARIO,TIPO_MOV,ORIGEM,ID_ORIGEM,' +
            'QUANTIDADE,VL_UNITARIO,VL_TOTAL,EST_ANTES,EST_DEPOIS,OBS) ' +
            'VALUES (:IP,:IU,:TM,''AJUSTE'',:IO,:QT,:VU,:VT,:EA,:ED,:OB)'
        else
          Qry.SQL.Text :=
            'INSERT INTO ESTOQUE_MP_MOV (ID_MAT_PRIMA,ID_USUARIO,TIPO_MOV,ORIGEM,ID_ORIGEM,' +
            'QUANTIDADE,VL_UNITARIO,VL_TOTAL,EST_ANTES,EST_DEPOIS,OBS) ' +
            'VALUES (:IP,:IU,:TM,''AJUSTE'',:IO,:QT,:VU,:VT,:EA,:ED,:OB)';
        Qry.ParamByName('IP').AsInteger := IDItem;
        Qry.ParamByName('IU').AsInteger := SessaoID;
        Qry.ParamByName('TM').AsString  := TpMov;
        Qry.ParamByName('IO').AsInteger := IDAdj;
        Qry.ParamByName('QT').AsFloat   := Qtd;
        Qry.ParamByName('VU').AsFloat   := VlUnit;
        Qry.ParamByName('VT').AsFloat   := Qtd * VlUnit;
        Qry.ParamByName('EA').AsFloat   := EstAnt;
        Qry.ParamByName('ED').AsFloat   := EstDep;
        Qry.ParamByName('OB').AsString  := sgdItens.Cells[6,R];
        Qry.ExecSQL;

        { Grava item do ajuste }
        Qry.Close;
        Qry.SQL.Text :=
          'INSERT INTO AJUSTES_ITENS (ID_AJUSTE,ITEM,TIPO_EST,' +
          'ID_PRODUTO,ID_MAT_PRIMA,DESCRICAO,TIPO_MOV,' +
          'QTD_ANTERIOR,QTD_NOVA,DIFERENCA,VL_UNITARIO,OBS) ' +
          'VALUES (:IA,:IT,:TE,:IP,:IM,:DC,:TM,:QA,:QN,:DF,:VU,:OB)';
        Qry.ParamByName('IA').AsInteger := IDAdj;
        Qry.ParamByName('IT').AsInteger := R;
        Qry.ParamByName('TE').AsString  := TipoEst;
        if TipoEst = 'P' then
        begin
          Qry.ParamByName('IP').AsInteger := IDItem;
          Qry.ParamByName('IM').Clear;
        end
        else
        begin
          Qry.ParamByName('IP').Clear;
          Qry.ParamByName('IM').AsInteger := IDItem;
        end;
        Qry.ParamByName('DC').AsString  := NomeItem;
        Qry.ParamByName('TM').AsString  := TpMov;
        Qry.ParamByName('QA').AsFloat   := EstAnt;
        Qry.ParamByName('QN').AsFloat   := EstDep;
        Qry.ParamByName('DF').AsFloat   := EstDep - EstAnt;
        Qry.ParamByName('VU').AsFloat   := VlUnit;
        Qry.ParamByName('OB').AsString  := sgdItens.Cells[6,R];
        Qry.ExecSQL;
      end;

      DMPrincipal.CommitTran;
      ShowMessage('Ajuste salvo com sucesso! Estoque atualizado.');
      ModoEdicao(False);
      LimparEdicao;
      CarregarLista;
    except
      on E: Exception do
      begin DMPrincipal.RollbackTran; ShowMessage('Erro: ' + E.Message); end;
    end;
  finally Qry.Free; end;
end;

procedure TFrmAjusteEstoque.btnFecharClick(Sender: TObject);
begin
  if pnlEdicao.Visible then
  begin ModoEdicao(False); LimparEdicao; end
  else Close;
end;

end.
