<?php
class Note {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    public function getByVideo(int $userId, int $videoId): array {
        $stmt = $this->db->prepare('SELECT * FROM notes WHERE user_id = ? AND video_id = ? ORDER BY timestamp ASC');
        $stmt->execute([$userId, $videoId]);
        return $stmt->fetchAll();
    }

    public function create(int $userId, int $videoId, string $content, int $timestamp = 0): int {
        $stmt = $this->db->prepare('INSERT INTO notes (user_id, video_id, content, timestamp) VALUES (?, ?, ?, ?)');
        $stmt->execute([$userId, $videoId, $content, $timestamp]);
        return (int) $this->db->lastInsertId();
    }

    public function update(int $id, int $userId, string $content): bool {
        $stmt = $this->db->prepare('UPDATE notes SET content = ? WHERE id = ? AND user_id = ?');
        return $stmt->execute([$content, $id, $userId]);
    }

    public function delete(int $id, int $userId): bool {
        $stmt = $this->db->prepare('DELETE FROM notes WHERE id = ? AND user_id = ?');
        return $stmt->execute([$id, $userId]);
    }
}