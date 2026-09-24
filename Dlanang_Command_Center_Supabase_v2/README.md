# D’Lanang Command Center — UI + Supabase

Versi ini merapikan layout dashboard agar tidak menumpuk dan mengganti koneksi Supabase dari sekadar "uji koneksi" menjadi **login Auth + CRUD data**.

## 1. Yang diperbaiki
- Sidebar dipersempit dan spacing dibuat konsisten.
- Dashboard tidak lagi terlalu tinggi; kartu statistik dibuat ringkas.
- Ada Quick Action agar tombol tidak menumpuk di header.
- Tabel tetap lengkap tetapi berada di card yang rapi dan scrollable.
- Tampilan mobile memakai bottom navigation.
- Login dapat memakai Supabase Auth.
- Anggota, setoran, pengeluaran, anggaran, event, pembayaran, profil, dan logo URL dapat disimpan ke Supabase.
- Jika URL/key Supabase belum diisi, file masih dapat dicoba dengan mode demo lokal.
- Pengaturan sekarang dapat di-scroll sampai bagian paling bawah.
- Logo dapat dipilih langsung dari komputer/HP menggunakan file picker; tidak perlu URL.

## 2. Setup Supabase
1. Buat project di Supabase.
2. Buka **SQL Editor**.
3. Copy seluruh isi `supabase_schema.sql` lalu Run.
4. Buka **Authentication > Users** dan buat akun admin, atau gunakan tombol "Buat akun admin Supabase" pada halaman login.
5. Ambil **Project URL** dan **Publishable/Anon Key** dari Project Settings > API.
6. Jalankan `index.html`.
7. Login ke dashboard > Pengaturan > Supabase Cloud.
8. Masukkan Project URL + Publishable/Anon Key.
9. Klik **Uji & Hubungkan**.
10. Logout, lalu login kembali memakai akun Supabase.

## 3. Catatan keamanan
- Frontend hanya boleh memakai **Publishable/Anon Key**.
- Jangan pernah memasukkan `service_role` key ke HTML.
- RLS pada schema membatasi akses tabel ke user yang sudah login.
- Contoh policy di schema memberi akses penuh kepada semua user authenticated. Jika nanti ada banyak role, policy perlu diperketat.

## 4. Deploy
Bisa langsung dihosting sebagai static site:
- Netlify
- Vercel
- GitHub Pages
- Cloudflare Pages
- hosting biasa/cPanel

Tidak membutuhkan Node.js untuk menjalankan versi ini.

## 5. Logo manual
Pilih file gambar pada **Pengaturan → Branding & Logo**, lihat preview, lalu klik **Simpan Logo**. Logo disimpan sebagai data gambar sehingga tidak perlu memasukkan link.

## 6. Mode demo
Jika Supabase belum diisi:
- Email bebas.
- Password demo: `demo123`.
- Data demo tersimpan di browser melalui localStorage.
- Setelah Supabase aktif, data cloud menjadi sumber data utama.
