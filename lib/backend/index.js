//require express
const express = require('express');
const app = express();
//routes cors
const cors = require('cors');
const routes = require('./routes');
app.use(cors());


//routes
app.use('/api',routes);

//start server
app.listen(3000, () => {
    console.log('Server on port 3000');
});

app.get('/', (req, res) => {
    res.send('Code Yellow!');
});


// sw.getCurrentUser().then(console.log)

