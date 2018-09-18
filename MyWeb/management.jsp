<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<!DOCTYPE html>
<html style="height: 100%;">
<head>
	<title>管理界面</title>
	<link rel="stylesheet" type="text/css" href="css/management.css">
	<meta charset="utf-8" content="text/html">
</head>

<%

	// 连接数据库
	String connectString = "jdbc:mysql://172.18.187.234:53306/15352013_21_project"
				+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8&&useSSL=false";
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection(connectString, "user", "123");
	Statement statement = conn.createStatement() ;

	// 删除文章
	if ( request.getParameter("userId")!=null ){
		String userId = request.getParameter("userId") ;
		String title = request.getParameter("title");
		String sql = "delete from article where userId='"+userId
					+"' and title='"+title+"'";
		statement.executeUpdate(sql);
		response.sendRedirect("management.jsp") ;
	}
	// 删除评论
	if ( request.getParameter("commentId")!=null){
		String commentId=request.getParameter("commentId") ;
		String sql = "delete from comment where commentId="+commentId;
		statement.executeUpdate(sql);
		response.sendRedirect("management.jsp") ;
	}

	String userList[]=null,articleIdList[][]=null,articleList[][]=null,titleList[][]=null,
		   commentList[][][]=null,commentUserIdList[][][]=null,commentIdList[][][]=null ;
	int cnt=0 ;
	// 查询
	String sql = "SELECT * from user" ;
	ResultSet rs = statement.executeQuery(sql) ;
	rs.last() ;
	userList = new String[rs.getRow()] ;
	articleList = new String[rs.getRow()][] ;
	articleIdList = new String[rs.getRow()][] ;
	titleList = new String[rs.getRow()][] ;
	commentList = new String[rs.getRow()][][] ;
	commentUserIdList = new String[rs.getRow()][][] ;
	commentIdList = new String[rs.getRow()][][] ;

	rs.first() ;
	do{
		userList[cnt++] = rs.getString("userId") ;
	}while( rs.next() );
	for ( int i=0; i<userList.length; i++ ) {
		sql = "SELECT * from article where userId='"+userList[i]+"'" ;
		rs = statement.executeQuery(sql) ;
		rs.last() ;
		articleList[i] = new String[rs.getRow()] ;
		articleIdList[i] = new String[rs.getRow()] ;
		titleList[i] = new String[rs.getRow()] ;
		commentList[i] = new String[rs.getRow()][] ;
		commentUserIdList[i] = new String[rs.getRow()][] ;
		commentIdList[i] = new String[rs.getRow()][] ;
		cnt = 0 ;
		if ( rs.getRow()!=0 ){
			rs.first();
			do{
				articleList[i][cnt++] = rs.getString("content") ;
				titleList[i][cnt-1] = rs.getString("title") ;
				articleIdList[i][cnt-1] = rs.getString("articleId") ;
			}while( rs.next() );
		}
	}
	for ( int i=0 ; i<articleIdList.length ; i++ ){
		for ( int j=0 ; j<articleIdList[i].length ; j++ ){
			sql = "SELECT * from comment where articleId="+articleIdList[i][j] ;
			rs = statement.executeQuery(sql) ;
			rs.last() ;
			commentList[i][j] = new String[rs.getRow()] ;
			commentUserIdList[i][j] = new String[rs.getRow()] ;
			commentIdList[i][j] = new String[rs.getRow()] ;
			cnt=0 ;
			if ( rs.getRow()!=0 ){
				rs.first() ;
				do{
					commentList[i][j][cnt++] = rs.getString("content");
					commentUserIdList[i][j][cnt-1] = rs.getString("userId") ; 
					commentIdList[i][j][cnt-1] = rs.getString("commentId") ; 
				}while ( rs.next() );
			}
		}
	}


	conn.close();


	StringBuilder userDisplay = new StringBuilder() ;
	String userHead="<li><a href=\"#\" class=\"user\">",userTail="</a></li>" ;
	String titleHead="<a href=\"#\" class=\"article\">",titleTail="</a>";
	for ( int i=0; i<userList.length; i++ ){
		userDisplay.append(userHead+userList[i]+userTail);
		userDisplay.append("<ul style=\"display: none;\">");
		for ( int j=0; j<titleList[i].length; j++ )
			userDisplay.append(titleHead+titleList[i][j]+titleTail) ;
		userDisplay.append("</ul>");
		
	}
	StringBuilder contentDisplay = new StringBuilder();
	contentDisplay.append("<div class=\"article-content-out\">") ;
	String contentHead="<p class=\"article-content\" style=\"display: none; white-space: pre-wrap;\" id=\"row";
	String contentTail="</p>";
	for ( int i=0; i<articleList.length; i++) 
		for ( int j=0; j<articleList[i].length; j++) 
			contentDisplay.append(contentHead+i+"col"+j+"\">"+articleList[i][j]+contentTail);
	contentDisplay.append("</div>");

	StringBuilder commentDisplay = new StringBuilder();
	commentDisplay.append("<div class=\"comment-out\">");
	String commentHead = "<p class=\"comment ";
	String commentCenter="\" style=\"display: none;\"><span style=\"white-space: pre-wrap;\">@" ;
	String commentCenterTail="<br>   </span><span class=\"comment-delete\" id=\"commentId" ;
	String commentTail="\">删除</span></p>" ;
	for ( int i=0 ; i<commentList.length; i++ )
		for ( int j=0 ; j<commentList[i].length; j++ )
			for ( int k=0 ; k<commentList[i][j].length; k++ )
				commentDisplay.append(commentHead+"row"+i+"col"+j+commentCenter+
									  commentUserIdList[i][j][k]+":<br>"+commentList[i][j][k]
									  +commentCenterTail+commentIdList[i][j][k]+commentTail);
	commentDisplay.append("</div>");
	
