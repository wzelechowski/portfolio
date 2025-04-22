const express = require('express');
const router = express.Router();
const { initDb } = require('../controllers/initContoller');
const { auth, checkRole } = require('../controllers/authController');

router.use(auth);
router.post('', checkRole('EMPLOYEE'), initDb);

module.exports = router;
