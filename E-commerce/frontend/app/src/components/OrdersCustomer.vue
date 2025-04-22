<template>
    <div v-if="opinionMode.mode">
        <div class="container d-flex justify-content-center align-items-center vh-100">
        <div class="card p-4 shadow-sm" style="width: 350px;">
        <h3 class="text-center mb-4">Add opinion</h3>
        <form @submit.prevent="addOpinion">
          <div class="mb-3">
            <label for="rating" class="form-label">Rating</label>
            <input
              type="number"
              class="form-control"
              id="rating"
              v-model="rating"
              required
              placeholder="Rating"
            />
          </div>
          <div class="mb-3">
            <label for="content" class="form-label">Content</label>
            <input
              type="text"
              class="form-control"
              id="content"
              v-model="content"
              required
              placeholder="Content"
            />
          </div>
          <button type="submit" class="btn btn-primary w-100">Confirm</button>
        </form>
      </div>
    </div>
    </div>
    <div v-else>
        <div class="form-group">
            <label for="statusFilter">Filter by status:</label>
            <select
            id="statusFilter"
            class="form-control w-50"
            v-model="selectedStatus"
            @change="filterOrders"
            >
            <option value="">All</option>
            <option v-for="status in statuses" :key="status.id" :value="status.id">
            {{ status.name }}
            </option>
            </select>
        </div>

        <div v-if="filteredOrders.length === 0" class="alert alert-info mt-3">
        No orders available for the selected status.
        </div>

        <table v-else class="table table-striped table-bordered table-hover mt-4">
        <thead class="thead-dark">
            <tr>
            <th>Confirm date</th>
            <th>Price</th>
            <th>Products List</th>
            <th>Status</th>
            <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="order in filteredOrders" :key="order.id">
            <td>{{ toLocalDate(order.confirmation_date) }}</td>
            <td>{{ calculateOrderValue(order.id) }} PLN</td>
            <td>
                <li v-for="item in getOrderItems(order.id)" :key="item.product_id">
                Name: {{ getProductById(item.product_id).name }}<br />
                Quantity: {{ item.quantity }}
                </li>
            </td>
            <td>{{ getStatus(order.status_id) }}</td>
            <td>
                <button
                class="btn btn-primary"
                @click="opinionModeOn(order.id)"
                >
                Add opinion
                </button>
            </td>
            </tr>
        </tbody>
        </table>
    </div>
</template>

<script>
import OrderService from "@/services/OrderService";
import ProductService from "@/services/ProductService";
import Cookies from 'js-cookie';

export default {
  data() {
    return {
      orders: [],
      order_items: [],
      products: [],
      statuses: [],
      selectedStatus: "",
      filteredOrders: [],
      username: null,
      role: null,
      opinionMode: {
        mode: false,
        order_id: null,
      },
      rating: null,
      content: null,
    };
  },
  methods: {
    async fetchUserOrders() {
      const response = await OrderService.getUserOrders(this.username);
      this.orders = response.data;
      this.filteredOrders = this.orders;
    },
    async fetchOrderItems() {
      const response = await OrderService.getOrderItems();
      this.order_items = response.data;
    },
    async fetchProducts() {
      const response = await ProductService.getAllProducts();
      this.products = response.data;
    },
    getOrderItems(orderId) {
      return this.order_items.filter((item) => item.order_id === orderId);
    },
    getProductById(productId) {
      return this.products.find((product) => product.id === productId);
    },
    async changeOrderStatus(id, status) {
          const request = {
          status_id: status,
          };

          try {
              await OrderService.changeOrderStatus(id, request);
              this.fetchOrders();
          } catch (error) {
              const errorMessage = error.response && error.response.data && error.response.data.error
              ? error.response.data.error
              : "An error occurred while changing the order status.";
              console.error("Error changing order status:", errorMessage);
          }
      },
    calculateOrderValue(orderId) {
      const items = this.getOrderItems(orderId);
      let totalValue = 0;
      items.forEach((item) => {
        totalValue += item.quantity * item.price;
      });
      return parseFloat(totalValue).toFixed(2);
    },
    async fetchStatuses() {
      const response = await OrderService.getOrderStatuses();
      this.statuses = response.data;
    },
    getStatus(id) {
      const status = this.statuses.find((status) => status.id === id);
      return status ? status.name : "Unknown";
    },
    toLocalDate(dateString) {
        if(dateString === null) return;
      const date = new Date(dateString);
      return date.toLocaleDateString();
    },
    filterOrders() {
      if (this.selectedStatus) {
        this.filteredOrders = this.orders.filter(
          (order) => order.status_id === Number(this.selectedStatus)
        );
      } else {
        this.filteredOrders = this.orders;
      }
    },
    opinionModeOn(id) {
        this.opinionMode.mode = true;
        this.opinionMode.order_id = id;
    },
    async addOpinion() {
        const request = {
            rating: this.rating,
            content: this.content,
        }
        try {
            const response = await OrderService.addOpinion(this.opinionMode.order_id, request);
            this.opinionMode.mode = false;
        } catch(error) {
            console.error(error.response.data.error);
        }
    }
  },
  async mounted() {
      this.role = Cookies.get('role'),
      this.username = Cookies.get('user'),
    await Promise.all([
      this.fetchUserOrders(),
      this.fetchOrderItems(),
      this.fetchProducts(),
      this.fetchStatuses(),
    ]);
  },
};
</script>

<style scoped>
.table th,
.table td {
  vertical-align: middle;
}

button {
  margin: 5px;
}

li {
  list-style-type: none;
}
</style>
