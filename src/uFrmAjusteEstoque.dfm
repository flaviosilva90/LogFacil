object FrmAjusteEstoque: TFrmAjusteEstoque
  Caption = 'Ajuste de Estoque'
  ClientHeight = 700  ClientWidth = 900
  Font.Name = 'Segoe UI'  Font.Height = -13
  Position = poOwnerFormCenter  OnCreate = FormCreate
  object pnlTopo: TPanel
    Left=0 Top=0 Width=900 Height=40 Align=alTop BevelOuter=bvNone Color=$00993300
    object lblTitulo: TLabel
      Left=12 Top=10 Caption='AJUSTE DE ESTOQUE'
      Font.Color=clWhite Font.Style=[fsBold] Font.Height=-14 ParentFont=False
    end
  end
  object pnlFiltro: TPanel
    Left=0 Top=40 Width=900 Height=44 Align=alTop BevelOuter=bvNone TabOrder=1
    object edtFiltro: TEdit Left=8 Top=10 Width=220 Height=25 Hint='Filtrar por motivo' TabOrder=0 end
    object cboTipoEst: TComboBox
      Left=240 Top=10 Width=140 Height=25 Style=csDropDownList TabOrder=1
    end
    object btnBuscar: TButton Left=392 Top=9 Width=80 Height=27 Caption='Buscar' TabOrder=2 OnClick=btnBuscarClick end
    object btnNovo: TButton   Left=480 Top=9 Width=80 Height=27 Caption='Novo'   TabOrder=3 OnClick=btnNovoClick end
  end
  object sgdLista: TStringGrid
    Left=0 Top=84 Width=900 Height=160 Align=alTop
    ColCount=6 DefaultRowHeight=22 RowCount=2 FixedRows=1
    Options=[goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRowSelect]
    TabOrder=2 OnClick=sgdListaClick
  end
  object pnlEdicao: TPanel
    Left=0 Top=244 Width=900 Height=456 Align=alTop
    BevelOuter=bvNone Color=$00FAFAFA TabOrder=3 Visible=False
    { Cabeçalho }
    object lblNumero: TLabel Left=8 Top=8 Caption='N'#250'mero' end
    object edtNumero: TEdit Left=8 Top=26 Width=90 Height=25 ReadOnly=True Color=clBtnFace TabOrder=0 end
    object lblData: TLabel Left=110 Top=8 Caption='Data' end
    object edtData: TDateTimePicker Left=110 Top=26 Width=120 Height=25 TabOrder=1 end
    object lblTipoEstLbl: TLabel Left=244 Top=8 Caption='Tipo Estoque' end
    object cboTipoEstEd: TComboBox
      Left=244 Top=26 Width=150 Height=25 Style=csDropDownList TabOrder=2
      OnChange=cboTipoEstEdChange
    end
    object lblMotivo: TLabel Left=406 Top=8 Caption='Motivo: *' end
    object edtMotivo: TEdit Left=406 Top=26 Width=380 Height=25 MaxLength=100 TabOrder=3 end
    object lblObs: TLabel Left=8 Top=62 Caption='Observa'#231#245'es' end
    object mmoObs: TMemo Left=8 Top=80 Width=780 Height=50 TabOrder=4 end
    { Grid Itens }
    object lblItens: TLabel Left=8 Top=140 Caption='Itens do Ajuste:' Font.Style=[fsBold] ParentFont=False end
    object sgdItens: TStringGrid
      Left=0 Top=158 Width=900 Height=130
      ColCount=7 DefaultRowHeight=22 RowCount=2 FixedRows=1
      Options=[goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRowSelect]
      TabOrder=5
    end
    { Linha de adição }
    object pnlAddItem: TPanel
      Left=0 Top=288 Width=900 Height=36 BevelOuter=bvNone Color=$00EEF4FF
      object lblAddID: TLabel Left=8 Top=10 Caption='ID:' end
      object edtAddID: TEdit Left=28 Top=6 Width=60 Height=25 TabOrder=0 end
      object edtAddNome: TEdit Left=92 Top=6 Width=200 Height=25 ReadOnly=True Color=clBtnFace TabOrder=1 end
      object btnBuscarItem: TButton Left=298 Top=5 Width=28 Height=27 Caption='...' TabOrder=2 OnClick=btnBuscarItemClick end
      object lblAddTipoMov: TLabel Left=334 Top=10 Caption='Mov:' end
      object cboAddTipoMov: TComboBox Left=362 Top=6 Width=120 Height=25 Style=csDropDownList TabOrder=3 end
      object lblAddQtdNova: TLabel Left=490 Top=10 Caption='Qtd:' end
      object edtAddQtdNova: TEdit Left=518 Top=6 Width=80 Height=25 Text='0,000' TabOrder=4 end
      object lblAddVlUnit: TLabel Left=606 Top=10 Caption='Vl.Unit:' end
      object edtAddVlUnit: TEdit Left=648 Top=6 Width=80 Height=25 Text='0,00' TabOrder=5 end
      object btnAddItem: TButton Left=736 Top=5 Width=70 Height=27 Caption='+ Add' TabOrder=6 OnClick=btnAddItemClick end
      object btnRemItem: TButton Left=812 Top=5 Width=70 Height=27 Caption='- Rem' TabOrder=7 OnClick=btnRemItemClick end
    end
    object lblAddObs: TLabel Left=8 Top=334 Caption='Obs do item:' end
    object edtAddObs: TEdit Left=8 Top=352 Width=500 Height=25 TabOrder=8 end
    { Botões }
    object pnlBotoes: TPanel
      Left=0 Top=388 Width=900 Height=44 BevelOuter=bvNone Color=$00E8E8E8
      object btnSalvar: TButton
        Left=8 Top=8 Width=120 Height=30 Caption='Salvar Ajuste' TabOrder=0 OnClick=btnSalvarClick
      end
      object btnFechar: TButton
        Left=136 Top=8 Width=100 Height=30 Caption='Fechar' TabOrder=1 OnClick=btnFecharClick
      end
    end
  end
end
