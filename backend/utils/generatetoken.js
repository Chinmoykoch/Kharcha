import jwt from "jsonwebtoken";
import cookieParser from "cookie-parser";

const generateTokenAndSetCookie = (userId, res) => {
    //we are going to get the response(res) and userId as arguments
    const token = jwt.sign({userId}, process.env.JWT_SECRET, {  //jwt.sign() method takes 3 arguments: payload, secretOrPrivateKey, and options
        expiresIn: '15d'
    })

    res.cookie("jwt", token, {
        maxAge:15*24*60*60*1000, //15 days  //cookie will be valid for 15 days //maxAge is in milliseconds
        httpOnly:true, //cookie is not accessible via client side script(users cannot access the cookie using document.cookie) //prevents cross-site scripting attacks (XSS)
        sameSite:"strict", //cookie will only be sent in a first-party context and not be sent along with requests initiated by third party websites //CSRF attack protection
        secure: process.env.NODE_ENV !== "development", //cookie will only be sent over https in production and not in development
    })

};

export default generateTokenAndSetCookie;