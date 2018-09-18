<%@ page language="java" import="java.util.*,java.sql.*" 
		contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html  lang="zh">
<head>
	<meta charset="UTF-8">
	<title>我是个人信息界面</title>
</head>
<%
	request.setCharacterEncoding("utf-8");
	String name = request.getParameter("user_name") ;
	name = java.net.URLDecoder.decode(name,"utf-8") ;

%>

<body>
	<h1>我是个人信息界面</h1>
	<p><%=name%></p>
</body>
</html>