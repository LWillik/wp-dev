# Fresh WordPress install with Docker compose
This repo contains a dev environment that runs in `Docker` for `Windows 11` and `WSL2`.<br>
Make sure to place the `wp-dev` folder in your own WSL Distro's development directory.

--------------
**Installation:**
### 1. Install https://mkcert.org/
```bash
apt get mkcert
```
### 2. cd to certs directory
```bash
cd nginx/certs
```

### 3. Generate certificates
```bash
mkcert wp-dev.test
```

### 4. cd to project root
```bash
cd .. && cd ..
```

### 4. Build your containers
```bash
docker compose up -d --build
```

### 5. Give php write permission
```bash
chown -R 1000 ./
```

### 6. Install the latest version of WordPress
```bash
cd public && docker compose run wp core download
```

### 7. Boost WordPress performance

- Add the preload.php file to the public root.
