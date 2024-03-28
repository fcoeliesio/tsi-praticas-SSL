const express = require("express");
const https = require("https");
const fs = require("fs");

const app = express();

const PORT = 8000;

app.get("/", (req, res) => {
  res.status(200);
  res.send("Hello World!");
});

https
  .createServer(
    {
      cert: fs.readFileSync("../certificates/cert.pem"),
      key: fs.readFileSync("../certificates/key.pem"),
    },
    app
  )
  .listen(PORT);
console.log(`Listening on port ${PORT}`);
