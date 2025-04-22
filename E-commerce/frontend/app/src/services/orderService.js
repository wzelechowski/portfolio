import axios from 'axios';
import authHeader from './auth-header';

const API_URL = 'http://localhost:3000/orders';

class OrderService {
    async addOrder(requestData) {
        return await axios.post(API_URL, requestData, { headers:authHeader() });
    }

    getOrders() {
        return axios.get(API_URL, { headers:authHeader() });
    }    
    
    async getOrderItems() {
        return await axios.get(API_URL + '/orderitems', { headers:authHeader() });
    }

    getOrderItem(id) {
        return axios.get(API_URL + `/orderitems/${id}`, { headers:authHeader() });
    }

    async getOrder(id) {
        return await axios.get(API_URL + `/${id}`, { headers:authHeader() });
    }

    async getOrderStatuses() {
        return await axios.get('http://localhost:3000/status');
    }

    async changeOrderStatus(id, status_id) {
        return await axios.patch(API_URL + `/${id}`,status_id, { headers: authHeader() })
    }

    async getUserOrders(username) {
        console.log(username);
        return await axios.get(API_URL + `/user/${username}`, { headers: authHeader() });
    }

    async addOpinion(id, requestBody) {
        return await axios.post(API_URL + `/${id}/opinions`, requestBody, { headers: authHeader() });
    }
}

export default new OrderService();