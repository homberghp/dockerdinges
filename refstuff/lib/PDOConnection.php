<?php

class PDOConnection extends PDO {

    public function __construct($dsnp = "pgsql:host=localhost;port=5432;dbname={$schema}") {
        require_once '../etc/db_settings.php';
        $options = [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION];
        parent::__construct($dsn, $username, $password, $options);
    }

}
