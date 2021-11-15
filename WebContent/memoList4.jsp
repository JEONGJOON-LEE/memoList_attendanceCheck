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
  background-color: #4CAF50; 
  border: none;							
  color: white;						
  padding: 6px;							
  text-align: center;					 
  text-decoration: none; 				
  display: inline-block;			
  font-size: 13px;						
  margin: 4px 2px;						 
  transition-duration: 0.4s;			 
  cursor: pointer;						
  width: 50px;							 
  height: 35px;							
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
			<th colspan="3">출석체크 게시판 Ver 0.99</th>
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
	int pageSize = 10;	 
	int totalCount = 0;  
	int totalPage = 0; 	
	int currentPage = 1; 
	int startNo = 0;	 	
	int endNo = 0;		 
	int startPage = 0;	 
	int endPage = 0;	 
	
	
	Connection conn = DBUtil.getMySQLConnection();
	String sql = "select count(*) from memolist;";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	ResultSet rs = pstmt.executeQuery();
	rs.next();
	totalCount = rs.getInt(1);
	
//	================================================================================================================

//	페이지당 표시할 글의 개수를 받아 pageSize 변수에 저장한다.
//	게시판이 최초로 실행될 때 이전 페이지가 없으므로 넘어오는 pageSize의 값이 null이고 보기 버튼 이외의 다른 버튼이
//  클릭되면 pageSize가 넘어오기 않기 때문에 null이 된다. => 에외 처리를 한다.

	try{
		pageSize = Integer.parseInt(request.getParameter("pageSize"));
//		화면에 표시할 글의 개수가 정상적으로 넘어왔으므로 화면에 표시할 글의 개수를 세션에 저장한다.
		session.setAttribute("pageSize", pageSize + "");
	} catch(NumberFormatException e){
//		이전 페이지에서 넘어오는 pageSize가 null이면 세션에 저장해둔 pageSize를 얻어와서 화면에 표시할 글의 개수로 지정한다.
//		브라우저가 최초로 실행될 때 세션이 만들어지기 때문에 브라우저가 최초로 실행되면 이젠 페이지에서 넘어오는 pageSize도 null이고
//		세션에 저장된 pageSize도 null이다.
		String temp = (String)session.getAttribute("pageSize");
		if(temp != null){
			pageSize = Integer.parseInt(temp);
		}
	}
//	================================================================================================================
	
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

<table width="1300" align="center" border="1" cellpadding="5" cellspacion="0">
		<tr>
			<th width="80">글번호</th> 
			<th width="80">이름</th>
			<th width="780">메모</th>
			<th width="120">작성일</th>
			<th width="120">IP</th>
			<th width="120">편집</th>
		</tr>
		
		<tr>
			<td colspan="3">
			
				<form action="?" method="post">
				페이지당 표시할 글의 개수를 선택하세요.
					<select name="pageSize" style="width: 100px; height: 25px;">
						<option>3</option>
						<option>5</option>
						<option selected="selected">10</option>
						<option>15</option>
						<option>20</option>
					</select>
					<input type="submit" value="보기"/>
				</form>
			
			</td>
			<td colspan="3" align="right">
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
		
		<!-- 수정, 삭제 버튼 추가 -->
		<td align="center">
			<button type="button" 
				onclick="location.href='memoUpdate.jsp?idx=<%=rs.getInt("idx")%>&currentPage=<%=currentPage%>'">수정</button>
			<button type="button" 
				onclick="location.href='memoDelete.jsp?idx=<%=rs.getInt("idx")%>&currentPage=<%=currentPage%>'">삭제</button>
		</td>
	</tr>
<% 			
		} while(rs.next());
	} else {
%>
	<tr>
		<td colspan="6">
			<marquee style="color: hotpink"><b>테이블에 저장된 글이 없습니다.</b></marquee>
		</td>
	</tr>
<% 
	}
%>		
	<tr>
		<td colspan="6" align="center">
<%
	startPage = (currentPage - 1) / 10 * 10 + 1;
	endPage = startPage + 9;
	endPage = endPage > totalPage ? totalPage : endPage;
	
	if(currentPage > 1){
%>
		<button class="button button1" type="button" title="첫 페이지로" onclick="location.href='?currentPage=1'">처음</button>
<% 		
	}else{
%>
		<button class="button button2" type="button" title="이미 첫 페이지입니다." disabled="disabled">처음</button>
<%	
	}

	if(startPage > 1){
%>	
		<button class="button button1" type="button" title="이전 10페이지로" onclick="location.href='?currentPage=<%=startPage - 1 %>'">이전</button>
<% 
	} else {
%>
		<button  class="button button2" type="button" title="이미 첫 10페이지 입니다." disabled="disabled">이전</button>
<%		
	}

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

	if(endPage < totalPage){
%>	
		<button class="button button1" type="button" title="다음 10페이지로" onclick="location.href='?currentPage=<%=endPage + 1 %>'">다음</button>
<% 	
	} else{
%>
		<button  class="button button2" type="button" title="이미 마지막 10페이지 입니다." disabled="disabled">다음</button>
<%
	}
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


















































