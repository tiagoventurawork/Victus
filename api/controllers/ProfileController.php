<?php
class ProfileController {

    public function show(array $params): void {
        $auth = AuthMiddleware::authenticate();
        $userModel = new User();
        $user = $userModel->findById($auth['user_id']);

        if (!$user) {
            http_response_code(404);
            echo json_encode(['error' => 'Utilizador não encontrado']);
            return;
        }

        echo json_encode($user);
    }

    public function update(array $params): void {
        $auth = AuthMiddleware::authenticate();
        $data = json_decode(file_get_contents('php://input'), true);

        $allowed = ['name', 'phone', 'birth_date'];
        $updateData = [];
        foreach ($allowed as $field) {
            if (isset($data[$field])) {
                $updateData[$field] = $data[$field];
            }
        }

        if (empty($updateData)) {
            http_response_code(422);
            echo json_encode(['error' => 'Nenhum campo para atualizar']);
            return;
        }

        $userModel = new User();
        $userModel->update($auth['user_id'], $updateData);
        $user = $userModel->findById($auth['user_id']);

        echo json_encode([
            'message' => 'Perfil atualizado com sucesso',
            'user'    => $user,
        ]);
    }

    public function uploadAvatar(array $params): void {
        $auth = AuthMiddleware::authenticate();

        if (!isset($_FILES['avatar'])) {
            http_response_code(422);
            echo json_encode(['error' => 'Ficheiro avatar é obrigatório']);
            return;
        }

        $file = $_FILES['avatar'];
        $allowedTypes = ['image/jpeg', 'image/png', 'image/webp'];

        if (!in_array($file['type'], $allowedTypes)) {
            http_response_code(422);
            echo json_encode(['error' => 'Tipo de ficheiro não permitido. Use JPG, PNG ou WebP']);
            return;
        }

        if ($file['size'] > 5 * 1024 * 1024) {
            http_response_code(422);
            echo json_encode(['error' => 'Ficheiro demasiado grande. Máximo 5MB']);
            return;
        }

        $uploadDir = __DIR__ . '/../uploads/avatars/';
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0755, true);
        }

        $ext = pathinfo($file['name'], PATHINFO_EXTENSION);
        $filename = 'avatar_' . $auth['user_id'] . '_' . time() . '.' . $ext;
        $filepath = $uploadDir . $filename;

        if (!move_uploaded_file($file['tmp_name'], $filepath)) {
            http_response_code(500);
            echo json_encode(['error' => 'Erro ao guardar ficheiro']);
            return;
        }

        $relativePath = '/uploads/avatars/' . $filename;
        $userModel = new User();
        $userModel->updateAvatar($auth['user_id'], $relativePath);
        $user = $userModel->findById($auth['user_id']);

        echo json_encode([
            'message' => 'Avatar atualizado com sucesso',
            'user'    => $user,
        ]);
    }
}