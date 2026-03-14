object FrmPagarDlg: TFrmPagarDlg
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Registrar Pagamento'
  ClientHeight = 280
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 17
  object lblValorDev: TLabel
    Left = 8
    Top = 12
    Width = 84
    Height = 17
    Caption = 'Valor Devido:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblDtPgto: TLabel
    Left = 8
    Top = 48
    Width = 100
    Height = 17
    Caption = 'Data Pagamento:'
  end
  object lblForma: TLabel
    Left = 8
    Top = 86
    Width = 129
    Height = 17
    Caption = 'Forma de Pagamento:'
  end
  object lblVlPago: TLabel
    Left = 8
    Top = 124
    Width = 71
    Height = 17
    Caption = 'Valor Pago:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblJuros: TLabel
    Left = 210
    Top = 124
    Width = 34
    Height = 17
    Caption = 'Juros:'
  end
  object lblMulta: TLabel
    Left = 8
    Top = 160
    Width = 36
    Height = 17
    Caption = 'Multa:'
  end
  object lblDescPgto: TLabel
    Left = 162
    Top = 160
    Width = 58
    Height = 17
    Caption = 'Desconto:'
  end
  object lblHistPgto: TLabel
    Left = 8
    Top = 196
    Width = 60
    Height = 17
    Caption = 'Hist'#195#179'rico:'
  end
  object edtValorDev: TEdit
    Left = 100
    Top = 8
    Width = 110
    Height = 25
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object edtDtPgto: TDateTimePicker
    Left = 120
    Top = 44
    Width = 120
    Height = 25
    Date = 46094.000000000000000000
    Time = 0.927106296294368800
    TabOrder = 1
  end
  object cboForma: TComboBox
    Left = 152
    Top = 82
    Width = 200
    Height = 25
    Style = csDropDownList
    TabOrder = 2
  end
  object edtVlPago: TEdit
    Left = 80
    Top = 120
    Width = 120
    Height = 25
    TabOrder = 3
  end
  object edtJuros: TEdit
    Left = 250
    Top = 120
    Width = 90
    Height = 25
    TabOrder = 4
  end
  object edtMulta: TEdit
    Left = 60
    Top = 156
    Width = 90
    Height = 25
    TabOrder = 5
  end
  object edtDescPgto: TEdit
    Left = 220
    Top = 156
    Width = 90
    Height = 25
    TabOrder = 6
  end
  object edtHistPgto: TEdit
    Left = 72
    Top = 192
    Width = 350
    Height = 25
    TabOrder = 7
  end
  object btnConfirmar: TButton
    Left = 8
    Top = 234
    Width = 130
    Height = 34
    Caption = 'Confirmar Pagamento'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = btnConfirmarClick
  end
  object btnCancelarDlg: TButton
    Left = 146
    Top = 234
    Width = 100
    Height = 34
    Caption = 'Cancelar'
    TabOrder = 9
    OnClick = btnCancelarDlgClick
  end
end
