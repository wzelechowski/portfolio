import axios from 'axios';
import authHeader from './auth-header';

const API_URL = 'http://localhost:3000/auth';

class AuthService {
    getUser() {
        return axios.get(API_URL + '/users', { headers: authHeader() });
    }

    getAuthorization(requestBody) {
        return axios.post(API_URL + '/login', requestBody);
    }

    Signup(requestBody) {
        return axios.post(API_URL + '/user', requestBody);
    }
}

export default new AuthService();