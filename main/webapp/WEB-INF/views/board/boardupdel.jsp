<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수정/삭제</title>
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

function spacebarcheck(istherespacebar) {
	
	var text = istherespacebar.val();
	
	if(text.search(' ') != -1){
		istherespacebar.val(text.replace(/ /gi, ''));
		alert("공백은 입력할 수 없습니다.");
	}
	
}

function textlengthcheck(target, maxlength, str) {
	
	var value = target.val();
	value = value.substring(0, maxlength);
	
	var valueleng = value.length;
	target.val(value);
	
	if(valueleng > maxlength) {
		str.css("color", "red");
		
		str.text('(' + valueleng + '/' + maxlength + ')')
		
	} else if(valueleng == maxlength) {
		str.css("color", "red");
		str.text('(' + valueleng + '/' + maxlength + ')')
	} else {
		str.css("color", "black");
		str.text('(' + valueleng + '/' + maxlength + ')')
	}
	
}

function subjectcheck(subject) {
	
	var subjectstr = subject.val();
	
	while(subjectstr.startsWith(' ')){
		subjectstr = subjectstr.substring(1);
	}
	
	while(subjectstr.endsWith(' ')){
		subjectstr = subjectstr.substring(0, subjectstr.length-1);
	}
	
	subject.val(subjectstr);
}

</script>
</head>
<body>

<div class="container-fluid">
	<div class="row justify-content-center">
		<div class="col col-10">
<br>
<form action="${path}/board/boardwrite.do" method="post" id="updateform" name="updateform">
<table class="table table-borderless" style="width: 100%; text-align: center;">
	<tr class="table-primary">
		<th colspan="3"><h2>글 수정/삭제</h2></th>
	</tr>
	<tr class="table-primary">
		<th><label for="b_writer">작성자</label></th>
		<td>
			<input type="text" name="b_writer" id="b_writer" class="form-control" required="required" placeholder="이름을 입력하세요."
			value="${var.b_writer }" oninput="spacebarcheck($('#b_writer')); textlengthcheck($('#b_writer'), 15, $('#writernum'));">
		</td>
		<td width="5%" id="writernum">(0/15)</td>
	</tr>
	<tr class="table-primary">
		<th><label for="b_pwd">비밀번호</label></th>
		<td>
			<input type="password" name="b_pwd" id="b_pwd" class="form-control" required="required" placeholder="비밀번호를 입력하세요."
			oninput="spacebarcheck($('#b_pwd')); textlengthcheck($('#b_pwd'), 20, $('#pwdnum'));">
		</td>
		<td width="5%" id="pwdnum">(0/20)</td>
	</tr>
	<tr class="table-primary">
		<th><label for="b_subject">제목</label></th>
		<td>
			<input type="text" name="b_subject" id="b_subject" class="form-control" placeholder="제목을 입력하세요." required="required" 
			value="${var.b_subject }" oninput="textlengthcheck($('#b_subject'), 50, $('#subjectnum'));"
			onfocusout="subjectcheck($('#b_subject')); textlengthcheck($('#b_subject'), 50, $('#subjectnum'));">
		</td>
		<td width="5%" id="subjectnum">(0/50)</td>
	</tr>
	<tr class="table-primary">
		<th colspan="3"><label for="b_content">본문</label></th>
	</tr>
	<tr class="table-primary" style="text-align: left;">
		<td colspan="3"><textarea name="b_content" id="b_content" class="form-control" required="required">${var.b_content }</textarea></td>
	</tr>
	<tr class="table-primary">
		<td colspan="3">
			<input type="button" value="수정" class="btn btn-block btn-primary" id="btnUpdate"><br>
			<input type="button" value="삭제" class="btn btn-block btn-danger" id="btnDelete">
			<input type="hidden" value="${var.b_num }" name="b_num" id="b_num">
		</td>
	</tr>
	<tr class="table-primary">
		<td colspan="3">
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