const knexConfig = require('../config/knexfile');
const knex = require('knex')(knexConfig);
const { StatusCodes } = require('http-status-codes');
const api = require('../.env');
const axios = require('axios');

const getAllProducts = async(req, res) => {
    try {
        const products = await knex.select('*').from('products');
        res.status(StatusCodes.OK).json(products);
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to fetch products' });
    }
};

const getProduct = async(req, res) => {
    try {
        const { id } = req.params;
        const [product] = await knex.select('*').from('products').where({ id });
        if (!product) return res.status(StatusCodes.NOT_FOUND).json({ error: 'Product not found' });
        return res.status(StatusCodes.OK).json(product);
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to fetch a product' });
    }
};

const addProduct = async(req, res) => {
    try {
        const { name, description, unit_price, unit_weight, category_id } = req.body;
        const validationError = productValidation(req, res);
        if (validationError) return;
        const [id] = await knex('products').insert({name, description, unit_price, unit_weight, category_id});
        if([id]) return res.status(StatusCodes.CREATED).json({ id: id, message: 'Product added successfully' });
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to add product'})
    }
}

const updateProduct = async(req, res) => {
    try {
        const { id } = req.params;
        const { name, description, unit_price, unit_weight, category_id } = req.body;
        const updateData = {};
        const validationError = productValidation(req, res);
        if (validationError) return;

        if (name) updateData.name = name;
        if (description) updateData.description = description;
        if (unit_price) updateData.unit_price = unit_price;
        if (unit_weight) updateData.unit_weight = unit_weight;
        if (category_id) updateData.category_id = category_id;
        
        const updated = await knex('products').where({ id }).update(updateData);
        if (updated) return res.status(StatusCodes.OK).json({ id: id, message: 'Product updated' });
        else return res.status(StatusCodes.NOT_FOUND).json({ error: 'Product not found'});
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to update product' })
    }
};

const productValidation = (req, res) => {
    if(typeof req.body.unit_price === 'string') {
        req.body.unit_price = parseFloat(req.body.unit_price);
    }
    
    if(typeof req.body.unit_weight === 'string') {
        req.body.unit_weight = parseFloat(req.body.unit_weight);
    }

    const decimalRegex = /^[0-9]\d*(\.\d{1,2})?$/;
    if(!decimalRegex.test(req.body.unit_price)) return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Invalid unit price format' });
    if(!decimalRegex.test(req.body.unit_weight)) return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Invalid unit weight format' });
    
    if(req.body.unit_price < 0 || req.body.unit_weight < 0) return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Unit price and weight cannot be negative' });
    if(req.body.unit_price === 0 || req.body.unit_weight === 0) return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Unit price and weight cannot be 0' });
    if(!req.body.name.trim() || !req.body.description.trim()) return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Name and description cannot be empty' });

    const forbiddenCharsRegex = /[<>;"'\/\\]/;
    if (forbiddenCharsRegex.test(req.body.description)) {
        return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Description contains forbidden characters' });
    }
    
    return null;
}

const generateSeoDescription = async (title, description) => {
    const url = `https://api.groq.com/openai/v1/chat/completions`;
    const body = {
        model: "llama-3.3-70b-versatile",
        messages: [
            {
                role: "user",
                content: `Na podstawie poniższych informacji, wygeneruj SEO w języku angielskim opis produktu w formie tekstu bez żadnych dodatków.
                Opis: ${description}`
            }
        ]
    };
    
    try {
        const response = await axios.post(url, body, {
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${api.groqApiKey}`
            }
        });

        const modelResponse = response.data.choices[0].message.content.trim();
        return modelResponse; 
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed' });
    }
};

const getSeoDescription = async (req, res) => {
    const productId = req.params.id;

    try {
        const product = await knex('products').where('id', productId).first();

        if (!product) {
            return res.status(StatusCodes.NOT_FOUND).json({ error: 'Product not found' });
        }

        const seoDescription = await generateSeoDescription(product.name, product.description);

        res.status(StatusCodes.OK).json({ seo_description: seoDescription });
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to generate SEO description' });
    }
};

module.exports = {
    getAllProducts,
    getProduct,
    addProduct,
    updateProduct,
    generateSeoDescription,
    getSeoDescription
};
