package org.queenscollege;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;

@WebServlet(name = "NoticeServlet", urlPatterns = "/api/notice/*")
public class NoticeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getAction(request);
        switch (action) {
            case "search":
                searchNotices(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getAction(request);
        switch (action) {
            case "create":
                createNotice(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getAction(request);
        switch (action) {
            case "update":
                updateNotice(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getAction(request);
        switch (action) {
            case "delete":
                deleteNotice(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private String getAction(HttpServletRequest request) {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            return null;
        }
        return pathInfo.substring(1);
    }

    private void searchNotices(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("query");
        if (query == null || query.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Search query is required");
            return;
        }

        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement("SELECT * FROM notices WHERE module_name LIKE ? OR topic LIKE ?")) {
            preparedStatement.setString(1, "%" + query + "%");
            preparedStatement.setString(2, "%" + query + "%");

            ResultSet resultSet = preparedStatement.executeQuery();
            JSONArray noticesArray = new JSONArray();
            while (resultSet.next()) {
                JSONObject noticeObj = new JSONObject();
                noticeObj.put("id", resultSet.getInt("notice_id"));
                noticeObj.put("module_name", resultSet.getString("module_name"));
                noticeObj.put("topic", resultSet.getString("topic"));
                noticeObj.put("content", resultSet.getString("content"));
                noticeObj.put("create_date", resultSet.getString("create_date"));
                noticeObj.put("update_date", resultSet.getString("update_date"));
                noticesArray.add(noticeObj);
            }

            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.println(noticesArray.toJSONString());
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error searching notices");
        }
    }

    private void createNotice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String moduleName = request.getParameter("module_name");
        String topic = request.getParameter("topic");
        String content = request.getParameter("content");

        if (moduleName == null || topic == null || content == null || moduleName.isEmpty() || topic.isEmpty() || content.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Module name, topic, and content are required");
            return;
        }

        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement("INSERT INTO notices (module_name, topic, content) VALUES (?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {

            preparedStatement.setString(1, moduleName);
            preparedStatement.setString(2, topic);
            preparedStatement.setString(3, content);
            int rowsAffected = preparedStatement.executeUpdate();

            if (rowsAffected > 0) {
                ResultSet generatedKeys = preparedStatement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    long id = generatedKeys.getLong(1);
                    response.setStatus(HttpServletResponse.SC_CREATED);
                    response.sendRedirect("/queenscollege/index-admin.jsp");
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating notice");
                }
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating notice");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating notice");
        }
    }

    private void updateNotice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Notice ID is required");
            return;
        }

        int id = Integer.parseInt(idParam);
        String topic = request.getParameter("topic");
        String content = request.getParameter("content");

        if (topic == null || content == null || topic.isEmpty() || content.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Topic and content are required for update");
            return;
        }

        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement("UPDATE notices SET topic = ?, content = ? WHERE notice_id = ?")) {

            preparedStatement.setString(1, topic);
            preparedStatement.setString(2, content);
            preparedStatement.setInt(3, id);
            int updated = preparedStatement.executeUpdate();

            if (updated > 0) {
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Notice not found");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating notice");
        }
    }

    private void deleteNotice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Notice ID is required");
            return;
        }

        int id = Integer.parseInt(idParam);

        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement("DELETE FROM notices WHERE notice_id = ?")) {

            preparedStatement.setInt(1, id);
            int deleted = preparedStatement.executeUpdate();

            if (deleted > 0) {
                // Send confirmation message upon successful deletion
                response.setContentType("text/html");
                PrintWriter out = response.getWriter();
                out.println("<script>alert('Notice deleted successfully!');window.location.href='index-admin.jsp';</script>");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Notice not found");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error deleting notice");
        }
    }

}
