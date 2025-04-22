const express = require('express');
const router  = express.Router();
const { auth, checkRole } = require('../controllers/authController');
const { 
    getAllProducts,
    getProduct,
    addProduct,
    updateProduct,
    getSeoDescription
} = require('../controllers/productController');

router.get('', getAllProducts);
router.get('/:id', getProduct);
router.post('', auth, checkRole('EMPLOYEE'), addProduct);
router.put('/:id', auth, checkRole('EMPLOYEE'), updateProduct);
router.get('/:id/seo-description', getSeoDescription);

module.exports = router
