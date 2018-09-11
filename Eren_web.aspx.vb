Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.VisualBasic

Public Class Eren_web
    Inherits System.Web.UI.Page
    'Private sql As New SqlConnection("Data Source=E1-572G\SQLEXPRElSS;Initial Catalog=GIS;Integrated Security=True")
    'Private da As New SqlDataAdapter("SELECT * FROM LocationDetails", sql)
    'Private ds As New DataSet
    'Private cd As New SqlCommandBuilder(da)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            ConvertDataTabletoString()
        End If

    End Sub

    Public Function ConvertDataTabletoString()
        Dim dt As New DataTable()
        Dim ddt As New ArrayList()

        Using con As New SqlConnection("Data Source = WANJUNG\SQLEXPRESS;Initial Catalog = GIS;Integrated Security = True")           '連結資料庫
            Using cmd As New SqlCommand("select title=機構名稱,lat=北緯,lng=東經,管理單位地址 from ILIST", con)                    '呼叫資料庫資料
                con.Open()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)

                Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
                Dim rows As New List(Of Dictionary(Of String, Object))()
                Dim row As Dictionary(Of String, Object)
                Dim ctl As New CoordinateTransform

                For Each dr As DataRow In dt.Rows
                    row = New Dictionary(Of String, Object)()

                    For Each col As DataColumn In dt.Columns
                        row.Add(col.ColumnName, dr(col))
                    Next
                    rows.Add(row)
                Next
                Return serializer.Serialize(rows)
            End Using
        End Using
    End Function
    'Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
    '   

    '   Dim TestArray() As String = Split(ctl.TWD97_To_lonlat(Convert.ToDouble(TextBox1.Text), Convert.ToDouble(TextBox2.Text), 2), ",")
    '   TextBox3.Text = TestArray(o)
    '   TextBox4.Text = TestArray(1)
    'TextBox3.Text = ctl.TWD97_To_lonlat(Convert.ToDouble(TextBox1.Text), Convert.ToDouble(TextBox2.Text), 2)
    'Dim ctl As New CoordinateTransform
    'TextBox3.Text = ctl.TWD97_To_lonlatX(Convert.ToDouble(TextBox1.Text), Convert.ToDouble(TextBox2.Text), 2)
    'TextBox4.Text = ctl.TWD97_To_lonlatY(Convert.ToDouble(TextBox1.Text), Convert.ToDouble(TextBox2.Text), 2)
    'ConvertDataTabletoString1()
    'End Sub

    'Public Sub ConvertDataTabletoString1()
    '    Dim dt As New DataTable
    '    Dim ctl As New CoordinateTransform


    '    Using con As New SqlConnection("Data Source=user-pc\sqlexpress;Initial Catalog=GIS;Integrated Security=True")

    '        Using cmd As New SqlCommand("select title=機構名稱,lat=北緯,lng=東經,管理單位地址 from 列管事業資料", con)
    '            con.Open()
    '            Dim da As New SqlDataAdapter(cmd)
    '            da.Fill(dt)
    '            For Each dr As DataRow In dt.Rows
    '                'Dim TestArray() As String = Split(ctl.TWD97_To_lonlat(Convert.ToDouble(dr("lat")), Convert.ToDouble(dr("lng")), 2), ",")
    '                TextBox5.Text = TextBox5.Text & ctl.TWD97_To_lonlatX(Convert.ToDouble(dr("lng")), Convert.ToDouble(dr("lat")), 2) & "," & ctl.TWD97_To_lonlatY(Convert.ToDouble(dr("lng")), Convert.ToDouble(dr("lat")), 2) & vbCrLf
    '            Next
    ' Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
    '  Dim rows As New List(Of Dictionary(Of String, Object))()
    '  Dim row As Dictionary(Of String, Object)
    '  For Each dr As DataRow In dt.Rows
    '  'row = New Dictionary(Of String, Object)()
    '  For Each col As DataColumn In dt.Columns
    '  'row.Add(col.ColumnName, dr(col))
    '   Next
    ''   rows.Add(row)
    '   Next
    '   Return serializer.Serialize(rows)
    '        End Using
    '    End Using
    'End Sub

End Class