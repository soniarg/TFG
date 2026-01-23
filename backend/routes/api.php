<?php
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;

Route::get('/tasks', function () {
    return DB::table('tasks')
        ->select('id', 'titulo', 'precio', 'latitud', 'longitud')
        ->where('estado', 'Open') 
        ->get();
});