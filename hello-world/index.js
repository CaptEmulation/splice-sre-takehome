const { createServer } = require('http')
const server = createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' })
  res.write('Hello Splice')
  res.end()
})
server.listen(80)