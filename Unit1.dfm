object Form1: TForm1
  Left = 0
  Top = 0
  Caption = '68kArray'
  ClientHeight = 661
  ClientWidth = 1076
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object memInput: TMemo
    Left = 8
    Top = 8
    Width = 425
    Height = 337
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = memInputChange
  end
  object memOutput: TMemo
    Left = 439
    Top = 8
    Width = 425
    Height = 337
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object grpMenu2: TGroupBox
    Left = 439
    Top = 351
    Width = 425
    Height = 178
    TabOrder = 2
    object editRow: TLabeledEdit
      Left = 11
      Top = 16
      Width = 87
      Height = 23
      EditLabel.Width = 67
      EditLabel.Height = 13
      EditLabel.Caption = 'Items per row'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '16'
    end
    object udRow: TUpDown
      Left = 104
      Top = 16
      Width = 17
      Height = 25
      TabOrder = 1
    end
    object boxType: TComboBox
      Left = 11
      Top = 67
      Width = 110
      Height = 22
      Style = csOwnerDrawFixed
      ItemIndex = 0
      TabOrder = 2
      Text = 'dc.b'
      Items.Strings = (
        'dc.b'
        'dc.w'
        'dc.l')
    end
    object chkSigned: TCheckBox
      Left = 11
      Top = 95
      Width = 97
      Height = 17
      Caption = 'Signed'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object editIndent: TLabeledEdit
      Left = 139
      Top = 16
      Width = 87
      Height = 23
      EditLabel.Width = 32
      EditLabel.Height = 13
      EditLabel.Caption = 'Indent'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Text = '2'
    end
    object UpDown1: TUpDown
      Left = 232
      Top = 16
      Width = 17
      Height = 25
      TabOrder = 5
    end
  end
  object grpMenu: TGroupBox
    Left = 8
    Top = 351
    Width = 425
    Height = 178
    TabOrder = 3
    object lblCount: TLabel
      Left = 11
      Top = 3
      Width = 67
      Height = 13
      Caption = '0 bytes found'
    end
  end
end
