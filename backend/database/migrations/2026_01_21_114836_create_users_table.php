<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id(); 
            $table->string('nombre_completo', 100);
            $table->string('email', 150)->unique();
            $table->string('password'); 
            $table->string('telefono', 20)->nullable();
            
            $table->decimal('reputacion_media', 3, 2)->default(0.00)->comment('De 0.00 a 5.00');
            $table->decimal('latitud', 10, 8)->nullable(); 
            $table->decimal('longitud', 11, 8)->nullable();
            
            $table->rememberToken(); 
            $table->timestamps(); 
        });
        
        Schema::create('password_reset_tokens', function (Blueprint $table) {
            $table->string('email')->primary();
            $table->string('token');
            $table->timestamp('created_at')->nullable();
        });

        Schema::create('sessions', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->foreignId('user_id')->nullable()->index();
            $table->string('ip_address', 45)->nullable();
            $table->text('user_agent')->nullable();
            $table->longText('payload');
            $table->integer('last_activity')->index();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
