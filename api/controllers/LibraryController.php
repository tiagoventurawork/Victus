<?php
class LibraryController {

    public function index(array $params): void {
        $auth = AuthMiddleware::authenticate();
        $userId = $auth['user_id'];

        $playlistModel = new Playlist();
        $playlists = $playlistModel->getAll();

        // Add progress to each playlist
        foreach ($playlists as &$playlist) {
            $playlist['progress'] = $playlistModel->getProgressForUser($playlist['id'], $userId);
        }

        echo json_encode($playlists);
    }

    public function show(array $params): void {
        $auth = AuthMiddleware::authenticate();
        $userId = $auth['user_id'];

        $playlistModel  = new Playlist();
        $favoriteModel  = new Favorite();
        $completedModel = new Completed();
        $progressModel  = new Progress();

        $playlist = $playlistModel->findById((int)$params['id']);
        if (!$playlist) {
            http_response_code(404);
            echo json_encode(['error' => 'Playlist não encontrada']);
            return;
        }

        $lessons = $playlistModel->getLessonsWithVideos((int)$params['id']);
        $playlist['progress'] = $playlistModel->getProgressForUser((int)$params['id'], $userId);

        // Enrich videos with user state
        foreach ($lessons as &$lesson) {
            foreach ($lesson['videos'] as &$video) {
                $video['is_favorited'] = $favoriteModel->isFavorited($userId, $video['id']);
                $video['is_completed'] = $completedModel->isCompleted($userId, $video['id']);
                $progress = $progressModel->get($userId, $video['id']);
                $video['progress'] = $progress ? [
                    'current_seconds' => (int)$progress['current_seconds'],
                    'total_seconds'   => (int)$progress['total_seconds'],
                    'percentage'      => (float)$progress['percentage'],
                ] : null;
            }
        }

        // Check lesson completion
        foreach ($lessons as &$lesson) {
            $allCompleted = true;
            foreach ($lesson['videos'] as $v) {
                if (!$v['is_completed']) { $allCompleted = false; break; }
            }
            $lesson['is_completed'] = $allCompleted;
        }

        $playlist['lessons'] = $lessons;
        echo json_encode($playlist);
    }
}