import { createRouter, createWebHistory } from "vue-router";
import Home from "@/components/Home.vue";
import Products from "@/components/Products.vue";
import Cart from "@/components/Cart.vue";
import Orders from "@/components/Orders.vue";
import Login from "@/components/Login.vue";
import Signup from "@/components/Signup.vue";

const routes = [
  {
    path: "/",
    name: "Home",
    component: Home,
  },
  {
    path: "/products",
    name: "Products",
    component: Products,
  },
  {
    path: "/cart",
    name: "cart",
    component: Cart,
  },  
  {
    path: "/orders",
    name: "Orders",
    component: Orders,
  },
  {
    path: "/login",
    name: "Login",
    component: Login,
  },
  {
    path: "/signup",
    name: "Signup",
    component: Signup,
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
