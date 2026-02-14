<?php
class EventController {

    public function index(array $params): void {
        AuthMiddleware::authenticate();
        $eventModel = new Event();
        echo json_encode($eventModel->getAll());
    }

    public function show(array $params): void {
        AuthMiddleware::authenticate();
        $eventModel = new Event();
        $event = $eventModel->findById((int)$params['id']);

        if (!$event) {
            http_response_code(404);
            echo json_encode(['error' => 'Evento não encontrado']);
            return;
        }

        echo json_encode($event);
    }
}