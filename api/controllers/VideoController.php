<?php
class VideoController {

    public function show(array $params): void {
        $auth = AuthMiddleware::authenticate();
        $userId = $auth['user_id'];

        $videoModel     = new Video();
        $favoriteModel  = new Favorite();
        $completedModel = new Completed();
        $progressModel  = new Progress();

        $video = $videoModel->findById((int)$params['id']);
        if (!$video) {
            http_response_code(404);
            echo json_encode(['error' => 'Vídeo não encontrado']);
            return;
        }

        $video['is_favorited'] = $favoriteModel->isFavorited($userId, $video['id']);
        $video['is_completed'] = $completedModel->isCompleted($userId, $video['id']);
        
        $progress = $progressModel->get($userId, $video['id']);
        $video['progress'] = $progress ? [
            'current_seconds' => (int)$progress['current_seconds'],
            'total_seconds'   => (int)$progress['total_seconds'],
            'percentage'      => (float)$progress['percentage'],
        ] : null;

        $next = $videoModel->getNextVideo($video['id']);
        $video['next_video'] = $next ? [
            'id'    => (int)$next['id'],
            'title' => $next['title'],
        ] : null;

        echo json_encode($video);
    }
}