<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Notice</title>
    <link rel="stylesheet" type="text/css" href="./resources/css/styles.css">
    <link rel="stylesheet" type="text/css" href="./resources/css/form.css">
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

<section class="body-section">
    <div class="back-button">
        <a href="index-admin.jsp" class="previous">&laquo; Back to Home</a>
    </div>

    <h1>Create Notice</h1>
    <hr/>
    <br/>

    <form action="api/notice/create" method="post" class="container">
        <div class="row">
            <div class="col-25">
                <label for="moduleName">Module Name:</label>
            </div>
            <div class="col-75">
                <select id="moduleName" name="module_name" required>
                    <option value="" hidden="">Select Module</option>
                    <option value="Module 1">Module 1</option>
                    <option value="Module 2">Module 2</option>
                    <option value="Module 3">Module 3</option>
                </select>
            </div>
        </div>

        <div class="row">
            <div class="col-25">
                <label for="topic">Topic:</label>
            </div>
            <div class="col-75">
                <input type="text" id="topic" name="topic" required>
            </div>
        </div>

        <div class="row">
            <div class="col-25">
                <label for="content">Content:</label>
            </div>
            <div class="col-75">
                <textarea id="content" name="content" rows="5" required></textarea>
            </div>
        </div>

        <div class="row submit-form-button">
            <input type="submit" value="Create">
        </div>
    </form>
</section>
<footer>
    <p>&copy; 2024 School Information Management System</p>
</footer>

<script src="./resources/js/script.js"></script>
</body>
</html>
