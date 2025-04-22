<template>
    <div class="container">
      <h1>Welcome to my shop {{ username }}</h1>
    </div>
  </template>
  
  <script>
  import AuthService from '@/services/authService';
  export default {
    data() {
      return {
        username: null,
      }
    },
    methods: {
      async getUser() {
        const response = await AuthService.getUser();
        this.username = response.data.username;
      }
    },
    mounted() {
      this.getUser();
    }
  };
  </script>
  
  <style scoped>
  .container {
    display: flex;
    justify-content: center;
    align-items: center;
  }
  
  h1 {
    margin-top: 250px;
  }
  </style>
  