<%@ page language="java" import="java.util.*,java.sql.*" 
		contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!doctype html>
<html lang="zh">
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" type="text/css" href="css/root.css">
	<title>管理员登录</title>
</head>
<%
	// 设置编码格式
	request.setCharacterEncoding("utf-8");
	boolean Hint=false ;
	if ( request.getParameter("login")!=null ){

		String userId = request.getParameter("userId");
		String pass = request.getParameter("pass") ;
		
		if ( !userId.equals("admin") || !pass.equals("123") ){
			Hint = true ;
			%>
				<style  type="text/css">
					.root_form input::-webkit-input-placeholder{color: red;font-weight: 1000;}
					.root_form input:-moz-placeholder{color: red;font-weight: 1000;}
					.root_form input::-moz-placeholder{color: red;font-weight: 1000;}
					.root_form input:-ms-input-placeholder{color: red;font-weight: 1000;}
				</style>
			<%
		}
		else response.sendRedirect("management.jsp");  
	}
	
%>


<body>
	<div class="htmleaf-container">
		<div class="root_wrapper">
			<div class="root_container">
				<h1>管理员登录</h1>
				
				<form class="root_form" action="root.jsp" method="post">
					<input type="text" id="root_userId" name="userId" placeholder=
						<%=Hint==true?"你不是管理员！":"请输入用户名"%>
					>
					<input type="password" id="root_pass" name="pass" placeholder=
						<%=Hint==true?"哼！放弃吧":"请输入密码"%>
					>
					<button type="submit" id="root_login-button" name="login">登录</button>
				</form>
			</div>
			<ul class="root_bg-bubbles">
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
			</ul>
		</div>
	</div>
</body>
</html>
