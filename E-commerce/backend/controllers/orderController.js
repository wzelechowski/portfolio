const knexConfig = require('../config/knexfile');
const knex = require('knex')(knexConfig);
const { StatusCodes } = require('http-status-codes');

const getAllOrders = async(req, res) => {
    try {
        const orders = await knex.select('*').from('orders');
        if(orders.length < 1) return res.status(StatusCodes.NOT_FOUND).json({ error: 'There is not any orders' }); 
        return res.status(StatusCodes.OK).json(orders);
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to fetch orders' })
    }
};

const getAllOrderItems = async(req, res) => {
    try {
        const orders = await knex.select('*').from('order_items');
        if(orders.length < 1) return res.status(StatusCodes.NOT_FOUND).json({ error: 'There is not any orders' }); 
        return res.status(StatusCodes.OK).json(orders);
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to fetch orders' })
    }
};

const getOrderItem = async(req, res) => {
    try {
        const { id } = req.params;
        const order = await knex.select('*').from('orders_items').where({ id });
        if(!order[0]) return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Order not found' });
        if(order[0].username !== req.user.username && req.user.role === 'CUSTOMER') return res.status(StatusCodes.FORBIDDEN).json({ error: 'You can only get your own orders' });
        return res.status(StatusCodes.OK).json(order);
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: `Failed to fetch order` });
    }
};


const getOrdersByUsername = async(req, res) => {
    try {
        const { username } = req.params;
        const orders = await knex.select('*').from('orders').where({ username });
        if(orders.length < 1) return res.status(StatusCodes.NOT_FOUND).json({ error: 'This user have no orders or does not exists' } );
        if(username !== req.user.username && req.user.role === 'CUSTOMER') return res.status(StatusCodes.FORBIDDEN).json({ error: 'You can only get your own orders' });
        return res.status(StatusCodes.OK).json(orders);
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: `Failed to fetch orders` });
    }
};

const getOrdersByStatus = async(req, res) => {
    try {
        const { status_id } = req.params;
        const [orders] = await knex.select('*').from('orders').where({ status_id, username: req.user.username });
        if(!orders) return res.status(StatusCodes.NOT_FOUND).json({ error: 'No orders found with this status'});
        return res.status(StatusCodes.OK).json(orders);
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: `Failed to fetch orders status` })
    }
};

const getOrder = async(req, res) => {
    try {
        const { id } = req.params;
        const order = await knex.select('*').from('orders').where({ id });
        if(!order[0]) return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Order not found' });
        if(order[0].username !== req.user.username && req.user.role === 'CUSTOMER') return res.status(StatusCodes.FORBIDDEN).json({ error: 'You can only get your own orders' });
        return res.status(StatusCodes.OK).json(order);
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: `Failed to fetch order` });
    }
};

const changeOrderStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const { status_id } = req.body;
        if (!status_id) {
            return res.status(StatusCodes.BAD_REQUEST).json({ e: 'Status is required' });
        }

        const currentOrder = await knex.select('*').from('orders').where({ id });
        if(currentOrder.length < 1) return res.status(StatusCodes.NOT_FOUND).json({ error: 'Order not found' })
        if(currentOrder[0].status_id === 3) return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Order is already cancelled' });
        if(currentOrder[0].status_id === req.body.status_id) return res.status(StatusCodes.BAD_REQUEST).json({ error: 'New status ID is the same as before' });
        if(currentOrder[0].status_id > req.body.status_id) return res.status(StatusCodes.BAD_REQUEST).json({ error: 'You cannot undo order status' })
        if(req.body.status_id < 1 || req.body.status_id > 4) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Invalid status ID' });
        }
        if(req.body.status_id === 2) {
            const date = new Date();
            const updated = await knex('orders').where({ id }).update({ status_id, confirmation_date: date });
            if (!updated) return res.status(StatusCodes.NOT_FOUND).json({ error: 'Order not found' });
        } else {
            let updated;
            if(currentOrder[0].confirmation_date === null) {
                const date = new Date();
                updated = await knex('orders').where({ id }).update({ status_id, confirmation_date: date });
            } else {
                updated = await knex('orders').where({ id }).update({ status_id });
            }
            if (!updated) return res.status(StatusCodes.NOT_FOUND).json({ error: 'Order not found' });
        }


        return res.status(StatusCodes.OK).json({ id: id, message: 'Order status updated' });
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to update order status' });
    }
};



