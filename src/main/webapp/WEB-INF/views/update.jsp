<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	#bbs table {
	    width:800px;
	    margin:0 auto;
	    margin-top:20px;
	    border:1px solid black;
	    border-collapse:collapse;
	    font-size:14px;
	    
	}
	
	#bbs table caption {
	    font-size:20px;
	    font-weight:bold;
	    margin-bottom:10px;
	}
	
	#bbs table th {
	    text-align:center;
	    border:1px solid black;
	    padding:4px 10px;
	}
	
	#bbs table td {
	    text-align:left;
	    border:1px solid black;
	    padding:4px 10px;
	}
	
	.no {width:15%}
	.subject {width:30%}
	.writer {width:20%}
	.reg {width:20%}
	.hit {width:15%}
	.title{background:lightsteelblue}
	.odd {background:silver}
</style>

<script type="text/javascript">
	function sendData(f) {
		// 유효성 검사
		for (var i = 0; i < f.elements.length; i++) {
			if(f.elements[i].value==""){
				if( i==2 || i==3 ||i==4||i==5 ) continue ;
				alert(f.elements[i].name+"를 입력하세요");
				f.elements[i].focus();
				return;
			}
		}
		if("${bvo.pwd}" == f.pwd.value){
			f.action="update_ok.do";
			f.submit();
		}else{
			alert("비밀번호가 틀립니다.\n다시입력해주세요");
			f.pwd.value="";
			f.pwd.focus();
			return;
		}
	}
	function send_list(f) {
		f.action="list.do";
		f.submit();
	}	
</script>
</head>
<body>
	<div id="bbs">
	<form method="post" encType="multipart/form-data">
		<table summary="게시판 글수정">
			<caption>게시판 글 수정</caption>
			<tbody>
				<tr>
					<th>제목:</th>
					<td><input type="text" name="subject" size="45" value="${bvo.subject}"></td>
				</tr>
				<tr>
					<th>이름:</th>
					<td><input type="text" name="writer" size="12" value="${bvo.writer}"></td>
				</tr>
				<tr>
					<th>내용:</th>
					<td><script src="https://cdn.ckeditor.com/4.16.0/standard/ckeditor.js"></script>
						<textarea name="content" cols="50" 
							rows="8">${bvo.content}</textarea>
						<script>
                        	CKEDITOR.replace( 'content' );
                		</script>	
					</td>
				</tr>
				<tr>
					<th>첨부파일:</th>
					<td>
					<c:if test="${empty bvo.file_name }">
					    <input type="file" name="file"> 이전 파일 없음<br>
					</c:if>
					<c:if test="${!empty bvo.file_name }">
					    <input type="file" name="file">이전파일 [${bvo.file_name}]
					    <input type="hidden" name="p_filename" value="${bvo.file_name }" >
					</c:if>
					</td>
				</tr>
				<tr>
					<th>비밀번호:</th>
					<td><input type="password" name="pwd" size="12"></td>
				</tr>
				<tr>
					<td colspan="2">
						<input type="button" value="수정하기" onclick="sendData(this.form)"/>
						<input type="reset" value="다시"/>
						<input type="button" value="목록" onclick="send_list(this.form)"/>
						<input type="hidden" name="cPage" value="${cPage}">
					    <input type="hidden" name="b_idx" value="${bvo.b_idx}">
					</td>
				</tr>
			</tbody>
		</table>
	</form>
	</div>
</body>
</html>

