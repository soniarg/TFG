<script setup>
import { onMounted } from 'vue';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import axios from 'axios';

onMounted(async () => {
  const map = L.map('mapContainer').setView([39.073, -0.264], 13);

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© OpenStreetMap'
  }).addTo(map);

  if ("geolocation" in navigator) {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        const { latitude, longitude } = position.coords;
        console.log("Usuario localizado en:", latitude, longitude);

        map.setView([latitude, longitude], 14);

        L.circleMarker([latitude, longitude], {
            color: 'red',
            fillColor: '#f03',
            fillOpacity: 0.5,
            radius: 10
        }).addTo(map).bindPopup("¡Estás aquí!");
      },
      (error) => {
        console.warn("No se pudo obtener ubicación, usando defecto.");
      }
    );
  } else {
    console.log("Geolocalización no disponible en este navegador.");
  }

  // 3. CARGAR TAREAS DEL BACKEND
  try {
    const response = await axios.get('http://localhost/api/tasks');
    const tareas = response.data;

    tareas.forEach(tarea => {
      L.marker([tarea.latitud, tarea.longitud])
        .addTo(map)
        .bindPopup(`
            <div style="text-align: center;">
                <b>${tarea.titulo}</b><br>
                Precio: <b>${tarea.precio}€</b><br>
                <button style="margin-top:5px">Ver detalle</button>
            </div>
        `);
    });

  } catch (error) {
    console.error("Error cargando tareas:", error);
  }
});
</script>

<template>
  <main class="container">
    <h1> Tareas Cerca de Ti</h1>
    <div id="mapContainer"></div>
  </main>
</template>

<style scoped>
.container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

h1 {
  text-align: center; 
  color: #2c3e50; 
  margin-bottom: 1rem;
}

#mapContainer {
  height: 70vh; 
  width: 100%;
  border-radius: 15px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  border: 2px solid #fff;
}
</style>