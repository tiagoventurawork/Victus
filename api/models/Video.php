<?php
class Video {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    public function findById(int $id): ?array {
        $stmt = $this->db->prepare('
            SELECT v.*, l.title AS lesson_title, l.playlist_id,
                   p.title AS playlist_title
            FROM videos v
            JOIN lessons l ON l.id = v.lesson_id
            JOIN playlists p ON p.id = l.playlist_id
            WHERE v.id = ?
        ');
        $stmt->execute([$id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function getNextVideo(int $currentVideoId): ?array {
        $current = $this->findById($currentVideoId);
        if (!$current) return null;

        // Next in same lesson
        $stmt = $this->db->prepare('
            SELECT v.* FROM videos v
            WHERE v.lesson_id = ? AND v.sort_order > ?
            ORDER BY v.sort_order ASC LIMIT 1
        ');
        $stmt->execute([$current['lesson_id'], $current['sort_order']]);
        $next = $stmt->fetch();
        if ($next) return $next;

        // Next lesson, first video
        $stmt = $this->db->prepare('
            SELECT v.* FROM videos v
            JOIN lessons l ON l.id = v.lesson_id
            JOIN lessons cl ON cl.id = ?
            WHERE l.playlist_id = cl.playlist_id AND l.sort_order > cl.sort_order
            ORDER BY l.sort_order ASC, v.sort_order ASC LIMIT 1
        ');
        $stmt->execute([$current['lesson_id']]);
        $next = $stmt->fetch();
        return $next ?: null;
    }
}