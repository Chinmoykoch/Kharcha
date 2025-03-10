import { Router } from 'express';
import { addTransaction } from '../controllers/transaction.js';


const transactionRouter = Router();

transactionRouter.post('/addtransaction', addTransaction);


export default transactionRouter;