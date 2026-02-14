<?php
class Banner {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    public function getActive(): array {
        $stmt = $this->db->query('SELECT * FROM banners WHERE active = 1 ORDER BY sort_order ASC');
        return $stmt->fetchAll();
    }
}