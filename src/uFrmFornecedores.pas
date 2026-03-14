unit uFrmFornecedores;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
  FireDAC.Comp.Client, system.math, system.StrUtils;

type
  TFrmFornecedores = class(TForm)
    pnlTopo: TPanel;        lblTitulo: TLabel;
    pnlFiltro: TPanel;
    edtFiltro: TEdit;       chkSoAtivos: TCheckBox;
    btnBuscar: TButton;     btnNovo: TButton;
    sgdLista: TStringGrid;
    pnlEdicao: TPanel;
    pgcDados: TPageControl;
    tabGeral: TTabSheet;    tabEndereco: TTabSheet;
    lblTipo: TLabel;        cboTipo: TComboBox;
    lblNome: TLabel;        edtNome: TEdit;
    lblFantasia: TLabel;    edtFantasia: TEdit;
    lblCNPJ: TLabel;        edtCNPJ: TEdit;
    lblCPF: TLabel;         edtCPF: TEdit;
    lblIE: TLabel;          edtIE: TEdit;
    lblEmail: TLabel;       edtEmail: TEdit;
    lblFone1: TLabel;       edtFone1: TEdit;
    lblFone2: TLabel;       edtFone2: TEdit;
    lblContato: TLabel;     edtContato: TEdit;
    lblAtivo: TLabel;       cboAtivo: TComboBox;
    lblCEP: TLabel;         edtCEP: TEdit;
    lblLogr: TLabel;        edtLogr: TEdit;
    lblNum: TLabel;         edtNum: TEdit;
    lblComp: TLabel;        edtComp: TEdit;
    lblBairro: TLabel;      edtBairro: TEdit;
    lblCidade: TLabel;      edtCidade: TEdit;
    lblUF: TLabel;          edtUF: TEdit;
    lblObs: TLabel;         mmoObs: TMemo;
    btnSalvar: TButton;     btnExcluir: TButton;    btnCancelar: TButton;
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

procedure TFrmFornecedores.FormCreate(Sender: TObject);
begin
  FIDSelecionado := 0;
  sgdLista.ColCount := 7;
  //sgdLista.FixedRows := 1;
  sgdLista.Options := sgdLista.Options + [goColSizing, goRowSelect];
  sgdLista.ColWidths[0]:=50; sgdLista.ColWidths[1]:=30;
  sgdLista.ColWidths[2]:=220; sgdLista.ColWidths[3]:=140;
  sgdLista.ColWidths[4]:=150; sgdLista.ColWidths[5]:=110; sgdLista.ColWidths[6]:=50;
  sgdLista.Cells[0,0]:='ID'; sgdLista.Cells[1,0]:='T';
  sgdLista.Cells[2,0]:='Nome'; sgdLista.Cells[3,0]:='CNPJ/CPF';
  sgdLista.Cells[4,0]:='E-mail'; sgdLista.Cells[5,0]:='Fone'; sgdLista.Cells[6,0]:='Ativo';
  cboTipo.Items.CommaText := 'J - Jurídica,F - Física';
  cboAtivo.Items.CommaText := 'S,N';
  ModoEdicao(False);
  CarregarLista;
end;

procedure TFrmFornecedores.CarregarLista;
var Qry: TFDQuery; W: string;
begin
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT ID,TIPO_PESSOA,NOME,COALESCE(CNPJ,CPF) AS DOC,EMAIL,FONE1,ATIVO ' +
      'FROM FORNECEDORES ';
    W := '';
    if chkSoAtivos.Checked then W := 'ATIVO=''S''';
    if Trim(edtFiltro.Text) <> '' then
    begin
      if W <> '' then W := W + ' AND ';
      W := W + '(UPPER(NOME) CONTAINING UPPER(:F) OR CNPJ CONTAINING :F)';
    end;
    if W <> '' then Qry.SQL.Add('WHERE ' + W);
    Qry.SQL.Add('ORDER BY NOME');
    if Trim(edtFiltro.Text) <> '' then Qry.ParamByName('F').AsString := edtFiltro.Text;
    Qry.Open;
    PreencherGrid(Qry);
  finally Qry.Free; end;
end;

