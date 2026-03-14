unit uFrmUsuarios;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
  FireDAC.Comp.Client, Data.DB;

type
  TFrmUsuarios = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    pnlFiltro: TPanel;
    edtFiltro: TEdit;
    btnBuscar: TButton;
    btnNovo: TButton;
    sgdLista: TStringGrid;
    pnlEdicao: TPanel;
    lblNome: TLabel;     edtNome: TEdit;
    lblLogin: TLabel;    edtLogin: TEdit;
    lblSenha: TLabel;    edtSenha: TEdit;
    lblEmail: TLabel;    edtEmail: TEdit;
    lblPerfil: TLabel;   cboPerfil: TComboBox;
    lblAtivo: TLabel;    cboAtivo: TComboBox;
    btnSalvar: TButton;
    btnExcluir: TButton;
    btnCancelar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure sgdListaClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FIDSelecionado: Integer;
    procedure CarregarLista(const AFiltro: string = '');
    procedure ModoEdicao(AEditar: Boolean);
    procedure LimparEdicao;
    procedure PreencherGrid(Qry: TFDQuery);
  end;

implementation

{$R *.dfm}

uses uGlobal, uDMPrincipal;

procedure TFrmUsuarios.FormCreate(Sender: TObject);
begin
  FIDSelecionado := 0;
  { Configura grid }
  sgdLista.ColCount := 6;
  sgdLista.RowCount := 1;
  //sgdLista.FixedRows := 1;
  sgdLista.Options := sgdLista.Options + [goColSizing, goRowSelect];
  sgdLista.ColWidths[0] := 50;
  sgdLista.ColWidths[1] := 200;
  sgdLista.ColWidths[2] := 120;
  sgdLista.ColWidths[3] := 180;
  sgdLista.ColWidths[4] := 120;
  sgdLista.ColWidths[5] := 60;
  sgdLista.Cells[0,0] := 'ID';
  sgdLista.Cells[1,0] := 'Nome';
  sgdLista.Cells[2,0] := 'Login';
  sgdLista.Cells[3,0] := 'E-mail';
  sgdLista.Cells[4,0] := 'Perfil';
  sgdLista.Cells[5,0] := 'Ativo';
  cboPerfil.Items.CommaText := 'ADMINISTRADOR,GERENTE,OPERADOR';
  cboAtivo.Items.CommaText  := 'S,N';
  ModoEdicao(False);
  CarregarLista;
end;

procedure TFrmUsuarios.CarregarLista(const AFiltro: string);
var Qry: TFDQuery;
begin
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text :=
      'SELECT ID,NOME,LOGIN,EMAIL,PERFIL,ATIVO FROM USUARIOS ';
    if Trim(AFiltro) <> '' then
      Qry.SQL.Add('WHERE UPPER(NOME) CONTAINING UPPER(:F) OR UPPER(LOGIN) CONTAINING UPPER(:F)');
    Qry.SQL.Add('ORDER BY NOME');
    if Trim(AFiltro) <> '' then Qry.ParamByName('F').AsString := AFiltro;
    Qry.Open;
    PreencherGrid(Qry);
  finally Qry.Free; end;
end;

procedure TFrmUsuarios.PreencherGrid(Qry: TFDQuery);
var R: Integer;
begin
  sgdLista.RowCount := Qry.RecordCount + 1;
  R := 1;
  Qry.First;
  while not Qry.Eof do
  begin
    sgdLista.Cells[0,R] := Qry.FieldByName('ID').AsString;
    sgdLista.Cells[1,R] := Qry.FieldByName('NOME').AsString;
    sgdLista.Cells[2,R] := Qry.FieldByName('LOGIN').AsString;
    sgdLista.Cells[3,R] := Qry.FieldByName('EMAIL').AsString;
    sgdLista.Cells[4,R] := Qry.FieldByName('PERFIL').AsString;
    sgdLista.Cells[5,R] := Qry.FieldByName('ATIVO').AsString;
    Inc(R); Qry.Next;
  end;
  { Limpa linhas extras se existirem }
  while R <= sgdLista.RowCount - 1 do
  begin
    sgdLista.Rows[R].Clear; Inc(R);
  end;
end;

procedure TFrmUsuarios.ModoEdicao(AEditar: Boolean);
begin
  pnlEdicao.Visible   := AEditar;
  btnNovo.Enabled     := not AEditar;
  btnBuscar.Enabled   := not AEditar;
  sgdLista.Enabled    := not AEditar;
end;

procedure TFrmUsuarios.LimparEdicao;
begin
  FIDSelecionado := 0;
  edtNome.Text  := '';
  edtLogin.Text := '';
  edtSenha.Text := '';
  edtEmail.Text := '';
  cboPerfil.ItemIndex := 2; { OPERADOR }
  cboAtivo.ItemIndex  := 0; { S }
  btnExcluir.Enabled  := False;
end;

procedure TFrmUsuarios.btnBuscarClick(Sender: TObject);
begin
  CarregarLista(edtFiltro.Text);
end;

procedure TFrmUsuarios.btnNovoClick(Sender: TObject);
begin
  LimparEdicao;
  ModoEdicao(True);
  edtNome.SetFocus;
end;

procedure TFrmUsuarios.sgdListaClick(Sender: TObject);
var R: Integer;
    Qry: TFDQuery;
    ID: Integer;
