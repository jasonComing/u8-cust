VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Tools"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
Public Sub BuildTxt()
    
    'retVal代表这个程序的任务 ID，若不成功，则会返回 0
    Dim retVal As Double

    retVal = Shell(App.Path & "\Txt\inven.bat", vbNormalFocus)

    'If 0 <> retVal Then
    '    MsgBox "操作成功", vbOKOnly, "系统提示"
    'Else
    '    MsgBox "操作失败", vbOKOnly, "系统提示"
    'End If
End Sub

Public Sub ReadTxt(o As Object, methodName As String)
    
    Dim fso As New FileSystemObject, file As file, ts As TextStream, S As String
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set file = fso.GetFile(App.Path & "\Txt\inven.txt")
    Set ts = file.OpenAsTextStream(ForReading)
    '例：条码:120R311YB08864821980 1 1006,存货编码=6120R311YB,琴号=0886482,年月日=1980 1 1,存放地点=006
    Dim barCode As String, invCode As String, cNo As String, cDay As String, cAddr As String
    '循环处理每一行的条码
    Dim barCodes As String
    barCodes = ""
    Do While Not ts.AtEndOfStream
        barCode = ts.ReadLine
        '去掉重复扫描的条码
        If InStr(barCodes, barCode) <= 0 Then
            If barCodes = "" Then
                barCodes = barCode
            Else
                barCodes = barCodes & "," & barCode
            End If
            
            '琴号
            cNo = Mid(barCode, 10, 7)
            '根据琴号从条码表里找出信息
            '存货编码空位补0
            invCode = "6" & Replace(Mid(barCode, 1, 9), " ", "0")
            cDay = Mid(barCode, 17, 8)
            cAddr = Mid(barCode, 25, 3)
            CallByName o, methodName, VbMethod, barCode, invCode, cNo, cDay, cAddr
        End If
    Loop
End Sub

Public Sub ReadBarCode(o As Object, methodName As String)
    
    Dim fso As New FileSystemObject, file As file, ts As TextStream, S As String
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set file = fso.GetFile(App.Path & "\Txt\inven.txt")
    Set ts = file.OpenAsTextStream(ForReading)
    '例：条码:120R311YB08864821980 1 1006,存货编码=6120R311YB,琴号=0886482,年月日=1980 1 1,存放地点=006
    Dim barCode As String, invCode As String, cNo As String, cDay As String, cAddr As String
    '循环处理每一行的条码
    Dim barCodes As String
    barCodes = ""
    Do While Not ts.AtEndOfStream
        barCode = ts.ReadLine
        '去掉重复扫描的条码
        If InStr(barCodes, barCode) <= 0 Then
            If barCodes = "" Then
                barCodes = barCode
            Else
                barCodes = barCodes & "," & barCode
            End If
            
            CallByName o, methodName, VbMethod, barCode
        End If
    Loop
End Sub

Public Function ExecuteScalar(u8Login As Object, Sql As String)
    Dim ConnStr As String
    ConnStr = u8Login.UfDbName
    
    Dim Conn As New ADODB.Connection
    Conn.ConnectionString = ConnStr
    Conn.Open
    
    Dim rst As New ADODB.Recordset
    
    Set rst = Conn.Execute(Sql)
    rst.MoveFirst
    ExecuteScalar = rst.fields(0)

End Function

Public Function ExecuteRecordset(u8Login As Object, Sql As String) As ADODB.Recordset
    Dim ConnStr As String
    ConnStr = u8Login.UfDbName
    Dim Conn As New ADODB.Connection
    Conn.ConnectionString = ConnStr
    Conn.Open
    
    Dim rst As New ADODB.Recordset

    Set rst = Conn.Execute(Sql)
    Set ExecuteRecordset = rst

End Function
'读取Excel数据生成Rst
Public Sub ReadXls(o As Object, methodName As String, AllLineStr As String, ConnStr As String)
    Dim Conn As New ADODB.Connection
    Dim rs As New ADODB.Recordset
    Dim i As Integer
    Dim Sql As String
    Dim strName As String
    Dim strSheetName As String
    
'    'On Error GoTo fileCancel
'    'On Error Resume Next
'
'    FrmControls.CommonDialog1.ShowOpen
'    strName = FrmControls.CommonDialog1.FileName
'
'    'MsgBox strName
'    'strName = App.Path & "\\book.xls" 'EXCEL文件名
'    'strName = "D:\1.xls" 'EXCEL文件名
'    strSheetName = "sheet1" 'EXCEL表名
'    Conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Persist Security Info=False;Data Source=" & strName & ";Extended Properties='Excel 8.0;HDR=Yes'" '连接EXCEL文件
'    'Conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & strName & ";Extended Properties='Excel 8.0;HDR=No;IMEX=1;'" '连接EXCEL文件
'    sql = "select * from [" & strSheetName & "$]" '打开EXCEL表
'    rs.Open sql, Conn, 3, 3
'    'MsgBox rs.RecordCount '显示表里的记录数
'
'    Do Until rs.EOF
'        CallByName o, methodName, VbMethod, rs.fields("存货编码"), rs.fields("数量")
'        rs.MoveNext
'    Loop
'
'    rs.Close '关闭数据集
'    Conn.Close '关闭对象

    
    

    
    Conn.Open ConnStr
    Sql = "exec p_PoSPaddLine '" & AllLineStr & "'"
    rs.Open Sql, Conn, 3, 3
    Do Until rs.EOF
        CallByName o, methodName, VbMethod, rs.fields("存货编码"), rs.fields("数量"), rs.fields("cDefine29"), rs.fields("cDefine33"), rs.fields("cDefine30"), rs.fields("csocode")
        rs.MoveNext
    Loop
    rs.Close '关闭数据集
    Conn.Close '关闭对象
    
    
    
    Exit Sub
'fileCancel:
End Sub



