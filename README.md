# LogFácil — Sistema ERP

Versão **2.0.0** · Delphi RAD Studio 11 · Firebird 3.0

---

## Módulos

| Módulo | Descrição |
|---|---|
| Login | Autenticação SHA-256 com bloqueio após 5 tentativas |
| Usuários | CRUD completo — perfis: Administrador, Gerente, Operador |
| Clientes | Pessoa Física e Jurídica, endereço, limite de crédito |
| Fornecedores | PF / PJ, contato, endereço |
| Matérias-Primas | Código, unidade, categoria, custo médio, estoque |
| Produtos | Código, código de barras, preço, margem automática |
| Compras | Itens de MP · status: Pendente → Confirmada → Recebida |
| Vendas | Itens de produto · status: Orçamento → Faturada → Entregue |
| Estoque | Posição atual (produtos e MP) + histórico de movimentações |
| Ajuste de Estoque | Entrada / Saída / Ajuste direto com rastreabilidade |

---

## Estrutura de Arquivos

```
LogFacil/
├── LogFacil.dpr          ← Projeto Delphi
├── LogFacil.dproj        ← Opções do projeto (RAD Studio 11)
├── database/
│   └── logfacil_create.sql   ← Script completo do banco Firebird 3.0
└── src/
    ├── uGlobal.pas           ← Constantes, sessão, funções utilitárias
    ├── uDMPrincipal.pas/.dfm ← DataModule: conexão FireDAC + helpers
    ├── uFrmLogin.pas/.dfm
    ├── uFrmPrincipal.pas/.dfm
    ├── uFrmUsuarios.pas/.dfm
    ├── uFrmClientes.pas/.dfm
    ├── uFrmFornecedores.pas/.dfm
    ├── uFrmMatPrimas.pas/.dfm
    ├── uFrmProdutos.pas/.dfm
    ├── uFrmCompras.pas/.dfm
    ├── uFrmVendas.pas/.dfm
    ├── uFrmEstoque.pas/.dfm
    └── uFrmAjusteEstoque.pas/.dfm
```

---

## Requisitos

- **IDE**: Embarcadero RAD Studio 11 (Alexandria)
- **Banco**: Firebird 3.0 (servidor local ou remoto)
- **Driver**: FireDAC — incluído no RAD Studio 11
- **Componentes**: padrão VCL + FireDAC (sem dependências externas)

---

## Instalação do Banco de Dados

### 1. Criar o banco
Usando **FlameRobin**, **IBExpert** ou `isql`:

```bash
# Via isql (linha de comando Firebird)
isql -user SYSDBA -password masterkey

SQL> CREATE DATABASE 'C:\LogFacil\logfacil.fdb'
     USER 'SYSDBA' PASSWORD 'masterkey'
     PAGE_SIZE 8192 DEFAULT CHARACTER SET WIN1252;
SQL> EXIT;
```

### 2. Executar o script
```bash
isql -user SYSDBA -password masterkey C:\LogFacil\logfacil.fdb -i database\logfacil_create.sql
```

---

## Configuração da Conexão

Edite as constantes em `src\uGlobal.pas`:

```pascal
DB_HOST     = 'localhost';    // IP ou nome do servidor
DB_PORT     = 3050;           // porta padrão Firebird
DB_DATABASE = 'C:\LogFacil\logfacil.fdb';
DB_USER     = 'SYSDBA';
DB_PASSWORD = 'masterkey';
DB_CHARSET  = 'WIN1252';
```

---

## Primeiro Acesso

| Campo | Valor |
|---|---|
| Login | `admin` |
| Senha | `admin123` |
| Perfil | ADMINISTRADOR |

> **Recomendado**: Altere a senha do administrador no primeiro acesso  
> em **Cadastros → Usuários**.

---

## Fluxo de Negócio

### Compras de Matéria-Prima
```
PENDENTE → CONFIRMADA → RECEBIDA
                           └─► Estoque MP atualizado (custo médio ponderado)
                           └─► Movimentação registrada em ESTOQUE_MP_MOV
```

### Vendas de Produtos
```
ORÇAMENTO → CONFIRMADA → FATURADA → ENTREGUE
                            └─► Estoque debitado automaticamente
                            └─► Movimentação registrada em ESTOQUE_MOV
FATURADA → CANCELADA
              └─► Estorno automático do estoque
```

### Ajuste Manual de Estoque
- **Entrada (E)**: acrescenta quantidade ao estoque atual
- **Saída (S)**: subtrai quantidade do estoque atual
- **Ajuste (A)**: define o valor absoluto do estoque

---

## Tabelas Principais

| Tabela | Descrição |
|---|---|
| USUARIOS | Controle de acesso |
| CLIENTES | Cadastro de clientes PF/PJ |
| FORNECEDORES | Cadastro de fornecedores |
| PRODUTOS | Cadastro de produtos com preço e estoque |
| MAT_PRIMAS | Matérias-primas com custo médio |
| COMPRAS / COMPRAS_ITENS | Pedidos de compra |
| VENDAS / VENDAS_ITENS | Pedidos de venda |
| ESTOQUE_MOV | Histórico de movimentações — produtos |
| ESTOQUE_MP_MOV | Histórico de movimentações — MP |
| AJUSTES_ESTOQUE / AJUSTES_ITENS | Ajustes manuais auditáveis |
| UNIDADES | Unidades de medida |
| CATEGORIAS | Categorias de produtos e MP |

---

## Perfis de Usuário

| Perfil | Permissões |
|---|---|
| ADMINISTRADOR | Acesso total, incluindo cadastro de usuários |
| GERENTE | Todos os módulos exceto usuários |
| OPERADOR | Operações do dia a dia (sem exclusão de cadastros) |

---

## Observações Técnicas

- Todas as senhas são armazenadas como **SHA-256**
- O estoque é atualizado por **triggers** no banco de dados (não no Delphi), garantindo integridade independente do cliente
- Custo médio ponderado calculado automaticamente no recebimento de compras
- Cancelamento de venda faturada faz **estorno automático** via trigger
- Conexão FireDAC com **transações explícitas** em todas as operações de escrita
- Charset **WIN1252** para compatibilidade com acentuação em português no Firebird
