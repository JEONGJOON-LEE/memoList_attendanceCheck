<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.koreait.memolist.DBUtil"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출석체크 게시판</title>

<style type="text/css">
.button {
  background-color: #4CAF50; /* Green */ /* 배경색 */
  border: none;							 /* 테두리 => 선두께 선종류 선색상*/
  color: white;							 /* 글자색 */
  padding: 6px;							 /* 안여백 */
  text-align: center;					 /* 텍스트 정력 */
  text-decoration: none; 				 /* 밑줄 */
  display: inline-block;				 /* 같은줄에 나타나게 한다. */
  font-size: 13px;						 /* 텍스트 크기 */
  margin: 4px 2px;						 /* 바깥여백 */
  transition-duration: 0.4s;			 /* 애니메이션 재생시간 */
  cursor: pointer;						 /* 마우스 포인터 모양 */
  width: 50px;							 /* 가로크기 */
  height: 35px;							 /* 세로크기 */
}

.button1 {
  background-color: black; 
  color: yellow; 
  border: 1px solid white;
}

.button1:hover {
  background-color: yellow;
  color: tomato;
}

.button2 {
  background-color: gray; 
  color: black; 
  border: 1px solid white;
  cursor: not-allowed;
}
</style>

</head>
<body>
<form action="memoInsert.jsp" method="post">
	<table width="1000" align="center" border="1" cellpadding="5" cellspacion="0">
		<tr>
			<th colspan="3">출석체크 게시판 Ver 0.67</th>
		</tr>
		<tr>
			<td width="100" align="center">이름</td>
			<td width="100" align="center">비밀번호</td>
			<td width="800" align="center">메모</td>
		</tr>
		<tr>
			<td align="center">
				<input type="text" name="name" style="width: 90%; height: 25px;"/>
			</td>
			<td align="center">
				<input type="password" name="password" style="width: 90%; height: 25px;"/>
			
			</td>
			<td align="center">
				<input type="text" name="memo" style="width: 92%; height: 25px;"/>
				<input type="submit" value="저장" style="height: 30px;"/>
			</td>
		</tr>
	</table>
</form><br>
<hr size="3" color="red"/><br>

<%
	int pageSize = 10;	 // 한 페이지에 표시할 글의 개수
	int totalCount = 0;  // 테이블에 저장된 전체 글의 개수
	int totalPage = 0; 	 // 전체 페이지 개수
	int currentPage = 1; // 현재 브라우저에 표시되는 페이지 번호
	int startNo = 0;	 // 현재 브라우저에 표시되는 글의 시작 인덱스 번호 => mysql의 인덱스는 0부터 시작된다.	
	int endNo = 0;		 // 현재 브라우저에 표시되는 글의 마지막 인덱스 번호
	int startPage = 0;	 // 페이지 이동 하이퍼링크 또는 버튼에 표시될 시작 페이지 번호
	int endPage = 0;	 // 페이지 이동 하이퍼링크 또는 버튼에 표시될 마지막 페이지 번호
	
	
	Connection conn = DBUtil.getMySQLConnection();
	String sql = "select count(*) from memolist;";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	ResultSet rs = pstmt.executeQuery();
	rs.next();
	totalCount = rs.getInt(1);
	
	totalPage = (totalCount - 1) / pageSize + 1;

	try{
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		currentPage = currentPage > totalPage ? totalPage : currentPage;
	} catch (NumberFormatException e) {	}

	startNo = (currentPage - 1) * pageSize;	
	endNo = endNo > totalCount ? totalCount : endNo;
	
	sql = "select * from memolist order by idx desc limit ?, ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, startNo);
	pstmt.setInt(2, pageSize);
	rs = pstmt.executeQuery();
	
%>

