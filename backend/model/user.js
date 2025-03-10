import mongoose from 'mongoose';

const UserSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true
    },
    phoneNumber:{
      type: String,
      unique: true,
      trim: true
    },
    email: {
      type: String,
      trim: true
    },
    password: {
      type: String,
      required: true
    },
    currentBalance: {
      type: Number,
      default: 0
    },
    Transactions: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Transaction'
      }
    ],
    emis: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'EMI'
      }
    ]
  },
  { timestamps: true }
);

const User = mongoose.model('User', UserSchema);

export default User;
