VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SOsImport"
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

Public Function RunCommand(ByVal objLogin As Object, ByVal objForm As Object, ByVal objVoucher As Object, _
                            ByVal sKey As String, ByVal VarentValue As Variant, ByVal other As String)
    
    Set u8Login = objLogin
   
   '得到单据号等相关信息
   '传给dll或者exe
   
   
   '增加的按钮 代码写在这里
    Set vouch = objVoucher
    
    Dim Conn As New ADODB.Connection
    Dim rs As New ADODB.Recordset
    Dim i As Integer
    Dim Sql As String
    Conn.Open u8Login.UfDbName
    Sql = "exec p_CreateSO '" & vouch.headerText("cSOCode") & "'"
    rs.Open Sql, Conn, 3, 3
    Do Until rs.EOF
        MsgBox (rs.fields("ReStr"))
        rs.MoveNext
    Loop
    rs.Close '关闭数据集
    Conn.Close '关闭对象

End Function

'初始化
Public Function Init(ByVal objLogin As Object, ByVal objForm As Object, ByVal objVoucher As Object, msbar As Object)
    
End Function

'在执行系统按钮只前调用,Cancel后会不再执行系统方法。
Public Function BeforeRunSysCommand(ByVal objLogin As Object, ByVal objForm As Object, ByVal objVoucher As Object, _
                            ByVal sKey As String, ByVal VarentValue As Variant, ByRef Cancel As Boolean, ByVal other As String)
                            
    Cancel = False
End Function






