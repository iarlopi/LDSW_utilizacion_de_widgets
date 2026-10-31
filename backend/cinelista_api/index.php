<?php

// Indicar que la respuesta será JSON
header('Content-Type: application/json; charset=utf-8');

// Cargar el endpoint de películas populares
require_once __DIR__ . '/api/peliculas.php';

?>