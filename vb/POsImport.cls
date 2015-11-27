VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "POsImport"
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
    
    '获取单据行数据
    Dim LineStr As String
    LineStr = ""
    Dim iCount As Integer
    iCount = vouch.BodyRows
    Dim i As Integer
    For i = iCount To 1 Step -1
        'vouch.DelLine i
        If LineStr <> "" Then
            LineStr = LineStr + "|"
        End If
        'cDefine22是否纳入MRP计算
        LineStr = LineStr + vouch.bodyText(i, "cInvCode") + "," + vouch.bodyText(i, "iQuantity") + "," + vouch.bodyText(i, "cDefine29") + "," + vouch.bodyText(i, "cDefine33") + "," + vouch.bodyText(i, "cDefine30") + "," + vouch.bodyText(i, "csocode")
    Next i
    
    
    
    Call thisTools.ReadXls(Me, "BodyInpuyt", LineStr, u8Login.UfDbName)

End Function
'表体输入
Public Sub BodyInpuyt(cInvCode As String, cQty As String, cDefine29 As String, cDefine33 As String, cDefine30 As String, csocode As String)
    Dim eCheck As Long
    Dim Code1 As String
    Dim Code2 As String
    Code1 = csocode
    Code2 = csocode

    Dim rowIndex As Integer
    '表体填写数据
    rowIndex = vouch.BodyRows + 1
    Call vouch.SimulateInput(SectionsConstants.sibody, rowIndex, "cInvCode", cInvCode, eCheck)
    Call vouch.SimulateInput(SectionsConstants.sibody, rowIndex, "iQuantity", cQty, eCheck)
    Call vouch.SimulateInput(SectionsConstants.sibody, rowIndex, "iMoney", 0, eCheck)
    
    Call vouch.SimulateInput(SectionsConstants.sibody, rowIndex, "cbdefine3", Code1, eCheck)
    
    Call vouch.SimulateInput(SectionsConstants.sibody, rowIndex, "cDefine29", cDefine29, eCheck)
    Call vouch.SimulateInput(SectionsConstants.sibody, rowIndex, "cDefine33", cDefine33, eCheck)
    Call vouch.SimulateInput(SectionsConstants.sibody, rowIndex, "cDefine30", "False", eCheck)
    Call vouch.SimulateInput(SectionsConstants.sibody, rowIndex, "csocode", Code2, eCheck)
    
    
    

End Sub

'初始化
Public Function Init(ByVal objLogin As Object, ByVal objForm As Object, ByVal objVoucher As Object, msbar As Object)
 
End Function

'在执行系统按钮只前调用,Cancel后会不再执行系统方法。
Public Function BeforeRunSysCommand(ByVal objLogin As Object, ByVal objForm As Object, ByVal objVoucher As Object, _
                            ByVal sKey As String, ByVal VarentValue As Variant, ByRef Cancel As Boolean, ByVal other As String)
                            
    
    Cancel = False
End Function








