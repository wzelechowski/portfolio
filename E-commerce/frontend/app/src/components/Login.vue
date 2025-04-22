<template>
    <div class="container d-flex justify-content-center align-items-center vh-100">
      <div class="card p-4 shadow-sm" style="width: 350px;">
        <h3 class="text-center mb-4">Log in</h3>
        <form @submit.prevent="login">
          <div class="mb-3">
            <label for="email" class="form-label">Username</label>
            <input
              type="text"
              class="form-control"
              id="username"
              v-model="username"
              required
              placeholder="Username"
            />
          </div>
          <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input
              type="password"
              class="form-control"
              id="password"
              v-model="password"
              required
              placeholder="Password"
            />
          </div>
          <button type="submit" class="btn btn-primary w-100">Log in</button>
        </form>
      </div>
    </div>
  </template>
  
  <script>
  import AuthService from '@/services/authService';
  import Cookies from 'js-cookie';
  
  export default {
    data() {
      return {
        username: '',
        password: '',
      };
    },
    methods: {
        async login() {
      const request = {
        name: this.username,
        password: this.password,
      };
      try {
        const response = await AuthService.getAuthorization(request);
        Cookies.set('accessToken', response.data.accessToken);
        Cookies.set('refreshToken', response.data.refreshToken);

        const userResponse = await AuthService.getUser();
        Cookies.set('user', userResponse.data.username);
        Cookies.set('role', userResponse.data.role);

        this.$router.push('/');

        
      } catch (error) {
        console.error(error.response.data.error);
      }
    },
    }
  };
  </script>
  
  <style scoped>
  </style>
  