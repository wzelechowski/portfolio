<template>
    <div class="container mt-5">
      <div v-if="role === 'EMPLOYEE'">
        <OrdersEmployee/>
      </div>
  
      <div v-if="role === 'CUSTOMER'">
        <OrdersCustomer/>
      </div>
    </div>
  </template>
  
  <script>
  import OrderService from "@/services/OrderService";
  import ProductService from "@/services/ProductService";
  import Cookies from 'js-cookie';
  import OrdersEmployee from "@/components/OrdersEmployee.vue"
  import OrdersCustomer from "@/components/OrdersCustomer.vue"
  
  export default {
  components: {OrdersEmployee, OrdersCustomer},
    data() {
      return {
        orders: [],
        order_items: [],
        products: [],
        statuses: [],
        selectedStatus: "",
        filteredOrders: [],
        user: null,
        role: null,
        userOrders: [],
        filteredUserOrders: [],
      };
    },
    methods: {
      async fetchOrders() {
        const response = await OrderService.getOrders();
        this.orders = response.data;
        this.filteredOrders = this.orders;
      },
      async fetchUserOrders() {
        const response = await OrderService.getUserOrders(this.user);
        this.userOrders = response.data;
        this.filteredUserOrders = this.userOrders;
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
              console.error(error.response.data.error)
            }
        },
      calculateOrderValue(orderId) {
        const items = this.getOrderItems(orderId);
        let totalValue = 0;
        items.forEach((item) => {
          totalValue += item.quantity * item.price;
        });
        return totalValue;
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
    },
    mounted() {
      this.role = Cookies.get('role');
      this.user = Cookies.get('user');
    }
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
  