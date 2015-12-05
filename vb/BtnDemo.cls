VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "BtnDemo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Function RunCommand(ByVal objLogin As Object, ByVal objForm As Object, ByVal objVoucher As Object, _
                            ByVal sKey As String, ByVal VarentValue As Variant, ByVal other As String)
   '增加的按钮 代码写在这里
   
   '下面的例子，模拟给单据填充数据
   
   Call FrmInputInv.Init(objVoucher)
   

'
'Public Sub SimulateInput(ByVal section As SectionsConstants, ByVal nRow As Long, ByVal Col As Variant, ByRef sRetValue As String, ByRef eCheck As Long)
 
   'SectionsConstants  常数 表体为1 ，表头为0
   'Dim sRet As String
   'Dim eCheck As Long
   'sRet = "001"
   'VBA.MsgBox "test"
  'Call objVoucher.SimulateInput(1, 1, "cinvcode", "01019002065", eCheck)
  ' bodyInput objVoucher
   
   '定义配置文件xml
   'Dim doc As New DOMDocument
   'doc.Load (App.Path & "\Xmls\Config.xml")
   'Dim btnKey As String
   'btnKey = Mid(sKey, 9)
   'Dim xn As IXMLDOMElement
   'Set xn = doc.selectSingleNode("/Button/Item[@ButtonKey='" & btnKey & "']")
   'Dim obj As Object
   'Set obj = Create(xn.getAttribute("ClassFullName"))
   'Call obj.Init(objVoucher)
   

End Function

'初始化
Public Function Init(ByVal objLogin As Object, ByVal objForm As Object, ByVal objVoucher As Object, msbar As Object)
 
End Function

'在执行系统按钮只前调用,Cancel后会不再执行系统方法。
Public Function BeforeRunSysCommand(ByVal objLogin As Object, ByVal objForm As Object, ByVal objVoucher As Object, _
                            ByVal sKey As String, ByVal VarentValue As Variant, ByRef Cancel As Boolean, ByVal other As String)
                            
    
    Cancel = False
End Function




