ConnectionFactory = require('../../lib/connection/connection-factory')
fs = require('fs')

#require('../../lib/tedious').statemachineLogLevel = 4

connectionFactory = new ConnectionFactory()

getConfig = ->
  config = JSON.parse(fs.readFileSync(process.env.HOME + '/.tedious/test-connection.json', 'utf8'))

  config.options.debug =
    packet: true
    data: true
    payload: true
    token: false

  config

exports.badServer = (test) ->
  config = getConfig()
  config.server = 'bad-server'

  connection = connectionFactory.createConnection(config)

  connection.on('connection', (err) ->
      test.ok(err)
      test.done()
  )

exports.badPort = (test) ->
  config = getConfig()
  config.options.port = -1
  config.options.connectTimeout = 200

  connection = connectionFactory.createConnection(config)

  connection.on('connection', (err) ->
      test.ok(err)
      test.done()
  )

exports.connect = (test) ->
  config = getConfig()

  connection = connectionFactory.createConnection(config)

  connection.on('connection', (err) ->
      test.ok(!err)
      test.done()
  )

  connection.on('infoMessage', (info) ->
    console.log("#{info.number} : #{info.message}")
  )

  connection.on('debug', (text) ->
    console.log(text)
  )
