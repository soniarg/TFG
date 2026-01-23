<?php
Route::get('/seed-mapa', function () {
    DB::statement('SET FOREIGN_KEY_CHECKS=0;');
    DB::table('tasks')->truncate();
    DB::table('users')->truncate();
    DB::statement('SET FOREIGN_KEY_CHECKS=1;');

    $idMarta = DB::table('users')->insertGetId([
        'nombre_completo' => 'Vicent del Pueblo',
        'email' => 'vicent@test.com',
        'password' => Hash::make('1234'),
        'latitud' => 39.073000, 
        'longitud' => -0.264000
    ]);

    DB::table('tasks')->insert([
        [
            'creador_id' => $idMarta,
            'titulo' => 'Arreglar Persiana',
            'descripcion' => 'Se ha atascado la cinta.',
            'precio' => 20.00,
            'estado' => 'Open',
            'latitud' => 39.073500, // En el Pueblo
            'longitud' => -0.264500,
        ],
        [
            'creador_id' => $idMarta,
            'titulo' => 'Limpiar Apartamento Playa',
            'descripcion' => 'Limpieza general entrada verano.',
            'precio' => 50.00,
            'estado' => 'Open',
            'latitud' => 39.085000, // En la Playa de Tavernes
            'longitud' => -0.223000,
        ],
        [
            'creador_id' => $idMarta,
            'titulo' => 'Recoger Naranjas',
            'descripcion' => 'Ayuda para cargar cajas.',
            'precio' => 12.00,
            'estado' => 'Open',
            'latitud' => 39.078000, // Entre medias (huertos)
            'longitud' => -0.240000,
        ]
    ]);

    return "¡Datos creados en Tavernes de la Valldigna!";
});