procedure TFrmFornecedores.PreencherGrid(Qry: TFDQuery);
var R: Integer;
begin
  sgdLista.RowCount := Qry.RecordCount + 1;
  R := 1; Qry.First;
  while not Qry.Eof do
  begin
    sgdLista.Cells[0,R]:=Qry.Fields[0].AsString; sgdLista.Cells[1,R]:=Qry.Fields[1].AsString;
    sgdLista.Cells[2,R]:=Qry.Fields[2].AsString; sgdLista.Cells[3,R]:=Qry.Fields[3].AsString;
    sgdLista.Cells[4,R]:=Qry.Fields[4].AsString; sgdLista.Cells[5,R]:=Qry.Fields[5].AsString;
    sgdLista.Cells[6,R]:=Qry.Fields[6].AsString;
    Inc(R); Qry.Next;
  end;
  while R <= sgdLista.RowCount - 1 do begin sgdLista.Rows[R].Clear; Inc(R); end;
end;

procedure TFrmFornecedores.ModoEdicao(AEditar: Boolean);
begin
  pnlEdicao.Visible := AEditar; btnNovo.Enabled := not AEditar;
  btnBuscar.Enabled := not AEditar; sgdLista.Enabled := not AEditar;
end;

procedure TFrmFornecedores.LimparEdicao;
begin
  FIDSelecionado := 0; cboTipo.ItemIndex := 0;
  edtNome.Text:=''; edtFantasia.Text:=''; edtCNPJ.Text:=''; edtCPF.Text:='';
  edtIE.Text:=''; edtEmail.Text:=''; edtFone1.Text:=''; edtFone2.Text:='';
  edtContato.Text:=''; cboAtivo.ItemIndex:=0;
  edtCEP.Text:=''; edtLogr.Text:=''; edtNum.Text:=''; edtComp.Text:='';
  edtBairro.Text:=''; edtCidade.Text:=''; edtUF.Text:=''; mmoObs.Lines.Clear;
  btnExcluir.Enabled:=False;
end;

procedure TFrmFornecedores.btnBuscarClick(Sender: TObject);
begin CarregarLista; end;

procedure TFrmFornecedores.btnNovoClick(Sender: TObject);
begin LimparEdicao; ModoEdicao(True); edtNome.SetFocus; end;

procedure TFrmFornecedores.sgdListaClick(Sender: TObject);
var R, ID: Integer; Qry: TFDQuery;
begin
  R := sgdLista.Row;
  if (R<1) or (sgdLista.Cells[0,R]='') then Exit;
  ID := StrToIntDef(sgdLista.Cells[0,R],0);
  if ID=0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT * FROM FORNECEDORES WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger := ID; Qry.Open;
    if Qry.IsEmpty then Exit;
    FIDSelecionado := ID;
    cboTipo.ItemIndex := IfThen(Qry.FieldByName('TIPO_PESSOA').AsString='J',0,1);
    edtNome.Text    := Qry.FieldByName('NOME').AsString;
    edtFantasia.Text:= Qry.FieldByName('NOME_FANTASIA').AsString;
    edtCNPJ.Text    := Qry.FieldByName('CNPJ').AsString;
    edtCPF.Text     := Qry.FieldByName('CPF').AsString;
    edtIE.Text      := Qry.FieldByName('IE').AsString;
    edtEmail.Text   := Qry.FieldByName('EMAIL').AsString;
    edtFone1.Text   := Qry.FieldByName('FONE1').AsString;
    edtFone2.Text   := Qry.FieldByName('FONE2').AsString;
    edtContato.Text := Qry.FieldByName('CONTATO').AsString;
    cboAtivo.ItemIndex := cboAtivo.Items.IndexOf(Qry.FieldByName('ATIVO').AsString);
    edtCEP.Text    := Qry.FieldByName('CEP').AsString;
    edtLogr.Text   := Qry.FieldByName('LOGRADOURO').AsString;
    edtNum.Text    := Qry.FieldByName('NUMERO').AsString;
    edtComp.Text   := Qry.FieldByName('COMPLEMENTO').AsString;
    edtBairro.Text := Qry.FieldByName('BAIRRO').AsString;
    edtCidade.Text := Qry.FieldByName('CIDADE').AsString;
    edtUF.Text     := Qry.FieldByName('UF').AsString;
    mmoObs.Text    := Qry.FieldByName('OBS').AsString;
    btnExcluir.Enabled := True; ModoEdicao(True); edtNome.SetFocus;
  finally Qry.Free; end;
end;

