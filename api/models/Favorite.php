<?php
class Favorite {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    public function toggle(int $userId, int $videoId): array {
        $stmt = $this->db->prepare('SELECT id FROM favorites WHERE user_id = ? AND video_id = ?');
        $stmt->execute([$userId, $videoId]);
        $exists = $stmt->fetch();

        if ($exists) {
            $this->db->prepare('DELETE FROM favorites WHERE id = ?')->execute([$exists['id']]);
            return ['favorited' => false];
        } else {
            $this->db->prepare('INSERT INTO favorites (user_id, video_id) VALUES (?, ?)')->execute([$userId, $videoId]);
            return ['favorited' => true];
        }
    }

    public function getAll(int $userId): array {
        $stmt = $this->db->prepare('
            SELECT f.*, v.title, v.thumbnail FROM favorites f
            JOIN videos v ON v.id = f.video_id
            WHERE f.user_id = ?
            ORDER BY f.created_at DESC
        ');
        $stmt->execute([$userId]);
        return $stmt->fetchAll();
    }

    public function isFavorited(int $userId, int $videoId): bool {
        $stmt = $this->db->prepare('SELECT 1 FROM favorites WHERE user_id = ? AND video_id = ?');
        $stmt->execute([$userId, $videoId]);
        return (bool) $stmt->fetch();
    }
}