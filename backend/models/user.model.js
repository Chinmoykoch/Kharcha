import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
  fullName: {
    type: String,
    required: true,
  },
  userName: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
    minlength: 6,
  },
  gender: {
    type: String,
    required: true,
    enum: ["male", "female"],
  },
  profilePic: {
    type: String,
    default: "",
  },
});

const User = mongoose.model("User", userSchema); //"User" is the name of the collection in the database and is singular
//User is the model and userSchema is the schema of the model
//if we use "User" then mongoDB will create a collection of users
//mongoDB will figure out "User" and will create a collection of users

export default User;