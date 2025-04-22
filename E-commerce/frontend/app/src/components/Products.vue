<template>
  <div class="container mt-5">
    <input 
      v-if="role === 'EMPLOYEE'" 
      type="file" 
      class="form-control mb-3"
      @change="handleFileUpload"
      accept=".json"
    />
    <button 
      v-if="role === 'EMPLOYEE'" 
      class="btn btn-primary mb-4" 
      @click="initDatabase"
    >
      Init Database
    </button>

    
    <div class="mb-4">
      <input 
        type="text" 
        class="form-control mb-2" 
        placeholder="Filter by name" 
        v-model="filterName" 
      />
      
      <select 
        class="form-control" 
        v-model="filterCategory" 
      >
        <option value="">Filter by category</option>
        <option v-for="category in categories" :key="category.id" :value="category.id">
          {{ category.name }}
        </option>
      </select>
    </div>
    
    <div v-if="filteredProducts.length === 0" class="alert alert-info">
      No products available.
    </div>
    
    <!-- Tryb normalny -->
    <div v-if="!editMode.edit">
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Name</th>
            <th>Description</th>
            <th>Price</th>
            <th>Unit Weight</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="product in filteredProducts" :key="product.id">
            <td>{{ product.name }}</td>
            <td>{{ product.description }}</td>
            <td>{{ product.unit_price }} USD</td>
            <td>{{ product.unit_weight }} kg</td>
            <td>
              <button class="btn btn-primary" @click="addToCart(product)">Buy</button>
              <button v-if="role == 'EMPLOYEE'" class="btn btn-primary" @click="editProduct(product)">Edit</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    
    <!-- Tryb edycji -->
    <div v-else>
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Category</th>
            <th>Price</th>
            <th>Unit Weight</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>
              <select v-model="editMode.product.category_id" class="form-control">
                <option v-for="category in categories" :key="category.id" :value="category.id">
                  {{ category.name }}
                </option>
              </select>
            </td>
            <td>
              <input
                type="number"
                class="form-control"
                v-model.number="editMode.product.unit_price"
                step="0.01"
                min="0"
                placeholder="Price"
                required
              />
            </td>
            <td>
              <input
                type="number"
                class="form-control"
                v-model.number="editMode.product.unit_weight"
                step="0.01"
                min="0"
                placeholder="Weight"
                required
              />
            </td>
            <td>
              <button class="btn btn-success" @click="saveProduct">Save</button>
              <button class="btn btn-secondary" @click="cancelEdit">Cancel</button>
            </td>
          </tr>
          <tr>
            <td colspan="3">
              <textarea
                  class="form-control"
                  value=""
                  v-model="editMode.product.description"
                ></textarea>  
            </td>
            <td>
              <button class="btn btn-primary" @click="optimalize(editMode.product)">Optimalize description</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

  </div>
</template>

<script>
import ProductService from "@/services/productService.js";
import Cookies from 'js-cookie';

export default {
  data() {
    return {
      products: [],
      filterName: "", 
      filterCategory: "",
      categories: [],
      editMode: {
        edit: false,
        product: null,
      },
      errorMessage: "",
      username: null,
      role: null,
      jsonData: null,
    };
  },
  computed: {
    filteredProducts() {
      return this.products.filter((product) => {
        const matchesName = product.name
          .toLowerCase()
          .includes(this.filterName.toLowerCase());
        const matchesCategory = this.filterCategory
          ? product.category_id === this.filterCategory
          : true;
        return matchesName && matchesCategory;
      });
      this.username = Cookies.get('user');
      this.role = Cookies.get('role');
    },
  },
  methods: {
    async fetchProducts() {
      try {
        const response = await ProductService.getAllProducts();
        this.products = response.data;
      } catch (error) {
        this.handleError(error);
      }
    },
    async fetchCategories() {
      try {
        const response = await ProductService.getCategories();
        this.categories = response.data;
      } catch (error) {
        this.handleError(error);
      }
    },
    addToCart(product) {
      let productsInCart = JSON.parse(localStorage.getItem("cart")) || [];
      productsInCart.push(product);
      localStorage.setItem("cart", JSON.stringify(productsInCart));
    },
    editProduct(product) {
      this.editMode.edit = true;
      this.editMode.product = { ...product };
    },
    async saveProduct() {
      try {
        const prod = this.editMode.product;

        // Obcinanie do dwóch miejsc po przecinku
        prod.unit_price = parseFloat(Number(prod.unit_price).toFixed(2));
        prod.unit_weight = parseFloat(Number(prod.unit_weight).toFixed(2));

        const request = {
          name: prod.name,
          description: prod.description,
          unit_price: prod.unit_price,
          unit_weight: prod.unit_weight,
          category_id: prod.category_id,
        };

        await ProductService.updateProduct(this.editMode.product.id, request);

        const productIndex = this.products.findIndex(
          (p) => p.id === this.editMode.product.id
        );
        if (productIndex !== -1) {
          this.products[productIndex] = { ...prod };
        }

        let productsInCart = JSON.parse(localStorage.getItem("cart")) || [];
        productsInCart = productsInCart.map((item) => {
          if (item.id === prod.id) {
            return { ...item, ...prod };
          }
          return item;
        });
        localStorage.setItem("cart", JSON.stringify(productsInCart));

        this.cancelEdit();
      } catch (error) {
        this.handleError(error);
      }
    },
    cancelEdit() {
      this.editMode.edit = false;
      this.editMode.product = null;
    },
    handleError(error) {
        console.error(error.response.data.error);
    },
    async optimalize(product) {
      const response = await ProductService.optimalizeDescription(product.id);
      product.description = response.data.seo_description;
    },
    handleFileUpload(event) {
      const file = event.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (e) => {
            this.jsonData = JSON.parse(e.target.result);
    };
    reader.readAsText(file);
    },
    async initDatabase() {
  const request = this.jsonData;

  try {
    const response = await ProductService.initDatabase(request, {
      headers: {
        'Content-Type': 'application/json',
      },
    });
  } catch (error) {
    console.error(error.response.data.error);
  }
}
  },
  async mounted() {
    await this.fetchProducts();
    await this.fetchCategories();
    this.role = Cookies.get('role');
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
</style>
