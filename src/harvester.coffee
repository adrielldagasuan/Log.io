### Log.io Log Harvester

Watches local files and sends new log message to server via TCP.

# Sample configuration:
config =
  nodeName: 'my_server01'
  logStreams:
    web_server: [
      '/var/log/nginx/access.log',
      '/var/log/nginx/error.log'
    ],
  server:
    host: '0.0.0.0',
    port: 28777

# Sends the following TCP messages to the server:
"+node|my_server01|web_server\r\n"
"+bind|node|my_server01\r\n"
"+log|web_server|my_server01|info|this is log messages\r\n"

# Usage:
harvester = new LogHarvester config
harvester.run()

###

fs = require 'fs'
net = require 'net'
events = require 'events'
winston = require 'winston'
chokidar = require 'chokidar'
Tail = require('tail').Tail

###
LogStream is a group of local files paths.  It watches each file for
changes, extracts new log messages, and emits 'new_log' events.

###
class LogStream extends events.EventEmitter
  constructor: (@name, @path, @_log) ->

###
LogHarvester creates LogStreams and opens a persistent TCP connection to the server.

On startup it announces itself as Node with Stream associations.
Log messages are sent to the server via string-delimited TCP messages

###
class LogHarvester
  constructor: (config) ->
    {@nodeName, @server} = config
    @delim = config.delimiter ? '\r\n'
    @_log = config.logging ? winston
    @logStreams = (new LogStream s, path, @_log for s, path of config.logStreams)

  LogHarvester::run = ->
    _this = this
    @_connect()
    @logStreams.forEach (stream) ->
      console.log stream
      watcher = chokidar.watch(stream.path,
        ignored: /(^|[\/\\])\../
        ignoreInitial: true
        persistent: true)
      watcher.on 'add', (file) ->
        console.log file + ' was added'
        tail = new Tail(file)
        tail.on 'line', (data) ->
          console.log data
          if _this._connected
            return _this._sendLog(stream, data)
          return
        return
      return
    return

  _connect: ->
    # Create TCP socket
    @socket = new net.Socket
    @socket.on 'error', (error) =>
      @_connected = false
      @_log.error "Unable to connect server, trying again..."
      setTimeout (=> @_connect()), 2000
    @_log.info "Connecting to server..."
    @socket.connect @server.port, @server.host, =>
      @_connected = true

  _sendLog: (stream, msg) ->
    @_log.debug "Sending log: (#{stream.name}) #{msg}"
    @_send '+log', stream.name, @nodeName, 'info', msg

  _send: (mtype, args...) ->
    @socket.write "#{mtype}|#{args.join '|'}#{@delim}"

exports.LogHarvester = LogHarvester
