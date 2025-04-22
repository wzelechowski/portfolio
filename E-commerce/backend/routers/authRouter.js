const express = require('express');
const router = express.Router();
const { auth, login, showUser, refreshToken, addUser } = require('../controllers/authController');

router.post('/login', login);
router.get('/users', auth, showUser);
router.post('/refresh-token', auth, refreshToken);
router.post('/user', addUser);

module.exports = router;
