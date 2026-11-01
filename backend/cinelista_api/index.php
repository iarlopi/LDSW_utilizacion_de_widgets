<?php

header('Content-Type: application/json; charset=utf-8');

// Permitir peticiones desde Flutter durante el desarrollo
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Responder a las peticiones de comprobación CORS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

require_once __DIR__ . '/api/peliculas.php';

?>