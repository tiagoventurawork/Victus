<?php
class MaterialController {

    public function index(array $params): void {
        AuthMiddleware::authenticate();
        $db = Database::getInstance();
        $stmt = $db->prepare('SELECT * FROM materials WHERE video_id = ? ORDER BY id ASC');
        $stmt->execute([(int)$params['videoId']]);
        echo json_encode($stmt->fetchAll());
    }
}