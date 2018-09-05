<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>窃电用户检测系统</title>
<!-- Tell the browser to be responsive to screen width -->
<meta
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
	name="viewport">
	

<%@ include file="/page/common_import.jsp"%>
<style type="text/css">
.login-page {
	background: URL(<%=path%>/img/login/bg.png);
	background-size:100% auto;
	background-repeat: no-repeat;
}


.login-box,.register-box {
	width: 360px;
	margin: 24% auto auto 55%;
}
@media screen and (max-width:1000px){
	.login-box,.register-box {
		width: 300px;
		margin: 60% auto;
	}
}

.login-button {
	background: URL(<%=path%>/img/login/button.png);
}

.login-img {
	width: 20px;
	height: 20px;
	border-radius: 6px;
}

.input-group-lg>.form-control,.input-group-lg>.input-group-addon,.input-group-lg>.input-group-btn>.btn
	{
	height: 56px;
	padding: 10px 16px;
	font-size: 18px;
	line-height: 1.3333333;
	border-radius: 6px;
}

.btn-lg {
	padding: 16px 18px;
	font-size: 18px;
	line-height: 1.3333333;
	border-radius: 6px;
}

#bannerDiv
{
    position:absolute;
    top:30px;
    left:30px;
    background-image:url("<%=path%>/img/login/banner.png"); 
    width: 100%;
    height: 100px;
    z-index: 9999999;
    background-repeat: no-repeat;
}

</style>
</head>
<body class="hold-transition login-page">
    <div id="bannerDiv">
    </div>

	<div class="login-box">
		<div>
			<div>
				<div class="form-group">
					<div class="input-group input-group-lg">
						<span class="input-group-addon"
							style="border-radius: 6px 0px 0px 6px;"><img
							class="login-img" src="<%=path%>/img/login/account.png" /> </span> <input
							type="text" class="form-control" name="username" id="username"
							placeholder="用户名">						
					</div>
				</div>
				<div class="form-group">
					<div class="input-group input-group-lg">
						<span class="input-group-addon"
							style="border-radius: 6px 0px 0px 6px;"> <img
							class="login-img" src="<%=path%>/img/login/password.png" /> </span> <input
							type="password" class="form-control" name="password"
							id="password" placeholder="密码">
					</div>
				</div>
				<div class="form-group">
					<button onclick="login()"
						class="btn btn-primary btn-block btn-flat login-button btn-lg"
						style="border-radius: 6px;">登录</button>
				</div>
			</div>
			<div id="msg" style="color: red; font-size: 18px;"></div>
		</div>
	</div>

	<script>
	
	$("#password").keypress(function(e){
        var eCode = e.keyCode ? e.keyCode : e.which ? e.which : e.charCode;
        if (eCode == 13){
            login();
        }
})
  function login() 
	{
		var url = "<%=path%>/loginAction/login.do";
		var username = $("#username").val();
		var password = $("#password").val();
		
		if ($.trim(username).length == 0) 
        {
            $("#msg").html("请输入用户名");
            return;
        }
        
        if ($.trim(password).length == 0) 
        {
            $("#msg").html("请输入密码");
            return;
        }
		
		//password = $.md5(password);
		
		$.ajax({
			url : url,
			type : "POST", //访问方式
			cache : false,
			data : {
			    "username":username,
			    "password":password
			}, //这里的参数后续确认一下???
			dataType : "json",
			success : function(datajson) {
				if(datajson.resultCode==200)
				{
				    window.location.href='<%=path%>/page/fileUpload.jsp';
					} else {
						$("#msg").html(datajson.resultDesc);
					}
				}
			});
		}
	</script>
</body>
</html>
