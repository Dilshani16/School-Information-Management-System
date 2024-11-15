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
        <li><a href="index-admin.jsp">Home</a></li>
        <li><a href="index.jsp">Go to User View</a></li>
    </ul>
</nav>
<main>
    <section class="body-section">
       <div class="admin-home-top-container">
           <h2>Notices</h2>
           <div class="notice-create-button">
               <a href="createNotice.jsp" class="create-button">Create Notice +</a>
           </div>
       </div>
        <div class="search-bar">
            <input type="text" id="searchInput" placeholder="Search...">
            <button class="search-btn-admin" onclick="searchNotices()">Search</button>
            &nbsp;
            <button class="clear-btn-admin" onclick="window.location.reload()">Clear</button>
        </div>


        <div>
            <div>
                <table id="notices">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Module</th>
                            <th>Topic</th>
                            <th>Created At</th>
                            <th>Last Update</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
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
                                String update_date = resultSet.getString("update_date");
                    %>
                    <tr>
                        <td class="centre-text-table"><%= noticeId %></td>
                        <td><%= moduleName %></td>
                        <td>
                            <a class="notice-topic-admin" href="admin-noticeView.jsp?id=<%= noticeId %>">
                                <%= topic %>
                            </a>
                        </td>
                        <td class="centre-text-table"><%= create_date %></td>
                        <td class="centre-text-table"><%= update_date %></td>
                        <td class="action-table-body">
                            <div class="action-edit-box">
                                <a class="notice-edit-btn"  href="admin-noticeUpdate.jsp?id=<%= noticeId %>">Edit</a>
                                &nbsp;
                                <a class="notice-dlt-btn" onclick="confirmDelete(<%= noticeId %>)">Delete</a>
                            </div>
                        </td>
                    </tr>
                    <% }
                        resultSet.close();
                        statement.close();
                        connection.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    %>
                    </tbody>
                </table>
            </div>

        </div>
    </section>
</main>
<footer>
    <p>&copy; 2024 School Information Management System</p>
</footer>
<script src="./resources/js/script.js"></script>
</body>
</html>
