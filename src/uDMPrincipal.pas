unit uDMPrincipal;

{
  uDMPrincipal.pas
  DataModule central do sistema.
  Contém: conexão FireDAC, transação e métodos de acesso ao banco.
  Todos os forms utilizam este DataModule via variável global DMPrincipal.
}

interface

uses
  System.SysUtils, System.Classes,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Comp.UI,
  Data.DB, firedac.DApt;

type
  TDMPrincipal = class(TDataModule)
    Conn: TFDConnection;
    Tran: TFDTransaction;
    WaitCursor: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure ConfigurarConexao;
  public
    { Controle de conexão }
    function  Conectar: Boolean;
    procedure Desconectar;
    function  Conectado: Boolean;

    { Transações }
    procedure IniciarTran;
    procedure CommitTran;
    procedure RollbackTran;

    { Helpers de Query }
    function  NovaQuery: TFDQuery;
    procedure ExecSQL(const ASQL: string); overload;
    procedure ExecSQL(Qry: TFDQuery); overload;
    function  OpenQuery(const ASQL: string): TFDQuery;
    function  ContarReg(const ATabela, AWhere: string): Integer;
    function  ProxNumero(const ASeq: string): Integer;

    { Autenticação }
    function  Autenticar(const ALogin, ASenha: string): Boolean;

    { Helpers para ComboBox }
    procedure CarregarUnidades(Combo: TObject);
    procedure CarregarCategorias(Combo: TObject; ATipo: string);
  end;

var
  DMPrincipal: TDMPrincipal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

uses uGlobal, Vcl.StdCtrls;

procedure TDMPrincipal.DataModuleCreate(Sender: TObject);
begin
  ConfigurarConexao;
end;

procedure TDMPrincipal.DataModuleDestroy(Sender: TObject);
begin
  Desconectar;
end;

procedure TDMPrincipal.ConfigurarConexao;
begin
  with Conn do
  begin
    DriverName := 'FB';
    Params.Clear;
    Params.Add('DriverID=FB');
    Params.Add('Server='    + DB_HOST);
    Params.Add('Port='      + IntToStr(DB_PORT));
    Params.Add('Database='  + DB_DATABASE);
    Params.Add('User_Name=' + DB_USER);
    Params.Add('Password='  + DB_PASSWORD);
    Params.Add('CharacterSet=' + DB_CHARSET);
    Params.Add('Protocol=TCPIP');
    LoginPrompt := False;
    Transaction := Tran;
  end;
  with Tran do
  begin
    Connection := Conn;
    Options.AutoStart := True;
    Options.AutoStop  := False;
    Options.Isolation := xiReadCommitted;
  end;
end;

function TDMPrincipal.Conectar: Boolean;
begin
  try
    if not Conn.Connected then Conn.Open;
    Result := Conn.Connected;
  except on E: Exception do
    raise Exception.Create('Falha na conexão com o banco de dados:' + sLineBreak + E.Message);
  end;
end;

procedure TDMPrincipal.Desconectar;
begin
  if Conn.Connected then Conn.Close;
end;

function TDMPrincipal.Conectado: Boolean;
begin Result := Conn.Connected; end;

procedure TDMPrincipal.IniciarTran;
begin
  if not Tran.Active then Tran.StartTransaction;
end;

procedure TDMPrincipal.CommitTran;
begin
  if Tran.Active then Tran.Commit;
end;

procedure TDMPrincipal.RollbackTran;
begin
  if Tran.Active then Tran.Rollback;
end;

function TDMPrincipal.NovaQuery: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := Conn;
end;

procedure TDMPrincipal.ExecSQL(const ASQL: string);
begin
  Conn.ExecSQL(ASQL);
end;

procedure TDMPrincipal.ExecSQL(Qry: TFDQuery);
begin
  Qry.ExecSQL;
end;

function TDMPrincipal.OpenQuery(const ASQL: string): TFDQuery;
begin
  Result := NovaQuery;
  Result.SQL.Text := ASQL;
  Result.Open;
