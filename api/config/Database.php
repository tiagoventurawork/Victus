<?php
class Database {
    private static $instance = null;
    private $conn;

    private $host   = 'localhost';
    private $db     = 'victus_db';
    private $user   = 'root';
    private $pass   = 'root';

    private function __construct() {
        try {
            $this->conn = new PDO(
                "mysql:host={$this->host};dbname={$this->db};charset=utf8mb4",
                $this->user,
                $this->pass,
                [
                    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES   => false,
                ]
            );
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
            exit;
        }
    }

    public static function getInstance(): PDO {
        if (self::$instance === null) {
            $db = new self();
            self::$instance = $db->conn;
        }
        return self::$instance;
    }
}