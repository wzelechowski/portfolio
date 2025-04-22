<template>
  <div class="app">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark py-3">
      <div class="container">
        <router-link to="/" class="navbar-brand">My Shop</router-link>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
          <ul class="navbar-nav ms-auto">
            <li class="nav-item">
              <router-link to="/products" class="nav-link">Products</router-link>
            </li>
            <li class="nav-item">
              <router-link to="/orders" class="nav-link">Orders</router-link>
            </li>
            <li class="nav-item">
              <router-link to="/cart" class="nav-link">Cart</router-link>
            </li>            
            <li class="nav-item" v-if="username === null">
              <router-link to="/login" class="nav-link">Log in</router-link>
            </li>
            <li class="nav-item" v-if="username === null">
              <router-link to="/signup" class="nav-link">Sing up</router-link>
            </li>
            <li class="nav-item" v-else>
              <a @click="logout" class="nav-link" href="#">Logout</a>
            </li>
          </ul>
        </div>
      </div>
    </nav>
    <router-view></router-view>
  </div>
</template>

<script>
import Cookies from 'js-cookie';
import AuthService from '@/services/authService';

export default {
  data() {
    return {
      username: null,
      role: null,
    };
  },
  mounted() {
    this.getUser();
  },
  methods: {
    logout() {
      Cookies.remove('user');
      Cookies.remove('role');
      Cookies.remove('accessToken');
      Cookies.remove('refreshToken');
      
      this.username = null;
      this.role = null;

      this.$router.push('/');
      
    },
    getUser() {
    const username = Cookies.get('user');
    if(username) {
      this.username = username;
    }
    const role = Cookies.get('role');
    if(role) {
      this.role = role;
    }
    console.log(this.username);
    }
  },
  created() {
    this.getUser();
  },
}
</script>

<style scoped>
</style>
