const express = require('express');
const cors = require('cors');
const productRouter = require('./routers/productRouter');
const categoryRouter = require('./routers/categoryRouter');
const orderRouter = require('./routers/orderRouter');
const statusRouter = require('./routers/orderstatusRouter');
const authRouter = require('./routers/authRouter');
const initRouter = require('./routers/initRouter');
const app = express();
app.use(cors());

app.use(express.json());
app.use('/products', productRouter);
app.use('/categories', categoryRouter);
app.use('/orders', orderRouter);
app.use('/status', statusRouter);
app.use('/auth', authRouter);
app.use('/init', initRouter);

app.listen(3000, () => {
    console.log(`Server is running on http://localhost:3000`);
});
