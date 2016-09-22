<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Chat Application</title>

    <script src="resources/sockjs-0.3.4.js"></script>
    <script src="resources/stomp.js"></script>
    <script type="text/javascript">
	
        var stompClient= null;
        
        function setConnected(connected) {
            document.getElementById('connect').disabled = connected;
            document.getElementById('disconnect').disabled = !connected;
            document.getElementById('response').innerHTML = '';
        }

        function connect()
        {
        	var socket = new SockJS('/tutorialspoint/register');
            stompClient = Stomp.over(socket);
        	stompClient.connect({},function(frame){
        		setConnected(true);
        		console.log('Connected'+frame);
        		/* stompClient.subscribe('/topic/showchat',function(message){
        			showChat(JSON.parse(message.body));
        				});
        			});
        	
        } */
        stompClient.subscribe('/topic/showchat',onsubscribe);
	});	
}
function onsubscribe(message){
		
	showChat(JSON.parse(message.body));
			
}
        function disconnect()
        {
        	if (stompClient != null) {
                stompClient.disconnect();
            }
            setConnected(false);
            console.log("Disconnected");
        
        }
        function sendText()
        {
        	var sender_name = document.getElementById('name').value;
        	var text = document.getElementById('input').value;
        	
            stompClient.send("/calcApp/send",{}, JSON.stringify({ 'text': text,'sender_name': sender_name }));
                  }
      
        function showChat(message) {
        var response = document.getElementById('response');
        var p = document.createElement('p');
        p.style.wordWrap = 'break-word';
        p.appendChild(document.createTextNode(message.name+" : "+message.chat));
        response.appendChild(p);
    	} 
        
    </script>
</head>
<body>

<div>
    <div>
        <button id="connect" onclick="connect();">Connect</button>
        <button id="disconnect" disabled="disabled" onclick="disconnect();">Disconnect</button><br/><br/>
    </div>
    <div id="calculationDiv">
        <label>Name: </label><br/>
        <input type="text" id="name"/><br/>
        <label>Enter Text:</label><br/>
        <input type="text" id="input"/><br/>
        <button id="sendText" onclick="sendText();">Send</button>
        <br/><br/>
        <p id="response"></p>
    </div>
</div>

</body>
</html>