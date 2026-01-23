<script setup>
import { RouterLink, RouterView } from 'vue-router'
</script>

<template>
  <header>
    <div class="navbar">
      <div class="brand">DumbJobs</div>
      <nav>
        <RouterLink to="/">Mapa</RouterLink>
        </nav>
    </div>
  </header>

  <RouterView />
</template>

<style scoped>
/* Estilos de la barra de navegación */
header {
  background-color: #ffffff;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  padding: 1rem 2rem;
  margin-bottom: 20px;
}

.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1200px;
  margin: 0 auto;
}

.brand {
  font-weight: bold;
  font-size: 1.5rem;
  color: #2c3e50;
}

nav a {
  text-decoration: none;
  color: #2c3e50;
  font-weight: 500;
  padding: 0.5rem 1rem;
  border-radius: 5px;
}

nav a:hover {
  background-color: #f0f0f0;
}

nav a.router-link-exact-active {
  color: #42b883; /* Verde Vue */
  font-weight: bold;
}
</style>