import Transaction from '../model/transaction.model.js';
import User from '../model/user.js';

export const addTransaction = async (req, res, next) => {


  try {
    const { userId, amount,
        reason,
        category,
        merchantName,
        transactionType,
        date, status} = req.body;

    

    
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    // Adjust balance
    let newBalance = user.currentBalance;
    if (req.body.transactionType === 'credit') {
      newBalance += amount;
    } else if (req.body.transactionType === 'debit') {
      if (user.currentBalance < amount) {
        return res.status(200).json({ success: true, message: 'Transaction will go below current amount' });
      }
      newBalance -= amount;
    }

    // Create transaction
    const transaction = new Transaction({
      user: userId,
      amount,
      reason,
      category,
      merchantName,
      transactionType,
      status,
      date
    });

    await transaction.create();

    // Update user's balance
    user.currentBalance = newBalance;
    user.Transactions.push(transaction._id);
    await user.save();



    res.status(201).json({
      success: true,
      message: 'Transaction added successfully',
      data: transaction
    });
  } catch (error) {

    next(error);
  }
};
