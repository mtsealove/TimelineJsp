<%@ page import="java.util.ArrayList" %>
<%@ page import="Crawling.Subject" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="DNAUtil.Util" %>
<%@ page import="java.util.Arrays" %><%--
  Created by IntelliJ IDEA.
  User: isanhae
  Date: 2020/06/09
  Time: 8:24 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 수강할 수업에 대한 파라미터 입력
    request.setCharacterEncoding("UTF-8");
    String[] IDs = request.getParameterValues("ID");
    String[] Names = request.getParameterValues("Name");
    String[] Divs = request.getParameterValues("Div");
    String[] Weeks = request.getParameterValues("Week");
    String[] Professors = request.getParameterValues("Professor");
    String[] Rooms = request.getParameterValues("Room");
    String[] PointStrs = request.getParameterValues("Point");
    String[] MaxStrs = request.getParameterValues("Max");
    String[] Times = request.getParameterValues("Time");
    String[] WeightStrs = request.getParameterValues("Weight");
    int[] Points = new int[PointStrs.length], Maxs = new int[MaxStrs.length], Weights = new int[WeightStrs.length];
    // 최대 학점
    int MaxPoint = Integer.parseInt(request.getParameter("max_point"));
    System.out.println("MaxPoint: " + MaxPoint);
    int MaxCount = MaxPoint / 3; // 최대 과목 수

    // 문자열 -> 숫자 변환
    for (int i = 0; i < PointStrs.length; i++) {
        Points[i] = Integer.parseInt(PointStrs[i]);
        Maxs[i] = Integer.parseInt(MaxStrs[i]);
        Weights[i] = Integer.parseInt(WeightStrs[i]);
    }
    // 객체 목록 생성
    ArrayList<Subject> subjects = new ArrayList<>();
    for (int i = 0; i < IDs.length; i++) {
        String week = Weeks[i];
        String id = IDs[i];
        String name = Names[i];
        String div = Divs[i];
        String time = Times[i];
        String professor = Professors[i];
        String room = Rooms[i];
        int point = Points[i];
        int max = Maxs[i];
        int weight = Weights[i];
        Subject subject = new Subject(week, id, name, div, time, professor, room, point, max);
        subject.setWeight(weight);
        subjects.add(subject);
    }

    // 학습 객체 생성
    Util util = new Util(subjects, MaxCount);
    // 1세대 유전자 랜덤 생성
    ArrayList<Subject>[] pick = util.generateDna();

    int i = 0;
    // 모든 적합도가 비슷할 때까지 수행
    while (!util.balanced(pick) || i <= 500) {
        pick = util.reproduction(pick);
        System.out.println("reproduction: " + i);
        i++;
    }

    System.out.println("result");
    for (Subject s : pick[0]) {
        System.out.print(s.toString());
        System.out.println("");
    }
%>
<html>
<head>
    <title>결과</title>
    <link rel="stylesheet" href="main.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container contents">
    <h3>추천 시간표</h3><br>

<%-- 최종 결과물 출력--%>
    <table class="table table-striped">
        <thead>
        <th>학수번호</th>
        <th>과목명</th>
        <th>구분</th>
        <th>시간</th>
        <th>교수</th>
        <th>강의실</th>
        <th>학점</th>
        <th>인원</th>
        <th>주차</th>
        <th>가중치</th>
        </thead>
        <tbody id="cart-table">
        <% for (int k = 0; k < pick[0].size(); k++) { %>
        <tr class="size-10">
            <td class="size-10"><%=pick[0].get(k).getID()%>
            </td>
            <td><%=pick[0].get(k).getName()%>
            </td>
            <td><%=pick[0].get(k).getDiv()%>
            </td>
            <td><%=Arrays.toString(pick[0].get(k).getDay())%>
            </td>
            <td><%=pick[0].get(k).getProfessor()%>
            </td>
            <td><%=pick[0].get(k).getRoom()%>
            </td>
            <td><%=pick[0].get(k).getPoint()%>
            </td>
            <td><%=pick[0].get(k).getMax()%>
            </td>
            <td><%=pick[0].get(k).getTime()%>
            </td>
            <td><%=pick[0].get(k).getWeight()%></td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <button type="button" class="btn btn-primary" onclick="location.href='index.jsp'">돌아가기</button>
</div>

</body>
</html>