end;

function TDMPrincipal.ContarReg(const ATabela, AWhere: string): Integer;
var Qry: TFDQuery;
    SQL: string;
begin
  Result := 0;
  SQL := 'SELECT COUNT(*) FROM ' + ATabela;
  if Trim(AWhere) <> '' then SQL := SQL + ' WHERE ' + AWhere;
  Qry := OpenQuery(SQL);
  try
    if not Qry.IsEmpty then Result := Qry.Fields[0].AsInteger;
  finally Qry.Free; end;
end;

function TDMPrincipal.ProxNumero(const ASeq: string): Integer;
var Qry: TFDQuery;
begin
  Result := 0;
  Qry := OpenQuery('SELECT NEXT VALUE FOR ' + ASeq + ' FROM RDB$DATABASE');
  try
    if not Qry.IsEmpty then Result := Qry.Fields[0].AsInteger;
  finally Qry.Free; end;
end;

function TDMPrincipal.Autenticar(const ALogin, ASenha: string): Boolean;
var Qry: TFDQuery;
begin
  Result := False;
  Qry := TFDQuery.Create(nil);
  Qry.Connection := Conn;
  try
    Qry.SQL.Text :=
      'SELECT ID, NOME, LOGIN, PERFIL, ATIVO ' +
      'FROM USUARIOS WHERE LOGIN = :L AND SENHA = :S';
    Qry.ParamByName('L').AsString := ALogin;
    Qry.ParamByName('S').AsString := SHA256(ASenha);
    Qry.Open;
    if Qry.IsEmpty then Exit;
    if Qry.FieldByName('ATIVO').AsString = 'N' then
    begin
      raise Exception.Create(MSG_USU_INATIVO);
      Exit;
    end;
    SessaoID     := Qry.FieldByName('ID').AsInteger;
    SessaoNome   := Qry.FieldByName('NOME').AsString;
    SessaoLogin  := Qry.FieldByName('LOGIN').AsString;
    SessaoPerfil := Qry.FieldByName('PERFIL').AsString;
    { Registra último acesso }
    ExecSQL('UPDATE USUARIOS SET DT_ULTIMO_ACESSO = CURRENT_TIMESTAMP WHERE ID = '
            + IntToStr(SessaoID));
    CommitTran;
    Result := True;
  finally Qry.Free; end;
end;

procedure TDMPrincipal.CarregarUnidades(Combo: TObject);
var Qry: TFDQuery;
    CB: TComboBox absolute Combo;
begin
  if not (Combo is TComboBox) then Exit;
  CB.Items.Clear;
  Qry := OpenQuery('SELECT ID, SIGLA || '' - '' || DESCRICAO AS NOME FROM UNIDADES WHERE ATIVO=''S'' ORDER BY SIGLA');
  try
    while not Qry.Eof do
    begin
      CB.Items.AddObject(Qry.Fields[1].AsString, TObject(Qry.Fields[0].AsInteger));
      Qry.Next;
    end;
  finally Qry.Free; end;
end;

procedure TDMPrincipal.CarregarCategorias(Combo: TObject; ATipo: string);
var Qry: TFDQuery;
    CB: TComboBox absolute Combo;
begin
  if not (Combo is TComboBox) then Exit;
  CB.Items.Clear;
  CB.Items.AddObject('(Nenhuma)', TObject(0));
  Qry := NovaQuery;
  Qry.SQL.Text := 'SELECT ID, DESCRICAO FROM CATEGORIAS WHERE TIPO=:T AND ATIVO=''S'' ORDER BY DESCRICAO';
  Qry.ParamByName('T').AsString := ATipo;
  Qry.Open;
  try
    while not Qry.Eof do
    begin
      CB.Items.AddObject(Qry.Fields[1].AsString, TObject(Qry.Fields[0].AsInteger));
      Qry.Next;
    end;
  finally Qry.Free; end;
end;

end.
