unit uFrmEstoque;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
  FireDAC.Comp.Client, system.Math, system.StrUtils;

type
  TFrmEstoque = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    pgcEstoque: TPageControl;
    tabPosicao: TTabSheet;
    tabHistorico: TTabSheet;
    { Posição }
    pnlFiltroPos: TPanel;
    edtFiltroProd: TEdit;
    cboSituacao: TComboBox;
    btnBuscarPos: TButton;
    sgdPosicao: TStringGrid;
    pnlResumo: TPanel;
    lblTotalItens: TLabel;
    lblSemEstoque: TLabel;
    lblBaixo: TLabel;
    { Histórico }
    pnlFiltroHist: TPanel;
    lblDe: TLabel;         edtDe: TDateTimePicker;
    lblAte: TLabel;        edtAte: TDateTimePicker;
    edtFiltroItem: TEdit;
    cboTipoMov: TComboBox;
    btnBuscarHist: TButton;
    sgdHistorico: TStringGrid;
    btnFechar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnBuscarPosClick(Sender: TObject);
    procedure btnBuscarHistClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure pgcEstoqueChange(Sender: TObject);
  public
    TipoEstoque: string; { 'P' = Produto  'M' = Matéria-Prima }
  private
    procedure CarregarPosicao;
    procedure CarregarHistorico;
    procedure ConfigurarGrids;
    procedure AtualizarResumo;
  end;

implementation

{$R *.dfm}

uses uGlobal, uDMPrincipal;

procedure TFrmEstoque.FormCreate(Sender: TObject);
begin
  TipoEstoque := 'P'; { padrão }
  edtDe.Date  := Date - 30;
  edtAte.Date := Date;
  cboSituacao.Items.Add('(Todas)');
  cboSituacao.Items.Add('NORMAL');
  cboSituacao.Items.Add('ESTOQUE BAIXO');
  cboSituacao.Items.Add('SEM ESTOQUE');
  cboSituacao.Items.Add('ESTOQUE ALTO');
  cboSituacao.ItemIndex := 0;
  cboTipoMov.Items.Add('(Todos)');
  cboTipoMov.Items.Add('E - Entrada');
  cboTipoMov.Items.Add('S - Saída');
  cboTipoMov.Items.Add('A - Ajuste');
  cboTipoMov.ItemIndex := 0;
  ConfigurarGrids;
end;

