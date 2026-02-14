<?php
class DashboardController {

    public function index(array $params): void {
        $auth = AuthMiddleware::authenticate();
        $userId = $auth['user_id'];

        $userModel     = new User();
        $bannerModel   = new Banner();
        $reminderModel = new Reminder();
        $eventModel    = new Event();

        $user     = $userModel->findById($userId);
        $banners  = $bannerModel->getActive();
        $reminder = $reminderModel->getToday();
        $events   = $eventModel->getUpcoming(5);

        echo json_encode([
            'user'     => $user,
            'banners'  => $banners,
            'reminder' => $reminder,
            'events'   => $events,
        ]);
    }
}