%>
<script type="text/javascript">
	window.onload = function(){
		// 为所有的li设置点击事件
		var ali = document.getElementsByTagName("li") ;
		for ( var i=0; i<ali.length ; i++ ){
			var element = ali[i].nextElementSibling ;
			// console.log(element);
			(function(x,ul){
				ali[x].onclick = function(){
					if ( ul.style.display=="none")
						ul.style.display="block";
					else ul.style.display="none";
					// console.log(ul);
				}
			})(i,element);
		}
		// 为所有的article设置点击事件
		var ali = document.getElementsByTagName("li") ;
		for ( var i=0; i<ali.length ; i++ ){
			var element = ali[i].nextElementSibling.getElementsByClassName("article");
			for (var j = 0; j < element.length; j++) {
				(function (x,y,element) {
					element.onclick = function() {
						// console.log(x+" "+y);
						var all = document.getElementsByClassName("article-content") ;
						for (var i = 0; i < all.length; i++)
							all[i].style.display = "none";
						var allComment = document.getElementsByClassName("comment");
						for (var i = 0; i < allComment.length; i++)
							allComment[i].style.display = "none";
						
						var article = document.getElementById("row"+x+"col"+y) ;
						// console.log(article);
						article.style.display="block";

						var comment = document.getElementsByClassName("row"+x+"col"+y) ;
						// console.log(comment);
						for ( var i=0 ; i<comment.length; i++ )
							comment[i].style.display="block";

						document.getElementById("title").innerText = element.innerText;
					}
				})(i,j,element[j])
			}
		}
		// 删除键点击事件
		var userList = new Array();
		var titleList = new Array();
		<% for (int i = 0; i < userList.length; i++) { %> 
			userList[<%=i%>]="<%=userList[i]%>";
			titleList[<%=i%>]=new Array();
			<% for (int j = 0; j < titleList[i].length; j++) { %>
				titleList[<%=i%>][<%=j%>]="<%=titleList[i][j]%>";
			<% } %>
		<% } %> 
		var del = document.getElementById("delete");
		del.onclick = function () {
			var all = document.getElementsByClassName("article-content") ;
			var userId,title ;
			// console.log(all);
			for (var i = 0; i < all.length; i++)
				if ( all[i].style.display=="block" ){
					// console.log(all[i]) ;
					var id = all[i].id.split("row")[1].split("col");
					userId = userList[id[0]];
					title = titleList[id[0]][id[1]];
				}
			window.location.href="management.jsp?userId="+userId+"&title="+title ;
		}
		var del_comment = document.getElementsByClassName("comment-delete") ;
		for (var i = 0; i < del_comment.length; i++) {
			(function (element) {
				element.onclick = function () {
					window.location.href="management.jsp?commentId="+element.id.split("commentId")[1] ;
				}
			})(del_comment[i])
		}


	} 
	
</script>
<body style="height: 100%; margin:0;" >
	<div class="background">
		<div class="navbar">
			<div class="navbar-inner">
				<a class="brand" href="management.jsp">Administrator</a>
				<a class="logout" href="index.jsp">Logout</a>
			</div>
		</div>
		<div class="left">
			<div class="left-top">
				用户名
			</div>
			<%=userDisplay%>
			<!-- <li><a href="#" class="user">15352005</a></li>
				<ul style="display: none;">
					<a href="#" class="article">小短文</a>
					<a href="#" class="article">难念的经</a>
				</ul>
				
			<li><a href="#" class="user">15352013</a></li>
				<ul style="display: none;">
					<a href="#" class="article">安卓怎么做</a>
					<a href="#" class="article">为什么说AI是未来的趋势</a>
				</ul>
			-->
		</div>
		<div class="right">
			<div class="right-top">
				<div class="right-content">
					<span id="title">文章内容</span>
					<span class="delete" id="delete">删除</span>
				</div>

			</div>
			
			<div class="right-body">
				<%=contentDisplay%>
				<!-- <div class="article-content-out">
	 				<p class="article-content" style="display: none; white-space: pre-wrap;" id="row0col1">文章内容</p>
	 			</div> -->
	 			<%=commentDisplay%>

				<!-- <div class="comment-out">
					<p class="comment row0col1" style="display: none;">
						<span style="white-space: pre-wrap;">@15352013：<br>    欧，我的天，瞧瞧这个优秀答案，我亲爱的上帝，这是汤姆斯.陈独秀先生的奖杯，是谁把它拿到这儿来的。来，我亲爱的汤姆斯，这是你的，摸它之前记得用蒂花之秀洗手液，这会让您显得庄重一些，如果您觉得不够，还可以来个橘子！</span>
						<span class="comment-delete" id="comment-delete id4">删除</span>
					</p>
					<p class="comment row3col1" style="display: none;">
						<span>@15352005：
							是寂寞刚好遇见了
							还是的确被吸引了
							无法回答这个问题
							就最好不要开始吧
							自己足够好了吗
							忧愁可以消化吗
						开心可以继续吗</span>
						<span class="comment-delete" id="comment-delete id5">删除</span>
					</p>
				</div> -->
			</div>
			
			
		</div>
	</div>
</body>
</html>


