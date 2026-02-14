<?php
class CompletedController {

    public function toggle(array $params): void {
        $auth = AuthMiddleware::authenticate();
        $data = json_decode(file_get_contents('php://input'), true);

        if (empty($data['video_id'])) {
            http_response_code(422);
            echo json_encode(['error' => 'video_id é obrigatório']);
            return;
        }

        $model  = new Completed();
        $result = $model->toggle($auth['user_id'], (int)$data['video_id']);
        echo json_encode($result);
    }

    public function index(array $params): void {
        $auth = AuthMiddleware::authenticate();
        $model = new Completed();
        echo json_encode($model->getAll($auth['user_id']));
    }
}