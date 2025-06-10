#!/bin/bash

# ==============================================================================
# Script Instalasi Otomatis Uptime Kuma dengan IP Binding Spesifik
# ==============================================================================
#
# Deskripsi:
# Script ini akan menginstal Git, Docker, dan Docker Compose jika belum ada,
# kemudian mengunduh Uptime Kuma dan menjalankannya dalam sebuah container Docker.
# Uptime Kuma akan dikonfigurasi untuk hanya merespon pada IP 172.16.97.3.
#
# Dibuat oleh: neocor
# Tanggal: 9 Juni 2025
#
# ==============================================================================

# -- Variabel Konfigurasi --
# Alamat IP yang akan digunakan oleh Uptime Kuma
# Pastikan server ini memiliki interface dengan IP ini.
UPTIME_KUMA_IP="172.0.0.1"

# Port yang akan digunakan di host. Port internal container adalah 3001.
UPTIME_KUMA_PORT="3001"

# Direktori instalasi
INSTALL_DIR="uptime-kuma"

# -- Fungsi untuk mencetak pesan --
print_info() {
    echo -e "\n\e[34m[INFO]\e[0m $1"
}

print_success() {
    echo -e "\e[32m[SUCCESS]\e[0m $1"
}

print_error() {
    echo -e "\e[31m[ERROR]\e[0m $1" >&2
    exit 1
}

# Hentikan script jika terjadi error
set -e

# -- Mulai Instalasi --
print_info "Memulai proses instalasi Uptime Kuma..."

# 1. Perbarui daftar paket
print_info "Memperbarui daftar paket (apt update)..."
sudo apt-get update -y

# 2. Install dependensi dasar (Git & Curl)
print_info "Menginstal dependensi: git dan curl..."
sudo apt-get install -y git curl

# 3. Install Docker jika belum terinstall
if ! command -v docker &> /dev/null; then
    print_info "Docker tidak ditemukan. Menginstal Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    # Tambahkan user saat ini ke grup docker untuk menjalankan perintah docker tanpa sudo
    # Perubahan ini memerlukan logout/login ulang atau 'newgrp docker' untuk aktif
    sudo usermod -aG docker ${USER}
    print_success "Docker berhasil diinstal."
    print_info "Anda mungkin perlu logout dan login kembali agar dapat menjalankan 'docker' tanpa 'sudo'."
else
    print_success "Docker sudah terinstal."
fi

# 4. Clone repository Uptime Kuma
if [ -d "$INSTALL_DIR" ]; then
    print_info "Direktori '$INSTALL_DIR' sudah ada. Melewati proses clone."
else
    print_info "Cloning repository Uptime Kuma dari GitHub..."
    git clone https://github.com/louislam/uptime-kuma.git "$INSTALL_DIR"
fi
cd "$INSTALL_DIR"

# 5. Buat file docker-compose.yml kustom
print_info "Membuat file docker-compose.yml dengan IP binding ke ${UPTIME_KUMA_IP}..."
cat << EOF > docker-compose.yml
version: '3.3'

services:
  uptime-kuma:
    image: louislam/uptime-kuma:1
    container_name: uptime-kuma
    volumes:
      - ./uptime-kuma-data:/app/data
    ports:
      # Format: "IP_HOST:PORT_HOST:PORT_CONTAINER"
      # Mengikat container ke IP spesifik di host
      - "${UPTIME_KUMA_IP}:${UPTIME_KUMA_PORT}:3001"
    restart: always

EOF

print_success "File docker-compose.yml berhasil dibuat."

# 6. Jalankan Uptime Kuma menggunakan Docker Compose
print_info "Menjalankan container Uptime Kuma di background..."
# Menggunakan 'sudo' untuk memastikan izin cukup, terutama setelah instalasi Docker baru
sudo docker compose up -d

# -- Selesai --
echo
print_success "========================================================"
print_success " INSTALASI UPTIME KUMA SELESAI!"
print_success "========================================================"
echo
print_info "Uptime Kuma sekarang berjalan dan hanya dapat diakses melalui:"
print_info "URL: http://${UPTIME_KUMA_IP}:${UPTIME_KUMA_PORT}"
echo
print_info "Catatan penting:"
print_info "-> Pastikan firewall di server Anda (misalnya ufw) mengizinkan koneksi masuk pada port ${UPTIME_KUMA_PORT}."
print_info "-> Karena IP ${UPTIME_KUMA_IP} adalah IP privat, Uptime Kuma hanya bisa diakses dari dalam jaringan lokal yang sama (LAN/VLAN)."
echo
