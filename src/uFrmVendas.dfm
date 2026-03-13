object FrmVendas: TFrmVendas
  Caption = 'Vendas de Produtos'
  ClientHeight = 740  ClientWidth = 960
  Font.Name = 'Segoe UI'  Font.Height = -13
  Position = poOwnerFormCenter  OnCreate = FormCreate
  object pnlTopo: TPanel
    Left=0 Top=0 Width=960 Height=40 Align=alTop BevelOuter=bvNone Color=$00993300
    object lblTitulo: TLabel
      Left=12 Top=10 Caption='VENDAS DE PRODUTOS'
      Font.Color=clWhite Font.Style=[fsBold] Font.Height=-14 ParentFont=False
    end
  end
  object pnlFiltro: TPanel
    Left=0 Top=40 Width=960 Height=44 Align=alTop BevelOuter=bvNone TabOrder=1
    object edtFiltro: TEdit Left=8 Top=10 Width=220 Height=25 TabOrder=0 end
    object cboStatus: TComboBox Left=240 Top=10 Width=130 Height=25 Style=csDropDownList TabOrder=1 end
    object btnBuscar: TButton Left=382 Top=9 Width=80 Height=27 Caption='Buscar' TabOrder=2 OnClick=btnBuscarClick end
    object btnNova: TButton   Left=470 Top=9 Width=80 Height=27 Caption='Nova'   TabOrder=3 OnClick=btnNovaClick end
  end
  object sgdLista: TStringGrid
    Left=0 Top=84 Width=960 Height=180 Align=alTop
    ColCount=8 DefaultRowHeight=22 RowCount=2 FixedRows=1
    Options=[goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRowSelect]
    TabOrder=2 OnClick=sgdListaClick
  end
  object pnlEdicao: TPanel
    Left=0 Top=264 Width=960 Height=476 Align=alTop
    BevelOuter=bvNone Color=$00FAFAFA TabOrder=3 Visible=False
    object lblNumero: TLabel  Left=8 Top=8 Caption='N'#250'mero' end
    object edtNumero: TEdit   Left=8 Top=26 Width=90 Height=25 ReadOnly=True Color=clBtnFace TabOrder=0 end
    object lblCliente: TLabel Left=110 Top=8 Caption='Cliente: *' end
    object edtClienteID: TEdit Left=110 Top=26 Width=55 Height=25 TabOrder=1 end
    object edtClienteNome: TEdit Left=170 Top=26 Width=280 Height=25 ReadOnly=True Color=clBtnFace TabOrder=2 end
    object btnBuscarCli: TButton Left=456 Top=25 Width=28 Height=27 Caption='...' TabOrder=3 OnClick=btnBuscarCliClick end
    object lblEmissao: TLabel Left=496 Top=8 Caption='Emiss'#227'o' end
    object edtEmissao: TDateTimePicker Left=496 Top=26 Width=110 Height=25 TabOrder=4 end
    object lblEntrega: TLabel Left=618 Top=8 Caption='Entrega' end
    object edtEntrega: TDateTimePicker Left=618 Top=26 Width=110 Height=25 TabOrder=5 end
    object lblStatus: TLabel Left=740 Top=8 Caption='Status' end
    object edtStatusLabel: TEdit Left=740 Top=26 Width=120 Height=25 ReadOnly=True Color=clBtnFace TabOrder=6 end
    object lblNF: TLabel Left=8 Top=62 Caption='NF N'#250'mero' end
    object edtNF: TEdit Left=8 Top=80 Width=120 Height=25 TabOrder=7 end
    object lblCondPagto: TLabel Left=140 Top=62 Caption='Cond. Pagamento' end
    object edtCondPagto: TEdit Left=140 Top=80 Width=200 Height=25 TabOrder=8 end
    object lblObs: TLabel Left=352 Top=62 Caption='Obs' end
    object mmoObs: TMemo Left=352 Top=80 Width=490 Height=48 TabOrder=9 end
    object lblItens: TLabel Left=8 Top=140 Caption='Itens da Venda:' Font.Style=[fsBold] ParentFont=False end
    object sgdItens: TStringGrid
      Left=0 Top=158 Width=960 Height=130
      ColCount=7 DefaultRowHeight=22 RowCount=2 FixedRows=1
      Options=[goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRowSelect]
      TabOrder=10
    end
    object pnlAddItem: TPanel
      Left=0 Top=288 Width=960 Height=36 BevelOuter=bvNone Color=$00EEF4FF
      object lblAddProd: TLabel Left=8 Top=10 Caption='ID Prod:' end
      object edtAddProdID: TEdit Left=56 Top=6 Width=55 Height=25 TabOrder=0 end
      object edtAddProdNome: TEdit Left=116 Top=6 Width=230 Height=25 ReadOnly=True Color=clBtnFace TabOrder=1 end
      object btnBuscarProd: TButton Left=352 Top=5 Width=28 Height=27 Caption='...' TabOrder=2 OnClick=btnBuscarProdClick end
      object lblAddQtd: TLabel Left=388 Top=10 Caption='Qtd:' end
      object edtAddQtd: TEdit Left=414 Top=6 Width=80 Height=25 Text='1,000' TabOrder=3 end
      object lblAddVlUnit: TLabel Left=502 Top=10 Caption='Vl.Unit:' end
      object edtAddVlUnit: TEdit Left=548 Top=6 Width=90 Height=25 Text='0,00' TabOrder=4 end
      object lblAddDesc: TLabel Left=646 Top=10 Caption='Desc:' end
      object edtAddDesc: TEdit Left=678 Top=6 Width=80 Height=25 Text='0,00' TabOrder=5 end
      object btnAddItem: TButton Left=766 Top=5 Width=80 Height=27 Caption='+ Item' TabOrder=6 OnClick=btnAddItemClick end
      object btnRemItem: TButton Left=852 Top=5 Width=80 Height=27 Caption='- Remover' TabOrder=7 OnClick=btnRemItemClick end
    end
    object pnlTotais: TPanel
      Left=640 Top=330 Width=316 Height=70 BevelOuter=bvNone Color=$00FAFAFA
      object lblFrete: TLabel Left=8 Top=6 Caption='Frete:' end
      object edtFrete: TEdit Left=60 Top=2 Width=100 Height=25 Text='0,00' TabOrder=0 OnChange=edtFreteChange end
      object lblDescGlobal: TLabel Left=168 Top=6 Caption='Desconto:' end
      object edtDescGlobal: TEdit Left=228 Top=2 Width=80 Height=25 Text='0,00' TabOrder=1 OnChange=edtDescGlobalChange end
      object lblTotalLabel: TLabel Left=8 Top=38 Caption='TOTAL:' Font.Style=[fsBold] ParentFont=False end
      object edtTotal: TEdit Left=60 Top=34 Width=120 Height=25 ReadOnly=True Color=clBtnFace 
        Font.Style=[fsBold] ParentFont=False TabOrder=2 end
    end
    object pnlBotoes: TPanel
      Left=0 Top=406 Width=960 Height=44 BevelOuter=bvNone Color=$00E8E8E8
      object btnSalvar: TButton    Left=8   Top=8 Width=100 Height=30 Caption='Salvar'      TabOrder=0 OnClick=btnSalvarClick end
      object btnConfirmar: TButton Left=116 Top=8 Width=100 Height=30 Caption='Confirmar'   Enabled=False TabOrder=1 OnClick=btnConfirmarClick end
      object btnFaturar: TButton   Left=224 Top=8 Width=100 Height=30 Caption='Faturar'     Enabled=False TabOrder=2 OnClick=btnFaturarClick end
      object btnEntregar: TButton  Left=332 Top=8 Width=100 Height=30 Caption='Entregar'    Enabled=False TabOrder=3 OnClick=btnEntregarClick end
      object btnCancelarDoc: TButton Left=440 Top=8 Width=100 Height=30 Caption='Cancelar'  Enabled=False TabOrder=4 OnClick=btnCancelarDocClick end
      object btnFechar: TButton    Left=548 Top=8 Width=100 Height=30 Caption='Fechar'      TabOrder=5 OnClick=btnFecharClick end
    end
  end
end
