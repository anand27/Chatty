<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<title>Login</title>

<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
	integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.1/css/font-awesome.min.css">

<!-- Optional theme -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css"
	integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp"
	crossorigin="anonymous">

<!-- Latest compiled and minified JavaScript -->
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
	integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
	crossorigin="anonymous"></script>

<style type="text/css">
h1 {
	text-align: center;
	color: white;
}

body {
	background: rgb(52, 73, 94);
}

.form-control {
	border-radius: 5px;
	background-color: rgba(8, 8, 8, 0.87);
	color: white;
}

.btn {
	border-radius: 5px;
	background: rgba(8, 8, 8, 0.87);;
	color: white;
	width: 100%;
}

form {
	background: rgba(236, 236, 236, 0.98);
	padding: 100px;
	border-radius: 5px;
	box-shadow: 0 0px 12px rgba(0, 0, 0, .74);
}
</style>
</head>
<body>
	<br />
	<h1>Hello, Welcome to Login Page</h1>
	<br />
	<div class="container">
		<div class="row">
			<div class="col-md-offset-3 col-md-6">
				<form action="login" method="POST">
					<div class="form-group">
						<label for="exampleInputUsername">Username</label>
						<div class="cols-sm-10">
							<div class="input-group">
								<span class="input-group-addon"><i class="fa fa-user fa"
									aria-hidden="true"></i></span> <input type="text" class="form-control"
									name="username" required="true"
									placeholder="Enter your Username">
							</div>
						</div>
					</div>
					<div class="form-group">
						<label for="exampleInputPassword1">Password</label>
						<div class="cols-sm-10">
							<div class="input-group">
								<span class="input-group-addon"><i
									class="fa fa-lock fa-lg" aria-hidden="true"></i></span> <input
									type="password" class="form-control" name="password"
									required="true" placeholder="Enter your Password">
							</div>
						</div>
					</div>
					<div class="form-group">
						<button type="submit" class="btn btn-default">Submit</button>
					</div>

					<center>
						<font color="red"><c:if test="${not empty param['error']}">
								<c:out value="${SPRING_SECURITY_LAST_EXCEPTION.message}" />
							</c:if> </font>
					</center>
					<a class="btn btn-default" href="register" role="button">Register</a>
					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />
				</form>

			</div>
		</div>
	</div>
	<center>
		<!-- <h1>Enter your credentials</h1> -->

		<%-- <form action="login" method="POST">
		<table>
			<tr>
				<td>Username:</td>
				<td><input type="text" name="username" value=''/></td>
			</tr>
			<tr>
				<td>Password:</td>
				<td><input type="password" name="password" /></td>
			</tr>
			<tr>
				<td align="center" colspan="2"><input type="submit" value="Login"/></td>
			</tr>
		</table>
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	</form> --%>
</body>
</html>