<?php
class JwtHelper {
    private static $secret = 'VICTUS_SECRET_KEY_2026_CHANGE_IN_PRODUCTION';
    private static $algo   = 'HS256';

    public static function encode(array $payload): string {
        $header = self::base64url(json_encode(['typ' => 'JWT', 'alg' => self::$algo]));
        
        $payload['iat'] = time();
        $payload['exp'] = time() + (60 * 60 * 24 * 30); // 30 days
        $payloadEncoded = self::base64url(json_encode($payload));
        
        $signature = self::base64url(
            hash_hmac('sha256', "$header.$payloadEncoded", self::$secret, true)
        );
        
        return "$header.$payloadEncoded.$signature";
    }

    public static function decode(string $token): ?array {
        $parts = explode('.', $token);
        if (count($parts) !== 3) return null;

        [$header, $payload, $signature] = $parts;
        
        $validSignature = self::base64url(
            hash_hmac('sha256', "$header.$payload", self::$secret, true)
        );
        
        if (!hash_equals($validSignature, $signature)) return null;
        
        $data = json_decode(self::base64urlDecode($payload), true);
        
        if (isset($data['exp']) && $data['exp'] < time()) return null;
        
        return $data;
    }

    private static function base64url(string $data): string {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    private static function base64urlDecode(string $data): string {
        return base64_decode(strtr($data, '-_', '+/'));
    }
}