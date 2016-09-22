<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

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

<title>Registration Page</title>
</head>
<body>
	<br />
	<h1>Enter your Details</h1>
	<br />
	<div class="container">
		<div class="row">
			<div class="col-md-offset-3 col-md-6">
				<form action="registration" method="POST">
					<div class="form-group">
						<label for="exampleInputUsername">Enter Username</label>
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
						<label for="exampleInputPassword1">Enter Password</label>
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
						<label for="exampleInputPassword2">Confirm Password</label>
						<div class="cols-sm-10">
							<div class="input-group">
								<span class="input-group-addon"><i
									class="fa fa-lock fa-lg" aria-hidden="true"></i></span> <input
									type="password" class="form-control" name="password2"
									required="true" placeholder="Confirm your Password">
							</div>
						</div>
					</div>
					<div class="form-group">
						<button type="submit" class="btn btn-default">Submit</button>
					</div>


					<center>
						<font color="red"><c:if test="${not empty error}">
								<c:out value="${error}" />
							</c:if> </font>
					</center>

					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />
				</form>
</body>
</html>