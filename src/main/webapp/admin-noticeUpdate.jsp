<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.queenscollege.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Notice</title>
    <link rel="stylesheet" type="text/css" href="./resources/css/styles.css">
    <link rel="stylesheet" type="text/css" href="./resources/css/form.css">

    <%
        // Retrieve notice data from the database based on the notice ID from the URL
        String noticeIdParam = request.getParameter("id");
        if (noticeIdParam == null || noticeIdParam.isEmpty()) {
            //Notice ID is required
            response.sendRedirect("index-admin.jsp");
        }

        int noticeId = Integer.parseInt(noticeIdParam);

        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement("SELECT * FROM notices WHERE notice_id = ?")) {

            preparedStatement.setInt(1, noticeId);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                // Extract notice data
                String moduleName = resultSet.getString("module_name");
                String topic = resultSet.getString("topic");
                String content = resultSet.getString("content");
    %>
    <script>
        var moduleName = '<%= moduleName %>';
        var topic = '<%= topic %>';
        var content = '<%= content %>';
        var noticeId = '<%= noticeId %>';
    </script>
    <%
            } else {
                // Notice not found
                response.sendRedirect("index-admin.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Database error
            response.sendRedirect("index-admin.jsp");
        }
    %>
</head>
<body>
<header>
    <img src="./resources/img/logo.png" alt="logo" width="100"/>
</header>
<nav>
    <ul>
        <li><a href="index-admin.jsp">Home</a></li>
        <li><a href="index.jsp">Go to User View</a></li>
    </ul>
</nav>
<main>
    <section class="body-section">
        <div class="back-button">
            <a href="index-admin.jsp" class="previous">&laquo; Back to Home</a>
        </div>

        <h1>Update Notice</h1>
        <hr/>
        <br/>

        <form action="api/notice/update" method="post" class="container">
            <label for="moduleName">Module Name:</label>
            <select id="moduleName" name="module_name" required>
                <option value="" hidden="">Select Module</option>
                <option value="Module 1">Module 1</option>
                <option value="Module 2">Module 2</option>
                <option value="Module 3">Module 3</option>
            </select><br><br>

            <label for="topic">Topic:</label>
            <input type="text" id="topic" name="topic" required><br><br>

            <label for="content">Content:</label><br>
            <textarea id="content" name="content" rows="5" required></textarea><br><br>

            <input type="hidden" id="noticeId" name="notice_id">
            <div class="row update-form-button">
                <input type="submit" value="Update">
            </div>
        </form>
    </section>
</main>
<footer>
    <p>&copy; 2024 School Information Management System</p>
</footer>
<script src="./resources/js/script.js"></script>
<script>
    // Set notice data to form fields
    document.getElementById("moduleName").value = moduleName;
    document.getElementById("topic").value = topic;
    document.getElementById("content").value = content;
    document.getElementById("noticeId").value = noticeId;
</script>
</body>
</html>
