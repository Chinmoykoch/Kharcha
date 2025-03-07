import User from "../models/user.model.js";
import bcrypt from "bcryptjs";
import generateTokenAndSetCookie from "../utils/generatetoken.js";


//signup controller
export const signup = async (req, res) => {
  try {
    const { fullName, userName, password, confirmPassword, gender } = req.body; //to get the data from the body of the request we need some middleware in server.js

    //password check
    if (password !== confirmPassword) {
      return res.status(400).json({ error: "Passwords don't match" });
    }

    //already existing user check through userName
    const user = await User.findOne({ userName });

    if (user) {
      return res.status(400).json({ error: "Username already exists" });
    }

    
    //if everything goes right we try to create the user

    // HASH PASSWORD HERE(bcryptjs)
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);


    // https://avatar-placeholder.iran.liara.run/

    const boyProfilePic =
      `https://avatar.iran.liara.run/public/boy?username=${userName}`;
    const girlProfilePic =
      `https://avatar.iran.liara.run/public/girl?username=${userName}`;


    //creating user
    const newUser = new User({
      fullName,
      userName,
      password: hashedPassword,
      gender,
      profilePic: gender === "male" ? boyProfilePic : girlProfilePic,
    });


    //saving user to the database
    if(newUser){
      //Generate jwt token here (utils/generatetoken.js)
      generateTokenAndSetCookie(newUser._id, res);
      await newUser.save();

    res.status(201).json({
      _id: newUser._id, // _.id is the unique id of the user(mongoDB generates it) this is a standard of mongoDB and we use it to identify the user
      fullName: newUser.fullName,
      userName: newUser.userName,
      profilePic: newUser.profilePic,
    });
    }else{
      res.status(400).json({error:"Invalid user data!"});
    }


  } catch (error) {
    console.log("Error in signup controller", error.message);
    res.status(500).json({ error: "internal server error" });
  }
};



//logout controller
export const logout = (req, res) => {
  try{
    res.cookie("jwt", "", {maxAge:0}); //maxAge:0 means the cookie will be deleted
    res.status(200).json({message:"Logged out successfully"});
  }catch(error){
    console.log("Error in Logout controller", error.message);
    res.status(500).json({error: "Internal Server Error"});
  }
};



//login controller
export const login = async (req, res) => {
  try{
    const {userName, password} = req.body;
    const user = await User.findOne({userName});
    const isPasswordCorrect = await bcrypt.compare(password, user?.password || ""); //password-> password the user used to login, user.password-> password stored in the database 
    //if user?.password is null then it will be an empty string and will not throw us an error //user?.password is optional chaining

    if(!user || !isPasswordCorrect){
      return res.status(400).json({error:"Invalid usrename or password"});
    }
    //if everything goes right we try to login the user
    generateTokenAndSetCookie(user._id,res); //send the payload and the response

    res.status(200).json({
      _id: user._id,
      fullName: user.fullName,
      userName: user.userName,
      profilePic: user.profilePic
    })
  }
  catch(error){
    console.log("Error in Login controller", error.message);
    res.status(500).json({error: "Internal Server Error"});
  }
};
