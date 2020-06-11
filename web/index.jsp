<%@ page import="Crawling.Craw" %>
<%@ page import="java.util.Arrays" %><%--
  Created by IntelliJ IDEA.
  User: isanhae
  Date: 2020/06/08
  Time: 2:44 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.js"
            integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="main.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
    <title>시간표 선택</title>
    <script>
        var list = [];
        $(function () {
            $('#modal').hide();
            $('#create-btn').click(function () {
                if (confirm('시간표를 생성하시겠습니까?')) {
                    $('#form').submit();
                }
            });

            $('#select-college').change(function () {
                var x = document.getElementById("select-college").selectedIndex;
                var y = document.getElementById("select-college").options;
                var idx = y[x].index - 1;
                getMajors(idx);
            });

            $('#select-major').change(function () {
                var cx = document.getElementById("select-college").selectedIndex;
                var cy = document.getElementById("select-college").options;
                var collegeIdx = cy[cx].index - 1;
                var mx = document.getElementById("select-major").selectedIndex;
                var my = document.getElementById("select-major").options;
                var majorIdx = my[mx].index - 1;

                var url = 'getSubjects.jsp?C=' + collegeIdx + "&M=" + majorIdx;
                $('#modal').fadeIn(200);
                $.get(url, function (data) {
                    const subejects = data.split(';;');
                    var html = '';
                    list = [];
                    for (var i = 0; i < subejects.length - 1; i++) {
                        subejects[i] = subejects[i].trim();
                        var v = subejects[i].split('|');
                        list.push(v);
                        html += '<tr>' +
                            '<td>' + v[0] + '</td>' +
                            '<td>' + v[1] + '</td>' +
                            '<td>' + v[2] + '</td>' +
                            '<td>' + v[3] + '</td>' +
                            '<td>' + v[4] + '</td>' +
                            '<td>' + v[5] + '</td>' +
                            '<td>' + v[6] + '</td>' +
                            '<td>' + v[7] + '</td>' +
                            '<td>' + v[8] + '</td>' +
                            '<td><button type="button" data-id=' + i + ' class="add-btn">추가</button></td>' +
                            '</tr>';
                    }
                    $('#tbody').html(html);
                    $('#modal').fadeOut();
                    setAddBtns();
                });
            });
        });

        function getMajors(ix) {
            var url = 'getMajor.jsp?idx=';
            url = url + ix;
            $.get(url, function (data) {
                var majors = data.split(',');
                var html = '<option>학과 선택</option>';
                for (var i = 0; i < majors.length - 1; i++) {
                    html += '<option>' + majors[i] + '</option>';
                }
                $('#select-major').html(html);
            });
        }

        function setAddBtns() {
            $('.add-btn').click(function () {
                var id = $(this).data('id');
                var v = list[id];
                $(this).parent().parent().remove();
                var html = '<tr>' +
                    '<td>' + v[0] + '</td>' +
                    '<td>' + v[1] + '</td>' +
                    '<td>' + v[2] + '</td>' +
                    '<td>' + v[3] + '</td>' +
                    '<td>' + v[4] + '</td>' +
                    '<td>' + v[5] + '</td>' +
                    '<td>' + v[6] + '</td>' +
                    '<td>' + v[7] + '</td>' +
                    '<td>' + v[8] + '</td>' +
                    '<td><input type="number" value="1" name="Weight"></td>' +
                    '</tr>';
                $('#cart-table').append(html);
                var fromData = '<input hidden name="ID" value="' + v[0] + '">' +
                    '<input hidden name="Name" value="' + v[1] + '">' +
                    '<input hidden name="Div" value="' + v[2] + '">' +
                    '<input hidden name="Week" value="' + v[3] + '">' +
                    '<input hidden name="Professor" value="' + v[4] + '">' +
                    '<input hidden name="Room" value="' + v[5] + '">' +
                    '<input hidden name="Point" value="' + v[6] + '">' +
                    '<input hidden name="Max" value="' + v[7] + '">' +
                    '<input hidden name="Time" value="' + v[8] + '">';
                $('#form').append(fromData);
            });
        }
    </script>
</head>
<body>
<div class=" container">
    <div id="modal">
        <div class="popup">
            <h4>잠시만 기다려주세요.</h4>
            <p>시간표를 크롤링 중입니다.</p>
        </div>
    </div>
    <div id="contents-div">
        <h3>학과 선택</h3>
        <%
            Craw craw = new Craw();
            String[] colleges = craw.getColleges();
        %>
        <select id="select-college">
            <option>단과대학 선택</option>
            <% for (String col : colleges) { %>
            <option><%=col%>
            </option>
            <% } %>
        </select>
        <select id="select-major">

        </select>
        <br>
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
            <th>추가</th>
            </thead>
            <tbody id="tbody">

            </tbody>
        </table>
    </div>
    <div id="add-div">
        <h3>담은 항목</h3>
        <form id="form" method="post" action="Learn.jsp">
            <label>최대 학점</label>
            <input name="max_point" class="form-control" value="12" type="number">
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

                </tbody>
            </table>
        </form>
        <button type="button" class="btn btn-primary btn-block" id="create-btn">시간표 생성</button>
    </div>
</div>
</body>
</html>
