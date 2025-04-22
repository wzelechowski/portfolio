import axios from 'axios';
import authHeader from './auth-header';

const API_URL = 'http://localhost:3000/products';

class ProductService {
    getAllProducts() {
        return axios.get(API_URL);
    }

    getProduct(id) {
        return axios.get(API_URL + `/${id}`);
    }

    getCategories() {
        return axios.get('http://localhost:3000/categories', { headers: authHeader() });
    }

    updateProduct(id, request) {
        return axios.put(API_URL + `/${id}`, request, { headers: authHeader() })
    }

    optimalizeDescription(id) {
        return axios.get(API_URL + `/${id}/seo-description`, {headers: authHeader() });
    }

    async initDatabase(requestBody) {
        console.log(requestBody);
        return await axios.post('http://localhost:3000/init', requestBody, { headers: authHeader() });
    }
}

export default new ProductService();