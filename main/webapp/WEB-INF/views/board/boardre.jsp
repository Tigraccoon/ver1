<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>답글쓰기</title>
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
	registerSummernote($('#b_content'), '본문을 입력하세요.', 2000, function(max) {
	    $('#maxContentPost').text(max)
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

function registerSummernote(element, placeholder, max, callbackMax) {
    $(element).summernote({
      height : 500,
      width : $("#writetable").width(),
      lang : 'ko-KR',
      placeholder,
      callbacks: {
        onKeydown: function(e) {
          var t = e.currentTarget.innerHTML;
            t = t.replace(/<br>/gi, '1');
    		t = t.replace(/&nbsp;/gi, '1');
    		t = t.replace(/&gt;/gi, '1');
    		t = t.replace(/&lt;/gi, '1');
      		t = t.replace(/(<([^>]+)>)/gi, '');
          if (t.length >= max) {

        	var key = e.keyCode;
            var allowed_keys = [8, 37, 38, 39, 40, 46];
            if ($.inArray(key, allowed_keys) == -1)
              e.preventDefault();
          }
        },
        onKeyup: function(e) {
          var t = e.currentTarget.innerHTML;
          	t = t.replace(/<br>/gi, '1');
      		t = t.replace(/&nbsp;/gi, '1');
      		t = t.replace(/&gt;/gi, '1');
      		t = t.replace(/&lt;/gi, '1');
      		t = t.replace(/(<([^>]+)>)/gi, '');
          if (typeof callbackMax == 'function') {
            callbackMax(max - t.length);
          }
        },
        onPaste: function(e) {
          var t = e.currentTarget.innerHTML;
          	t = t.replace(/<br>/gi, '1');
    		t = t.replace(/&nbsp;/gi, '1');
    		t = t.replace(/&gt;/gi, '1');
    		t = t.replace(/&lt;/gi, '1');
    		t = t.replace(/(<([^>]+)>)/gi, '');
    		
          var bufferText = ((e.originalEvent || e).clipboardData || window.clipboardData).getData('Text');
          e.preventDefault();
          
          if(t.length == 1){
        	  document.execCommand('insertText', false, bufferText.substring(0, 2000));
          } else if(t.length < 2000){
        	  document.execCommand('insertText', false, bufferText.substring(0, (2000-t.length)));
          } else {
        	  return;
          }

          if (typeof callbackMax == 'function') {
            callbackMax(max - t.length);
          }
        },
        onChange: function(contents){
        	var txt = contents;
          	var maxleng = 2000;
          	txt = txt.replace(/<br>/gi, '1');
        	txt = txt.replace(/&nbsp;/gi, '1');
        	txt = txt.replace(/&gt;/gi, '1');
        	txt = txt.replace(/&lt;/gi, '1');
        	txt = txt.replace(/(<([^>]+)>)/gi, '');
          	var txtlength = txt.length;

          	var tstr = $("#contentnum");
          	
          	if(txtlength >= maxleng){
          		tstr.css("color", "red");
        		tstr.text('(' + txtlength + '/' + maxleng + ')');
          	} else if (txtlength == 0){
          		tstr.css("color", "black");
        		tstr.text('(' + txtlength + '/' + maxleng + ')');
          	} else {
          		tstr.css("color", "blue");
        		tstr.text('(' + txtlength + '/' + maxleng + ')');
          	}
          		
        }
      }
    });
  }

function spacebarcheck(istherespacebar) {
	
	var text = istherespacebar.val();
	
	if(text.search(' ') != -1){
		istherespacebar.val(text.replace(/\s/gi, ''));
		alert("공백은 입력할 수 없습니다.");
	}
	
}

function textlengthcheck(target, maxlength, str) {

	var value = target.val();
	value = value.substring(0, maxlength);
	
	var valueleng = value.length;
	target.val(value);
	
	if(valueleng >= maxlength) {
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

</script>
</head>
<body>

<div class="container-fluid">
	<div class="row justify-content-center">
		<div class="col col-10">
<br>
<form action="${path}/board/boardrewrite.do" method="post" id="writeform" name="writeform" enctype="multipart/form-data">
<table class="table table-borderless" style="width: 100%; text-align: center;" id="writetable">
	<tr class="table-primary">
		<th colspan="3"><h2>답글쓰기</h2></th>
	</tr>
	<tr class="table-primary">
		<th colspan="3">
			<button class="btn btn-outline-secondary btn-block" data-toggle="modal" data-target="#exampleModal">
		    	원본글 보기/닫기
		  	</button>
	  	</th>
  	</tr>
  	
	<tr class="table-primary">
		<th><label for="b_writer">작성자</label></th>
		<td>
			<input type="text" name="b_writer" id="b_writer" class="form-control" required="required" 
			placeholder="이름을 입력하세요." 
			oninput="spacebarcheck($('#b_writer')); textlengthcheck($('#b_writer'), 15, $('#writernum'));">
		</td>
		<td width="150px" id="writernum">(0/15)</td>
	</tr>
	<tr class="table-primary">
		<th><label for="b_pwd">비밀번호</label></th>
		<td>
			<input type="password" name="b_pwd" id="b_pwd" class="form-control" required="required" 
			placeholder="비밀번호를 입력하세요. 영문, 숫자, 특수문자로 6자 이상 입력되어야 합니다." 
			oninput="spacebarcheck($('#b_pwd')); pwdlengthcheck($('#b_pwd'), 20, $('#pwdnum'));"
			onblur="pwdcheck($('#b_pwd'));">
		</td>
		<td width="150px" id="pwdnum">(0/20)</td>
	</tr>
	<tr class="table-primary">
		<th><label for="b_subject">제목</label></th>
		<td>
			<input type="text" name="b_subject" id="b_subject" class="form-control" required="required"
			placeholder="제목을 입력하세요." 
			oninput="textlengthcheck($('#b_subject'), 50, $('#subjectnum'));"
			onblur="subjectcheck($('#b_subject')); textlengthcheck($('#b_subject'), 50, $('#subjectnum'));">
		</td>
		<td width="150px" id="subjectnum">(0/50)</td>
	</tr>
	<tr class="table-primary">
		<th><label for="b_file">파일</label></th>
		<td>
			<input type="file" class="form-control-file" id="b_file" name="b_file"
			onchange="filesizecheck(this, $('#filesize'));">
		</td>
		<td width="150px" id="filesize">(0 MB/10 MB)</td>
	</tr>
	<tr class="table-primary">
		<th colspan="2"><label for="b_content">본문</label></th>
		<td width="150px" id="contentnum">(0/2000)</td>
	</tr>
	<tr class="table-primary" style="text-align: left;">
		<td colspan="3">
			<textarea name="b_content" id="b_content" class="form-control" required="required"></textarea>
		</td>
	</tr>
	<tr class="table-primary">
		<td colspan="3">
			<input type="hidden" value="${var.b_unum }" name="b_unum">
			<input type="hidden" value="${var.b_gnum }" name="b_gnum">
			<input type="hidden" value="${var.b_mnum }" name="b_mnum">
			<input type="button" value="글쓰기" class="btn btn-block btn-primary" id="dowrite">
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

<div class="modal fade bd-example-modal-xl" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">원본 글</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <table class="table table-bordered">
			<tr class="table-primary" style="text-align: center;">
				<th width="50%">제목</th>
				<th width="20%">작성자</th>
				<th width="10%">조회수</th>
				<th width="20%">날짜</th>
			</tr>
			<tr class="table-primary" style="text-align: center;">
				<td width="50%"><b><c:out value="${var.b_subject }" /></b></td>
				<td width="20%"><c:out value="${var.b_writer }" /></td>
				<td width="10%"><c:out value="${var.b_readcount }" /></td>
				<td width="20%"><fmt:formatDate value="${var.b_date }" pattern="yyyy-MM-dd hh:mm:ss E"/></td>
			</tr>
			<tr class="table-primary">
				<td colspan="4" height="1500%">
					<div id="cont" style="white-space: normal; word-wrap: break-word;">
					${var.b_content }
					<br><br><br><br><br><br><br>
					<c:if test="${var.b_filename != null }">
					첨부파일  :  ${var.b_filename } 
					(<fmt:formatNumber pattern="#,###" value="${var.b_filesize }"/> KB) 
					<button class="btn btn-outline-secondary" onclick="fn_filedown('${var.b_num}')">다운받기</button>
					</c:if>
					</div>
				</td>
			</tr>
		</table>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

</body>
</html>