What changed in this version?

Used ([chokidar](https://github.com/paulmillr/chokidar)) for watching files. And instead of watching files, the harvester.conf file will be configured to watch folders.

```
exports.config = {
  nodeName: "application_server",
  logStreams: {
    Folder1: "/home/Folder1",
    Folder2" "/var/Folder2"
  },
  server: {
    host: '0.0.0.0',
    port: 28777
  }
}
```

Chokidar has the option of exluding files/folders that will not be watched. Currently, this is set in the harverster.js file but in the future this option will be retrieved from the harvester.conf file.

Next steps:
- Read chokidar options from harvester.conf file
- Update dependencies since some functionalities are already deprecated
- Make changes to the UI


Log.io - Real-time log monitoring in your browser
=================================================

Powered by [node.js](http://nodejs.org) + [socket.io](http://socket.io)

## How does it work?

*Harvesters* watch log files for changes, send new log messages to the *server* via TCP, which broadcasts to *web clients* via socket.io.

Log streams are defined by mapping file paths to a stream name in harvester configuration.

Users browse streams and nodes in the web UI, and activate (stream, node) pairs to view and search log messages in screen widgets.

## Install Server & Harvester

1) Install via npm

    npm install -g log.io --user "ubuntu"

2) Run server

    log.io-server

3) Configure harvester

    nano ~/.log.io/harvester.conf

4) Run harvester

    log.io-harvester

5) Browse to http://localhost:28778

## Server TCP Interface

Harvesters connect to the server via TCP, and write properly formatted strings to the socket.  Third party harvesters can send messages to the server using the following commands:

Send a log message

    +log|my_stream|my_node|info|this is log message\r\n

Register a new node

    +node|my_node\r\n

Register a new node, with stream associations

    +node|my_node|my_stream1,my_stream2\r\n

Remove a node

    -node|my_node\r\n

## Credits

- Mike Smathers &lt;msmathers@narrativescience.com&gt; ([msmathers](http://github.com/msmathers))

- Narrative Science http://narrativescience.com ([NarrativeScience](http://github.com/NarrativeScience))

## Acknowledgements

- Jeremy Ashkenas ([jashkenas](https://github.com/jashkenas))

- Guillermo Rauch &lt;guillermo@learnboost.com&gt; ([Guille](http://github.com/guille))

- Ryan Dahl &lt;ry at tiny clouds dot org&gt; ([ry](https://github.com/ry)) + Joyent http://www.joyent.com/ ([joyent](https://github.com/joyent/))

- [turtlebender](http://github.com/turtlebender)

- [jdrake](http://github.com/jdrake)

## License

Copyright 2013 Narrative Science &lt;contrib@narrativescience.com&gt;

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
