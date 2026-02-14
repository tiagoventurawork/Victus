<?php
class Completed {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    public function toggle(int $userId, int $videoId): array {
        $stmt = $this->db->prepare('SELECT id FROM completed WHERE user_id = ? AND video_id = ?');
        $stmt->execute([$userId, $videoId]);
        $exists = $stmt->fetch();

        if ($exists) {
            $this->db->prepare('DELETE FROM completed WHERE id = ?')->execute([$exists['id']]);
            return ['completed' => false];
        } else {
            $this->db->prepare('INSERT INTO completed (user_id, video_id) VALUES (?, ?)')->execute([$userId, $videoId]);
            return ['completed' => true];
        }
    }

    public function getAll(int $userId): array {
        $stmt = $this->db->prepare('
            SELECT c.*, v.title, v.thumbnail FROM completed c
            JOIN videos v ON v.id = c.video_id
            WHERE c.user_id = ?
        ');
        $stmt->execute([$userId]);
        return $stmt->fetchAll();
    }

    public function isCompleted(int $userId, int $videoId): bool {
        $stmt = $this->db->prepare('SELECT 1 FROM completed WHERE user_id = ? AND video_id = ?');
        $stmt->execute([$userId, $videoId]);
        return (bool) $stmt->fetch();
    }
}