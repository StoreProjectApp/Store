# Catatan Penjualan (PWA, offline-first)

Aplikasi kasir dan pencatatan penjualan toko. Berjalan di browser HP/komputer, bisa dipasang seperti aplikasi, tetap bisa dipakai tanpa internet, dan (opsional) menyinkronkan data ke Supabase saat ada jaringan.

## Isi folder

| File | Fungsi |
|---|---|
| `index.html` | Seluruh aplikasi (kasir, produk, laporan, pengaturan) |
| `sw.js` | Service Worker agar aplikasi terbuka saat offline |
| `manifest.json` | Agar bisa dipasang ke layar utama |
| `icons/` | Ikon aplikasi (ganti dengan logo Anda bila mau, nama dan ukuran sama) |
| `supabase.sql` | Pembuatan tabel dan aturan keamanan di Supabase |

## Cara pakai (tanpa Supabase)

1. Taruh semua file di hosting HTTPS (lihat bagian GitHub Pages), atau uji di komputer dengan `python3 -m http.server` lalu buka `http://localhost:8000`.
2. Buka tab **Pengaturan**: unggah **logo**, isi **nama toko**, alamat, dan catatan struk, lalu simpan.
3. Buka tab **Produk** dan tambahkan barang (stok boleh dikosongkan).
4. Pakai tab **Kasir** untuk transaksi, **Laporan** untuk omzet dan barang terlaris.

Logo dan nama toko tampil di bagian atas aplikasi dan di struk cetak. Logo otomatis diperkecil agar hemat ruang.

## Pasang di GitHub Pages

1. Buat repositori publik baru di GitHub, unggah semua isi folder ini (termasuk folder `icons`).
2. Settings > Pages > Source: **Deploy from a branch**, pilih `main` dan folder `/ (root)`.
3. Tunggu satu sampai dua menit. Alamatnya `https://NAMAANDA.github.io/NAMA-REPO/`.
4. Buka alamat itu di Chrome Android saat online, lalu menu ⋮ > **Instal aplikasi** / **Tambahkan ke layar utama**.
5. Uji: nyalakan mode pesawat, buka aplikasi dari ikon. Harus tetap terbuka.

## Sinkronisasi Supabase (opsional)

1. Buat proyek di supabase.com.
2. SQL Editor > tempel isi `supabase.sql` > Run.
3. Authentication > Users > **Add user** (isi email dan password, centang auto-confirm). Ini akun login toko.
4. Authentication > Sign In / Providers: matikan **Allow new users to sign up** agar orang lain tidak bisa mendaftar sendiri.
5. Project Settings > API: salin **Project URL** dan **anon public key**.
6. Di aplikasi: Pengaturan > Sinkronisasi Supabase, isi URL dan key, **Simpan koneksi**, lalu isi email dan password, **Login**.

Jangan pernah memasukkan kunci `service_role` ke aplikasi ini.

Setelah login, data yang belum terkirim diunggah otomatis saat ada jaringan (saat aplikasi dibuka, saat sinyal kembali, dan tiap 60 detik). Indikator di pojok kanan atas menunjukkan statusnya.

## Hal yang perlu diketahui

- **Stok di beberapa HP**: perubahan stok memakai aturan "yang terakhir menang". Jika dua HP menjual barang yang sama saat sama-sama offline, stok bisa selisih. Untuk toko dengan satu kasir, ini tidak jadi masalah.
- **Logo dan nama toko** disimpan per perangkat, tidak ikut tersinkron. Atur sekali di tiap perangkat.
- **Backup**: Pengaturan > Unduh backup (JSON) secara berkala, karena data lokal hilang jika data browser dihapus.
- **Cetak struk**: memakai fungsi cetak browser (ukuran 58 mm). Untuk printer Bluetooth, biasanya perlu aplikasi bawaan printer atau fitur cetak Android.
- **Update aplikasi**: ubah file di GitHub; saat HP online, versi baru terpakai setelah aplikasi dibuka ulang. Jika perubahan tidak muncul, naikkan angka `CACHE` di `sw.js` (misal `toko-v2`).
