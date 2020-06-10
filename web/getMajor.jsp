<%@ page import="Crawling.Craw" %><%--
  Created by IntelliJ IDEA.
  User: isanhae
  Date: 2020/06/08
  Time: 3:29 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String index = request.getParameter("idx");
    int idx = Integer.parseInt(index);
    System.out.println(idx);
    Craw craw = new Craw();
    String[] majors = craw.getMajors(idx);
    String result = "";
    for (String major : majors) {
        result += major + ",";
    }
    result.replace(" ", "");
    result = result.trim();
    result.replace("\n", "");
    result.substring(0, result.length() - 2);
    craw.close();
    out.print(result);
%>