procedure TFrmFornecedores.btnSalvarClick(Sender: TObject);
var Qry: TFDQuery; TP: string;
begin
  if Trim(edtNome.Text)='' then begin ShowMessage('Informe o nome.'); Exit; end;
  TP := IfThen(cboTipo.ItemIndex=0,'J','F');
  Qry := DMPrincipal.NovaQuery;
  try
    DMPrincipal.IniciarTran;
    try
      if FIDSelecionado = 0 then
        Qry.SQL.Text :=
          'INSERT INTO FORNECEDORES (TIPO_PESSOA,NOME,NOME_FANTASIA,CPF,CNPJ,IE,EMAIL,FONE1,FONE2,' +
          'CONTATO,ATIVO,CEP,LOGRADOURO,NUMERO,COMPLEMENTO,BAIRRO,CIDADE,UF,OBS) ' +
          'VALUES (:TP,:NM,:NF,:CPF,:CNPJ,:IE,:EM,:F1,:F2,:CT,:AT,:CEP,:LG,:NU,:CM,:BA,:CI,:UF,:OB) RETURNING ID'
      else
        Qry.SQL.Text :=
          'UPDATE FORNECEDORES SET TIPO_PESSOA=:TP,NOME=:NM,NOME_FANTASIA=:NF,CPF=:CPF,CNPJ=:CNPJ,' +
          'IE=:IE,EMAIL=:EM,FONE1=:F1,FONE2=:F2,CONTATO=:CT,ATIVO=:AT,' +
          'CEP=:CEP,LOGRADOURO=:LG,NUMERO=:NU,COMPLEMENTO=:CM,BAIRRO=:BA,CIDADE=:CI,UF=:UF,OBS=:OB' +
          ' WHERE ID=:ID';
      Qry.ParamByName('TP').AsString:=TP; Qry.ParamByName('NM').AsString:=edtNome.Text;
      Qry.ParamByName('NF').AsString:=edtFantasia.Text; Qry.ParamByName('CPF').AsString:=edtCPF.Text;
      Qry.ParamByName('CNPJ').AsString:=edtCNPJ.Text; Qry.ParamByName('IE').AsString:=edtIE.Text;
      Qry.ParamByName('EM').AsString:=edtEmail.Text; Qry.ParamByName('F1').AsString:=edtFone1.Text;
      Qry.ParamByName('F2').AsString:=edtFone2.Text; Qry.ParamByName('CT').AsString:=edtContato.Text;
      Qry.ParamByName('AT').AsString:=cboAtivo.Items[cboAtivo.ItemIndex];
      Qry.ParamByName('CEP').AsString:=edtCEP.Text; Qry.ParamByName('LG').AsString:=edtLogr.Text;
      Qry.ParamByName('NU').AsString:=edtNum.Text; Qry.ParamByName('CM').AsString:=edtComp.Text;
      Qry.ParamByName('BA').AsString:=edtBairro.Text; Qry.ParamByName('CI').AsString:=edtCidade.Text;
      Qry.ParamByName('UF').AsString:=edtUF.Text; Qry.ParamByName('OB').AsString:=mmoObs.Text;
      if FIDSelecionado=0 then Qry.Open
      else begin Qry.ParamByName('ID').AsInteger:=FIDSelecionado; Qry.ExecSQL; end;
      DMPrincipal.CommitTran; ShowMessage(MSG_SALVO);
      ModoEdicao(False); LimparEdicao; CarregarLista;
    except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
  finally Qry.Free; end;
end;

procedure TFrmFornecedores.btnExcluirClick(Sender: TObject);
begin
  if FIDSelecionado=0 then Exit;
  if DMPrincipal.ContarReg('COMPRAS','ID_FORNECEDOR='+IntToStr(FIDSelecionado))>0 then
  begin ShowMessage('Fornecedor possui compras e não pode ser excluído!'); Exit; end;
  if MessageDlg(MSG_CONF_EXCLUIR,mtConfirmation,[mbYes,mbNo],0)<>mrYes then Exit;
  try
    DMPrincipal.IniciarTran;
    DMPrincipal.ExecSQL('DELETE FROM FORNECEDORES WHERE ID='+IntToStr(FIDSelecionado));
    DMPrincipal.CommitTran; ShowMessage(MSG_EXCLUIDO);
    ModoEdicao(False); LimparEdicao; CarregarLista;
  except on E: Exception do begin DMPrincipal.RollbackTran; ShowMessage('Erro: '+E.Message); end; end;
end;

procedure TFrmFornecedores.btnCancelarClick(Sender: TObject);
begin ModoEdicao(False); LimparEdicao; end;

end.
