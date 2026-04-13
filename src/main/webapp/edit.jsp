<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.User" %>
<%@ page import="java.sql.*" %>

<%
    // Get the user ID from the request
    int userId = Integer.parseInt(request.getParameter("id"));
    User user = null;

    // Connect to the database and retrieve user details
    Connection connection = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/MP0613_jsp", "root", "");
        PreparedStatement statement = connection.prepareStatement("SELECT * FROM users WHERE id=?");
        statement.setInt(1, userId);
        ResultSet resultSet = statement.executeQuery();

        // If user found, create the User object
        if (resultSet.next()) {
            user = new User(resultSet.getInt("id"), resultSet.getString("name"), resultSet.getString("email"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Ensure that user is not null (error handling)
    if (user == null) {
        out.println("<h3>Error: User not found.</h3>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit User</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            text-align: center;
        }
        h1 {
            color: #333;
        }
        .container {
            width: 50%;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .form-label {
            font-size: 1.1em;
            margin: 10px 0;
            text-align: left;
        }
        input[type="text"], input[type="email"] {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        input[type="submit"] {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        a {
            display: inline-block;
            margin-top: 15px;
            padding: 8px 15px;
            background-color: #dc3545;
            color: white;
            border-radius: 5px;
            text-decoration: none;
        }
        a:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Edit User</h1>

    <% if (user != null) { %>
    <form action="users" method="post">
	    <input type="hidden" name="action" value="update">
	    <input type="hidden" name="id" value="<%= user.getId() %>">
	
	    <div class="form-group">
	        <label for="name" class="form-label">Name:</label>
	        <input type="text" id="name" name="name" value="<%= user.getName() %>" required>
	    </div>
	
	    <div class="form-group">
	        <label for="email" class="form-label">Email:</label>
	        <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required>
	    </div>
	
	    <input type="submit" value="Update User">
	</form>
    <% } %>

    <a href="users">Back to User List</a>
</div>

</body>
</html>
