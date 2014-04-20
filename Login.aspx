<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="login">
<div class="content">			
			<div class="row">
				<div class="ten columns centered text-center">
                    <h1 class="lead" style=" font-size:22px; font-family:Sans-Serif;"><i class="icon-login"></i> Login</h1>                      
						<ul>
                            <li class="prepend field">
							    <span class="adjoined"><i class="icon-user"></i></span>
							    <input class="xwide text input" type="text" placeholder="Please Enter User Name" id="txtnameLogin">
						    </li>                            
                            <li class="prepend field">
							    <span class="adjoined"><i class="icon-key"></i></span>
							    <input class="xwide text input" type="password" placeholder="Please Enter Your Password" id="txtpwdLogin">
						    </li>                                                      							
						</ul>	
                        <div class="medium primary btn"><a href="#" onclick="login();"><i class="icon-login"></i>Login</a></div>
                        <a onclick="funSign();" style="float:right; cursor:pointer;">Click here to Signup <i class="icon-export"></i></a>			
					<%--<h2>This is a modal.</h2>
					<p>Gumby modals are easy to make using Toggles &amp; Switches. The <span class="label default">.modal</span> class already has the required styles which you can open and close using Toggles &amp; Switches.</p>--%>
				</div>
			</div>
            <div id="notify1" style="padding:10px; display:none; text-align:center; margin-left:25%; width:50%;"><label id="lblAlertMessage1"></label></div>
            <div style="text-align:center;  display:none;" id="load1" ><img src="img/sync.gif" /></div>
		</div>
</div>
<div id="signup" style="display:none;">
<div class="content">			
			<div class="row">
				<div class="ten columns centered text-center">
                    <h1 class="lead" style=" font-size:22px; font-family:Sans-Serif;"><i class="icon-lock-open"></i> Sign-Up</h1>                      
						<ul>
                            <li class="prepend field">
							    <span class="adjoined"><i class="icon-user"></i></span>
							    <input class="xwide text input" type="text" placeholder="Please Enter User Name" id="txtNameSignup">
						    </li>                            
                            <li class="prepend field">
							    <span class="adjoined"><i class="icon-key"></i></span>
							    <input class="xwide text input" type="password" placeholder="Please Enter Your Password" id="txtPasswordSignup">
						    </li>                                                      							
						</ul>	
                        <div class="medium primary btn"><a href="#" onclick="signup();"><i class="icon-export"></i>Signup</a></div>		
                        <a onclick="funLogin();" style="float:right; cursor:pointer;">Click here to Login <i class="icon-login"></i></a>                        				
					<%--<h2>This is a modal.</h2>
					<p>Gumby modals are easy to make using Toggles &amp; Switches. The <span class="label default">.modal</span> class already has the required styles which you can open and close using Toggles &amp; Switches.</p>--%>
				</div>                
			</div>
            <div id="notify" style="padding:10px; display:none; text-align:center; margin-left:25%; width:50%;"><label id="lblAlertMessage"></label></div>
            <div style="text-align:center;  display:none;" id="load" ><img src="img/sync.gif" /></div>
		</div>
</div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="footer" Runat="Server">
    <script>
    function funSign() {
        $("#login").hide();
        $("#signup").show();
    }
    function funLogin() {
        $("#login").show();
        $("#signup").hide();
    }
    function signup() {
        var txtnameSignup = $("#txtNameSignup").val();
        var txtpwdSignup = $("#txtPasswordSignup").val();
        if (txtnameSignup != "" && txtpwdSignup != "") {
            $("#load").show();
            $("#notify").hide();
            $.ajax({
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json;charset:utf-8',
                url: 'Login.aspx/Signup',
                data: '{"uname":"' + txtnameSignup + '"' + "," + '"password":"' + txtpwdSignup + '"}',
                success: function (data) {
                    if (data.d == true) {
                        $("#load").hide();
                        window.location = 'Calculator.aspx';
                    }
                    else if (data.d == false) {
                        $("#notify").show();
                        $("#notify").addClass("danger alert");
                        $("#load").hide();
                        $("#lblAlertMessage").html("UserName Already Exists !!");
                    }
                    else {
                        $("#notify").show();
                        $("#notify").addClass("danger alert");
                        $("#load").hide();
                        $("#lblAlertMessage").html("Something Went Wrong .. Please Try Again");
                    }
                }
            });
        }
        else {
            $("#notify").show();
            $("#notify").addClass("danger alert");        
            $("#lblAlertMessage").html("All the Fields are Mandatory");
        }
    }

    function login() {
        var txtnamelogin = $("#txtnameLogin").val();
        var txtpwdlogin = $("#txtpwdLogin").val();
        if (txtnamelogin != "" && txtpwdlogin != "") {
            $("#load1").show();
            $("#notify1").hide();
            $.ajax({
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json;charset:utf-8',
                url: 'Login.aspx/login',
                data: '{"uname":"' + txtnamelogin + '"' + "," + '"password":"' + txtpwdlogin + '"}',
                success: function (data) {
                    if (data.d == true) {
                        $("#load1").hide();
                        window.location = 'Calculator.aspx';
                    }
                    else {
                        $("#notify1").show();
                        $("#notify1").addClass("danger alert");
                        $("#load1").hide();
                        $("#lblAlertMessage1").html("UserName (OR) PassWord Is Wrong ...");
                    }
                }
            });
        }
        else {
            $("#notify1").show();
            $("#notify1").addClass("danger alert");
            $("#lblAlertMessage1").html("All the Fields are Mandatory");
        }
    }
</script>
</asp:Content>

