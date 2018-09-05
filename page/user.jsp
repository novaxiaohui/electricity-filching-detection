<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    
    <title>My JSP 'index.jsp' starting page</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	

<%@ include file="/page/common_import.jsp"%>  
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
  </head>
  <body>
  <div style="padding:50px;">
    <input id="user" type="text" style="width:300px;" />
    <button onclick="generate()">生成</button>
    
  </div>
    <script>
    	function generate(){
    	 var user = $("#user").val();
    	 $("#user").val(($.md5(user)).toUpperCase());
    	}
    </script>
  </body>
</html>