const addOrder = async (req, res) => {
    try {
        const { phone_number, products, discount = 0, email } = req.body;
        const username = req.user.username;
        const validationError = orderValidation(req, res);
        if (validationError) return;
        if (!Array.isArray(products) || products.length === 0) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Products array is required and cannot be empty' });
        }
        
        const discountRegex = /^(?:0(?:\.[0-9]{1,2})?)$/;
        if(!discountRegex.test(discount)) return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Invalid discount. Discount have to be between 0 and 1 (excluded)' })

        const [orderId] = await knex('orders').insert({
            confirmation_date: null,
            status_id: 1,
            username,
            email: email,
            phone_number,
        });

        console.log('siema')
        const orderItems = [];

        for (const product of products) {
            const { product_id, quantity } = product;

            const quantityRegex = /^[1-9]\d*$/;
            if (!quantityRegex.test(quantity)) {
                return res.status(StatusCodes.BAD_REQUEST).json({ error: `Invalid quantity for product with ID ${product_id}` });
            }

            const productDetails = await knex('products').select('id', 'unit_price').where('id', product_id).first();

            if (!productDetails) {
                return res.status(StatusCodes.NOT_FOUND).json({ error: `Product with ID ${product_id} not found` });
            }

            orderItems.push({
                order_id: orderId,
                product_id: productDetails.id,
                quantity: quantity || 1,
                price: productDetails.unit_price * (1 - discount) * quantity,
                discount: discount,
            });
        }

        await knex('order_items').insert(orderItems);

        return res.status(StatusCodes.CREATED).json({ id: orderId, message: 'Order added successfully' });
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to add an order' });
    }
};



const orderValidation = (req, res) => {
    // if (!req.body.username || !req.body.username.trim()) {
    //     return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Username cannot be empty' });
    // }

    if (!req.body.email || !req.body.email.trim()) {
        return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Email cannot be empty' });
    }

    if (!req.body.phone_number || !req.body.phone_number.trim()) {
        return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Phone number cannot be empty' });
    }
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(req.body.email)) {
        return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Invalid email format' });
    }

    const phoneRegex = /^[0-9]{3}(-[0-9]{3}){2}$/;
    if (!phoneRegex.test(req.body.phone_number)) {
        return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Invalid phone number format' });
    }

    return null;
}


const addOpinion = async (req, res) => {
    const orderId = req.params.id;
    const { rating, content } = req.body;
    const username = req.user.username;

    if (rating < 1 || rating > 5 || !Number.isInteger(rating)) {
        return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Rating must be an integer between 1 and 5' });
    }

    if (!content || content.trim() === '') {
        return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Content cannot be empty' });
    }

    try {
        const order = await knex('orders').where('id', orderId).first();
        if (!order) {
            return res.status(StatusCodes.NOT_FOUND).json({ error: 'Order not found' });
        }

        if (order.status_id !== 3 && order.status_id !== 4) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Order must be completed or canceled to add an opinion' });
        }

        if (order.username !== username) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'You can give opinion only to your orders' });
        }

        const existingOpinion = await knex('opinions').where('order_id', orderId).andWhere('username', username).first();
        if (existingOpinion) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'You have already added an opinion for this order' });
        }

        await knex('opinions').insert({
            order_id: orderId,
            username: username,
            rating: rating,
            content: content
        });

        res.status(StatusCodes.CREATED).json({ message: 'Opinion added successfully', username: req.user.name });
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to add opinion' });
    }
};

const getOpionions = async(req, res) => {
    try {
        const { order_id } = req.params;
        const opinions = await knex.select('*').from('opinions').where({ order_id });
        if(opinions.length < 1) return res.status(StatusCodes.NOT_FOUND).json({ error: 'This order have not any opinions yet' });
        res.status(StatusCodes.OK).json(opinions);
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to fetch opinions' });
    }
}

const getAllOpinions = async (req, res) => {
    try {
        const opinions = await knex.select('*').from('opinions');
        
        if (opinions.length < 1) {
            return res.status(StatusCodes.NOT_FOUND).json({ error: 'No opinions available' });
        }

        res.status(StatusCodes.OK).json(opinions);
    } catch (error) {
        console.error(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to fetch opinions' });
    }
};


module.exports = {
    getAllOrders,
    getAllOrderItems,
    getOrderItem,
    getOrdersByUsername,
    getOrdersByStatus,
    getOrder,
    changeOrderStatus,
    addOrder,
    addOpinion,
    getOpionions,
    getAllOpinions,
};
