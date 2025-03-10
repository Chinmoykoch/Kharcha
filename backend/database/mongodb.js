import mongoose from 'mongoose';





  const connectToDatabase = async () => {
    try {

        await mongoose.connect("mongodb+srv://zorochan404:admin@cluster0.otz5c.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
        console.log(`Connected to database in development mode`);
    }catch(error){
        console.error('Error connecting to database: ', error);
        process.exit(1);
    }
};

export default connectToDatabase;