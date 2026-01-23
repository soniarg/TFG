DROP DATABASE IF EXISTS dumb_jobs;
CREATE DATABASE dumb_jobs CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dumb_jobs;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    reputacion_media DECIMAL(3, 2) DEFAULT 0.00 COMMENT 'De 0.00 a 5.00',
    latitud DECIMAL(10, 8),
    longitud DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    creador_id INT NOT NULL,
    trabajador_id INT DEFAULT NULL,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL COMMENT 'Pago en efectivo',
    estado ENUM('Open', 'In_Process', 'AI_Review', 'Completed', 'Cancelled') DEFAULT 'Open',
    latitud DECIMAL(10, 8) NOT NULL,
    longitud DECIMAL(11, 8) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_task_creador FOREIGN KEY (creador_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_task_trabajador FOREIGN KEY (trabajador_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE evidences (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tarea_id INT NOT NULL,
    url_imagen VARCHAR(255) NOT NULL,
    validacion_ia BOOLEAN DEFAULT FALSE COMMENT 'True si la IA aprueba la foto',
    metadatos_ia JSON COMMENT 'Respuesta técnica de Google Vision/Azure',
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_evidence_task FOREIGN KEY (tarea_id) REFERENCES tasks(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tarea_id INT NOT NULL,
    emisor_id INT NOT NULL,
    contenido TEXT NOT NULL,
    leido BOOLEAN DEFAULT FALSE,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_msg_task FOREIGN KEY (tarea_id) REFERENCES tasks(id) ON DELETE CASCADE,
    CONSTRAINT fk_msg_user FOREIGN KEY (emisor_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tarea_id INT NOT NULL,
    autor_id INT NOT NULL,
    usuario_calificado_id INT NOT NULL,
    puntuacion INT NOT NULL CHECK (puntuacion BETWEEN 1 AND 5),
    comentario TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_review_task FOREIGN KEY (tarea_id) REFERENCES tasks(id) ON DELETE CASCADE,
    CONSTRAINT fk_review_autor FOREIGN KEY (autor_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_review_calificado FOREIGN KEY (usuario_calificado_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DELIMITER //
CREATE TRIGGER after_review_insert
AFTER INSERT ON reviews
FOR EACH ROW
BEGIN
    UPDATE users 
    SET reputacion_media = (
        SELECT AVG(puntuacion) 
        FROM reviews 
        WHERE usuario_calificado_id = NEW.usuario_calificado_id
    )
    WHERE id = NEW.usuario_calificado_id;
END;
//
DELIMITER ;

INSERT INTO users (nombre_completo, email, password_hash, telefono, latitud, longitud) VALUES
('Carlos Estudiante', 'carlos@example.com', 'hash_secreto_123', '600111222', 40.416775, -3.703790),
('Marta García', 'marta@example.com', 'hash_secreto_456', '600333444', 40.418000, -3.705000), 
('Pedro López', 'pedro@example.com', 'hash_secreto_789', '600555666', 40.415000, -3.701000); 

INSERT INTO tasks (creador_id, titulo, descripcion, precio, estado, latitud, longitud) VALUES
(2, 'Ayuda Mudanza', 'Necesito subir sofá 3 plazas. 2º sin ascensor.', 15.00, 'Open', 40.418000, -3.705000),
(3, 'Paseo Perros', 'Dos caniches muy buenos. 30 min parque.', 8.00, 'Open', 40.415000, -3.701000);