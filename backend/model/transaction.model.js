import mongoose from 'mongoose';

const TransactionSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true
    },
    amount: {
      type: Number,
      required: true
    },
    reason: {
      type: String,
      trim: true
    },
    category: {
      type: String,
      trim: true
    },
    date: {
      type: Date,
      default: Date.now
    },
    time: {
      type: String, 
      default: new Date().toLocaleTimeString()
    },
    merchantName: {
      type: String,
      trim: true
    },
    status: {
      type: String,
      enum: ['pending', 'completed', 'failed'],
      default: 'completed'
    },
    transactionType: {
      type: String,
      enum: ['credit', 'debit'],
      default: "debit"
    }
  },
  { timestamps: true }
);

const Transaction = mongoose.model('Transaction', TransactionSchema);
export default Transaction;
