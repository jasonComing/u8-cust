VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Button"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Function RunCommand(ByVal objLogin As Object, ByVal objForm As Object, ByVal objVoucher As Object, _
                            ByVal sKey As String, ByVal VarentValue As Variant, ByVal other As String)

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






