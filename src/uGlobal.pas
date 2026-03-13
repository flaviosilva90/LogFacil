unit uGlobal;

{
  uGlobal.pas
  Constantes, variáveis de sessão e funções auxiliares globais.
  Referenciada por todos os forms do projeto.
}

interface

uses
  System.SysUtils, System.Hash, System.RegularExpressions,
  Vcl.Graphics;

const
  { ── Aplicação ── }
  APP_NOME   = 'LogFácil';
  APP_VERSAO = '2.0.0';

  { ── Banco de dados (ajuste conforme ambiente) ── }
  DB_HOST     = 'localhost';
  DB_PORT     = 3050;
  DB_DATABASE = 'C:\LogFacil\logfacil.fdb';
  DB_USER     = 'SYSDBA';
  DB_PASSWORD = 'masterkey';
  DB_CHARSET  = 'WIN1252';

  { ── Perfis ── }
  PERFIL_ADMIN    = 'ADMINISTRADOR';
  PERFIL_GERENTE  = 'GERENTE';
  PERFIL_OPERADOR = 'OPERADOR';

  { ── Status Compras ── }
  STC_PENDENTE   = 'PENDENTE';
  STC_CONFIRMADA = 'CONFIRMADA';
  STC_RECEBIDA   = 'RECEBIDA';
  STC_CANCELADA  = 'CANCELADA';

  { ── Status Vendas ── }
  STV_ORCAMENTO  = 'ORCAMENTO';
  STV_CONFIRMADA = 'CONFIRMADA';
  STV_FATURADA   = 'FATURADA';
  STV_ENTREGUE   = 'ENTREGUE';
  STV_CANCELADA  = 'CANCELADA';

  { ── Tipo de Movimentação ── }
  TMOV_ENTRADA = 'E';
  TMOV_SAIDA   = 'S';
  TMOV_AJUSTE  = 'A';

  { ── Mensagens comuns ── }
  MSG_SALVO         = 'Registro salvo com sucesso!';
  MSG_EXCLUIDO      = 'Registro excluído com sucesso!';
  MSG_CONF_EXCLUIR  = 'Deseja realmente excluir este registro?';
  MSG_OBRIGATORIOS  = 'Preencha todos os campos obrigatórios.';
  MSG_SEM_ITENS     = 'Adicione pelo menos um item antes de salvar.';
  MSG_LOGIN_INVALIDO= 'Login ou senha inválidos!';
  MSG_USU_INATIVO   = 'Usuário inativo. Contate o administrador.';
  MSG_EST_INSUF     = 'Estoque insuficiente para o produto: ';

{ ── Variáveis de sessão ── }
var
  SessaoID     : Integer = 0;
  SessaoNome   : string  = '';
  SessaoLogin  : string  = '';
  SessaoPerfil : string  = '';

{ ── Funções utilitárias ── }
function  SHA256(const S: string): string;
function  SoNumeros(const S: string): string;
function  FormatCPF(const S: string): string;
function  FormatCNPJ(const S: string): string;
function  FormatFone(const S: string): string;
function  FormatCEP(const S: string): string;
function  MoedaStr(V: Double): string;
function  QtdStr(V: Double): string;
function  StrMoeda(const S: string): Double;
function  IsAdmin: Boolean;
function  IsGerenteOuAdmin: Boolean;
function  CorStatus(const S: string): TColor;

implementation

function SHA256(const S: string): string;
begin
  Result := THashSHA2.GetHashString(S);
end;

function SoNumeros(const S: string): string;
var C: Char;
begin
  Result := '';
  for C in S do if CharInSet(C, ['0'..'9']) then Result := Result + C;
end;

function FormatCPF(const S: string): string;
var N: string;
begin
  N := SoNumeros(S);
  if Length(N) = 11 then
    Result := Copy(N,1,3)+'.'+Copy(N,4,3)+'.'+Copy(N,7,3)+'-'+Copy(N,10,2)
  else Result := S;
end;

function FormatCNPJ(const S: string): string;
var N: string;
begin
  N := SoNumeros(S);
  if Length(N) = 14 then
    Result := Copy(N,1,2)+'.'+Copy(N,3,3)+'.'+Copy(N,6,3)+'/'+Copy(N,9,4)+'-'+Copy(N,13,2)
  else Result := S;
end;

function FormatFone(const S: string): string;
var N: string;
begin
  N := SoNumeros(S);
  case Length(N) of
    10: Result := '('+Copy(N,1,2)+') '+Copy(N,3,4)+'-'+Copy(N,7,4);
    11: Result := '('+Copy(N,1,2)+') '+Copy(N,3,5)+'-'+Copy(N,8,4);
  else  Result := S;
  end;
end;

function FormatCEP(const S: string): string;
var N: string;
begin
  N := SoNumeros(S);
  if Length(N) = 8 then Result := Copy(N,1,5)+'-'+Copy(N,6,3)
  else Result := S;
end;

function MoedaStr(V: Double): string;
begin
  Result := FormatFloat('R$ #,##0.00', V);
end;

function QtdStr(V: Double): string;
begin
  if Frac(V) = 0 then Result := FormatFloat('0', V)
  else Result := FormatFloat('0.###', V);
end;

function StrMoeda(const S: string): Double;
var T: string;
begin
  T := StringReplace(S, 'R$', '', [rfReplaceAll]);
  T := StringReplace(T, '.', '', [rfReplaceAll]);
  T := StringReplace(Trim(T), ',', '.', [rfReplaceAll]);
  Result := StrToFloatDef(T, 0);
end;

function IsAdmin: Boolean;
begin Result := SessaoPerfil = PERFIL_ADMIN; end;

function IsGerenteOuAdmin: Boolean;
begin
//  Result := SessaoPerfil in [PERFIL_ADMIN, PERFIL_GERENTE]
end;

function CorStatus(const S: string): TColor;
begin
  if S = 'CANCELADA'     then Result := $001414D0
  else if S = 'RECEBIDA'  then Result := $00227722
  else if S = 'FATURADA'  then Result := $00227722
  else if S = 'ENTREGUE'  then Result := $00115511
  else if S = 'CONFIRMADA'then Result := $00995500
  else if S = 'SEM ESTOQUE' then Result := $001414D0
  else if S = 'ESTOQUE BAIXO' then Result := $000099FF
  else Result := clWindowText;
end;

end.
