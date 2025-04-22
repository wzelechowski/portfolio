<template>
    <div class="container mt-5">
      <h1>Cart</h1>
  
      <div v-if="productsToBuy.length === 0" class="alert alert-info">
        Your cart is empty.
      </div>
  
      <table v-else class="table table-striped table-bordered table-hover mt-4">
        <thead>
          <tr>
            <th></th>
            <th>Name</th>
            <th>Description</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Total</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(product, index) in productsToBuy" :key="index">
            <td>
                <button class="btn btn-primary" @click="removeFromCart(product)">X</button>
            </td>
            <td>{{ product.name }}</td>
            <td>{{ product.description }}</td>
            <td>{{ (product.unit_price * (1 - discount)).toFixed(2) }} USD</td>
            <td>
            <div class="d-flex align-items-center">
                <input type="number" v-model.number="product.quantity" min="1" class="form-control form-control-sm" @change="updateLocalStorage" style="width: 50px; text-align: center;" />
            </div>
          </td>
          <td style="width:120px; overflow: hidden;">{{ (product.unit_price * product.quantity * (1 - discount)).toFixed(2) }} USD</td>
        </tr>
          <tr>
            <td></td>
            <td colspan="4" class="text-right"></td>
            <td rowspan="2" style="max-width:120px; overflow: hidden;">
              <strong>{{ (totalPrice * (1 - discount)).toFixed(2) }} USD</strong>
            </td>
          </tr>
        </tbody>
      </table>
      <div id="orderForm" class="">
        <form @submit.prevent="submitOrder">
          <div class="form-group">
            <label for="phone_number" class="form-label">Phone Number</label>
            <input type="tel" id="phone_number" class="form-control" v-model="phoneNumber" required />
            </div>            
            <div class="form-group">
            <label for="email" class="form-label">Email</label>
            <input type="email" id="email" class="form-control" v-model="email" required />
            </div>
            <div class="form-group d-flex align-items-center">
            <div>
                <label for="discount_code" class="form-label">Discount Code (Optional)</label>
                <input v-if="discount > 0" type="text" id="discount_code" class="form-control" value={{discountCode}} v-model="discountCode" />
                <input v-else type="text" id="discount_code" class="form-control" v-model="discountCode" />

            </div>
            <button class="btn btn-primary ms-3" style="margin-top:2rem;" type="submit" @click="checkDiscount()">Check</button>
            </div>
        </form>
        <button class="btn btn-primary mt-3" @click="createOrder()">Make an order</button>
</div>

  </div>
</template>

  
  <script>
  import OrderService from '@/services/orderService.js';
  import Cookies from 'js-cookie'

  export default {
    data() {
      return {
        productsToBuy: [],
        phoneNumber: '',
        discountCode: '',
        discount: 0,
        discountCode: '',
        email: '',
        role: '',
        user: JSON.parse(localStorage.getItem('user')) || {}
      };
    },
    computed: {
      totalItems() {
        return this.productsToBuy.reduce((sum, product) => sum + product.quantity, 0);
      },
      totalPrice() {
        return this.productsToBuy.reduce((sum, product) => sum + (product.unit_price * product.quantity), 0);
      },
    },
    methods: {
        checkDiscount() {
            const storedDiscount = localStorage.getItem("discount");
            if(storedDiscount) {
                return
            }
            if(this.discountCode === "AJI") {
            this.discount = 0.1;
            localStorage.setItem("discount", JSON.stringify({ code: this.discountCode, value: this.discount }));
            }
        },
        async createOrder() {
          const productsRequest = [];

          this.productsToBuy.forEach(product => {
                productsRequest.push({
                    product_id: product.id,
                    quantity: product.quantity
                });
          });
          const request = {
            email: this.email,
            phone_number: this.phoneNumber,
            products: productsRequest,
            discount: this.discount || 0,
          }

          try {
            const response = await OrderService.addOrder(request);
            this.productsToBuy = [];
            localStorage.removeItem('cart');
            localStorage.removeItem('discount');
            this.discountCode = '';
            this.email = '';
            this.phoneNumber = '';
            if(this.role === 'EMPLOYEE') await this.changeOrderStatus(response.data.id, 2);
          } catch(error) {
            console.log(error.response.data.error);
          }
        },
      loadCart() {
        const storedProducts = localStorage.getItem('cart');
        if (storedProducts) {
          this.productsToBuy = JSON.parse(storedProducts);
          this.getQuantity();
        }
      },
      saveCart() {
        localStorage.setItem('cart', JSON.stringify(this.productsToBuy));
      },
      removeFromCart(product) {
        this.productsToBuy = this.productsToBuy.filter(p => p.id !== product.id);
        this.saveCart();
      },
      getQuantity() {
        const uniqueProducts = [];
        for(let i = 0; i < this.productsToBuy.length; i++) {
            const currentProduct = this.productsToBuy[i];

            const exsistingProduct = uniqueProducts.find(p => p.id === currentProduct.id);

            if(exsistingProduct) {
                exsistingProduct.quantity += 1;
            } else {
                currentProduct.quantity = 1;
                uniqueProducts.push(currentProduct);
            }
        }
        this.productsToBuy = uniqueProducts;
      },
      totalDiscount() {
        const discountData = JSON.parse(localStorage.getItem("discount"));
        if (discountData) {
            this.discount = discountData.value;
            this.discountCode = discountData.code;
        }     
      },
      async fetchStatuses() {
        const response = await OrderService.getOrderStatuses();
        this.statuses = response.data;
      },
      getStatus(id) {
        const status = this.statuses.find(status => status.id === id);
        return status.name;
      },
      async changeOrderStatus(id, status) {
        const request = {
          status_id: status,
        };
        await OrderService.changeOrderStatus(id, request);
      },
    },
    created() {
      this.loadCart();
      this.totalDiscount();
      this.role = Cookies.get('role');
    },
  };
  </script>
  
  <style scoped>
  td > button {
    margin-left: 10px;
    display: inline-block;
    gap: 10px;
  }
  
  form {
    display: flex;
    gap: 30px;
  }

  </style>