<?php
class AuthMiddleware {
    public static function authenticate(): array {
        $headers = getallheaders();
        $auth = $headers['Authorization'] ?? $headers['authorization'] ?? '';
        
        if (empty($auth) || !preg_match('/Bearer\s+(.+)/', $auth, $matches)) {
            http_response_code(401);
            echo json_encode(['error' => 'Token não fornecido']);
            exit;
        }
        
        $decoded = JwtHelper::decode($matches[1]);
        
        if (!$decoded) {
            http_response_code(401);
            echo json_encode(['error' => 'Token inválido ou expirado']);
            exit;
        }
        
        return $decoded;
    }
}