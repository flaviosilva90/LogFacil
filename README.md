# LogFácil ERP v3.0
Delphi RAD Studio 11 - Firebird 3.0

## Novidades v3.0

| Módulo novo | O que faz |
|---|---|
| Importação NF-e XML | Lê XML SEFAZ, preenche compra, vincula itens às Matérias-Primas |
| Orçamentos de Venda | Cria orçamentos, converte em Venda com 1 clique |
| Emissão NF-e Saída | Gera NF-e a partir de Venda, exporta XML layout 4.00 |
| Campos Fiscais | Produtos/Clientes/Fornecedores com ICMS, PIS, COFINS, IPI, SUFRAMA |
| Contas a Pagar | Parcelas, liquidação parcial/total, histórico de pagamentos |
| Contas a Receber | Idem para recebimentos, vinculado a Clientes e Vendas |
| Formas de Pagamento | Dinheiro, PIX, Cartão, Boleto, Cheque, Transferência |
| Fluxo de Caixa | Saldo em tempo real, projeção 30 dias, lançamento manual |

## Banco de Dados

### Instalação nova
1. Criar banco: C:\LogFacil\logfacil.fdb (Firebird 3.0, charset WIN1252)
2. Executar: database\logfacil_create.sql

### Migração de v2 para v3
Executar apenas: database\logfacil_v3_migrate.sql

## Primeiro acesso
Login: admin / Senha: admin123

## Dados fiscais da empresa emitente
Edite a função GerarXMLNFe em src\uFrmNFSaida.pas:
- CNPJ, Razão Social, IE, CRT da empresa

## Fluxos principais

Orçamento -> Converter em Venda -> Confirmar -> Faturar -> Emitir NF-e

NF-e XML de fornecedor -> Importar -> Compra criada -> Estoque atualizado

Venda faturada -> Conta a Receber -> Receber -> Fluxo de Caixa (entrada)
Compra recebida -> Conta a Pagar  -> Pagar  -> Fluxo de Caixa (saida)

## Dependencias
Todos os componentes sao padrao RAD Studio 11: VCL, FireDAC, Xml.XMLDoc
Para transmissao real da NF-e ao SEFAZ utilize ACBr ou DFe com o XML gerado.
