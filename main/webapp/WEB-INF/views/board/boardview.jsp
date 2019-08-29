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
		<td width="10%">${var.b_num }</td>	
		<td width="40%"><b>${var.b_subject }</b></td>
		<td width="20%">${var.b_writer }</td>
		<td width="10%">조회수&nbsp;&nbsp;${var.b_readcount }</td>
		<td width="20%"><fmt:formatDate value="${var.b_date }" pattern="yyyy-MM-dd hh:mm:ss E"/></td>
	</tr>
	<tr class="table-primary">
		<td colspan="5" height="1500%">${var.b_content }<br><br><br><br><br><br><br></td>
	</tr>
	<tr class="table-primary" style="text-align: center;">
		<td colspan="5">
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

<form action="${path}/board/b_update.go" method="post" id="updategoform" name="updategoform">
<div class="container-fluid">
  <div class="row justify-content-center">
	<div class="col col-10">
<div class="modal fade" id="boardupdate" tabindex="-1" role="dialog" aria-labelledby="boardupdateLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="boardupdateLabel">비밀번호 확인</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
  <table class="table" style="width: 100%; text-align: left;">
	<tr class="table-success">
		<th width="30%"><label for="b_pwd">비밀번호</label></th>
		<td width="70%">
			<input name="b_pwd" id="b_pwd" class="form-control">
			<br>
			<input type="hidden" name="b_writer" id="b_writer" value="${var.b_writer }">
      		<input type="hidden" name="b_num" id="b_num" value="${var.b_num }">
		</td>
	</tr>
	<tr class="table-success">
		<td colspan="2">
			<input type="submit" class="btn btn-primary" value="수정">
			<button type="button" class="btn btn-danger" data-dismiss="modal">닫기</button>
		</td>
	</tr>
  </table>
      </div>
    </div>
  </div>
</div>

		</div>
	</div>
</div>
</form>

</body>
</html>