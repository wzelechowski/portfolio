const express = require('express');
const router = express.Router();
const { auth, checkRole } = require('../controllers/authController');
const { 
    getAllOrders, 
    getAllOrderItems, 
    getOrdersByUsername, 
    getOrdersByStatus, 
    getOrder, 
    getOrderItem, 
    changeOrderStatus, 
    addOrder,
    addOpinion,
    getOpionions,
    getAllOpinions
} = require('../controllers/orderController');

router.use(auth);
router.get('', checkRole('EMPLOYEE'), getAllOrders);
router.get('/orderitems', getAllOrderItems);
router.post('', addOrder);
router.get('/:id', getOrder);
router.get('/orderitems/:id', getOrderItem);
router.patch('/:id', checkRole('EMPLOYEE'), changeOrderStatus);
router.get('/status/:status_id', getOrdersByStatus);
router.get('/user/:username', getOrdersByUsername);
router.post('/:id/opinions', addOpinion);
router.get('/:order_id/opinions', checkRole('EMPLOYEE'), getOpionions);
router.get('/opinions', checkRole('EMPLOYEE'), getAllOpinions);

module.exports = router;
