#!/bin/bash

# Update system and install necessary packages
sudo apt-get update -y
sudo apt-get install -y apt-transport-https software-properties-common wget ufw nginx

# Allow Nginx HTTP through UFW (if using firewall)
sudo ufw allow 'Nginx HTTP'

# Allow Grafana port 3000 through UFW
sudo ufw allow 3000

# Install Prometheus, Prometheus Node Exporter, Push Gateway, and Alertmanager
sudo apt-get install -y prometheus prometheus-node-exporter prometheus-pushgateway prometheus-alertmanager

# Install Grafana
# Add Grafana APT repository keyring
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

# Add Grafana repository to APT sources
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Update the list of available packages
sudo apt-get update

# Install Grafana
sudo apt-get install -y grafana

# Install Prometheus Blackbox Exporter for HTTP monitoring
sudo apt-get install -y prometheus-blackbox-exporter

# Enable and start Prometheus service
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Enable and start Grafana service
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Configure Prometheus to scrape metrics from localhost and the app on port 80
cat <<EOF | sudo tee /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]  # Module to check for HTTP 2xx responses
    static_configs:
      - targets:
        - http://localhost:80  # Your app running on port 80
    relabel_configs:
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __param_probe
        replacement: probe_http
      - target_label: job
        replacement: blackbox
EOF

# Restart Prometheus to apply changes
sudo systemctl restart prometheus

# Configure Grafana to listen on all network interfaces (0.0.0.0)
sudo sed -i 's/^#http_addr = 127.0.0.1/http_addr = 0.0.0.0/' /etc/grafana/grafana.ini

# Restart Grafana to apply changes
sudo systemctl restart grafana-server

# Check if Prometheus and Grafana services are running
sudo systemctl status prometheus
sudo systemctl status grafana-server

# Install Nginx and set up a simple HTML page
echo "<h1>Hello World from Level Up In Tech</h1>" > /var/www/html/index.html

# Enable Nginx to start on boot
sudo systemctl enable nginx
sudo systemctl restart nginx
