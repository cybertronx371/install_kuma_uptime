# Skrip Instalasi Otomatis Uptime Kuma dengan IP Binding

Skrip ini dirancang untuk mengotomatiskan instalasi Uptime Kuma, sebuah tool monitoring modern, pada sistem operasi berbasis Debian/Ubuntu. Fitur utama dari skrip ini adalah kemampuannya untuk mengonfigurasi Uptime Kuma agar hanya berjalan dan merespon pada alamat IP server yang spesifik. Hal ini sangat berguna untuk meningkatkan keamanan dengan mencegah eksposur layanan ke jaringan publik secara tidak sengaja.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Deskripsi

Proses instalasi manual bisa memakan waktu dan rentan terhadap kesalahan konfigurasi. Skrip ini menyederhanakan proses tersebut dengan melakukan langkah-langkah berikut secara otomatis:
1.  Memperbarui daftar paket sistem.
2.  Memeriksa dan menginstal dependensi yang dibutuhkan (`git`, `curl`, `docker`).
3.  Mengunduh (clone) repositori resmi Uptime Kuma.
4.  Membuat file `docker-compose.yml` kustom yang mengikat container ke IP dan port yang telah ditentukan.
5.  Menjalankan Uptime Kuma di background menggunakan Docker Compose.

## Fitur Utama

-   **Instalasi Otomatis**: Menginstal Docker, Docker Compose, dan Git jika belum ada.
-   **Konfigurasi Keamanan**: Secara default, mengikat Uptime Kuma ke alamat IP privat untuk membatasi akses.
-   **Kustomisasi Mudah**: Variabel seperti Alamat IP, Port, dan Direktori Instalasi dapat dengan mudah diubah di bagian atas skrip.
-   **Idempoten**: Skrip dapat dijalankan kembali tanpa menyebabkan masalah (misalnya, tidak akan meng-clone ulang jika direktori sudah ada).
-   **Notifikasi Proses**: Memberikan output yang jelas mengenai setiap langkah yang sedang dijalankan.

## Prasyarat

-   Sistem Operasi: **Debian** atau **Ubuntu**.
-   Hak Akses: Anda harus memiliki akses `sudo` atau `root`.
-   Koneksi Internet: Diperlukan untuk mengunduh paket dan image Docker.
-   **IP Statis**: Server tempat skrip dijalankan harus memiliki alamat IP yang akan digunakan untuk binding (misalnya, `172.16.97.3` dalam konfigurasi default).

## Cara Penggunaan

1.  **Konfigurasi Skrip**

    Buka file skrip dan ubah variabel di bagian `-- Variabel Konfigurasi --` sesuai dengan kebutuhan Anda.
    ```bash
    # Alamat IP yang akan digunakan oleh Uptime Kuma
    UPTIME_KUMA_IP="172.16.97.3"

    # Port yang akan digunakan di host
    UPTIME_KUMA_PORT="3001"

    # Direktori instalasi
    INSTALL_DIR="uptime-kuma"
    ```
    **PENTING:** Pastikan nilai `UPTIME_KUMA_IP` adalah salah satu alamat IP yang terpasang di server Anda.

2.  **Simpan Skrip**

    Simpan skrip ini ke dalam sebuah file, misalnya `install-kuma.sh`.

3.  **Berikan Izin Eksekusi**

    Buka terminal dan jalankan perintah berikut untuk membuat skrip dapat dieksekusi:
    ```bash
    chmod +x install-kuma.sh
    ```

4.  **Jalankan Skrip**

    Eksekusi skrip dengan hak akses `sudo` agar dapat menginstal paket dan menjalankan Docker.
    ```bash
    sudo ./install-kuma.sh
    ```

## Setelah Instalasi

Setelah skrip selesai dijalankan, Anda akan melihat pesan sukses.
-   **Akses Uptime Kuma**: Buka browser Anda dan akses melalui URL yang ditampilkan, contohnya:
    `http://172.16.97.3:3001`
-   **Konfigurasi Firewall**: Pastikan firewall Anda (misalnya `ufw`) mengizinkan koneksi masuk pada port yang telah Anda konfigurasikan.
    ```bash
    # Contoh jika menggunakan ufw
    sudo ufw allow 3001/tcp
    sudo ufw reload
    ```
-   **Lokasi Data**: Semua data konfigurasi dan riwayat Uptime Kuma akan tersimpan di dalam direktori `./uptime-kuma/uptime-kuma-data` relatif terhadap lokasi skrip dijalankan.

## Penafian (Disclaimer)

Skrip ini disediakan "sebagaimana adanya". Penulis tidak bertanggung jawab atas kerusakan atau masalah yang mungkin timbul dari penggunaan skrip ini. Selalu uji coba di lingkungan yang tidak kritis terlebih dahulu.

## Lisensi

Skrip ini berada di bawah [Lisensi MIT](https://opensource.org/licenses/MIT).
