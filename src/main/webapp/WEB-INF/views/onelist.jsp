<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
#bbs table {
	width: 800px;
	margin: 0 auto;
	margin-top: 20px;
	border: 1px solid black;
	border-collapse: collapse;
	font-size: 14px;
}

#bbs table caption {
	font-size: 20px;
	font-weight: bold;
	margin-bottom: 10px;
}

#bbs table th {
	text-align: center;
	border: 1px solid black;
	padding: 4px 10px;
}

#bbs table td {
	text-align: left;
	border: 1px solid black;
	padding: 4px 10px;
}

.no {
	width: 15%
}

.subject {
	width: 30%
}

.writer {
	width: 20%
}

.reg {
	width: 20%
}

.hit {
	width: 15%
}

.title {
	background: lightsteelblue
}

.odd {
	background: silver
}

/* 댓글 */
.div1 {
	width: 580px;
	margin: auto;
}
</style>
<script type="text/javascript">
	function list_go(f) {
		f.action="list.do";
		f.submit();
	}
	function update_go(f) {
		f.action="update.do";
		f.submit();
	}
	function delete_go(f) {
		f.action="delete.do";
		f.submit();
	}
	function comm_delete(f) {
		var chk = confirm("정말 삭제 할까요?");
		if(chk){
			f.action="comm_delete.do";
			f.submit();
		}else{
			return;
		}
	}
	function comm_go(f) {
		var login = "<c:out value='${login}' />"
		// 로그인 해야지만 글 쓸수 있다.
		if(login == 'ok'){
			f.action = "comm_write.do";
			f.submit();
		}
		if(login != 'ok'){	
			alert("로그인 하세요");
			f.action = "login.do" ;
			f.submit();
		}
		
	} 
</script>
</head>
<body>
	<div id="bbs">
		<form method="post" encType="multipart/form-data">
			<table summary="게시판 내용보기">
				<caption>게시판 내용보기</caption>
				<tbody>
					<tr>
						<th>제목</th>
						<td>${bvo.subject}</td>
					</tr>
					<tr>
						<th>이름</th>
						<td>${bvo.writer}</td>
					</tr>
					<tr>
						<th>내용:</th>
						<td><script
								src="https://cdn.ckeditor.com/4.16.0/standard/ckeditor.js"></script>
							<textarea name="content" cols="50" rows="8" readonly><pre>${bvo.content}</pre></textarea>
							<script>
                        	CKEDITOR.replace( 'content' );
                		</script></td>
					</tr>
					<tr>
						<th>첨부파일:</th>
						<c:choose>
							<c:when test="${empty bvo.file_name}">
								<td><b> 첨부파일 없음 </b></td>
							</c:when>
							<c:otherwise>
								<td><img alt="" src="resources/upload/${bvo.file_name }"
									style="width: 100px;"><br> <a
									href="download.do?file_name=${bvo.file_name }">${bvo.file_name }</a>
								</td>
							</c:otherwise>
						</c:choose>
					</tr>
					<tr>
						<td colspan="2">
						<c:if test="${bvo.m_id == mvo.id}">
						<input type="button" value="수정" onclick="update_go(this.form)">
						<input type="button" value="삭제" onclick="delete_go(this.form)">
						</c:if>
						<input type="hidden" value="${cPage}" name="cPage"> 
						<input type="button" value="목록" onclick="list_go(this.form)">
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<br>
	<hr>
	<%-- 댓글 출력  --%>
	<br>
	<div class="div1">
		<c:forEach var="k" items="${clist}">
			<div style="margin: 10px; 0px;">
				<form method="post">
				 	${k.writer} <br>
					<table>
						<tbody>
							<tr>
								<td>
									<textarea rows="4" cols="70" name="content" disabled>${k.content}</textarea>
								</td>
								<c:if test="${k.writer == mvo.id }">  
								<td>
									<input style="height: 70px;" type="button" value="댓글삭제" onclick="comm_delete(this.form)">
									<input type="hidden" name="c_idx" value="${k.c_idx}">
									<input type="hidden" name="b_idx" value="${k.b_idx}">
									
								 	<input type="hidden" value="${cPage}" name="cPage"> 
								</td>
								</c:if>
							</tr>
						</tbody>
					</table>
				</form>
			</div>
		</c:forEach>
	</div>
	<br>
	<%-- 댓글 입력 --%>
	<div class="div1">
		<form method="post">
				<div style="margin: 5px;"> 
					<c:if test="${login == 'ok'}">
					   <strong>${mvo.name}(${mvo.id}님)</strong><br>  
				    </c:if>
			    </div>
			<table>
				<tbody>
					<tr>					     
						<td><textarea rows="4" cols="70" name="content"></textarea></td>
						<td><input style="height: 70px;" type="button" value="댓글" onclick="comm_go(this.form)"></td>
						<input type="hidden" name="b_idx" value="${bvo.b_idx}">
						<input type="hidden" value="${cPage}" name="cPage">
						<input type="hidden" value="${mvo.id}" name="writer">
					</tr>
				</tbody>
			</table>
		</form>
	</div>
</body>
</html>