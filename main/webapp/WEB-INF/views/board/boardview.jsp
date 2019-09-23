<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 읽기</title>
	<%@ include file="../include/header.jsp" %>
<style type="text/css">
#cont {
	width:1620px;
}
</style>
<script type="text/javascript">

$(function(){
	var screenwidth = (screen.width-500)+"px";
	
	document.getElementById('cont').style.width = screenwidth;
	
	var errorcheck = '${message}';
	if(errorcheck == 'pwderror'){
		document.getElementById('cont').style.width = screenwidth;
		
		$("#boardupdate").modal('show');
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

function spacebarcheck(istherespacebar) {
	var text = istherespacebar.val();
	
	if(text.search(' ') != -1){
		istherespacebar.val(text.replace(/ /gi, ''));
		alert("공백은 입력할 수 없습니다.");
	}
	
}

function pwdcheck(target){
	var pt = /^.*(?=^.{6,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/gi;
	var val = target.val();

	if(!pt.test(val)){
		alert("비밀번호는 영문, 숫자, 특수문자의 조합으로 6자 이상 입력되어야 합니다!");
		setTimeout(function(){
		target.focus();
		}, 10);
		return;
	}
}

function pwdlengthcheck(target, maxlength, str) {

	var value = target.val();
	value = value.substring(0, maxlength);
	
	var valueleng = value.length;
	target.val(value);
	
	var pt = /^.*(?=^.{6,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/gi;
	
	if(!pt.test(value)){
		str.css("color", "red");
		str.text('(' + valueleng + '/' + maxlength + ')');
		
	} else if(valueleng == 0){
		str.css("color", "black");
		str.text('(' + valueleng + '/' + maxlength + ')');
	} else {
		str.css("color", "blue");
		str.text('(' + valueleng + '/' + maxlength + ')');
	}
	
}

function fn_filedown(b_num){
	window.open('${path}/board/filedown.do?b_num='+b_num,'#');
}

</script>
</head>
<body>

<div class="container-fluid">
	<div class="row justify-content-center">
		<div class="col col-10">
<table class="table table-bordered">
	<tr class="table-primary" style="text-align: center;">
		<th width="50%">제목</th>
		<th width="20%">작성자</th>
		<th width="10%">조회수</th>
		<th width="20%">날짜</th>
	</tr>
	<tr class="table-primary" style="text-align: center;">
		<td width="50%"><b>${var.b_subject }</b></td>
		<td width="20%">${var.b_writer }</td>
		<td width="10%">${var.b_readcount }</td>
		<td width="20%"><fmt:formatDate value="${var.b_date }" pattern="yyyy-MM-dd hh:mm:ss E"/></td>
	</tr>
	<tr class="table-primary">
		<td colspan="4" height="1500%">
			<div id="cont" style="white-space: normal; word-wrap: break-word;">${var.b_content }
			<br><br><br><br><br><br><br>
			<c:if test="${var.b_filename != null }">
			첨부파일  :  ${var.b_filename } 
			(<fmt:formatNumber pattern="#,###" value="${var.b_filesize }"/> KB) 
			<button class="btn btn-outline-secondary" onclick="fn_filedown('${var.b_num}')">다운받기</button>
			</c:if>
			</div>
		</td>
	</tr>
	<tr class="table-primary" style="text-align: center;">
		<td colspan="4">
			<button type="button" class="btn btn-primary btn-block" data-toggle="modal" data-target="#boardupdate">
  				수정/삭제
			</button><br>
			<a href="${path }/board/boardreple.go?b_num=${var.b_num}" class="btn btn-success btn-block">답글달기</a>
			<br>
			<a href="${path }/board/boardlist.do" class="btn btn-info btn-block">리스트</a>
			
		</td>
	</tr>
</table>

<!-- 댓글쓰기 -->
<br><hr><br>
<form action="${path }/board/c_insert.do" method="post" id="commentInsertform" name="commentInsertform">
	<table class="table" style="width: 100%; text-align: left;">
		<tr class="table-success">
			<th colspan="3">댓글쓰기</th>
		</tr>
		<tr class="table-success">
			<td>
				<label for="c_writer">이름</label><br>
				<div class="input-group">
					<input name="c_writer" id="c_writer" class="form-control" required="required" 
					placeholder="이름을 입력하세요" aria-describedby="basic-addon1"
					oninput="spacebarcheck($('#c_writer')); textlengthcheck($('#c_writer'), 15, $('#basic-addon1'));">
				  	<div class="input-group-append" style="width: 200px">
				    	<span class="input-group-text" id="basic-addon1" style="width: 90px">(0/15)</span>
				  	</div>
				</div>
			</td>
			<td>
				<label for="c_pwd">비밀번호</label><br>
				<div class="input-group">
					<input type="password" name="c_pwd" id="c_pwd" class="form-control" required="required" 
					placeholder="비밀번호를 입력하세요" aria-describedby="basic-addon2"
					oninput="spacebarcheck($('#c_pwd')); pwdlengthcheck($('#c_pwd'), 20, $('#basic-addon2'));"
					onblur="pwdcheck($('#c_pwd'));">
				  	<div class="input-group-append" style="width: 200px">
				    	<span class="input-group-text" id="basic-addon2" style="width: 90px">(0/20)</span>
				  	</div>
				</div>
			</td>			
			<th style="text-align: center;" rowspan="2">
			<br>
				<input type="hidden" name="b_num" id="b_num" value="${var.b_num }"><br><br>
				<input type="submit" id="btnCommentInsert" class="btn btn-block btn-primary" value="확인">
				<br><br>
			</th>
		</tr>
		<tr class="table-success">
			<td colspan="2">
			<div class="input-group">
				<textarea rows="3" cols="80" placeholder="댓글을 입력하세요" id="c_content" class="form-control" 
				name="c_content" required="required" aria-describedby="basic-addon3"
				oninput="textlengthcheck($('#c_content'), 200, $('#basic-addon3'));"></textarea>
			  	<div class="input-group-append" style="width: 200px">
			    	<span class="input-group-text" id="basic-addon3" style="width: 90px">(0/200)</span>
			  	</div>
			</div>
			</td>
		</tr>
	</table>
</form>
<br><hr><br>

<table class="table" style="width: 100%; text-align: left; caption-side: top;">
<caption style="text-align: right; caption-side: top;">${c_count } 개의 댓글이 있습니다.</caption>
	<tr class="table-primary">
		<th colspan="2">댓글</th>
	</tr>
	
<!-- 댓글이 없을때 -->
<c:if test="${c_count == 0 }">
	<tr class="table-primary">
		<th colspan="2">댓글이 없습니다.</th>
	</tr>
</c:if>
	
<!-- 댓글이 있을때 -->
<c:if test="${c_count > 0}">
	
<c:forEach items="${war }" var="war">
<!-- 일반 댓글 -->
 <c:if test="${war.c_show == 'Y' && war.c_secret == 'N' }">
 <tr class="table-primary">
		<td>
			<b><c:out value="${war.c_writer }"/></b>&emsp;&emsp;&emsp;
			<i>(<fmt:formatDate value="${war.c_date }" pattern="yyyy-MM-dd hh:mm:ss E"/>)</i>
			<br>
			<div id="ccont" style="white-space: normal; word-wrap: break-word; width: 900px;">
				${war.c_content }
			</div>
		</td>
		<td>
		<div class="input-group" style="width: 300px;">
		  <input type="password" class="form-control" id="cpwd${war.c_num }" placeholder="비밀번호" aria-describedby="button-addon${war.c_num }">
		  <div class="input-group-append">
		    <button class="btn btn-outline-success" type="button" id="button-addon${war.c_num }" 
		    onclick="
			    if('${war.c_pwd}' != $('#cpwd'+'${war.c_num }').val()){
			    	alert('비밀번호가 다릅니다.');
			    	$('#cpwd'+'${war.c_num }').focus();
			    } else{
			    	$('#cpwd'+'${war.c_num }').val('');
			    	$('#commentupdate'+'${war.c_num}').modal('show');
			    	textlengthcheck($('#c_writer'+'${war.c_num }'), 15, $('#m-name'+'${war.c_num }'));
			    	pwdlengthcheck($('#c_pwd'+'${war.c_num }'), 20, $('#m-pwd'+'${war.c_num }'));
			    	textlengthcheck($('#c_content'+'${war.c_num }'), 200, $('#m-content'+'${war.c_num }'));
			    }
		    ">수정/삭제</button>
		  </div>
		</div>
		</td>
	</tr>
 </c:if>
 </c:forEach>
 </c:if>
 </table>

		</div>
	</div>
</div>

<!-- 댓글 수정 모달 -->

<c:forEach items="${war }" var="mo">

<form action="${path}/board/c_update.do" method="post" id="commentupdateform" name="commentupdateform">
<div class="container-fluid">
  <div class="row justify-content-center">
	<div class="col col-10">
<div class="modal fade bd-example-modal-xl" id="commentupdate${mo.c_num}" tabindex="-1" role="dialog" aria-labelledby="commentupdateLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="commentupdateLabel">댓글 수정/삭제</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
  <table class="table" style="width: 100%; text-align: left;">
	<tr class="table-success">
		<td width="100%">
			<label for="c_writer">이름</label><br>
			<div class="input-group">
				<input name="c_writer" id="c_writer${mo.c_num }" value="${mo.c_writer }" class="form-control" required="required" 
				placeholder="이름을 입력하세요" aria-describedby="m-name${mo.c_num }"
				oninput="spacebarcheck($('#c_writer'+'${mo.c_num }')); 
				textlengthcheck($('#c_writer'+'${mo.c_num }'), 15, $('#m-name'+'${mo.c_num }'));"
				onfocus="textlengthcheck($('#c_writer'+'${mo.c_num }'), 15, $('#m-name'+'${mo.c_num }'));">
			  	<div class="input-group-append">
			    	<span class="input-group-text" id="m-name${mo.c_num }" style="width: 90px">(0/15)</span>
			  	</div>
			</div>
			<br>
			<input type="hidden" name="c_num" id="c_num${mo.c_num}" value="${mo.c_num }">
      		<input type="hidden" name="b_num" id="b_num${mo.c_num}" value="${var.b_num }">
		</td>
	</tr>
	<tr class="table-success">
		<td>
			<label for="c_pwd">비밀번호</label><br>
			<div class="input-group">
				<input type="password" name="c_pwd" id="c_pwd${mo.c_num }" class="form-control" required="required" 
				placeholder="비밀번호를 입력하세요" aria-describedby="m-pwd${mo.c_num }" value="${mo.c_pwd }"
				oninput="spacebarcheck($('#c_pwd'+'${mo.c_num }')); 
				pwdlengthcheck($('#c_pwd'+'${mo.c_num }'), 20, $('#m-pwd'+'${mo.c_num }'));"
				onblur="pwdcheck($('#c_pwd'+'${mo.c_num }'));" 
				onfocus="pwdlengthcheck($('#c_pwd'+'${mo.c_num }'), 20, $('#m-pwd'+'${mo.c_num }'));">
			  	<div class="input-group-append">
			    	<span class="input-group-text" id="m-pwd${mo.c_num }" style="width: 90px">(0/20)</span>
			  	</div>
			</div>
		</td>
	</tr>
	<tr class="table-success">
		<td>
			<div class="input-group">
				<textarea rows="3" cols="80" placeholder="댓글을 입력하세요" id="c_content${mo.c_num }" class="form-control" 
				name="c_content" required="required" aria-describedby="m-content${mo.c_num }"
				oninput="textlengthcheck($('#c_content'+'${mo.c_num }'), 200, $('#m-content'+'${mo.c_num }'));"
				onfocus="textlengthcheck($('#c_content'+'${mo.c_num }'), 200, $('#m-content'+'${mo.c_num }'));"><c:out value="${mo.c_content }"/></textarea>
			  	<div class="input-group-append">
			    	<span class="input-group-text" id="m-content${mo.c_num }" style="width: 90px">(0/200)</span>
			  	</div>
			</div>
		</td>
	</tr>
  </table>
      </div>
      <div class="modal-footer">
      	<input type="submit" id="btnCommentUpdate${mo.c_num}" value="수정" class="btn btn-primary">
      	<a href="${path}/board/c_delete.do?c_num=${mo.c_num}&b_num=${mo.b_num}" class="btn btn-danger"> 삭제</a>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

	</div>
  </div>
</div>
</form>
</c:forEach>



<!-- 글 수정용 비밀번호 확인 모달 -->
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
		<td width="65%">
			<input name="b_pwd" id="b_pwd" class="form-control" type="password" value="${pwd }"
				oninput="spacebarcheck($('#b_pwd')); textlengthcheck($('#b_pwd'), 20, $('#pwdnum'));">
			<br>
			<input type="hidden" name="b_writer" id="b_writer" value="${var.b_writer }">
      		<input type="hidden" name="b_num" id="b_num" value="${var.b_num }">
		</td>
		<td width="5%" id="pwdnum">(0/20)</td>
	</tr>
	<tr class="table-success">
		<td colspan="3">
			<input type="button" class="btn btn-primary btn-block" value="수정/삭제" onclick="inputcheck()"><br>
			<button type="button" class="btn btn-danger btn-block" data-dismiss="modal">닫기</button>
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