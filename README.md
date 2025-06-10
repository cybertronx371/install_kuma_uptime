# NEOCORE.ID
# Skrip Instalasi Otomatis Uptime Kuma dengan IP Binding 

Skrip ini dirancang untuk mengotomatiskan instalasi Uptime Kuma, sebuah tool monitoring modern, pada sistem operasi berbasis Debian/Ubuntu. Fitur utama dari skrip ini adalah kemampuannya untuk mengonfigurasi Uptime Kuma agar hanya berjalan dan merespon pada alamat IP server yang **Anda tentukan**. Hal ini sangat berguna untuk meningkatkan keamanan dengan mencegah eksposur layanan ke jaringan publik secara tidak sengaja.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Deskripsi

Proses instalasi manual bisa memakan waktu dan rentan terhadap kesalahan konfigurasi. Skrip ini menyederhanakan proses tersebut dengan melakukan langkah-langkah berikut secara otomatis:
1.  Memperbarui daftar paket sistem.
2.  Memeriksa dan menginstal dependensi yang dibutuhkan (`git`, `curl`, `docker`).
3.  Mengunduh (clone) repositori resmi Uptime Kuma.
4.  Membuat file `docker-compose.yml` kustom yang mengikat container ke IP dan port yang telah ditentukan pengguna.
5.  Menjalankan Uptime Kuma di background menggunakan Docker Compose.

## Fitur Utama

-   **Instalasi Otomatis**: Menginstal Docker, Docker Compose, dan Git jika belum ada.
-   **Konfigurasi Keamanan**: Mengikat Uptime Kuma ke alamat IP spesifik untuk membatasi akses.
-   **Kustomisasi Mudah**: Variabel seperti Alamat IP, Port, dan Direktori Instalasi dapat dengan mudah diubah di bagian atas skrip.
-   **Idempoten**: Skrip dapat dijalankan kembali tanpa menyebabkan masalah (misalnya, tidak akan meng-clone ulang jika direktori sudah ada).
-   **Notifikasi Proses**: Memberikan output yang jelas mengenai setiap langkah yang sedang dijalankan.

## Prasyarat

-   Sistem Operasi: **Debian** atau **Ubuntu**.
-   Hak Akses: Anda harus memiliki akses `sudo` atau `root`.
-   Koneksi Internet: Diperlukan untuk mengunduh paket dan image Docker.
-   **Alamat IP**: Server tempat skrip dijalankan harus memiliki alamat IP yang akan Anda gunakan untuk binding.

## Cara Penggunaan

1.  **Konfigurasi Skrip**

    Buka file skrip dan ubah variabel di bagian `-- Variabel Konfigurasi --` sesuai dengan kebutuhan Anda.

    ```bash
    # Alamat IP yang akan digunakan oleh Uptime Kuma.
    # Ganti dengan IP LAN server Anda jika ingin diakses dari komputer lain.
    #
    # Pilihan:
    # - "127.0.0.1" (localhost): Paling aman, hanya bisa diakses dari server itu sendiri.
    # - "192.168.1.100" (contoh): Gunakan IP server Anda di jaringan lokal (LAN).
    UPTIME_KUMA_IP="127.0.0.1"

    # Port yang akan digunakan di host.
    UPTIME_KUMA_PORT="3001"

    # Direktori instalasi
    INSTALL_DIR="uptime-kuma"
    ```
    **PENTING:** Pastikan Anda mengisi `UPTIME_KUMA_IP` dengan benar sesuai dengan tujuan akses Anda.

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
-   **Akses Uptime Kuma**: Buka browser Anda dan akses melalui URL sesuai konfigurasi Anda:
    `http://<IP_YANG_ANDA_KONFIGURASI>:<PORT_YANG_ANDA_KONFIGURASI>`
    Contoh: `http://127.0.0.1:3001` atau `http://192.168.1.100:3001`

-   **Konfigurasi Firewall**: Pastikan firewall Anda (misalnya `ufw`) mengizinkan koneksi masuk pada port yang telah Anda konfigurasikan.
    ```bash
    # Contoh jika menggunakan port 3001
    sudo ufw allow 3001/tcp
    sudo ufw reload
    ```
-   **Catatan Akses**:
    -   Jika Anda menggunakan `127.0.0.1`, Uptime Kuma hanya bisa diakses dari dalam server itu sendiri (misalnya via browser di desktop server atau SSH Tunnel).
    -   Jika Anda menggunakan IP LAN (contoh: `192.168.1.100`), Uptime Kuma bisa diakses dari komputer lain selama masih dalam satu jaringan yang sama.

-   **Lokasi Data**: Semua data konfigurasi dan riwayat Uptime Kuma akan tersimpan di dalam direktori `./uptime-kuma/uptime-kuma-data` relatif terhadap lokasi skrip dijalankan.

## Penafian (Disclaimer)

Skrip ini disediakan "sebagaimana adanya". Penulis tidak bertanggung jawab atas kerusakan atau masalah yang mungkin timbul dari penggunaan skrip ini. Selalu uji coba di lingkungan yang tidak kritis terlebih dahulu.

## Lisensi

Skrip ini berada di bawah [Lisensi MIT](https://opensource.org/licenses/MIT).
