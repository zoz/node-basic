express = require('express')
app = express.createServer()

app.get '/', (req, res) ->
  res.send layoutSimple()

layoutSimple = (simpleValue) -> '''  
<html>
<head>
  <title>Node Basic Template</title>
</head>
<body>
<div style="width: 100%;">
  Node Basic Template
</div>
</body>
</html>
'''

app.listen 3000

# keep this log message so that our ops scripts can detect when node has started
# make sure it is at the end of the file so all errors messages are seen
console.log 'node started\n'