procedure TFrmEstoque.ConfigurarGrids;
begin
  { Grid Posição – Produtos }
  if TipoEstoque = 'P' then
  begin
    lblTitulo.Caption := 'POSIÇÃO DE ESTOQUE – PRODUTOS';
    sgdPosicao.ColCount := 9;
    sgdPosicao.ColWidths[0]:=50; sgdPosicao.ColWidths[1]:=100;
    sgdPosicao.ColWidths[2]:=220; sgdPosicao.ColWidths[3]:=50;
    sgdPosicao.ColWidths[4]:=80; sgdPosicao.ColWidths[5]:=80;
    sgdPosicao.ColWidths[6]:=80; sgdPosicao.ColWidths[7]:=90;
    sgdPosicao.ColWidths[8]:=110;
    sgdPosicao.Cells[0,0]:='ID';    sgdPosicao.Cells[1,0]:='Código';
    sgdPosicao.Cells[2,0]:='Produto'; sgdPosicao.Cells[3,0]:='UN';
    sgdPosicao.Cells[4,0]:='Est.Atual'; sgdPosicao.Cells[5,0]:='Est.Mín';
    sgdPosicao.Cells[6,0]:='Est.Máx';  sgdPosicao.Cells[7,0]:='Vl.Custo Total';
    sgdPosicao.Cells[8,0]:='Situação';
  end
  else
  begin
    lblTitulo.Caption := 'POSIÇÃO DE ESTOQUE – MATÉRIAS-PRIMAS';
    sgdPosicao.ColCount := 9;
    sgdPosicao.ColWidths[0]:=50; sgdPosicao.ColWidths[1]:=100;
    sgdPosicao.ColWidths[2]:=220; sgdPosicao.ColWidths[3]:=50;
    sgdPosicao.ColWidths[4]:=80; sgdPosicao.ColWidths[5]:=80;
    sgdPosicao.ColWidths[6]:=80; sgdPosicao.ColWidths[7]:=90;
    sgdPosicao.ColWidths[8]:=110;
    sgdPosicao.Cells[0,0]:='ID';    sgdPosicao.Cells[1,0]:='Código';
    sgdPosicao.Cells[2,0]:='Matéria-Prima'; sgdPosicao.Cells[3,0]:='UN';
    sgdPosicao.Cells[4,0]:='Est.Atual'; sgdPosicao.Cells[5,0]:='Est.Mín';
    sgdPosicao.Cells[6,0]:='Est.Máx';  sgdPosicao.Cells[7,0]:='Vl.Total';
    sgdPosicao.Cells[8,0]:='Situação';
  end;
  //sgdPosicao.FixedRows := 1;
  sgdPosicao.Options := sgdPosicao.Options + [goColSizing, goRowSelect];

  { Grid Histórico }
  sgdHistorico.ColCount := 8;
  //sgdHistorico.FixedRows := 1;
  sgdHistorico.Options := sgdHistorico.Options + [goColSizing, goRowSelect];
  sgdHistorico.ColWidths[0]:=130; sgdHistorico.ColWidths[1]:=30;
  sgdHistorico.ColWidths[2]:=220; sgdHistorico.ColWidths[3]:=80;
  sgdHistorico.ColWidths[4]:=100; sgdHistorico.ColWidths[5]:=80;
  sgdHistorico.ColWidths[6]:=80; sgdHistorico.ColWidths[7]:=160;
  sgdHistorico.Cells[0,0]:='Data/Hora'; sgdHistorico.Cells[1,0]:='Tp';
  sgdHistorico.Cells[2,0]:='Item';      sgdHistorico.Cells[3,0]:='Qtd';
  sgdHistorico.Cells[4,0]:='Origem';    sgdHistorico.Cells[5,0]:='Ant.';
  sgdHistorico.Cells[6,0]:='Depois';    sgdHistorico.Cells[7,0]:='Obs';
end;

procedure TFrmEstoque.CarregarPosicao;
var Qry: TFDQuery; R: Integer; W,SitFiltro: string;
    SituacaoItem: string;
