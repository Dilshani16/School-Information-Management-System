<%@ page import="java.sql.ResultSet" %>
<%@ page import="org.queenscollege.DBUtil" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Queens College - School Information Management System</title>
    <link rel="stylesheet" type="text/css" href="./resources/css/styles.css">
</head>
<body>
<header>
    <img src="./resources/img/logo.png" alt="logo" width="100"/>
</header>
<nav>
    <ul>
        <li><a href="index.jsp">Home</a></li>
        <li><a href="index-admin.jsp">Go to Admin View</a></li>
    </ul>
</nav>
<main>
    <section class="body-section">
        <h2>Notices</h2>

        <div>
            <%
                try {
                    Connection connection = DBUtil.getConnection();
                    Statement statement = connection.createStatement();
                    ResultSet resultSet = statement.executeQuery("SELECT * FROM notices ORDER BY create_date DESC");
                    while (resultSet.next()) {
                        int noticeId = resultSet.getInt("notice_id");
                        String moduleName = resultSet.getString("module_name");
                        String topic = resultSet.getString("topic");
                        String content = resultSet.getString("content");
                        String create_date = resultSet.getString("create_date");
            %>
            <button class="accordion">
                <a href="noticeView.jsp?id=<%= noticeId %>">
                    <%= topic %>
                </a>
            </button>
            <div class="panel">
                <div>
                    <div class="panel-box">
                        <p class="panel-module-name"><%= moduleName %></p>
                        <p class="panel-date"><%= create_date %></p>
                    </div>
                    <p class="panel-content"><%= content %></p>
                </div>
            </div>
            <%
                    }
                    resultSet.close();
                    statement.close();
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            %>
        </div>
    </section>
</main>
<footer>
    <p>&copy; 2024 School Information Management System</p>
</footer>
<script src="./resources/js/script.js"></script>
</body>
</html>