<table width="1200" align="center" border="1" cellpadding="5" cellspacion="0">
		<tr>
			<th width="80">글번호</th> 
			<th width="80">이름</th>
			<th width="800">메모</th>
			<th width="120">작성일</th>
			<th width="80">IP</th>
		</tr>
		
		<tr>
			<td colspan="5" align="right">
				<%=totalCount%>개(<%=currentPage%>/<%=totalPage%>)Page
			</td>
		</tr>
		
		
<%
	if(rs.next()){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd(E)");
		do{
%>
	<tr>
		<td align="center"><%=rs.getInt("idx")%></td>
		<td align="center"><%=rs.getString("name")%></td>
		<td align="center"><%=rs.getString("memo")%></td>
		<td align="center"><%=sdf.format(rs.getTimestamp("writeDate"))%></td>
		<td align="center"><%=rs.getString("ip")%></td>
	</tr>
<% 			
		} while(rs.next());
	} else {
%>
	<tr>
		<td colspan="5">
			<marquee style="color: hotpink"><b>테이블에 저장된 글이 없습니다.</b></marquee>
		</td>
	</tr>
<% 
	}
%>		
	<!-- 10페이지 단위로 페이지 이동 버튼을 추가한다. -->
	<tr>
		<td colspan="5" align="center">
<%
//	페이지 이동 버튼의 시작 페이지 번호와 마지막 페이지 번호를 계산한다.
	startPage = (currentPage - 1) / 10 * 10 + 1;
	endPage = startPage + 9;
// 	페이지 이동 버튼의 마지막 페이지 번호가전체 페이지 수보다 커지면 존재하지 않는 페이지 번호가 표소되므로
//	마지막 페이지 번호를 전체 페이지 수로 변경한다.
	endPage = endPage > totalPage ? totalPage : endPage;
	
//	맨 앞으로
//	현재 보고 있는 페이지가 1보다 크다면 맨앞으로 이동할 수 있다.
	if(currentPage > 1){
%>
		<button class="button button1" type="button" title="첫 페이지로" onclick="location.href='?currentPage=1'">처음</button>
<% 		
	}else{
%>
		<button class="button button2" type="button" title="이미 첫 페이지입니다." disabled="disabled">처음</button>
<%	
	}

//	10페이지 앞으로
//	startPage가 1보다 크다면 이전 10 페이지로 이동할 수 있다.
	if(startPage > 1){
%>	
		<button class="button button1" type="button" title="이전 10페이지로" onclick="location.href='?currentPage=<%=startPage - 1 %>'">이전</button>
<% 
	} else {
%>
		<button  class="button button2" type="button" title="이미 첫 10페이지 입니다." disabled="disabled">이전</button>
<%		
	}

//	10페이지 단위로 페이지 이동 버튼을 출력한다.
 	for(int i = startPage; i <= endPage; i++){
		if(currentPage == i){
%>
			<button  class="button button2" type="button" disabled="disabled"><%=i%></button>
<% 			
		} else {
%>
			<button class="button button1" type="button" onclick="location.href='?currentPage=<%=i%>'"><%=i%></button>
<%
		}
	}

//	10 페이지 뒤로
//	endPage가 totalPage보다 작으면 다음 10페이지로 이동할 수 있다.
	if(endPage < totalPage){
%>	
		<button class="button button1" type="button" title="다음 10페이지로" onclick="location.href='?currentPage=<%=endPage + 1 %>'">다음</button>
<% 	
	} else{
%>
		<button  class="button button2" type="button" title="이미 마지막 10페이지 입니다." disabled="disabled">다음</button>
<%
	}
//	맨뒤로
//	currentPage가 totalPage보다 작으면 마지막페이지로 이동할 수 있다.
	if (currentPage < totalPage) {
%>
		<button class="button button1" type="button" title="마지막 페이지로" onclick="location.href='?currentPage=<%=totalPage%>'">맨뒤</button>
	
<% 		
	} else {
%>
		<button  class="button button2" type="button" title="이미 마지막 페이지 입니다." disabled="disabled">맨뒤</button>
<% 		
	}
%>
		</td>
	</tr>
	
</table>

</body>
</html>


















































