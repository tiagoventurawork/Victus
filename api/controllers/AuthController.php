<?php
class AuthController {
    
    public function register(array $params): void {
        $data = json_decode(file_get_contents('php://input'), true);

        if (empty($data['name']) || empty($data['email']) || empty($data['password'])) {
            http_response_code(422);
            echo json_encode(['error' => 'Nome, email e password são obrigatórios']);
            return;
        }

        if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            http_response_code(422);
            echo json_encode(['error' => 'Email inválido']);
            return;
        }

        if (strlen($data['password']) < 6) {
            http_response_code(422);
            echo json_encode(['error' => 'Password deve ter pelo menos 6 caracteres']);
            return;
        }

        $userModel = new User();
        
        if ($userModel->findByEmail($data['email'])) {
            http_response_code(409);
            echo json_encode(['error' => 'Este email já está registado']);
            return;
        }

        $userId = $userModel->create($data);
        $user   = $userModel->findById($userId);
        $token  = JwtHelper::encode(['user_id' => $userId, 'email' => $user['email']]);

        http_response_code(201);
        echo json_encode([
            'message' => 'Conta criada com sucesso',
            'token'   => $token,
            'user'    => $user,
        ]);
    }

    public function login(array $params): void {
        $data = json_decode(file_get_contents('php://input'), true);

        if (empty($data['email']) || empty($data['password'])) {
            http_response_code(422);
            echo json_encode(['error' => 'Email e password são obrigatórios']);
            return;
        }

        $userModel = new User();
        $user = $userModel->findByEmail($data['email']);

        if (!$user || !password_verify($data['password'], $user['password'])) {
            http_response_code(401);
            echo json_encode(['error' => 'Credenciais inválidas']);
            return;
        }

        $token = JwtHelper::encode(['user_id' => $user['id'], 'email' => $user['email']]);
        unset($user['password']);

        echo json_encode([
            'message' => 'Login efetuado com sucesso',
            'token'   => $token,
            'user'    => $user,
        ]);
    }

    public function recover(array $params): void {
        $data = json_decode(file_get_contents('php://input'), true);

        if (empty($data['email'])) {
            http_response_code(422);
            echo json_encode(['error' => 'Email é obrigatório']);
            return;
        }

        $userModel = new User();
        $user = $userModel->findByEmail($data['email']);

        // Always return success (security)
        if ($user) {
            $token = bin2hex(random_bytes(32));
            $userModel->createResetToken($user['id'], $token);
            // In production: send email with $token
        }

        echo json_encode([
            'message' => 'Se o email existir, receberás instruções de recuperação',
        ]);
    }

    public function resetPassword(array $params): void {
        $data = json_decode(file_get_contents('php://input'), true);

        if (empty($data['token']) || empty($data['new_password'])) {
            http_response_code(422);
            echo json_encode(['error' => 'Token e nova password são obrigatórios']);
            return;
        }

        $userModel = new User();
        $reset = $userModel->findResetToken($data['token']);

        if (!$reset) {
            http_response_code(400);
            echo json_encode(['error' => 'Token inválido ou expirado']);
            return;
        }

        $userModel->resetPassword($reset['user_id'], $data['new_password'], $reset['id']);
        echo json_encode(['message' => 'Password alterada com sucesso']);
    }
}