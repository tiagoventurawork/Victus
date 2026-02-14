<?php
class NoteController {

    public function index(array $params): void {
        $auth = AuthMiddleware::authenticate();
        $noteModel = new Note();
        $notes = $noteModel->getByVideo($auth['user_id'], (int)$params['videoId']);
        echo json_encode($notes);
    }

    public function store(array $params): void {
        $auth = AuthMiddleware::authenticate();
        $data = json_decode(file_get_contents('php://input'), true);

        if (empty($data['video_id']) || empty($data['content'])) {
            http_response_code(422);
            echo json_encode(['error' => 'video_id e content são obrigatórios']);
            return;
        }

        $noteModel = new Note();
        $id = $noteModel->create(
            $auth['user_id'],
            (int)$data['video_id'],
            $data['content'],
            (int)($data['timestamp'] ?? 0)
        );

        http_response_code(201);
        echo json_encode(['message' => 'Nota criada', 'id' => $id]);
    }

    public function update(array $params): void {
        $auth = AuthMiddleware::authenticate();
        $data = json_decode(file_get_contents('php://input'), true);

        if (empty($data['content'])) {
            http_response_code(422);
            echo json_encode(['error' => 'content é obrigatório']);
            return;
        }

        $noteModel = new Note();
        $noteModel->update((int)$params['id'], $auth['user_id'], $data['content']);
        echo json_encode(['message' => 'Nota atualizada']);
    }

    public function destroy(array $params): void {
        $auth = AuthMiddleware::authenticate();
        $noteModel = new Note();
        $noteModel->delete((int)$params['id'], $auth['user_id']);
        echo json_encode(['message' => 'Nota eliminada']);
    }
}