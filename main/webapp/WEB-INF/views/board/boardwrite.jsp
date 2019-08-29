<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글쓰기</title>
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
	
	$("#dowrite").click(function(){
		
		var b_writer = $("#b_writer");
		var b_pwd = $("#b_pwd");
		var b_subject = $("#b_subject");
		var b_content = $("#b_content");

		if(b_writer.val() == ""){	
			alert("이름을 입력해주세요!");
			b_writer.focus();	
			return;
		}
		if(b_pwd.val() == ""){	
			alert("비밀번호를 입력해주세요!");
			b_pwd.focus();	
			return;
		}
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
		
		document.writeform.submit();
	});
	
});

</script>
</head>
<body>

<div class="container-fluid">
	<div class="row justify-content-center">
		<div class="col col-10">
<br>
<form action="${path}/board/boardwrite.do" method="post" id="writeform" name="writeform">
<table class="table table-borderless" style="width: 100%; text-align: center;">
	<tr class="table-primary">
		<th colspan="2"><h2>글쓰기</h2></th>
	</tr>
	<tr class="table-primary">
		<th><label for="b_writer">작성자</label></th>
		<td><input type="text" name="b_writer" id="b_writer" class="form-control" required="required" placeholder="이름을 입력하세요."></td>
	</tr>
	<tr class="table-primary">
		<th><label for="b_pwd">비밀번호</label></th>
		<td><input type="password" name="b_pwd" id="b_pwd" class="form-control" required="required" placeholder="비밀번호를 입력하세요."></td>
	</tr>
	<tr class="table-primary">
		<th><label for="b_subject">제목</label></th>
		<td><input type="text" name="b_subject" id="b_subject" class="form-control" placeholder="제목을 입력하세요." required="required"></td>
	</tr>
	<tr class="table-primary">
		<th colspan="2"><label for="b_content">본문</label></th>
	</tr>
	<tr class="table-primary" style="text-align: left;">
		<td colspan="2"><textarea name="b_content" id="b_content" class="form-control" required="required"></textarea></td>
	</tr>
	<tr class="table-primary">
		<td colspan="2">
			<input type="button" value="글쓰기" class="btn btn-block btn-primary" id="dowrite">
		</td>
	</tr>
	<tr class="table-primary">
		<td colspan="2">
			<a href="${path }/board/boardlist.do" class="btn btn-info btn-block">리스트</a>
		</td>
	</tr>
</table>
</form>

		</div>
	</div>
</div>
<br>


</body>
</html>