const express = require('express');
const router = express.Router();
const { getOrderStatuses } = require('../controllers/orderstatusController');

router.get('', getOrderStatuses);

module.exports = router;
