const { StatusCodes } = require('http-status-codes');
const knexConfig = require('../config/knexfile');
const knex = require('knex')(knexConfig);

const initDb = async(req, res) => {
    try {
        const productsExist = await knex('products').first();
        if (productsExist) {
            return res.status(StatusCodes.CONFLICT).json({ error: 'Database already initialized' });
        }
        let products = [];
        
        if (req.headers['content-type'].includes('application/json')) {
            products = req.body;
        } else {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Invalid content type. JSON expected.' });
        }
        const validProducts = products.filter((product) =>
            product.name && product.description && product.unit_price && product.unit_weight && product.category_id
    );
    if (validProducts.length === 0) {
        return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Invalid data format' });
    }
        await knex('products').insert(products);
        res.status(StatusCodes.OK).json({ message: 'Database initialized successfully' });
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to initialize database' });
    }
};

module.exports = { initDb };
