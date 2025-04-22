<template>
    <div class="container d-flex justify-content-center align-items-center vh-100">
      <div class="card p-4 shadow-sm" style="width: 350px;">
        <h3 class="text-center mb-4">Sign up</h3>
        <form @submit.prevent="register">
          <div class="mb-3">
            <label for="username" class="form-label">Username</label>
            <input
              type="text"
              class="form-control"
              id="username"
              v-model="username"
              required
              placeholder="Enter your username"
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
              placeholder="Enter your password"
              minlength="6"
            />
          </div>
  
          <div class="mb-3">
            <label for="confirmPassword" class="form-label">Confirm Password</label>
            <input
              type="password"
              class="form-control"
              id="confirmPassword"
              v-model="confirmPassword"
              required
              placeholder="Confirm your password"
              :class="{'is-invalid': password && confirmPassword && password !== confirmPassword}"
            />
            <div v-if="password && confirmPassword && password !== confirmPassword" class="invalid-feedback">
              Passwords do not match.
            </div>
          </div>
  
          <button type="submit" class="btn btn-primary w-100">Sign up</button>
        </form>
      </div>
    </div>
  </template>
  
  <script>
  import AuthService from '@/services/authService';
  
  export default {
    data() {
      return {
        username: '',
        password: '',
        confirmPassword: '',
      };
    },
    methods: {
      async register() {
        if (this.password !== this.confirmPassword) {
          alert("Passwords do not match!");
          return;
        }
  
        const request = {
          username: this.username,
          password: this.password,
        };

        try {
            const response = await AuthService.Signup(request);
            this.$router.push('/login');
        } catch (error) {
          console.error(error.response.data.error);
        }
      },
    },
  };
  </script>
  
  <style scoped>
  </style>
  