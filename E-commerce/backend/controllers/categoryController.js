const knexConfig = require('../config/knexfile');
const knex = require('knex')(knexConfig);
const { StatusCodes } = require('http-status-codes');

const getAllCategories = async (req, res) => {
    try {
        const categories = await knex.select('*').from('categories').orderBy('id');
        res.status(StatusCodes.OK).json(categories);
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to fetch categories' });
    }
};


module.exports = { getAllCategories };
