<template>
  <div class="container">
    <div class="dashboard">
      <div
        class="tile"
        v-for="tile in filteredTiles"
        :key="tile.id"
        @click="navigateTo(tile.link)"
      >
        <i :class="tile.icon"></i>
        <h4>{{ tile.title }}</h4>
        <p>{{ tile.description }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import UserService from "../services/user.service";
import { useStore } from 'vuex';
import { useI18n } from 'vue-i18n';

const { t, locale } = useI18n();
const store = useStore();
const currentUser = computed(() => store.state.auth.user);
const content = ref("");
const router = useRouter();

const tiles = ref([
  { id: 1, title: t('home-raports'), description: t('home-raports-description'), icon: "fas fa-file-alt", link: "/reports", roles: ["ROLE_AUTHORITY", "ROLE_DONOR"] },
  { id: 2, title: t('home-profile'), description: t('home-profile-description'), icon: "fas fa-user", link: "/profile", roles: ["ROLE_USER","ROLE_VICTIM", "ROLE_VOLUNTEER", "ROLE_AUTHORITY", "ROLE_ORGANIZATION","ROLE_DONOR"] },
  { id: 3, title: t('home-resource'), description: t('home-resource-description'), icon: "fas fa-cogs", link: "/resource", roles: ["ROLE_ORGANIZATION", "ROLE_AUTHORITY", "ROLE_DONOR"] },
  { id: 4, title: t('home-map'), description: t('home-map-description'), icon: "fas fa-map", link: "/map", roles: ["ROLE_AUTHORITY","ROLE_VICTIM","ROLE_ORGANIZATION"] },
  { id: 5, title: t('home-chat'), description: t('home-chat-description'), icon: "fas fa-comments", link: "/communication", roles: ["ROLE_AUTHORITY","ROLE_VICTIM","ROLE_ORGANIZATION","ROLE_VOLUNTEER","ROLE_DONOR"] },
  { id: 6, title: t('home-volunteer'), description: t('home-volunteer-description'), icon: "fas fa-map", link: "/volunteer", roles: ["ROLE_ORGANIZATION"] },
  { id: 7, title: t('home-application'), description: t('home-application-description'), icon: "fas fa-map", link: "/application", roles: ["ROLE_ORGANIZATION"] },
  { id: 8, title: t('home-application'), description: t('home-organizationVol-description'), icon: "fas fa-map", link: "/organization", roles: ["ROLE_VOLUNTEER"] },
  { id: 8, title: t('home-organization'), description: t('home-organization-description'), icon: "fas fa-map", link: "/organization", roles: ["ROLE_AUTHORITY"] },
]);

const filteredTiles = computed(() => {
  if (!currentUser.value) return [];
  return tiles.value.filter(tile => tile.roles.some(role => currentUser.value.roles.includes(role)));
});

const navigateTo = (link) => {
  router.push(link);
};

onMounted(() => {
  UserService.getPublicContent().then(
    (response) => {
      content.value = response.data;
    },
    (error) => {
      content.value =
        (error.response &&
          error.response.data &&
          error.response.data.message) ||
        error.message ||
        error.toString();
    }
  );
});

// Watch for changes in locale and update tiles accordingly
watch(locale, () => {
  tiles.value = [
  { id: 1, title: t('home-raports'), description: t('home-raports-description'), icon: "fas fa-file-alt", link: "/reports", roles: ["ROLE_AUTHORITY", "ROLE_DONOR"] },
  { id: 2, title: t('home-profile'), description: t('home-profile-description'), icon: "fas fa-user", link: "/profile", roles: ["ROLE_USER","ROLE_VICTIM", "ROLE_VOLUNTEER", "ROLE_AUTHORITY", "ROLE_ORGANIZATION","ROLE_DONOR"] },
  { id: 3, title: t('home-resource'), description: t('home-resource-description'), icon: "fas fa-cogs", link: "/resource", roles: ["ROLE_ORGANIZATION", "ROLE_AUTHORITY", "ROLE_DONOR"] },
  { id: 4, title: t('home-map'), description: t('home-map-description'), icon: "fas fa-map", link: "/map", roles: ["ROLE_AUTHORITY","ROLE_VICTIM","ROLE_ORGANIZATION"] },
  { id: 5, title: t('home-chat'), description: t('home-chat-description'), icon: "fas fa-comments", link: "/communication", roles: ["ROLE_AUTHORITY","ROLE_VICTIM","ROLE_ORGANIZATION","ROLE_VOLUNTEER","ROLE_DONOR"] },
  { id: 6, title: t('home-volunteer'), description: t('home-volunteer-description'), icon: "fas fa-map", link: "/volunteer", roles: ["ROLE_ORGANIZATION"] },
  { id: 7, title: t('home-application'), description: t('home-application-description'), icon: "fas fa-map", link: "/application", roles: ["ROLE_ORGANIZATION"] },
  { id: 8, title: t('home-organization'), description: t('home-organization-description'), icon: "fas fa-map", link: "/organization", roles: ["ROLE_AUTHORITY", "ROLE_VOLUNTEER"] },
  ];
});
</script>

<style scoped>
.container {
  padding: 20px;
}

.dashboard {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
}

.tile {
  background-color: #ffffff;
  border: 1px solid #ddd;
  border-radius: 5px;
  padding: 20px;
  flex: 1 1 calc(33.333% - 20px);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s;
  cursor: pointer;
  text-align: center;
}

.tile:hover {
  transform: scale(1.05);
}

.tile i {
  font-size: 24px;
  margin-bottom: 10px;
}

.tile h4 {
  margin-top: 0;
}

.tile p {
  margin-bottom: 0;
}
</style>