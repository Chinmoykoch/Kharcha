import mongoose from 'mongoose';

const EMISchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true
    },
    reason: {
      type: String,
      required: true,// e.g., "Car Loan EMI", "Laptop EMI"
    },
    amount: {
      type: Number,
      required: true // Total EMI amount
    },
    amountPaid: {
      type: Number,
      default: 0 // Tracks the total amount paid so far
    },
    interestAmount: {
      type: Number,
      required: true // Interest amount included in the EMI
    },
    timePeriod: {
      type: Number,
      required: true // Duration 
    },
    type: {
        type: String,
        enum: ['daily', 'weekly', 'monthly', 'yearly', 'random'],
        default: 'active'
      },
    status: {
      type: String,
      enum: ['active', 'completed', 'defaulted'],
      default: 'active'
    },
    merchantName: {
      type: String,
    }
  },
  { timestamps: true }
);

const EMI = mongoose.model('EMI', EMISchema);
export default EMI;

