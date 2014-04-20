<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Calculator.aspx.cs" Inherits="Calculator" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style>

h2
{
text-align:center;
text-decoration:underline;
}
.box
{
background-color:#3d4543;
height:300px;
width:250px;
border-radius:10px;
position:relative;
top:80px;
left:40%;
}
.display
{
background-color:#222;
width:220px;
position:relative;
left:15px;
top:20px;
height:40px;
}
.display input
{
position:relative;
left:2px;
top:2px;
height:35px;
color:black;
background-color:#bccd95;
font-size:21px;
text-align:right;
}
.keys
{
position:relative;
top:15px;
}
.button
{
width:40px;
height:30px;
border:none;
border-radius:8px;
margin-left:17px;
cursor:pointer;
border-top:2px solid transparent;
}
.button.gray
{
color:white;
background-color:#6f6f6f;
border-bottom:black 2px solid;
border-top:2px #6f6f6f solid;
}
.button.pink
{
color:black;
background-color:#ff4561;
border-bottom:black 2px solid;
}
.button.black
{
color:white;
background-color:303030;
border-bottom:black 2px solid;
border-top:2px 303030 solid;
}
.button.orange
{
color:black;
background-color:FF9933;
border-bottom:black 2px solid;
border-top:2px FF9933 solid;
}
.gray:active
{
border-top:black 2px solid;
border-bottom:2px #6f6f6f solid;
}
.pink:active
{
border-top:black 2px solid;
border-bottom:#ff4561 2px solid;
}
.black:active
{
border-top:black 2px solid;
border-bottom:#303030 2px solid;
}
.orange:active
{
border-top:black 2px solid;
border-bottom:FF9933 2px solid;
}
p
{
line-height:10px;
}
.button.black 
{
    color :Black;
    border-bottom: 2px solid #000;
}
p{
    line-height: 52px;
}
table thead tr th {
font-size: 13px;
font-weight:400px;
vertical-align: bottom;
}
table tr td:first-child {
font-weight: 400px;
}
table tr td, table tbody tr td {
font-size: 12px;
}
table thead th,table tbody td, table tr td {
display: table-cell;
padding: 3px 7px 3px 7px;
vertical-align: top;
text-align: left;
border-top: 1px solid #e5e5e5;
}
.f_right{ float:right; color:White; font-size:12px;}
</style>
<script>         
    function c(val) {
        document.getElementById("d").value = val;
    }
    function v(val) {
        document.getElementById("d").value += val;
    }
    function e() {
        try {
            var expression = document.getElementById("d").value;
            var value = eval(expression);
            c(eval(document.getElementById("d").value))
            //var uid =  $("input[id*='hdnUid']").val();
            var uid = $("#<%=hdnUid.ClientID %>").val();
            $.ajax({
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json;charset:utf-8',
                url: 'Calculator.aspx/StoreCalc',
                data: '{"uid":"' + uid + '"' + "," + '"Expression":"' + expression + '"' + "," + ' "Value":"' + value + '"}',
                success: function (data) {
                    if (data.d == true) {
                        document.getElementById("d").value = value;

                        $.ajax({
                            type: 'POST',
                            dataType: 'json',
                            contentType: 'application/json;charset:utf-8',
                            url: 'Calculator.aspx/DisplayResult',
                            data: '{"uid":"' + uid + '"}',
                            success: function (data) {
                                $("#tblStrip tbody").html(data.d);
                            }
                        });
                    }
                    else {
                        document.getElementById("d").value = "error";
                    }
                }
            });

        }
        catch (e) {
            c('Error')
        }
    }    
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:Button ID="login" runat="server" Text="logout" onclick="login_Click" CssClass="medium primary btn f_right" style="font-size:11px;"/>
<div class="box">
	<div class="display"><input type="text" readonly size="18" id="d" style="width: 217px;"></div>
	<div class="keys">
		<p><input type="button" class="button gray" value="mrc" onclick='c("Created....................")'>        
        <input type="button" class="button gray " value="m-" onclick='c("...............by............")'><input type="button" class="button gray" value="m+" onclick='c(".....................Arun")'><input type="button" class="button pink" value="/" onclick='v("/")'></p>
		<p><input type="button" class="button black " value="7" onclick='v("7")'><input type="button" class="button black" value="8" onclick='v("8")'><input type="button" class="button black" value="9" onclick='v("9")'><input type="button" class="button pink" value="*" onclick='v("*")'></p>
		<p><input type="button" class="button black" value="4" onclick='v("4")'><input type="button" class="button black" value="5" onclick='v("5")'><input type="button" class="button black" value="6" onclick='v("6")'><input type="button" class="button pink" value="-" onclick='v("-")'></p>
		<p><input type="button" class="button black" value="1" onclick='v("1")'><input type="button" class="button black" value="2" onclick='v("2")'><input type="button" class="button black" value="3" onclick='v("3")'><input type="button" class="button pink" value="+" onclick='v("+")'></p>
		<p><input type="button" class="button black" value="0" onclick='v("0")'><input type="button" class="button black" value="." onclick='v(".")'><input type="button" class="button black" value="C" onclick='c("")'><input type="button" class="button orange" value="=" onclick='e()'></p>
	</div>
</div>
<div style="clear:both;"></div>
<br /><br /><br /><br />
<div style="width:500px; margin-left:400px;">
 <table class="striped" style="font-size:9px; padding:0px;" id="tblStrip">					
	<thead>
		<tr>
			<th>Expression</th>
			<th>IPAddress</th>
            <th>DateTime</th>     
		</tr>
	</thead>
	<tbody>
    </tbody>
</table>
</div>
<asp:HiddenField ID="hdnUid" runat="server"/>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="footer" Runat="Server">
<script>
    $(document).ready(function () {
        loadPage();
    });
    function loadPage() {
        var uid = $("#<%=hdnUid.ClientID %>").val();        
        $.ajax({
            type: 'POST',
            dataType: 'json',
            contentType: 'application/json;charset:utf-8',
            url: 'Calculator.aspx/DisplayResult',
            data: '{"uid":"' + uid + '"}',
            success: function (data) {
                $("#tblStrip tbody").html(data.d);
            }
        });
    }
    </script>  
</asp:Content>

