<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 읽기</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.12/summernote-bs4.css" rel="stylesheet">
	<%@ include file="../include/header.jsp" %>
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.12/summernote-bs4.js"></script>
    <script src="${path }/include/summernote/lang/summernote-ko-KR.js"></script>
    
    <script type="text/javascript">
$(document).ready(function() {
	$('#b_content').summernote({
		placeholder: '본문을 입력하세요.',
		height : 500, 
	    minHeight : null,
	    maxHeight : null,
		lang : 'ko-KR'
	});
	
	$("#btnUpdate").click(function(){
		
		var b_subject = $("#b_subject");
		var b_content = $("#b_content");

		if(b_subject.val() == ""){	
			alert("제목을 입력해주세요!");
			b_subject.focus();	
			return;
		}
		if(b_content.val() == ""){	
			alert("내용을 입력해주세요!");
			b_content.focus();	
			return;
		}
		
		document.updateform.action="${path}/board/boardupdate.do";
		document.updateform.submit();
	});
	
	$("#btnDelete").click(function(){
		
		if(confirm("정말 삭제하시겠습니까?")==true){
			
			document.updateform.action="${path}/board/boarddelete.do";
			document.updateform.submit();
		} else{
			return;
		}
	});
	
	
});

</script>
</head>
<body>

<div class="container-fluid">
	<div class="row justify-content-center">
		<div class="col col-10">
<table class="table table-bordered"  style="width: 100%;">
	<tr class="table-primary" style="text-align: center;">
		<td width="25%">${var.b_num }</td>	
		<td width="50%">${var.b_subject }</td>
		<td width="25%">${var.b_writer }</td>
	</tr>
	<tr class="table-primary" style="text-align: center;">
		<td width="25%">조회수&nbsp;&nbsp;${var.b_readcount }</td>
		<td width="25%"><fmt:formatDate value="${var.b_date }" pattern="yyyy-MM-dd hh:mm:ss E"/></td>
	</tr>
	<tr class="table-primary">
		<td colspan="3" height="500%">${var.b_content }</td>
	</tr>
	<tr class="table-primary" style="text-align: center;">
		<td colspan="3">
			<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#boardupdate">
  				수정
			</button>
			<a href="${path }/board/boardlist.do" class="btn btn-info">리스트</a>
		</td>
	</tr>
</table>

		</div>
	</div>
</div>

</body>
</html>