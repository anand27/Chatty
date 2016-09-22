<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<title>Chat Application</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
	integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
	crossorigin="anonymous">

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

<!-- for select menu -->

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<style type="text/css">
#nav {
	width: 100%;
}

#right {
	float: right;
	width: 100px;
	color: white;
	margin-right: 9px;
}

#center {
	margin: 0 auto;
	width: 200px;
	color: white;
}

h4 {
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
	background: rgba(8, 8, 8, 0.87);
	color: white;
	width: 100%;
}

.form {
	background: rgba(236, 236, 236, 0.98);
	padding: 30px;
	border-radius: 5px;
	box-shadow: 0 0px 12px rgba(0, 0, 0, .74);
}
</style>
<script src="resources/sockjs-0.3.4.js"></script>
<script src="resources/stomp.js"></script>
<script type="text/javascript">
	var stompClient = null;
	var subscriptions = {};
	function connect() {
		var socket = new SockJS('/tutorialspoint/register');
		stompClient = Stomp.over(socket);
		stompClient.connect({}, function(frame) {
			console.log('Connected' + frame);
			stompClient.subscribe('/user/queue/private', function(message) {
				console.log('message ' + message.body);
				showChat(message.body);
			});
			stompClient.subscribe('/topic/publicgroups', function(message) {
				showgroups(message.body);
			});
			stompClient.subscribe('/topic/public', function(message) {
				showusers(message.body);
			});

			stompClient.subscribe('/user/queue/groupnames', function(message) {
				getGroups(message.body);
			});
			stompClient.send("/calcApp/send9", {}, "");

			stompClient.send("/calcApp/send8", {}, "");
			stompClient.send("/calcApp/send7", {}, "");
		});
	}
	function getGroups(message) {
		var message = message.replace("[", "");
		var message = message.replace("]", "");
		var res = message.split(", ");
		var i;
		for (i = 0; i < res.length; i++) {
			subscriptions[res[i]] = stompClient.subscribe('/topic/' + res[i],
					function(message) {
						showChat(message.body);
					});
		}
		showjoinedgroups();
	}
	function disconnect() {
		if (stompClient != null) {
			stompClient.disconnect();
		}
		console.log("Disconnected");
	}
	function sendText() {
		/* var sender_name = document.getElementById('name').value; */
		var text = document.getElementById('input').value;
		var receiver_name = document.getElementById('receiver').value;

		/* var group='false';
		if(receiver_name in subscriptions)
			{
				group='true';
			}
		stompClient.send("/calcApp/send3",{}, JSON.stringify({ 'text': text,'receiver_name' : receiver_name, 'group':group}));
		 */
		var group = false;
		var e = document.getElementById("selectoption");
		var strUser = e.options[e.selectedIndex].value;
		if (strUser == "user") {
			stompClient.send("/calcApp/send3", {}, JSON.stringify({
				'text' : text,
				'receiver_name' : receiver_name,
				'group' : group
			}));
		}
		if (strUser == "group" && (receiver_name in subscriptions)) {
			group = true;
			stompClient.send("/calcApp/send3", {}, JSON.stringify({
				'text' : text,
				'receiver_name' : receiver_name,
				'group' : group
			}));
		}
	}

	function showChat(message) {
		var text = document.getElementById('chats').value;
		if (text) {
			text = text + "\r\n" + message;
		} else {
			text = message;
		}
		document.getElementById('chats').value = text;
	}

	function creategroup() {
		var groupname = document.getElementById('creategroupname').value;
		if (!(groupname in subscriptions)) {
			subscriptions[groupname] = stompClient.subscribe('/topic/'
					+ groupname, function(message) {
				console.log('message ' + message.body);
				showChat(message.body);
			});
			stompClient.send("/calcApp/send5", {}, groupname);
		}
		showjoinedgroups();
	}
	function leavegroup() {
		var groupname = document.getElementById('leavegroupname').value;
		if (groupname in subscriptions) {
			subscriptions[groupname].unsubscribe();
			stompClient.send("/calcApp/send6", {}, groupname);
			delete subscriptions[groupname];
		}
		showjoinedgroups();
	}
	function showgroups(message) {
		var message = message.replace("[", "");
		var message = message.replace("]", "");
		var message = message.replace(/,/g, "<br />");
		if (message == "") {
			message = "No Groups Available";
		}
		document.getElementById('groups').innerHTML = message;
	}

	function showusers(message) {

		var message = message.replace("${username}<br />", "");
		if (message == "") {
			message = "No Online Users";
		}
		document.getElementById('users').innerHTML = message;

		/* var message = message.replace("${username}", "");
		var message = message.replace("[", "");
		var message = message.replace("]", "");
		var message = message.replace(/,/g, "<br />");
		if(message=="")
		{
		message="No Online Users";
		}
		document.getElementById('users').innerHTML=message;   */
	}

	function showjoinedgroups() {

		var text = "";
		for ( var key in subscriptions) {
			if (subscriptions.hasOwnProperty(key)) {
				text = text + "<br />" + key;
			}
		}
		if (text == "<br />") {
			text = "No Groups Joined";
		}
		document.getElementById('joinedgroups').innerHTML = text;
	}
