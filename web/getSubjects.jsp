<%@ page import="Crawling.Craw" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="Crawling.Subject" %><%--
  Created by IntelliJ IDEA.
  User: isanhae
  Date: 2020/06/08
  Time: 4:17 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String m = request.getParameter("M");
    String c = request.getParameter("C");
    int majorIdx = Integer.parseInt(m);
    int collegeIdx = Integer.parseInt(c);
    Craw craw = new Craw();
    ArrayList<Subject> subjects = craw.getSubjects(collegeIdx, majorIdx);
    String result = "";
    for (Subject subject : subjects) {
        result += subject.toString();
    }
    result = result.replace(" ", "");
    result = result.trim();
    craw.close();
    out.print(result);
%>
