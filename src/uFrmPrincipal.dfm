object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'LogF'#225'cil ERP v3.0'
  ClientHeight = 600
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  OnClose = FormClose
  OnCreate = FormCreate
  WindowState = wsMaximized
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    Color = $00993300
    TabOrder = 0
    object lblBemVindo: TLabel
      Left = 16
      Top = 14
      Caption = 'Bem-vindo,'
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPerfil: TLabel
      Left = 240
      Top = 16
      Caption = '[ADMINISTRADOR]'
      Font.Color = $00FFCC99
      Font.Height = -12
      Font.Name = 'Segoe UI'
      ParentFont = False
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 578
    Width = 1000
    Height = 22
    Panels = <
      item
        Width = 220
      end
      item
        Width = 220
      end
      item
        Width = 200
      end>
  end
  object MainMenu: TMainMenu
    object mnuCadastros: TMenuItem
      Caption = '&Cadastros'
      object mnuUsuarios: TMenuItem
        Caption = '&Usu'#225'rios'
        OnClick = mnuUsuariosClick
      end
      object sep1: TMenuItem
        Caption = '-'
      end
      object mnuClientes: TMenuItem
        Caption = '&Clientes'
        OnClick = mnuClientesClick
      end
      object mnuFornecedores: TMenuItem
        Caption = '&Fornecedores'
        OnClick = mnuFornecedoresClick
      end
      object sep2: TMenuItem
        Caption = '-'
      end
      object mnuMatPrimas: TMenuItem
        Caption = '&Mat'#233'rias-Primas'
        OnClick = mnuMatPrimasClick
      end
      object mnuProdutos: TMenuItem
        Caption = '&Produtos'
        OnClick = mnuProdutosClick
      end
    end
    object mnuMovimentos: TMenuItem
      Caption = '&Movimentos'
      object mnuOrcamentos: TMenuItem
        Caption = '&Or'#231'amentos de Venda'
        OnClick = mnuOrcamentosClick
      end
      object mnuVendas: TMenuItem
        Caption = '&Vendas de Produtos'
        OnClick = mnuVendasClick
      end
      object mnuCompras: TMenuItem
        Caption = '&Compras de Mat. Prima'
        OnClick = mnuComprasClick
      end
      object sep3: TMenuItem
        Caption = '-'
      end
      object mnuImportNFXML: TMenuItem
        Caption = 'Importar NF-e &XML (Entrada)'
        OnClick = mnuImportNFXMLClick
      end
      object mnuNFSaida: TMenuItem
        Caption = 'Emitir &NF-e (Sa'#237'da)'
        OnClick = mnuNFSaidaClick
      end
    end
    object mnuEstoque: TMenuItem
      Caption = '&Estoque'
      object mnuEstoqueProd: TMenuItem
        Caption = 'Posi'#231#227'o de &Produtos'
        OnClick = mnuEstoqueProdClick
      end
      object mnuEstoqueMP: TMenuItem
        Caption = 'Posi'#231#227'o de Mat. &Primas'
        OnClick = mnuEstoqueMPClick
      end
      object mnuAjuste: TMenuItem
        Caption = '&Ajuste de Estoque'
        OnClick = mnuAjusteClick
      end
    end
    object mnuFinanceiro: TMenuItem
      Caption = '&Financeiro'
      object mnuContasPagar: TMenuItem
        Caption = 'Contas a &Pagar'
        OnClick = mnuContasPagarClick
      end
      object mnuContasReceber: TMenuItem
        Caption = 'Contas a &Receber'
        OnClick = mnuContasReceberClick
      end
      object sep4: TMenuItem
        Caption = '-'
      end
      object mnuFluxoCaixa: TMenuItem
        Caption = '&Fluxo de Caixa'
        OnClick = mnuFluxoCaixaClick
      end
    end
    object mnuSistema: TMenuItem
      Caption = '&Sistema'
      object mnuSair: TMenuItem
        Caption = '&Sair'
        OnClick = mnuSairClick
      end
    end
  end
  object tmrRelogio: TTimer
    Interval = 1000
    OnTimer = tmrRelogioTimer
    Left = 20
    Top = 60
  end
end
