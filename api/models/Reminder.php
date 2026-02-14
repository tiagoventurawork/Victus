<?php
class Reminder {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    public function getToday(): ?array {
        $stmt = $this->db->prepare('SELECT * FROM reminders WHERE show_date = CURDATE() AND active = 1 LIMIT 1');
        $stmt->execute();
        $row = $stmt->fetch();
        return $row ?: null;
    }
}