VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SOsImportPrint"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
Dim vouch As Object
Dim cDepCode As String
Dim cWhCode As String
Dim u8Login As Object
Dim thisTools As New Tools

Dim xlApp As Excel.Application
Dim xlBook As Excel.Workbook
Dim xlSheet As Excel.Worksheet

Public Function RunCommand(ByVal objLogin As Object, ByVal objForm As Object, ByVal objVoucher As Object, _
                            ByVal sKey As String, ByVal VarentValue As Variant, ByVal other As String)
    
    Set u8Login = objLogin
    Set vouch = objVoucher
    
    Call PrintOrOut("Print", u8Login.UfDbName)
    
End Function

'初始化
Public Function Init(ByVal objLogin As Object, ByVal objForm As Object, ByVal objVoucher As Object, msbar As Object)
    
End Function

'在执行系统按钮只前调用,Cancel后会不再执行系统方法。
Public Function BeforeRunSysCommand(ByVal objLogin As Object, ByVal objForm As Object, ByVal objVoucher As Object, _
                            ByVal sKey As String, ByVal VarentValue As Variant, ByRef Cancel As Boolean, ByVal other As String)
                            
    Cancel = False
End Function




Private Sub PrintOrOut(sLei As String, ConnStr As String)
    Dim strName As String
    

    Dim Conn As New ADODB.Connection
    Dim rs As New ADODB.Recordset
    Dim i As Integer
    i = 0
    Dim Sql As String
    
    Dim Lei As String
    Dim X As Integer
    Dim Y As Integer
    Dim S As String
    Dim W As Integer
    Dim PicName As String
    Dim iStm
    
    'ConnStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=sa;Password=123456;Initial Catalog=UFDATA_999_2014;Data Source=127.0.0.1"      '这是连接SQL数据库的语句
    Conn.Open ConnStr
    Sql = "exec p_SOprint ''"
    rs.Open Sql, Conn, 3, 3
    Do Until rs.EOF
        If i = 0 Then
            Set xlApp = CreateObject("Excel.Application")
            Set xlBook = xlApp.Application.Workbooks.Open(rs.fields("ModelName"))
            Set xlSheet = xlBook.Worksheets(1)
        End If
        i = i + 1
        Lei = rs.fields("Lei")
        X = rs.fields("X")
        Y = rs.fields("Y")
        S = rs.fields("S")
        PicName = rs.fields("PicName")
        W = rs.fields("W")
        
        If Lei = "T" Then
            xlSheet.Cells(Y, X) = S
        End If
        If Lei = "P" Then
            '保存到文件
            Set iStm = New ADODB.Stream
            With iStm
                .Mode = adModeReadWrite
                .Type = adTypeBinary
                .Open
                .Write rs.fields("P") '这里注意了,如果当前目录下存在test1.jpg,会报一个文件写入失败的错误.
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
    rs.Close '关闭数据集
    Conn.Close '关闭对象

    If sLei = "Print" Then xlBook.PrintOut
    If sLei = "Out" Then
        FrmControls.CommonDialog1.ShowSave
        strName = FrmControls.CommonDialog1.FileName
        xlSheet.ExportAsFixedFormat Type:=xlTypePDF, FileName:=strName + ".pdf", Quality:=xlQualityStandard, IncludeDocProperties:=True, IgnorePrintAreas:=False, OpenAfterPublish:=False
    End If
    xlBook.Close False       '关闭工作簿
    xlApp.Quit '结束EXCEL对象
    Set xlApp = Nothing '释放xlApp对象
End Sub

