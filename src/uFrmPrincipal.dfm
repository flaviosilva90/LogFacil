object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'LogF'#225'cil - Sistema ERP'
  ClientHeight = 599
  ClientWidth = 896
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 17
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 896
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    Color = 10040064
    TabOrder = 0
    ExplicitWidth = 900
    object lblBemVindo: TLabel
      Left = 16
      Top = 14
      Width = 78
      Height = 19
      Caption = 'Bem-vindo,'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPerfil: TLabel
      Left = 200
      Top = 16
      Width = 101
      Height = 15
      Caption = '[ADMINISTRADOR]'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16764057
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 577
    Width = 896
    Height = 22
    Panels = <
      item
        Width = 200
      end
      item
        Width = 200
      end
      item
        Width = 200
      end>
    ExplicitTop = 578
    ExplicitWidth = 900
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
      object mnuCompras: TMenuItem
        Caption = '&Compras de Mat. Prima'
        OnClick = mnuComprasClick
      end
      object mnuVendas: TMenuItem
        Caption = '&Vendas de Produtos'
        OnClick = mnuVendasClick
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
    object mnuSistema: TMenuItem
      Caption = '&Sistema'
      object mnuSair: TMenuItem
        Caption = '&Sair'
        OnClick = mnuSairClick
      end
    end
  end
  object tmrRelogio: TTimer
    OnTimer = tmrRelogioTimer
    Left = 20
    Top = 60
  end
end
