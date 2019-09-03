<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ page session="true"%>
<!-- views/include/header.jsp -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="path" value="${pageContext.request.contextPath}"/>

<script src="${path}/include/js/jquery-3.3.1.min.js"></script>
<script src="${path}/include/js/bootstrap.min.js"></script>
<script src="${path}/include/js/bootstrap.bundle.min.js"></script>

<meta charset="utf-8">

  <title>게시판</title>

  <!-- Bootstrap CSS -->
  <link rel="stylesheet" type="text/css" href="${path}/include/css/bootstrap.min.css">

  <!-- icon -->
  <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
  