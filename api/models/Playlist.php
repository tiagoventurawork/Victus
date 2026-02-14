<?php
class Playlist {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    public function getAll(): array {
        $stmt = $this->db->query('SELECT * FROM playlists ORDER BY sort_order ASC');
        return $stmt->fetchAll();
    }

    public function findById(int $id): ?array {
        $stmt = $this->db->prepare('SELECT * FROM playlists WHERE id = ?');
        $stmt->execute([$id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function getLessonsWithVideos(int $playlistId): array {
        $stmt = $this->db->prepare('
            SELECT l.*, 
                   v.id AS video_id, v.title AS video_title, v.description AS video_description,
                   v.video_url, v.thumbnail, v.duration, v.sort_order AS video_sort_order
            FROM lessons l
            LEFT JOIN videos v ON v.lesson_id = l.id
            WHERE l.playlist_id = ?
            ORDER BY l.sort_order ASC, v.sort_order ASC
        ');
        $stmt->execute([$playlistId]);
        $rows = $stmt->fetchAll();

        $lessons = [];
        foreach ($rows as $row) {
            $lid = $row['id'];
            if (!isset($lessons[$lid])) {
                $lessons[$lid] = [
                    'id'         => (int) $row['id'],
                    'title'      => $row['title'],
                    'sort_order' => (int) $row['sort_order'],
                    'is_free'    => (bool) $row['is_free'],
                    'videos'     => [],
                ];
            }
            if ($row['video_id']) {
                $lessons[$lid]['videos'][] = [
                    'id'          => (int) $row['video_id'],
                    'title'       => $row['video_title'],
                    'description' => $row['video_description'],
                    'video_url'   => $row['video_url'],
                    'thumbnail'   => $row['thumbnail'],
                    'duration'    => (int) $row['duration'],
                    'sort_order'  => (int) $row['video_sort_order'],
                ];
            }
        }

        return array_values($lessons);
    }

    public function getProgressForUser(int $playlistId, int $userId): float {
        $stmt = $this->db->prepare('
            SELECT 
                COUNT(DISTINCT v.id) AS total_videos,
                COUNT(DISTINCT c.video_id) AS completed_videos
            FROM lessons l
            JOIN videos v ON v.lesson_id = l.id
            LEFT JOIN completed c ON c.video_id = v.id AND c.user_id = ?
            WHERE l.playlist_id = ?
        ');
        $stmt->execute([$userId, $playlistId]);
        $row = $stmt->fetch();

        if (!$row || $row['total_videos'] == 0) return 0;
        return round(($row['completed_videos'] / $row['total_videos']) * 100, 1);
    }
}