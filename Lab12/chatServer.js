var net = require('net');
var eol = require('os').EOL;

var srvr = net.createServer();
var clientList = [];

srvr.on('connection', function(client) {
  client.name = client.remoteAddress + ':' + client.remotePort;
  client.write('Welcome, ' + client.name + eol);
  clientList.push(client);

  client.on('data', function(data) {
    var dataStr = data.toString().trim();
    // console.log(dataStr);
    var strArray = dataStr.split(' ');
    // for (var i in strArray) {
    //     console.log("String at " + i + ":" + strArray[i]);
    // }

    if (strArray[0] === '\\list') {
        for (var i in clientList) {
            if (client !== clientList[i]) {
                client.write("name: " + clientList[i].name + '\n');
            }
        }
    }
    else if (strArray[0] === '\\rename') {
        if (strArray.length !== 2) {
            client.write("Invalid, hint* \\rename <name> \n");
        }
        client.name = strArray[1];
        // console.log("new name is now " + client.name);
    } 
    else if (strArray[0] === '\\private') {
        if (strArray.length < 2) {
            client.write("Invalid, hint* \\private <name> <msg>");
        }
        var msg = [];
        for (let i = 2; i < strArray.length; i++) {
            msg.push(strArray[i]);
        }
        var msgStr = msg.join(' ') + "\n";
        // console.log("given msg " + msgStr);
        for (var i in clientList) {
            if (clientList[i].name.toString() === strArray[1]) {
                clientList[i].write(client.name + " whispers to you: " + msgStr);
            }
        }
    }
    else {
        broadcast(data, client);
    }
  });
});

function broadcast(data, client) {
    for (var i in clientList) {
        if (client !== clientList[i]) {
            clientList[i].write(client.name + " says " + data);
        }
    }
}

srvr.listen(9000);


