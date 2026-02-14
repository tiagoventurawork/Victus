<?php
class CommentController {

    public function index(array $params): void {
        AuthMiddleware::authenticate();
        $db = Database::getInstance();
        $stmt = $db->prepare('
            SELECT c.*, u.name AS user_name, u.avatar AS user_avatar
            FROM comments c
            JOIN users u ON u.id = c.user_id
            WHERE c.video_id = ?
            ORDER BY c.created_at DESC
        ');
        $stmt->execute([(int)$params['videoId']]);
        echo json_encode($stmt->fetchAll());
    }

    public function store(array $params): void {
        $auth = AuthMiddleware::authenticate();
        $data = json_decode(file_get_contents('php://input'), true);

        if (empty($data['video_id']) || empty($data['content'])) {
            http_response_code(422);
            echo json_encode(['error' => 'video_id e content são obrigatórios']);
            return;
        }

        $db = Database::getInstance();
        $stmt = $db->prepare('INSERT INTO comments (user_id, video_id, content) VALUES (?, ?, ?)');
        $stmt->execute([$auth['user_id'], (int)$data['video_id'], $data['content']]);

        http_response_code(201);
        echo json_encode(['message' => 'Comentário criado', 'id' => (int)$db->lastInsertId()]);
    }
}