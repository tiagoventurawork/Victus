<?php
class Event {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    public function getAll(): array {
        $stmt = $this->db->query('SELECT * FROM events ORDER BY event_date ASC');
        return $stmt->fetchAll();
    }

    public function getUpcoming(int $limit = 5): array {
        $stmt = $this->db->prepare('SELECT * FROM events WHERE event_date >= NOW() ORDER BY event_date ASC LIMIT ?');
        $stmt->execute([$limit]);
        return $stmt->fetchAll();
    }

    public function findById(int $id): ?array {
        $stmt = $this->db->prepare('SELECT * FROM events WHERE id = ?');
        $stmt->execute([$id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }
}