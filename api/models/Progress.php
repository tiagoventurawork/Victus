<?php
class Progress {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    public function save(int $userId, int $videoId, int $currentSeconds, int $totalSeconds): bool {
        $percentage = $totalSeconds > 0 ? round(($currentSeconds / $totalSeconds) * 100, 2) : 0;
        $stmt = $this->db->prepare('
            INSERT INTO video_progress (user_id, video_id, current_seconds, total_seconds, percentage)
            VALUES (?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE
                current_seconds = VALUES(current_seconds),
                total_seconds = VALUES(total_seconds),
                percentage = VALUES(percentage),
                updated_at = NOW()
        ');
        return $stmt->execute([$userId, $videoId, $currentSeconds, $totalSeconds, $percentage]);
    }

    public function get(int $userId, int $videoId): ?array {
        $stmt = $this->db->prepare('SELECT * FROM video_progress WHERE user_id = ? AND video_id = ?');
        $stmt->execute([$userId, $videoId]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function getAllForUser(int $userId): array {
        $stmt = $this->db->prepare('SELECT * FROM video_progress WHERE user_id = ?');
        $stmt->execute([$userId]);
        return $stmt->fetchAll();
    }
}