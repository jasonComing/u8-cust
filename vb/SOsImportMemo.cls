VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SOsImportMemo"
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
   
   '�õ����ݺŵ������Ϣ
   '����dll����exe
   
   
   '���ӵİ�ť ����д������
    Set vouch = objVoucher
    
    
    
    'cDepCode = vouch.headerText("cDepCode")
    
    'If (IsNull(cDepCode) Or 0 = Len(cDepCode)) Then
    '    MsgBox "��ѡ����!", vbOKOnly, "ϵͳ��ʾ"
    '    Exit Function
    'End If
    
    'cWhCode = vouch.headerText("cWhCode")
    'If (IsNull(cWhCode) Or 0 = Len(cWhCode)) Then
    '    MsgBox "��ѡ��ֿ�!", vbOKOnly, "ϵͳ��ʾ"
    '    Exit Function
    'End If
    
'    MsgBox ("���۶���")
'    MsgBox (vouch.headerText("cSOCode"))
'    MsgBox (u8Login.UfDbName)
'
'    'ɾ���Ѿ�������ı�������
'    Dim iCount As Integer
'    iCount = vouch.BodyRows
'    Dim i As Integer
'    'For i = iCount To 1 Step -1
'    '    vouch.DelLine i
'    'Next i
'
'    'Call thisTools.ReadXls(Me, "BodyInpuyt")

    
    Dim frm As New F_SOsImportMemo
    frm.DocNo = vouch.headerText("cSOCode")
    frm.ConnStr = u8Login.UfDbName
    frm.Show vbModal, F_SOsImportMemo

'    Dim Conn As New ADODB.Connection
'    Dim rs As New ADODB.Recordset
'    Dim i As Integer
'    Dim sql As String
'    Conn.Open u8Login.UfDbName
'    sql = "exec p_SoSPaddDoc '" & vouch.headerText("cSOCode") & "','','','0','',''"
'    rs.Open sql, Conn, 3, 3
'    Do Until rs.EOF
'        MsgBox (rs.fields("ReStr"))
'        rs.MoveNext
'    Loop
'    rs.Close '�ر����ݼ�
'    Conn.Close '�رն���

End Function
'��������
Public Sub BodyInpuyt(cInvCode As String, cQty As String)
    MsgBox ("SoAdd")
    Dim eCheck As Long

    Dim rowIndex As Integer
    '������д����
    rowIndex = vouch.BodyRows + 1
    Call vouch.SimulateInput(SectionsConstants.sibody, rowIndex, "cInvCode", cInvCode, eCheck)
    Call vouch.SimulateInput(SectionsConstants.sibody, rowIndex, "iQuantity", cQty, eCheck)

End Sub

'��ʼ��
Public Function Init(ByVal objLogin As Object, ByVal objForm As Object, ByVal objVoucher As Object, msbar As Object)
    
End Function

'��ִ��ϵͳ��ťֻǰ����,Cancel��᲻��ִ��ϵͳ������
Public Function BeforeRunSysCommand(ByVal objLogin As Object, ByVal objForm As Object, ByVal objVoucher As Object, _
                            ByVal sKey As String, ByVal VarentValue As Variant, ByRef Cancel As Boolean, ByVal other As String)
                            
    Cancel = False
End Function







