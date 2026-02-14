<?php
$hash = password_hash('123456', PASSWORD_DEFAULT);
echo "Hash: " . $hash . "<br>";

$host = 'localhost';
$db   = 'victus_db';
$user = 'root';
$pass = 'root';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8mb4", $user, $pass);
    $stmt = $pdo->prepare("UPDATE users SET password = ? WHERE email = 'cristiana@victus.pt'");
    $stmt->execute([$hash]);
    echo "Password atualizada com sucesso!<br>";
    echo "Login: cristiana@victus.pt / 123456";
} catch (Exception $e) {
    echo "Erro: " . $e->getMessage();
}