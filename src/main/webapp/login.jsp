<%
	String path = request.getScheme() + "://" + request.getServerName() + ":" +
			request.getServerPort() + request.getContextPath() + "/";
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<base href="<%=path%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
	$(function () {
		// 加载页面第一件事 给用户名加焦点
		// 并且将用户名中内容清空
		$("#loginAct").val("");
		$("#loginAct").focus();

		// 点击按钮提交登录
		$("#submitBtn").click(function () {
			checkLogin();
		})

		// 为回车绑定提交功能
		$(window).keydown(function (event) {
			if (event.keyCode == 13){
				checkLogin();
			}
		})


	})

	function checkLogin() {
		// 获取登录验证的账号和密码 要先判断非空

		var loginAct = $.trim($("#loginAct").val());
		var loginPwd = $.trim($("#loginPwd").val());

		if (loginAct === "" || loginPwd === ""){
			$("#msg").html("账号或密码为空")
			// 账号密码为空 停止方法执行
			return false;
		}
		// 去后台验证
		$.ajax({
			url:"settings/user/login.do",
			data:{
				"loginAct":loginAct,
				"loginPwd":loginPwd
			},
			dataType:"json",
			type:"post",
			success:function (data) {
				alert("222");
				/*
					后台一共提供两个参数
					success: true / false 成功/失败
					msg: 出错时哪里错了的提示信息
				*/
				// 成功
				if (data.success){
					window.location.href("workbench/index.html");
				// 失败
				}
			}
		})


	}


</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="用户名" id="loginAct">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="密码" id="loginPwd">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: red">${msg}</span>
						
					</div>
<%--					类型为submit默认为表单提供提交作用--%>
					<button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>