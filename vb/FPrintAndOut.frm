VERSION 5.00
Begin VB.Form FPrintAndOut 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "��ӡ�����"
   ClientHeight    =   6240
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   6840
   Icon            =   "FPrintAndOut.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6240
   ScaleWidth      =   6840
   StartUpPosition =   2  '��Ļ����
   Begin VB.CommandButton Command3 
      Caption         =   "���Excel"
      BeginProperty Font 
         Name            =   "����"
         Size            =   48
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1455
      Left            =   480
      TabIndex        =   2
      Top             =   4320
      Width           =   5715
   End
   Begin VB.CommandButton Command2 
      Caption         =   "���PDF"
      BeginProperty Font 
         Name            =   "����"
         Size            =   48
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1455
      Left            =   480
      TabIndex        =   1
      Top             =   2520
      Width           =   5715
   End
   Begin VB.CommandButton Command1 
      Caption         =   "��ӡ"
      BeginProperty Font 
         Name            =   "����"
         Size            =   48
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1455
      Left            =   480
      TabIndex        =   0
      Top             =   720
      Width           =   5715
   End
End
Attribute VB_Name = "FPrintAndOut"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public DocNo As String
Public ConnStr As String


Dim xlApp As Excel.Application
Dim xlBook As Excel.Workbook
Dim xlSheet As Excel.Worksheet
Dim xlSheet2 As Excel.Worksheet

Private Sub Command1_Click()
    Call PrintOrOut("Print")
End Sub

Private Sub Command2_Click()
    Call PrintOrOut("Out")
End Sub

Private Sub Command3_Click()
    Call PrintOrOut("OutExcel")
End Sub

Private Sub PrintOrOut(sLei As String)
    On Error GoTo Error
    
    
    Dim strName As String
    
    Dim Conn As New ADODB.Connection
    Dim rs As New ADODB.Recordset
    Dim i As Integer
    Dim ii As Integer
    i = 0
    Dim Sql As String
    
    Dim Lei As String
    Dim X As Integer
    Dim Y As Integer
    Dim S As String
    Dim W As Integer
    Dim Xall As String
    Dim PicName As String
    Dim iStm
    Dim ColW As Single
    
    'ConnStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=sa;Password=123456;Initial Catalog=UFDATA_999_2014;Data Source=127.0.0.1"      '��������SQL���ݿ�����
    Conn.Open ConnStr
    Sql = "exec p_SOprint '" & DocNo & "'"
    rs.Open Sql, Conn, 3, 3
    Do Until rs.EOF
        If i = 0 Then
            Set xlApp = CreateObject("Excel.Application")
            If sLei = "OutExcel" Then
                Dim SourceFile, DestinationFile
                SourceFile = rs.fields("ModelName")   ' ָ��Դ�ļ�����
                DestinationFile = "C:\U8Print\Pic\U" & Format$(Now, "yyyymmddhhnnss") & ".xlsx"    ' ָ��Ŀ���ļ�����
                FileCopy SourceFile, DestinationFile   ' ��Դ�ļ������ݸ��Ƶ�Ŀ���ļ��С�
                Set xlBook = xlApp.Application.Workbooks.Open(DestinationFile)
            Else
                Set xlBook = xlApp.Application.Workbooks.Open(rs.fields("ModelName"))
            End If
            Set xlSheet = xlBook.Worksheets(1)
            Set xlSheet2 = xlBook.Worksheets(2)
        End If
        i = i + 1
        Lei = rs.fields("Lei")
        X = rs.fields("X")
        Y = rs.fields("Y")
        S = rs.fields("S")
        Xall = rs.fields("Xall")
        PicName = rs.fields("PicName")
        W = rs.fields("W")
        
        If Lei = "T" Then
            If Xall <> "" Then
                Xall = Xall & ",,,,,,,,,,,,,"
                ColW = 0
                For ii = 0 To 5 Step 1
                    If Split(Xall, ",")(ii) <> "" Then
                        ColW = ColW + xlSheet.Columns(CInt(Split(Xall, ",")(ii))).ColumnWidth + 0.7
                    End If
                Next ii
                xlSheet2.Columns(X).ColumnWidth = ColW
                xlSheet2.Cells(Y, X) = S
                xlSheet.Rows(Y).RowHeight = xlSheet2.Rows(Y).RowHeight
            End If
            xlSheet.Cells(Y, X) = S
        End If
        If Lei = "P" Then
            '���浽�ļ�
            Set iStm = New ADODB.Stream
            With iStm
                .Mode = adModeReadWrite
                .Type = adTypeBinary
                .Open
                .Write rs.fields("P") '����ע����,�����ǰĿ¼�´���test1.jpg,�ᱨһ���ļ�д��ʧ�ܵĴ���.
                .SaveToFile PicName 'App.Path & Pic
            End With
            
            Dim objPic As Object
            Set objPic = xlSheet.Pictures.Insert(PicName)
            objPic.Left = X
            objPic.Top = Y
            objPic.Width = W
        End If
        
        rs.MoveNext
    Loop
    rs.Close '�ر����ݼ�
    Conn.Close '�رն���

    If sLei = "Print" Then
        'xlBook.PrintOut
        xlSheet.PrintOut
    End If
    If sLei = "OutExcel" Then
        xlApp.Visible = True
        Unload Me
        Exit Sub
    End If
    If sLei = "Out" Then
        FrmControls.CommonDialog1.ShowSave
        strName = FrmControls.CommonDialog1.FileName
        xlSheet.ExportAsFixedFormat Type:=xlTypePDF, FileName:=strName + ".pdf", Quality:=xlQualityStandard, IncludeDocProperties:=True, IgnorePrintAreas:=False, OpenAfterPublish:=False
    End If
    xlBook.Close False       '�رչ�����
    'xlBook.Close True
    xlApp.Quit '����EXCEL����
    Set xlApp = Nothing '�ͷ�xlApp����
'    MsgBox (5)
    Unload Me
'    MsgBox (6)

    
    
Error:
    Exit Sub

End Sub


