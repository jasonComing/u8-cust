VERSION 5.00
Begin VB.Form F_SOsImportMemo 
   Caption         =   "销售订单文字说明内容"
   ClientHeight    =   4785
   ClientLeft      =   120
   ClientTop       =   450
   ClientWidth     =   7110
   Icon            =   "F_SOsImportMemo.frx":0000
   LinkTopic       =   "Form1"
   Picture         =   "F_SOsImportMemo.frx":058A
   ScaleHeight     =   4785
   ScaleWidth      =   7110
   StartUpPosition =   2  '屏幕中心
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   1500
      Left            =   1680
      Top             =   2400
   End
   Begin VB.CommandButton Command1 
      Caption         =   "载入"
      Height          =   350
      Left            =   4080
      TabIndex        =   2
      Top             =   4320
      Width           =   1455
   End
   Begin VB.CommandButton SOsImportMemo 
      Caption         =   "保存"
      Height          =   350
      Left            =   5640
      TabIndex        =   1
      Top             =   4320
      Width           =   1215
   End
   Begin VB.TextBox Text1 
      Enabled         =   0   'False
      Height          =   3735
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      Top             =   480
      Width           =   7095
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "请先载入数据然后再编辑"
      Height          =   180
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   1980
   End
End
Attribute VB_Name = "F_SOsImportMemo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public DocNo As String
Public ConnStr As String

Private Sub Command1_Click()
    Dim Conn As New ADODB.Connection
    Dim rs As New ADODB.Recordset
    Dim i As Integer
    Dim Sql As String
    Conn.Open ConnStr
    Sql = "select b.chdefine3 from SO_SOMain a left join SO_SOMain_extradefine b on a.ID=b.ID where a.cSOCode='" & DocNo & "' and isnull(b.chdefine3,'')!=''"
    rs.Open Sql, Conn, 3, 3
    'MsgBox ("a")
    Do Until rs.EOF
        Text1.Text = rs.fields("chdefine3")
        rs.MoveNext
    Loop
    'MsgBox ("d")
    rs.Close '关闭数据集
    Conn.Close '关闭对象
    Text1.Enabled = True
End Sub

Private Sub SOsImportMemo_Click()
    Dim Conn As New ADODB.Connection
    Dim rs As New ADODB.Recordset
    Dim i As Integer
    Dim Sql As String
    Conn.Open ConnStr
    'Sql = "update SO_SOMain set cDefine3='" & Text1.Text & "' where cSOCode='" & DocNo & "'"
    
    Sql = "update b set b.chdefine3='" & Text1.Text & "' from SO_SOMain a left join SO_SOMain_extradefine b on a.ID=b.ID where a.cSOCode='" & DocNo & "'"
    
    
    
'    rs.Open Sql, Conn, 3, 3
'    Do Until rs.EOF
'        Text1.Text = rs.fields("cDefine3")
'        rs.MoveNext
'    Loop
    Set rs = Conn.Execute(Sql)
    'rs.Close '关闭数据集
    Conn.Close '关闭对象
    MsgBox ("保存成功！")
End Sub

