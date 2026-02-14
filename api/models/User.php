<?php
class User {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    public function findByEmail(string $email): ?array {
        $stmt = $this->db->prepare('SELECT * FROM users WHERE email = ?');
        $stmt->execute([$email]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function findById(int $id): ?array {
        $stmt = $this->db->prepare('SELECT id, name, email, avatar, phone, birth_date, weight_lost, created_at FROM users WHERE id = ?');
        $stmt->execute([$id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function create(array $data): int {
        $stmt = $this->db->prepare('INSERT INTO users (name, email, password) VALUES (?, ?, ?)');
        $stmt->execute([
            $data['name'],
            $data['email'],
            password_hash($data['password'], PASSWORD_DEFAULT),
        ]);
        return (int) $this->db->lastInsertId();
    }

    public function update(int $id, array $data): bool {
        $fields = [];
        $values = [];
        foreach ($data as $key => $val) {
            $fields[] = "$key = ?";
            $values[] = $val;
        }
        $values[] = $id;
        $sql = 'UPDATE users SET ' . implode(', ', $fields) . ' WHERE id = ?';
        return $this->db->prepare($sql)->execute($values);
    }

    public function updateAvatar(int $id, string $path): bool {
        $stmt = $this->db->prepare('UPDATE users SET avatar = ? WHERE id = ?');
        return $stmt->execute([$path, $id]);
    }

    public function createResetToken(int $userId, string $token): bool {
        $expires = date('Y-m-d H:i:s', strtotime('+1 hour'));
        $stmt = $this->db->prepare('INSERT INTO password_resets (user_id, token, expires_at) VALUES (?, ?, ?)');
        return $stmt->execute([$userId, $token, $expires]);
    }

    public function findResetToken(string $token): ?array {
        $stmt = $this->db->prepare('SELECT * FROM password_resets WHERE token = ? AND used = 0 AND expires_at > NOW()');
        $stmt->execute([$token]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function resetPassword(int $userId, string $newPassword, int $tokenId): bool {
        $this->db->beginTransaction();
        try {
            $stmt1 = $this->db->prepare('UPDATE users SET password = ? WHERE id = ?');
            $stmt1->execute([password_hash($newPassword, PASSWORD_DEFAULT), $userId]);
            $stmt2 = $this->db->prepare('UPDATE password_resets SET used = 1 WHERE id = ?');
            $stmt2->execute([$tokenId]);
            $this->db->commit();
            return true;
        } catch (Exception $e) {
            $this->db->rollBack();
            return false;
        }
    }
}