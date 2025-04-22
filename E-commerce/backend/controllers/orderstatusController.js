const knexConfig = require('../config/knexfile');
const knex = require('knex')(knexConfig);
const { StatusCodes } = require('http-status-codes');

const getOrderStatuses = async(req, res) => {
    try {
        const orderStatus = await knex.select('*').from('order_statuses').orderBy('id');
        res.status(StatusCodes.OK).json(orderStatus);
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to fetch Order Statuses'});
    }
}

module.exports = { getOrderStatuses };