</script>
</head>


<body onload="connect();">
	<div id="nav">
		<div id="right">
			<a class="btn btn-default" onclick="disconnect();" href="logout"
				role="button">Logout</a>
		</div>
		<div id="center">
			<h3>Welcome ${username}</h3>
		</div>
	</div>


	<div class="container">
		<div class="row">
			<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">

				<div class="form">
					<div class="form-group">
						<label>Create or Join a Group :</label> <input type="text"
							class="form-control" id="creategroupname"
							placeholder="Enter name of group" />
						<center>
							<button id="creategroup" onclick="creategroup();"
								class="btn btn-default">Submit</button>
							<br />
						</center>
					</div>
					<div class="form-group">
						<label>Leave a Group :</label> <input type="text"
							class="form-control" id="leavegroupname"
							placeholder="Enter name of group" />
						<center>
							<button id="leavegroup" onclick="leavegroup();"
								class="btn btn-default">Submit</button>
							<br />
						</center>
					</div>
				</div>
			</div>

			<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
				<div class="form">
					<div class="form-group">
						<label>Enter Text :</label> <input type="text"
							class="form-control" id="input" placeholder="Enter Text Here" />
					</div>
					<div class="form-group">
						<label>Select :</label> <select class="form-control"
							id="selectoption">
							<option value="user">User</option>
							<option value="group">Group</option>
						</select>
					</div>
					<div class="form-group">
						<label>Send To :</label> <input type="text" class="form-control"
							id="receiver" placeholder="Enter destination" />
					</div>
					<center>
						<button id="sendText" onclick="sendText();"
							class="btn btn-default">Submit</button>
						<br />
					</center>
				</div>
			</div>


			<div class="col-lg-6 col-md-6 col-sm-10 col-xs-12">
				<div class="form">
					<div class="form-group">
						<textarea class="form-control" rows="10" id="chats"></textarea>
					</div>
				</div>
			</div>
		</div>


		<div class="row">

			<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12"">
				<h4>Joined Groups</h4>
				<div class="form">
					<div class="form-group">
						<div id="joinedgroups"></div>

					</div>
				</div>
			</div>


			<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12"">
				<h4>Show Online Users</h4>
				<div class="form">
					<div class="form-group">
						<div id="users"></div>
					</div>
				</div>
			</div>
			<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12"">
				<h4>Show Groups</h4>
				<div class="form">
					<div class="form-group">
						<div id="groups"></div>
					</div>
				</div>
			</div>
		</div>
	</div>








	<!-- <label>Create or Join a Group :</label><br/>
        	<input type="text" id="creategroupname"/><br/>
        	<button id="creategroup" onclick="creategroup();">Submit</button><br/>
        	<label>Leave a Group :</label><br/>
        	<input type="text" id="leavegroupname"/><br/>
        	<button id="leavegroup" onclick="leavegroup();">Submit</button>
<table>
	<tr>
		<td>    
			<div id="calculationDiv" align="left">
        	<label>Name: </label><br/>
        	<input type="text" id="name"/><br/>
        	<label>Enter Text:</label><br/>
        	<input type="text" id="input"/><br/>
        	<label>Send To :</label><br/>
        	<input type="text" id="receiver"/><br/>
        	<button id="sendText" onclick="sendText();">Send</button>   
        	</div>
		</td>
		<td>
			<div style="padding-left: 200px;"><h4>Joined Groups</h4><br/><div id="joinedgroups"></div></div>
		</td>
		<td>
			<div style="padding-left: 200px;"><h4>Show Online Users</h4><br/><div id="users"></div></div>
		</td>
		<td>
			<div style="padding-left: 200px;"><h4>Show Groups</h4><br/><div id="groups"></div></div>
		</td>
	</tr>
</table> -->


	<!-- 
<button type="button" class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal">
  Launch demo modal
</button>

<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Modal title</h4>
      </div>
      <div class="modal-body">
        ...
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div>
  </div>
</div> -->
</body>
</html>