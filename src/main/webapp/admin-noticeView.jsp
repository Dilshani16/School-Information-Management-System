<%@ page import="java.sql.ResultSet" %>
<%@ page import="org.queenscollege.DBUtil" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Notice Details - School Information Management System</title>
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
        <div>
            <div class="back-button">
                <a href="index-admin.jsp" class="previous">&laquo; Back to Home</a>
            </div>

            <%
                try {
                    // Get notice ID
                    String noticeIdStr = request.getParameter("id");
                    if (noticeIdStr == null) {
                        response.sendRedirect("index-admin.jsp");
                    } else {
                        int noticeId = Integer.parseInt(noticeIdStr);

                        // Retrieve notice details from the database
                        Connection connection = DBUtil.getConnection();
                        Statement statement = connection.createStatement();
                        ResultSet resultSet = statement.executeQuery("SELECT * FROM notices WHERE notice_id = " + noticeId);
                        if (resultSet.next()) {
                            String moduleName = resultSet.getString("module_name");
                            String topic = resultSet.getString("topic");
                            String content = resultSet.getString("content");
                            String create_date_str = resultSet.getString("create_date");
            %>
            <div>
                <h2 class="notice-view-topic"><%= topic %></h2>
                <hr/>
                <div class="notice-top-box">
                    <h4><%= moduleName %></h4>
                    <h4><%= create_date_str %></h4>
                </div>
                <p class="notice-content"><%= content %></p>
            </div>
            <%
                        } else {
                            // Notice not found
                            response.sendRedirect("index.jsp");
                        }
                        resultSet.close();
                        statement.close();
                        connection.close();
                    }
                } catch (SQLException | NumberFormatException e) {
                    e.printStackTrace();
                }
            %>
        </div>
    </section>
</main>
<footer>
    <p>&copy; 2024 School Information Management System</p>
</footer>
</body>
</html>
