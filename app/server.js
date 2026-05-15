const express = require('express');
const app = express();
const port = 80;

app.get('/', (req, res) => {
    res.send(`
    <html>
      <body style="background-color: #0d1117; color: #58a6ff; text-align: center; font-family: sans-serif; padding-top: 20%;">
        <h1>🚀 Containerization Complete!</h1>
        <p>This Node.js API is running securely inside an isolated Docker Container.</p>
      </body>
    </html>
  `);
});

app.listen(port, () => {
    console.log(`App running on port ${port}`);
});