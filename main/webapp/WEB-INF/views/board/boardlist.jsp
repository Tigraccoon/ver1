<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리스트</title>
<%@ include file="../include/header.jsp" %>
<script type="text/javascript">

$(function(){
	
	var keyword = '${map.keyword}';
	
});

function list(page, option, keyword){
	location.href="${path}/board/boardlist.do?curPage="+page+"&option="+encodeURIComponent(option)+"&keyword="+encodeURIComponent(keyword);
}

</script>
</head>
<body>

<div class="container-fluid">
	<div class="row justify-content-center">
		<div class="col col-10">
<br>

<div class="col col-10 justify-content-end">

<form class="form-inline my-2" method="post" action="${path }/board/boardlist.do">
	<select class="form-control mr-sm-2" name="option">
	  <option selected value="%">작성자 + 제목</option>
	  <option value="writer">작성자</option>
	  <option value="subject">제목</option>
	</select>
    <input class="form-control mr-sm-2" name="keyword" type="search" placeholder="게시물 검색" aria-label="Search">
    <button class="btn btn-outline-success my-2 my-sm-0" type="submit"><i class="fa fa-search"></i>&nbsp;검색</button>
</form>
	
</div>
<br>
<div class="table-responsive-xl">
<table class="table table-bordered" style="text-align: center; table-layout:fixed;">
<caption style="text-align: right; caption-side: top;"><strong>${map.count }</strong>&nbsp;개의 글이 있습니다.</caption>
<thead>
	<tr class="table-primary">
		<th scope="col" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;">번호</th>
		<th scope="col" width="50%" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;">제목</th>
		<th scope="col" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;">작성자</th>
		<th scope="col" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;">조회수</th>
		<th scope="col" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;">날짜</th>
	</tr>
</thead>
<tbody>
	<c:if test="${map.count == 0 }">
			<th colspan="5" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;">검색 결과가 없습니다.</th>
	</c:if>
	
	<c:forEach var="list" items="${map.b_list }">
	<!-- 일반글 -->
		<c:if test="${list.b_show == 'Y' && list.b_secret == 'N'}">
		<tr>
			<th scope="row" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;">${list.idx }</th>
			<td style="text-align: left;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;">
				<a href="${path }/board/boardview.go?b_num=${list.b_num}" title="${list.b_subject }">
				${list.b_subject }
					<c:if test="${list.c_count > 0 }">
						<label style="color: black">(${list.c_count })</label>
					</c:if>
				</a>
			</td>
			<td style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;">${list.b_writer }</td>
			<td style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;">${list.b_readcount }</td>
			<td style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;"><fmt:formatDate value="${list.b_date }" pattern="yyyy-MM-dd hh:mm:ss E"/></td>
		</tr>
		</c:if>
		<c:if test="${list.b_show == 'N' && list.b_secret == 'N'}">
		<tr>	
			<th scope="row" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;">${list.idx }</th>
			<td colspan="4" style="text-align: center;">
				삭제된 글입니다
			</td>
		</tr>
		</c:if>
		
	</c:forEach>
</tbody>
</table>
</div>

<!-- 페이징 -->
<br><br>
<nav aria-label="Page navigation example">
  <ul class="pagination justify-content-center">
<c:if test="${map.pager.curBlock > 1 }">
    <li class="page-item">
      <a class="page-link" href="#" aria-label="Previous" onclick="list('1', '${map.option }', '${map.keyword}')">
        <span aria-hidden="true">&laquo;</span><!-- 처음 -->
      </a>
    </li>
</c:if>
<c:if test="${map.pager.curBlock > 1}">
    <li class="page-item">
      <a class="page-link" href="#" aria-label="Previous" onclick="list('${map.pager.prevPage}', '${map.option }', '${map.keyword}')">
        <span aria-hidden="true">&lt;</span><!-- 이전 -->
      </a>
    </li>
</c:if>
<c:forEach var="num" begin="${map.pager.blockBegin}" end="${map.pager.blockEnd}">
	<c:choose>
		<c:when test="${num == map.pager.curPage}"><!-- 현재 패이지 -->
			<li class="page-item active" aria-current="page">
				<span class="page-link">${num }<span class="sr-only">(current)</span></span>
			</li>
		</c:when>
		<c:otherwise>
		<li class="page-item"><!-- 페이지들 -->
      		<a class="page-link" href="#" onclick="list('${num}', '${map.option }', '${map.keyword}')">${num }</a>
    	</li>
		</c:otherwise>
	</c:choose>
	</c:forEach>
<c:if test="${map.pager.curBlock < map.pager.totBlock}">
    <li class="page-item">
      <a class="page-link" href="#" aria-label="Next" onclick="list('${map.pager.nextPage}', '${map.option }', '${map.keyword}')">
        <span aria-hidden="true">&gt;</span><!-- 다음 -->
      </a>
    </li>
</c:if>
    
<c:if test="${map.pager.curBlock < map.pager.totBlock}">
    <li class="page-item">
      <a class="page-link" href="#" aria-label="Next" onclick="list('${map.pager.totPage}', '${map.option }', '${map.keyword}')">
        <span aria-hidden="true">&raquo;</span><!-- 끝 -->
      </a>
    </li>
</c:if>
  </ul>
</nav>
<br>
<a class="btn btn-block btn-primary" href="${path }/board/boardwrite.go">글쓰기</a>
<br>
<a href="${path }/board/boardlist.do" class="btn btn-info btn-block">리스트</a>
		</div>
	</div>
</div>

</body>
</html>