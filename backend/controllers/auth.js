import mongoose from 'mongoose';
import bcrypt from 'bcryptjs';


import User from '../model/user.js';

export const signUp = async (req, res, next) => {
  const session = await mongoose.startSession();
  session.startTransaction();

  try {
    const { name, phoneNumber, password } = req.body;

    // Check if a user already exists
    const existingUser = await User.findOne({ phoneNumber });

    if(existingUser) {
      const error = new Error('User already exists');
      error.statusCode = 409;
      throw error;
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const newUsers = await User.create([{ name, phoneNumber, password: hashedPassword }]);

    const userResponse = {
        _id: newUsers[0]._id,
        name: newUsers[0].name,
        phoneNumber: newUsers[0].phoneNumber,
        createdAt: newUsers[0].createdAt,
        updatedAt: newUsers[0].updatedAt
      };

    res.status(201).json({
      success: true,
      message: 'User created successfully',
      data: {
        user: userResponse ,
      }
    })
  } catch (error) {
    next(error);
  }
}

export const signIn = async (req, res, next) => {
  try {
    const { phoneNumber, password } = req.body;

    const user = await User.findOne({ phoneNumber });

    if(!user) {
      const error = new Error('User not found');
      error.statusCode = 404;
      throw error;
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);

    if(!isPasswordValid) {
      const error = new Error('Invalid password');
      error.statusCode = 401;
      throw error;
    }

    res.status(200).json({
      success: true,
      message: 'User signed in successfully',
      data: {
        user,
      }
    });
  } catch (error) {
    next(error);
  }
}

export const signOut = async (req, res, next) => {}