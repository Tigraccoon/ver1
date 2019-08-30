<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 읽기</title>
	<%@ include file="../include/header.jsp" %>
<script type="text/javascript">

$(function(){
	var errorcheck = '${message}';
	
	if(errorcheck == 'pwderror'){
		alert('비밀번호 오류입니다. 다시 확인해주세요.');
	}
});

function inputcheck(){
	var b_pwd = $("#b_pwd");
	
	if(b_pwd.val() == "") {
		alert('비밀번호를 입력하세요.');
		b_pwd.focus();
		return;
	} else {
		document.updategoform.submit();
	}
}

</script>
</head>
<body>

<div class="container-fluid">
	<div class="row justify-content-center">
		<div class="col col-10">
<table class="table table-bordered"  style="width: 100%;">
	<tr class="table-primary" style="text-align: center;">
		<th width="10%">글번호</th>	
		<th width="40%">제목</th>
		<th width="20%">작성자</th>
		<th width="10%">조회수</th>
		<th width="20%">날짜</th>
	</tr>
	<tr class="table-primary" style="text-align: center;">
		<td width="10%">${var.idx }</td>	
		<td width="40%"><b>${var.b_subject }</b></td>
		<td width="20%">${var.b_writer }</td>
		<td width="10%">${var.b_readcount }</td>
		<td width="20%"><fmt:formatDate value="${var.b_date }" pattern="yyyy-MM-dd hh:mm:ss E"/></td>
	</tr>
	<tr class="table-primary">
		<td colspan="5" height="1500%">${var.b_content }<br><br><br><br><br><br><br></td>
	</tr>
	<tr class="table-primary" style="text-align: center;">
		<td colspan="5">
			<button type="button" class="btn btn-primary btn-block" data-toggle="modal" data-target="#boardupdate">
  				수정
			</button><br>
			<a href="${path }/board/boardlist.do" class="btn btn-info btn-block">리스트</a>
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
			<input name="b_pwd" id="b_pwd" class="form-control" type="password">
			<br>
			<input type="hidden" name="b_writer" id="b_writer" value="${var.b_writer }">
      		<input type="hidden" name="b_num" id="b_num" value="${var.b_num }">
		</td>
	</tr>
	<tr class="table-success">
		<td colspan="2">
			<input type="button" class="btn btn-primary" value="수정/삭제" onclick="inputcheck()">
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