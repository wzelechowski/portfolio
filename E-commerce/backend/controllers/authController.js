const jwt = require('jsonwebtoken');
const { StatusCodes } = require('http-status-codes');
const knexConfig = require('../config/knexfile');
const knex = require('knex')(knexConfig);

async function auth(req, res, next) {
    try {
        const token = req.headers.authorization.replace('Bearer ', '');
        await jwt.verify(token, 'super-secret');
        req.token = token;
        const decodedUser = jwt.decode(token, 'super-secret');
        
        const user = await knex('users').where('username', decodedUser.name).first();

        if (!user) {
            return res.status(StatusCodes.NOT_FOUND).json({ error: 'User not found' });
        }

        req.user = user;
        next();
    } catch {
        res.status(StatusCodes.UNAUTHORIZED).json({ error: 'You are not authorized' });
    }
}

function checkRole(requiredRole) {
    return (req, res, next) => {
        if (req.user.role !== requiredRole) {
            return res.status(StatusCodes.FORBIDDEN).json({ error: 'Access denied' });
        }
        next();
    };
}

const login = async (req, res) => {
    try {
        const { name, password } = req.body;

        if(!name) return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Username cannot be empty' });
        if(!password) return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Password cannot be empty' });
    
        const user = await knex('users').where('username', name).first();
    
        if (!user) {
            return res.status(StatusCodes.NOT_FOUND).json({ error: 'User not found' });
        }
    
        const passwordMatch = user.password === password;
        if (!passwordMatch) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Wrong password' });
        }
    
        const accessToken = jwt.sign({ name: user.username }, 'super-secret', { expiresIn: '1h' });
    
        const refreshToken = jwt.sign({ name: user.username }, 'super-secret-refresh', { expiresIn: '7d' });
    
    
        res.status(StatusCodes.OK).json({ accessToken, refreshToken });
    } catch {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to log in'} );
    }
};

const showUser = (req, res) => {
    res.send(req.user);
};

const refreshToken = async (req, res) => {
    const { refreshToken } = req.body;

    if (!refreshToken) {
        return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Refresh token is required' });
    }

    try {
        const decoded = jwt.verify(refreshToken, 'super-secret-refresh');
        const user = await knex('users').where('username', decoded.name).first();

        if (!user) {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'User not found' });
        }

        const newAccessToken = jwt.sign({ name: user.username }, 'super-secret', { expiresIn: '1h' });

        res.status(StatusCodes.OK).json({ accessToken: newAccessToken });

    } catch {
        return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Invalid refresh token' });
    }
};

const addUser = async (req, res) => {
    try {
        const { username, password } = req.body;
        const [id] = await knex('users').insert({username, password, role: 'CUSTOMER'});
        if([id]) return res.status(StatusCodes.CREATED).json({ id: id, message: 'User added successfully' });
    } catch(error) {
        return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'Failed to add user' })
    }
}

module.exports = { auth, checkRole, login, showUser, refreshToken, addUser };