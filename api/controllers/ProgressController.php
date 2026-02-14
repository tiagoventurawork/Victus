<?php
class ProgressController {

    public function save(array $params): void {
        $auth = AuthMiddleware::authenticate();
        $data = json_decode(file_get_contents('php://input'), true);

        if (empty($data['video_id']) || !isset($data['current_seconds']) || !isset($data['total_seconds'])) {
            http_response_code(422);
            echo json_encode(['error' => 'video_id, current_seconds e total_seconds são obrigatórios']);
            return;
        }

        $progressModel = new Progress();
        $progressModel->save(
            $auth['user_id'],
            (int)$data['video_id'],
            (int)$data['current_seconds'],
            (int)$data['total_seconds']
        );

        echo json_encode(['message' => 'Progresso guardado']);
    }

    public function get(array $params): void {
        $auth = AuthMiddleware::authenticate();
        $progressModel = new Progress();
        $progress = $progressModel->get($auth['user_id'], (int)$params['videoId']);

        echo json_encode($progress ?? ['current_seconds' => 0, 'total_seconds' => 0, 'percentage' => 0]);
    }
}