begin
  SitFiltro := IfThen(cboSituacao.ItemIndex > 0, cboSituacao.Items[cboSituacao.ItemIndex], '');
  Qry := DMPrincipal.NovaQuery;
  try
    if TipoEstoque = 'P' then
    begin
      Qry.SQL.Text :=
        'SELECT P.ID,P.CODIGO,P.DESCRICAO,U.SIGLA,' +
        'P.ESTOQUE_ATUAL,P.ESTOQUE_MIN,P.ESTOQUE_MAX,' +
        'P.ESTOQUE_ATUAL*P.PRECO_CUSTO AS VL_TOTAL,' +
        'CASE WHEN P.ESTOQUE_ATUAL<=0 THEN ''SEM ESTOQUE'' ' +
        'WHEN P.ESTOQUE_ATUAL<P.ESTOQUE_MIN THEN ''ESTOQUE BAIXO'' ' +
        'WHEN P.ESTOQUE_MAX>0 AND P.ESTOQUE_ATUAL>P.ESTOQUE_MAX THEN ''ESTOQUE ALTO'' ' +
        'ELSE ''NORMAL'' END AS SIT ' +
        'FROM PRODUTOS P LEFT JOIN UNIDADES U ON U.ID=P.ID_UNIDADE ' +
        'WHERE P.ATIVO=''S'' ';
    end
    else
    begin
      Qry.SQL.Text :=
        'SELECT MP.ID,MP.CODIGO,MP.DESCRICAO,U.SIGLA,' +
        'MP.ESTOQUE_ATUAL,MP.ESTOQUE_MIN,MP.ESTOQUE_MAX,' +
        'MP.ESTOQUE_ATUAL*MP.CUSTO_MEDIO AS VL_TOTAL,' +
        'CASE WHEN MP.ESTOQUE_ATUAL<=0 THEN ''SEM ESTOQUE'' ' +
        'WHEN MP.ESTOQUE_ATUAL<MP.ESTOQUE_MIN THEN ''ESTOQUE BAIXO'' ' +
        'WHEN MP.ESTOQUE_MAX>0 AND MP.ESTOQUE_ATUAL>MP.ESTOQUE_MAX THEN ''ESTOQUE ALTO'' ' +
        'ELSE ''NORMAL'' END AS SIT ' +
        'FROM MAT_PRIMAS MP LEFT JOIN UNIDADES U ON U.ID=MP.ID_UNIDADE ' +
        'WHERE MP.ATIVO=''S'' ';
    end;
    W := '';
    if Trim(edtFiltroProd.Text) <> '' then
      W := W + 'AND (UPPER(P.DESCRICAO) CONTAINING UPPER(''' + edtFiltroProd.Text + ''') ' +
           'OR P.CODIGO CONTAINING ''' + edtFiltroProd.Text + ''') ';
    if SitFiltro <> '' then
      W := W + 'AND (CASE WHEN ' + IfThen(TipoEstoque='P','P','MP') + '.ESTOQUE_ATUAL<=0 THEN ''SEM ESTOQUE'' ' +
           'WHEN ' + IfThen(TipoEstoque='P','P','MP') + '.ESTOQUE_ATUAL<' +
           IfThen(TipoEstoque='P','P','MP') + '.ESTOQUE_MIN THEN ''ESTOQUE BAIXO'' ' +
           'WHEN ' + IfThen(TipoEstoque='P','P','MP') + '.ESTOQUE_MAX>0 AND ' +
           IfThen(TipoEstoque='P','P','MP') + '.ESTOQUE_ATUAL>' +
           IfThen(TipoEstoque='P','P','MP') + '.ESTOQUE_MAX THEN ''ESTOQUE ALTO'' ' +
           'ELSE ''NORMAL'' END) = ''' + SitFiltro + ''' ';
    if W <> '' then Qry.SQL.Add(W);
    Qry.SQL.Add('ORDER BY 3');
    Qry.Open;
    sgdPosicao.RowCount := Max(Qry.RecordCount+1,2);
    R:=1; Qry.First;
    while not Qry.Eof do
    begin
      sgdPosicao.Cells[0,R]:=Qry.Fields[0].AsString;
      sgdPosicao.Cells[1,R]:=Qry.Fields[1].AsString;
      sgdPosicao.Cells[2,R]:=Qry.Fields[2].AsString;
      sgdPosicao.Cells[3,R]:=Qry.Fields[3].AsString;
      sgdPosicao.Cells[4,R]:=FormatFloat('0.###',Qry.Fields[4].AsFloat);
      sgdPosicao.Cells[5,R]:=FormatFloat('0.###',Qry.Fields[5].AsFloat);
      sgdPosicao.Cells[6,R]:=FormatFloat('0.###',Qry.Fields[6].AsFloat);
      sgdPosicao.Cells[7,R]:=MoedaStr(Qry.Fields[7].AsFloat);
      SituacaoItem := Qry.Fields[8].AsString;
      sgdPosicao.Cells[8,R]:=SituacaoItem;
      { Colorir linha pela situação }
      sgdPosicao.Objects[8,R]:=TObject(CorStatus(SituacaoItem));
      Inc(R); Qry.Next;
    end;
    while R<=sgdPosicao.RowCount-1 do begin sgdPosicao.Rows[R].Clear; Inc(R); end;
    AtualizarResumo;
  finally Qry.Free; end;
end;

procedure TFrmEstoque.AtualizarResumo;
var R,Total,Sem,Baixo: Integer;
begin
  Total:=0; Sem:=0; Baixo:=0;
  for R:=1 to sgdPosicao.RowCount-1 do
  begin
    if sgdPosicao.Cells[0,R]='' then Continue;
    Inc(Total);
    if sgdPosicao.Cells[8,R]='SEM ESTOQUE'   then Inc(Sem);
    if sgdPosicao.Cells[8,R]='ESTOQUE BAIXO' then Inc(Baixo);
  end;
  lblTotalItens.Caption := 'Total: '+IntToStr(Total)+' itens';
  lblSemEstoque.Caption := 'Sem estoque: '+IntToStr(Sem);
  lblBaixo.Caption      := 'Estoque baixo: '+IntToStr(Baixo);
end;

procedure TFrmEstoque.CarregarHistorico;
var Qry: TFDQuery; R: Integer; TpFiltro: string;
begin
  TpFiltro:='';
  case cboTipoMov.ItemIndex of
    1: TpFiltro:='E'; 2: TpFiltro:='S'; 3: TpFiltro:='A';
  end;
  Qry := DMPrincipal.NovaQuery;
  try
    if TipoEstoque='P' then
    begin
      Qry.SQL.Text :=
        'SELECT EM.DT_MOV, EM.TIPO_MOV, P.DESCRICAO AS ITEM, ' +
        'EM.QUANTIDADE, EM.ORIGEM, EM.EST_ANTES, EM.EST_DEPOIS, EM.OBS ' +
        'FROM ESTOQUE_MOV EM ' +
        'JOIN PRODUTOS P ON P.ID=EM.ID_PRODUTO ' +
        'WHERE CAST(EM.DT_MOV AS DATE) BETWEEN :DE AND :ATE ';
    end
    else
    begin
      Qry.SQL.Text :=
        'SELECT EM.DT_MOV, EM.TIPO_MOV, MP.DESCRICAO AS ITEM, ' +
        'EM.QUANTIDADE, EM.ORIGEM, EM.EST_ANTES, EM.EST_DEPOIS, EM.OBS ' +
        'FROM ESTOQUE_MP_MOV EM ' +
        'JOIN MAT_PRIMAS MP ON MP.ID=EM.ID_MAT_PRIMA ' +
        'WHERE CAST(EM.DT_MOV AS DATE) BETWEEN :DE AND :ATE ';
    end;
    Qry.ParamByName('DE').AsDateTime := edtDe.Date;
    Qry.ParamByName('ATE').AsDateTime:= edtAte.Date;
    if Trim(edtFiltroItem.Text)<>'' then
      Qry.SQL.Add('AND UPPER(ITEM) CONTAINING UPPER('''+edtFiltroItem.Text+''') ');
    if TpFiltro<>'' then
      Qry.SQL.Add('AND EM.TIPO_MOV='''+TpFiltro+''' ');
    Qry.SQL.Add('ORDER BY EM.DT_MOV DESC');
    Qry.Open;
    sgdHistorico.RowCount:=Max(Qry.RecordCount+1,2);
    R:=1; Qry.First;
    while not Qry.Eof do
    begin
      sgdHistorico.Cells[0,R]:=FormatDateTime('dd/mm/yyyy hh:nn:ss',Qry.Fields[0].AsDateTime);
      sgdHistorico.Cells[1,R]:=Qry.Fields[1].AsString;
      sgdHistorico.Cells[2,R]:=Qry.Fields[2].AsString;
      sgdHistorico.Cells[3,R]:=FormatFloat('0.###',Qry.Fields[3].AsFloat);
      sgdHistorico.Cells[4,R]:=Qry.Fields[4].AsString;
      sgdHistorico.Cells[5,R]:=FormatFloat('0.###',Qry.Fields[5].AsFloat);
      sgdHistorico.Cells[6,R]:=FormatFloat('0.###',Qry.Fields[6].AsFloat);
      sgdHistorico.Cells[7,R]:=Qry.Fields[7].AsString;
      Inc(R); Qry.Next;
    end;
    while R<=sgdHistorico.RowCount-1 do begin sgdHistorico.Rows[R].Clear; Inc(R); end;
  finally Qry.Free; end;
end;

procedure TFrmEstoque.btnBuscarPosClick(Sender: TObject);
begin CarregarPosicao; end;

procedure TFrmEstoque.btnBuscarHistClick(Sender: TObject);
begin CarregarHistorico; end;

procedure TFrmEstoque.btnFecharClick(Sender: TObject);
begin Close; end;

procedure TFrmEstoque.pgcEstoqueChange(Sender: TObject);
begin
  if pgcEstoque.ActivePageIndex=0 then CarregarPosicao
  else CarregarHistorico;
end;

end.
