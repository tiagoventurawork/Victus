<?php
class Router {
    private $routes = [];

    public function add(string $method, string $path, string $handler): void {
        $this->routes[] = [
            'method'  => strtoupper($method),
            'path'    => $path,
            'handler' => $handler,
        ];
    }

    public function dispatch(): void {
        $requestMethod = $_SERVER['REQUEST_METHOD'];
        $requestUri    = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
        
        // Remove the base path (e.g., /victus/api)
        $basePath = $this->detectBasePath();
        if ($basePath && strpos($requestUri, $basePath) === 0) {
            $requestUri = substr($requestUri, strlen($basePath));
        }
        
        // Ensure starts with /
        if (empty($requestUri)) $requestUri = '/';
        if ($requestUri[0] !== '/') $requestUri = '/' . $requestUri;
        
        // Remove trailing slash (except root)
        if (strlen($requestUri) > 1) {
            $requestUri = rtrim($requestUri, '/');
        }

        foreach ($this->routes as $route) {
            $params = $this->match($route['path'], $requestUri);
            
            if ($route['method'] === $requestMethod && $params !== false) {
                [$controllerName, $methodName] = explode('@', $route['handler']);
                
                if (!class_exists($controllerName)) {
                    http_response_code(500);
                    echo json_encode(['error' => "Controller $controllerName not found"]);
                    return;
                }
                
                $controller = new $controllerName();
                
                if (!method_exists($controller, $methodName)) {
                    http_response_code(500);
                    echo json_encode(['error' => "Method $methodName not found"]);
                    return;
                }
                
                $controller->$methodName($params);
                return;
            }
        }

        http_response_code(404);
        echo json_encode(['error' => 'Route not found', 'uri' => $requestUri]);
    }

    private function detectBasePath(): string {
        // Detect the base path from SCRIPT_NAME
        // e.g., /victus/api/index.php -> /victus/api
        $scriptName = $_SERVER['SCRIPT_NAME'] ?? '';
        return dirname($scriptName);
    }

    private function match(string $routePath, string $requestUri) {
        $routeParts   = explode('/', trim($routePath, '/'));
        $requestParts = explode('/', trim($requestUri, '/'));

        if (count($routeParts) !== count($requestParts)) return false;

        $params = [];
        for ($i = 0; $i < count($routeParts); $i++) {
            if (preg_match('/^\{(\w+)\}$/', $routeParts[$i], $m)) {
                $params[$m[1]] = $requestParts[$i];
            } elseif ($routeParts[$i] !== $requestParts[$i]) {
                return false;
            }
        }

        return $params;
    }
}