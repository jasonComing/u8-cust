VERSION 5.00
Begin VB.Form FrmInputInv 
   Caption         =   "�������"
   ClientHeight    =   3030
   ClientLeft      =   120
   ClientTop       =   450
   ClientWidth     =   4560
   LinkTopic       =   "Form1"
   ScaleHeight     =   3030
   ScaleWidth      =   4560
   StartUpPosition =   3  '����ȱʡ
   Begin VB.TextBox Text1 
      Height          =   495
      Left            =   600
      TabIndex        =   1
      Text            =   "Text1"
      Top             =   480
      Width           =   3255
   End
   Begin VB.CommandButton Command1 
      Caption         =   "ȷ��"
      Height          =   495
      Left            =   1320
      TabIndex        =   0
      Top             =   1440
      Width           =   1335
   End
End
Attribute VB_Name = "FrmInputInv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim vouch As Object

Private Sub Command1_Click()
    Dim eCheck As Long
    Call vouch.SimulateInput(SectionsConstants.sibody, vouch.BodyRows + 1, "cinvcode", Me.Text1.Text, eCheck)
End Sub

Public Sub Init(objVouch As Object)
    Set vouch = objVouch
    Me.Show
End Sub

Public Sub BuildTxt(objVouch As Object)
    
    'retVal���������������� ID�������ɹ�����᷵�� 0
    Dim retVal As Double
    
    retVal = Shell(App.Path & "\Txt\inven.bat", vbNormalFocus)
    
    If 0 <> retVal Then
        MsgBox "�����ɹ�", vbOKOnly, "ϵͳ��ʾ"
    Else
        MsgBox "����ʧ��", vbOKOnly, "ϵͳ��ʾ"
    End If
End Sub


Public Sub demo()
    'ctlVoucher1.headerText ("cWhCode")
   
   'ctlVoucher1.headerText("bredvouch")
   
   
    

End Sub
