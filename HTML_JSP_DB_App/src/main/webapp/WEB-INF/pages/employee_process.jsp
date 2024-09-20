<%@ page language="java" import="java.sql.*"%>

<%!Connection connection = null;
	PreparedStatement preparedStatement1 = null;
	PreparedStatement preparedStatement2 = null;

	public void jspInit() {
		ServletConfig config = getServletConfig();
		String url = config.getInitParameter("url");
		String user = config.getInitParameter("user");
		String password = config.getInitParameter("password");
		try {
			System.out.println("BootStrapping the environment...");
			Class.forName("com.mysql.cj.jdbc.Driver");
			connection = DriverManager.getConnection(url, user, password);
			preparedStatement1 = connection.prepareStatement("Insert into employee(ename, eaddr, esal) value(?,?,?)");
			preparedStatement2 = connection.prepareStatement("Select eid,ename,eaddr,esal from employee");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}%>

<%
String action = request.getParameter("s1");
if (action.equalsIgnoreCase("register")) {
	String ename = request.getParameter("ename");
	String eaddr = request.getParameter("eaddr");
	String esal = request.getParameter("esal");

	preparedStatement1.setString(1, ename);
	preparedStatement1.setString(2, eaddr);
	preparedStatement1.setInt(3, Integer.parseInt(esal));

	int rowsAffect = preparedStatement1.executeUpdate();

	if (rowsAffect == 1) {
%>
<h1 style='color: green; text-align: center;'>EMPLOYEE REGISTERED</h1>

<%
} else {
%>
<h1 style='color: red; text-align: center;'>EMPLOYEE NOT REGISTERED</h1>
<%
}
} else {
ResultSet resultSet = preparedStatement2.executeQuery();
%>

<table bgcolor='pink' align='center' border='1'>
	<tr>
		<th>Employee ID</th>
		<th>Employee NAME</th>
		<th>Employee ADDRESS</th>
		<th>Employee SALARY</th>
	</tr>
	<%
	while (resultSet.next()) {
	%>
	<tr>
		<td><%=resultSet.getInt(1)%></td>
		<td><%=resultSet.getString(2)%></td>
		<td><%=resultSet.getString(3)%></td>
		<td><%=resultSet.getString(4)%></td>
	</tr>

	<%
	}
	%>
</table>

<h1 style='color: blue; text-align: center;'>
	<a href="./index.html">|HOME|</a>
</h1>


<%
}
%>

<%!public void jspDestroy() {
		System.out.println("Cleaning the environment...");
		try {
			if (preparedStatement1 != null) {
				preparedStatement1.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		try {
			if (preparedStatement2 != null) {
				preparedStatement2.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		try {
			if (connection != null) {
				connection.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}%>
