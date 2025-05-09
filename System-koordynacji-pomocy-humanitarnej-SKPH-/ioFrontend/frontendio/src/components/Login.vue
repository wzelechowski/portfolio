<template>
  <div class="col-md-12">
    <div class="card card-container">
      <img
        id="profile-img"
        src="//ssl.gstatic.com/accounts/ui/avatar_2x.png"
        class="profile-img-card"
      />
      <Form @submit="handleLogin" :validation-schema="schema">
        <div class="form-group">
          <label for="username">{{ $t('login-username') }}</label>
          <Field name="username" type="text" class="form-control"  v-model="user.username" required/>
          <ErrorMessage name="username" class="error-feedback" />
        </div>
        <div class="form-group">
          <label for="password">{{ $t('login-password') }}</label>
          <Field name="password" type="password" class="form-control" v-model="user.password" required />
          <ErrorMessage name="password" class="error-feedback" />
        </div>

        <div class="form-group">
          <button class="btn btn-primary btn-block  mt-4 mx-auto d-block" :disabled="loading">
            <span
              v-show="loading"
              class="spinner-border spinner-border-sm"
            ></span>
            <span>{{ $t('login-button') }}</span>
          </button>
        </div>

        <div class="form-group">
          <div v-if="message" class="alert alert-danger" role="alert">
            {{ message }}
          </div>
        </div>
      </Form>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { useStore } from "vuex";
import { useRouter,useRoute } from "vue-router";
import { Form, Field, ErrorMessage } from "vee-validate";
import * as yup from "yup";
import { useI18n } from 'vue-i18n';

const { t, locale } = useI18n();
const store = useStore();
const router = useRouter();
const route = useRoute();

let usernameRequiredMessage = computed(() => t('validation-username-required'));
let passwordRequiredMessage = computed(() => t('validation-password-required'));

const schema = computed(() => yup.object().shape({
  username: yup.string().required(usernameRequiredMessage.value),
  password: yup.string().required(passwordRequiredMessage.value),
}));

watch(locale, () => {
  schema.value = yup.object().shape({
    username: yup.string().required(usernameRequiredMessage.value),
    password: yup.string().required(passwordRequiredMessage.value),
  });
});

const loading = ref(false);
const message = ref("");
const user = ref({ username: '', password: '' });
const loggedIn = computed(() => store.state.auth.status.loggedIn);

const props = defineProps({
  method: {
    type: Function,
  }
});

onMounted(() => {
  if (loggedIn.value) {
    router.push("/");
  }
});

const handleLogin = async () => {
  loading.value = true;

  try {
    await store.dispatch('auth/login', user.value);
    await props.method(); // Call the function passed as prop
    router.push('/');
  } catch (error) {
    loading.value = false;
    message.value =
      (error.response && error.response.data && error.response.data.message) ||
      error.message ||
      error.toString();
  }
};
</script>

<style scoped>
label {
  display: block;
  margin-top: 10px;
}

.card-container.card {
  max-width: 350px !important;
  padding: 40px 40px;
}

.card {
  background-color: #f7f7f7;
  padding: 20px 25px 30px;
  margin: 0 auto 25px;
  margin-top: 50px;
  -moz-border-radius: 2px;
  -webkit-border-radius: 2px;
  border-radius: 2px;
  -moz-box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
  -webkit-box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
  box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
}

.profile-img-card {
  width: 96px;
  height: 96px;
  margin: 0 auto 10px;
  display: block;
  -moz-border-radius: 50%;
  -webkit-border-radius: 50%;
  border-radius: 50%;
}

.error-feedback {
  color: red;
}
</style>