begin
  R := sgdLista.Row;
  if (R < 1) or (sgdLista.Cells[0, R] = '') then Exit;
  ID := StrToIntDef(sgdLista.Cells[0, R], 0);
  if ID = 0 then Exit;
  Qry := DMPrincipal.NovaQuery;
  try
    Qry.SQL.Text := 'SELECT * FROM USUARIOS WHERE ID=:ID';
    Qry.ParamByName('ID').AsInteger := ID;
    Qry.Open;
    if Qry.IsEmpty then Exit;
    FIDSelecionado := ID;
    edtNome.Text  := Qry.FieldByName('NOME').AsString;
    edtLogin.Text := Qry.FieldByName('LOGIN').AsString;
    edtSenha.Text := ''; { Não exibe senha }
    edtEmail.Text := Qry.FieldByName('EMAIL').AsString;
    cboPerfil.ItemIndex := cboPerfil.Items.IndexOf(Qry.FieldByName('PERFIL').AsString);
    cboAtivo.ItemIndex  := cboAtivo.Items.IndexOf(Qry.FieldByName('ATIVO').AsString);
    btnExcluir.Enabled  := (ID <> SessaoID); { Não exclui a si mesmo }
    ModoEdicao(True);
    edtNome.SetFocus;
  finally Qry.Free; end;
end;

procedure TFrmUsuarios.btnSalvarClick(Sender: TObject);
var Qry: TFDQuery;
begin
  if Trim(edtNome.Text) = '' then begin ShowMessage('Informe o nome.'); edtNome.SetFocus; Exit; end;
  if Trim(edtLogin.Text) = '' then begin ShowMessage('Informe o login.'); edtLogin.SetFocus; Exit; end;
  if (FIDSelecionado = 0) and (Trim(edtSenha.Text) = '') then
    begin ShowMessage('Informe a senha.'); edtSenha.SetFocus; Exit; end;
  if cboPerfil.ItemIndex < 0 then begin ShowMessage('Selecione o perfil.'); Exit; end;

  { Verificar login único }
  if DMPrincipal.ContarReg('USUARIOS',
    'UPPER(LOGIN)=UPPER(''' + edtLogin.Text + ''') AND ID<>' + IntToStr(FIDSelecionado)) > 0 then
  begin
    ShowMessage('Login já cadastrado!'); edtLogin.SetFocus; Exit;
  end;

  Qry := DMPrincipal.NovaQuery;
  try
    DMPrincipal.IniciarTran;
    try
      if FIDSelecionado = 0 then
      begin
        Qry.SQL.Text :=
          'INSERT INTO USUARIOS (NOME,LOGIN,SENHA,EMAIL,PERFIL,ATIVO) ' +
          'VALUES (:N,:L,:S,:E,:P,:A) RETURNING ID';
        Qry.ParamByName('N').AsString := edtNome.Text;
        Qry.ParamByName('L').AsString := edtLogin.Text;
        Qry.ParamByName('S').AsString := SHA256(edtSenha.Text);
        Qry.ParamByName('E').AsString := edtEmail.Text;
        Qry.ParamByName('P').AsString := cboPerfil.Items[cboPerfil.ItemIndex];
        Qry.ParamByName('A').AsString := cboAtivo.Items[cboAtivo.ItemIndex];
        Qry.Open;
      end
      else
      begin
        if Trim(edtSenha.Text) <> '' then
          Qry.SQL.Text :=
            'UPDATE USUARIOS SET NOME=:N,LOGIN=:L,SENHA=:S,EMAIL=:E,PERFIL=:P,ATIVO=:A WHERE ID=:ID'
        else
          Qry.SQL.Text :=
            'UPDATE USUARIOS SET NOME=:N,LOGIN=:L,EMAIL=:E,PERFIL=:P,ATIVO=:A WHERE ID=:ID';
        Qry.ParamByName('N').AsString := edtNome.Text;
        Qry.ParamByName('L').AsString := edtLogin.Text;
        if Trim(edtSenha.Text) <> '' then
          Qry.ParamByName('S').AsString := SHA256(edtSenha.Text);
        Qry.ParamByName('E').AsString := edtEmail.Text;
        Qry.ParamByName('P').AsString := cboPerfil.Items[cboPerfil.ItemIndex];
        Qry.ParamByName('A').AsString := cboAtivo.Items[cboAtivo.ItemIndex];
        Qry.ParamByName('ID').AsInteger := FIDSelecionado;
        Qry.ExecSQL;
      end;
      DMPrincipal.CommitTran;
      ShowMessage(MSG_SALVO);
      ModoEdicao(False);
      LimparEdicao;
      CarregarLista(edtFiltro.Text);
    except
      on E: Exception do
      begin DMPrincipal.RollbackTran; ShowMessage('Erro: ' + E.Message); end;
    end;
  finally Qry.Free; end;
end;

procedure TFrmUsuarios.btnExcluirClick(Sender: TObject);
begin
  if FIDSelecionado = 0 then Exit;
  if FIDSelecionado = SessaoID then
  begin ShowMessage('Você não pode excluir seu próprio usuário!'); Exit; end;
  if MessageDlg(MSG_CONF_EXCLUIR, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
  try
    DMPrincipal.IniciarTran;
    DMPrincipal.ExecSQL('DELETE FROM USUARIOS WHERE ID=' + IntToStr(FIDSelecionado));
    DMPrincipal.CommitTran;
    ShowMessage(MSG_EXCLUIDO);
    ModoEdicao(False);
    LimparEdicao;
    CarregarLista(edtFiltro.Text);
  except
    on E: Exception do
    begin DMPrincipal.RollbackTran; ShowMessage('Erro: ' + E.Message); end;
  end;
end;

procedure TFrmUsuarios.btnCancelarClick(Sender: TObject);
begin
  ModoEdicao(False);
  LimparEdicao;
end;

end.
