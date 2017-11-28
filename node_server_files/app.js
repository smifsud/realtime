/*
Copyright 2017 Material Cause LLC

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction, 
including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial 
portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/


var express = require('express');
var connection = require('./connection');
var bodyParser = require ('body-parser');
var app = express();
var socketserver = require('http').createServer();
var io = require('socket.io')(socketserver);
var socketClientsArray = [];
connection.init();

// GET call to retrieve that headlines associated with the newsgroups the user belongs to
app.get ('/headlines', function (request, response){
connection.acquire(function(err, con) 
    {
       con.query('SELECT newsgroupID,newsgroup,headline from headlines JOIN newsgroups ON headlines.newsgroupID = newsgroups.id where newsgroupID = (SELECT newsgroup_id FROM user_newsgroups where user_id = (SELECT userID FROM users where token = ?))' , [request.query.token], function(err, rows, fields)
      {     
      		response.send({headlines: rows});
          	con.release();
         })
      });
});

// POST call to add a headline into a newsgroup
app.post('/headline', function(request, response) {
connection.acquire(function(err, con) 
    {
     con.query('INSERT INTO headlines VALUES (null,?,?)' , [request.query.newsgroup,request.query.headline], function(err, rows, fields)
      {     
      		response.send({message: "record inserted"});
          	con.release();
          	emitHeadlineEvent();
         })
      });
});

// check to see if a connected token is inside a usergroup, if so emit an update that headline has been updated
function emitHeadlineEvent()
{
	connection.acquire(function(err, con) 
    {
    // query to see the tokens associated with users that are in a newgroup
     con.query('SELECT DISTINCT user_id, users.token FROM user_newsgroups JOIN users ON user_newsgroups.user_id = users.userID' , function(err, rows, fields)
      {     
      		var headlineTokensArray = [];
      		var connectedTokensArray = [];
      		var connectedSocketsArray = [];
      		var socketsToGetEventArray = [];

      		rows.forEach(function(value)
      		{
      			// put query values into an array to compare with tokens that are connected
      			headlineTokensArray.push (value.token);
      		})
      		con.release(); // release database connection while we iterate through the arrays
      		
      		socketClientsArray.forEach(function(value)
			{
				connectedSocketsArray.push (value.socketid);
				connectedTokensArray.push (value.token);
			});

      		// now compare headline yokens from database to those client tokens that are connected with a live socket
      		let connectionsToReceiveArray = connectedTokensArray.filter((n) => headlineTokensArray.includes(n))
      		
      		connectionsToReceiveArray.forEach(function(value)
			{
				socketClientsArray.forEach(function(socket_value)
				{
					//if there is a match on the token, loop through the connection objects to get the socketID
					if (value == socket_value.token)
					{
						// check this is a connected socketID
 						if (io.sockets.connected[socket_value.socketid]) 
      					{
      						// if checks out that this is a connected socket emit the event to socketID
   			 				io.sockets.connected[socket_value.socketid].emit('headlines_updated');
						};
						
						// print to console current socket being emitted to
						console.log (socket_value.socketid);
					}
				})
			});
    })
  });
};

// event called on Socket.IO connection
io.on('connect', function(client)
{
	// incoming parameters
	var clientID = client.id;
	var token = client.handshake.query.token;
	console.log ("connected: " + client.id); // print to console the incoming socket ID

	// remove any existing socket connections from array that are
	// different than the incoming token

	for (var i = 0; i < socketClientsArray.length; i++) 
	{
   		if (socketClientsArray[i].token == token)
 		{
 			if (i > -1) 
 			{
    			socketClientsArray.splice(i, 1);
			};
		};
	};

	// create an object with the socketID and the token that's associated with
	var clientConnection = {};
	clientConnection.socketid = clientID;
	clientConnection.token = token;
	socketClientsArray.push(clientConnection);
})

socketserver.listen(8080); // Socket.IO, port 8080
app.listen (3000); // API, port 3000

