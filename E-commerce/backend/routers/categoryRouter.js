const express = require('express');
const router = express.Router();
const { auth } = require('../controllers/authController');
const { getAllCategories } = require('../controllers/categoryController');

router.use(auth);
router.get('',  getAllCategories);

module.exports = router;
