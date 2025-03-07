//package imports
import express from 'express';
import dotenv from 'dotenv';

//file imports
import authRoutes from './routes/auth.routes.js';
import connectToMongoDB from './db/connectToMongoDB.js';


const app = express();
const PORT = process.env.PORT || 5054;



dotenv.config();

//middleware to extract user data from req.body
app.use(express.json());//to parse the incoming request with JSON payloads (from req.body)

//middleware for route
app.use('/api/auth', authRoutes);


// app.get('/', (req, res) => {
     //root route http://localhost:5054/
//     res.send('Hello World 2');
// })

//adding some routes for authentication   //-> write inside middlewares

// app.get('/api/auth/signup', (req, res)=>{
//   res.send('Signup Route');
// })  






app.listen(PORT, ()=> {
    connectToMongoDB();
    console.log(`Server is running on port ${PORT}`);
})