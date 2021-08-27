<?php

/**
 * Using a data source allows easy switch between databases using the same user and password.
 * @author Pieter avn den Hombergh p.vandenhombergh@fontys.nl
 */
class PDODataSource {

    private $username;
    private $password;
    private $dbname;
    private $port = 5432;
    private $host = 'localhost';
    private $options = [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION];

    /**
     * Construct a datasource.
     * @param string $dbnamep name of database to connect to.
     */
    public function __construct(string $dbnamep, int $port=5432, string $host='localhost') {
        require_once '../etc/db_settings.php';
        $this->username = $username;
        $this->password = $password;
        $this->dbname = $dbnamep;
        $this->port=$port;
        $this->host=$host;
    }

    /**
     * Get a connection using this data source.
     * @return \PDO the connection object.
     */
    public function getConnection(): PDO {
        $dsn = "pgsql:host={$this->host};port={$this->port};dbname={$this->dbname}";
        return new PDO($dsn, $this->username, $this->password, $this->options);
    }

    /**
     * Specify the port. Call this method before getting a connection.
     * @param int $port to use
     * @return $this this data source
     */
    public function setPort(int $port) {
        $this->port = $port;
        return $this;
    }

    /**
     * Set the host for this data source.
     * @param string $host to use
     * @return $this data source
     */
    public function setHost(string $host) {
        $this->host = $host;
        return $this;
    }

    /**
     * Get the data base name for this data source.
     * @return string the name
     */
    public function getDbname() {
        return $this->dbname;
    }

    /**
     * Get the port for this data source.
     * @return int the port
     */
    public function getPort() {
        return $this->port;
    }

    /**
     * Get the host name for this datasource.
     * @return string host name
     */
    public function getHost() {
        return $this->host;
    }

    /**
     * Get the options array for this data source.
     * @return map with connection options such as how to deal with errors (exceptions).
     */
    public function getOptions() {
        return $this->options;
    }


}
