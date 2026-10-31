<?php

require_once __DIR__ . '/../config.php';

// Consultar películas populares en TMDB
$url = 'https://api.themoviedb.org/3/movie/popular?language=es-MX&page=1';

$ch = curl_init();

curl_setopt_array($ch, [
    CURLOPT_URL => $url,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER => [
        'Authorization: Bearer ' . TMDB_TOKEN,
        'accept: application/json'
    ]
]);

$response = curl_exec($ch);
$statusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

if (curl_errno($ch)) {
    http_response_code(500);

    echo json_encode([
        'error' => 'Error de conexión con TMDB'
    ]);

} else {
    http_response_code($statusCode);

    echo $response;
}

curl_close($ch);

?>