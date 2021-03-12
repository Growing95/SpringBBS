<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
function login_go(f) {
	if(f.id.value == "" || f.pw.value == ""){
		alert("id 혹은 pw를 입력하세요");
		f.id.value="";
		f.pw.value="";
		f.id.focus();
		return;
	}
	f.action="login_ok.do";
	f.submit();
		
	
}
// 미완성알아서하기
function join_go(f) {
	f.action="join.do";
	f.submit();
}

</script>
</head>
<body>
<div id="log_div">
	<form method="post">
		<table>
			<thead>
				<tr>
					<th colspan="2"><h2>로그인</h2></th>
				</tr>
				
			</thead>
			<tbody>
				<tr>
					<td>아이디 : <input type="text" name="id" ></td>
					<td>비밀번호 : <input type="password" name="pw" > </td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="2">
						<input type="hidden" value="${cPage}" name="cPage">
						<input type="button" value="로그인" onclick="login_go(this.form)">
						<input type="button" value="회원가입" onclick="join_go(this.form)">
					</td>
				</tr>
			</tfoot>
		</table>
	</form>
</div>
</body>
</html>