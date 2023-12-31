-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 28 Jul 2023 pada 11.16
-- Versi server: 10.4.21-MariaDB
-- Versi PHP: 7.4.24

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `enterprise`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `barangjadi`
--

CREATE TABLE `barangjadi` (
  `idBarangJadi` char(10) NOT NULL,
  `namaBarangJadi` varchar(100) NOT NULL,
  `status` enum('Active','Inactive') NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `barangjadi`
--

INSERT INTO `barangjadi` (`idBarangJadi`, `namaBarangJadi`, `status`) VALUES
('BJ001', 'Jeans Pendek', 'Active'),
('BJ002', 'Jeans Panjang', 'Active'),
('BJ003', 'Jeans Kulot', 'Active'),
('BJ004', 'Jeans Sobek', 'Active');

-- --------------------------------------------------------

--
-- Struktur dari tabel `barangkeluarjadi`
--

CREATE TABLE `barangkeluarjadi` (
  `idTransaksi` char(15) NOT NULL,
  `tanggal` date NOT NULL,
  `idBarangJadi` char(10) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `harga` int(11) NOT NULL,
  `keterangan` text NOT NULL,
  `inserted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `barangkeluarjadi`
--

INSERT INTO `barangkeluarjadi` (`idTransaksi`, `tanggal`, `idBarangJadi`, `jumlah`, `harga`, `keterangan`, `inserted_at`) VALUES
('TKBJ-160723-001', '2023-07-16', 'BJ001', 20, 2000000, '', '2023-07-16 15:30:52'),
('TKBJ-160723-002', '2023-07-16', 'BJ002', 20, 2000000, '', '2023-07-16 15:31:25'),
('TKBJ-210723-001', '2023-07-21', 'BJ002', 20, 1500000, '', '2023-07-21 14:32:11'),
('TKBJ-210723-002', '2023-07-21', 'BJ003', 20, 1500000, '', '2023-07-21 14:32:18'),
('TKBJ-210723-003', '2023-07-21', 'BJ003', 20, 2000000, '', '2023-07-21 14:32:27'),
('TKBJ-210723-004', '2023-07-21', 'BJ003', 20, 2000000, '', '2023-07-21 14:32:34'),
('TKBJ-210723-005', '2023-07-21', 'BJ004', 20, 2000000, '', '2023-07-21 14:32:52');

--
-- Trigger `barangkeluarjadi`
--
DELIMITER $$
CREATE TRIGGER `delete_transaksi_keluar_trigger` AFTER DELETE ON `barangkeluarjadi` FOR EACH ROW BEGIN
    UPDATE stokbarangjadi
    SET stok = stok + OLD.jumlah
    WHERE idBarangJadi = OLD.idBarangJadi;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_transaksi_keluar_trigger` AFTER INSERT ON `barangkeluarjadi` FOR EACH ROW BEGIN
    UPDATE stokbarangjadi
    SET stok = stok - NEW.jumlah
    WHERE idBarangJadi = NEW.idBarangJadi;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_transaksi_keluar_trigger` AFTER UPDATE ON `barangkeluarjadi` FOR EACH ROW BEGIN
    DECLARE selisih INT;
    SET selisih = NEW.jumlah - OLD.jumlah;
    UPDATE stokbarangjadi
    SET stok = stok - selisih
    WHERE idBarangJadi = NEW.idBarangJadi;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `barangmasukmentah`
--

CREATE TABLE `barangmasukmentah` (
  `idTransaksi` char(15) NOT NULL,
  `tanggal` date NOT NULL,
  `idBarangMentah` char(10) NOT NULL,
  `idSupplier` char(10) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `harga` int(11) NOT NULL,
  `keterangan` text NOT NULL,
  `inserted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `barangmasukmentah`
--

INSERT INTO `barangmasukmentah` (`idTransaksi`, `tanggal`, `idBarangMentah`, `idSupplier`, `jumlah`, `harga`, `keterangan`, `inserted_at`) VALUES
('TMBM-120723-001', '2023-07-12', 'BM002', 'S001', 20, 2000000, '', '2023-07-12 17:24:32'),
('TMBM-120723-002', '2023-07-12', 'BM002', 'S002', 25, 2000000, '', '2023-07-12 17:27:06'),
('TMBM-120723-003', '2023-07-12', 'BM003', 'S001', 20, 2000000, '', '2023-07-12 17:33:41'),
('TMBM-120723-004', '2023-07-12', 'BM005', 'S003', 20, 2000000, '', '2023-07-12 17:36:46'),
('TMBM-130723-001', '2023-07-13', 'BM004', 'S005', 20, 2000000, '', '2023-07-13 08:32:51'),
('TMBM-140723-001', '2023-07-14', 'BM003', 'S002', 20, 2000000, '', '2023-07-14 14:11:45'),
('TMBM-200623-001', '2023-06-20', 'BM002', 'S001', 15, 1500000, 'Pembelian bahan mentah awal', '2023-07-12 16:42:07'),
('TMBM-210723-001', '2023-07-21', 'BM002', 'S001', 15, 1500000, '', '2023-07-21 14:33:13'),
('TMBM-210723-002', '2023-07-21', 'BM004', 'S002', 20, 2000000, '', '2023-07-21 14:55:26'),
('TMBM-210723-003', '2023-07-21', 'BM001', 'S002', 20, 123123, '', '2023-07-21 14:56:20'),
('TMBM-210723-004', '2023-07-21', 'BM002', 'S002', 123, 123123, '', '2023-07-21 15:49:09'),
('TMBM-220723-001', '2023-08-03', 'BM002', 'S003', 20, 2000000, '', '2023-07-22 13:25:26');

--
-- Trigger `barangmasukmentah`
--
DELIMITER $$
CREATE TRIGGER `delete_transaksi_masuk_trigger` AFTER DELETE ON `barangmasukmentah` FOR EACH ROW BEGIN
    UPDATE stokbarangmentah
    SET stok = stok - OLD.jumlah
    WHERE idBarangMentah = OLD.idBarangMentah;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_transaksi_masuk_trigger` AFTER INSERT ON `barangmasukmentah` FOR EACH ROW BEGIN
    UPDATE stokbarangmentah
    SET stok = stok + NEW.jumlah
    WHERE idBarangMentah = NEW.idBarangMentah;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_transaksi_masuk_trigger` AFTER UPDATE ON `barangmasukmentah` FOR EACH ROW BEGIN
    DECLARE selisih INT;
    SET selisih = NEW.jumlah - OLD.jumlah;
    UPDATE stokbarangmentah
    SET stok = stok + selisih
    WHERE idBarangMentah = NEW.idBarangMentah;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `barangmentah`
--

CREATE TABLE `barangmentah` (
  `idBarangMentah` char(10) NOT NULL,
  `namaBarangMentah` varchar(100) NOT NULL,
  `status` enum('Active','Inactive') NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `barangmentah`
--

INSERT INTO `barangmentah` (`idBarangMentah`, `namaBarangMentah`, `status`) VALUES
('BM001', 'Kain', 'Active'),
('BM002', 'Benang Jahit', 'Active'),
('BM003', 'Kancing', 'Active'),
('BM004', 'Resleting', 'Active'),
('BM005', 'Tali', 'Active');

-- --------------------------------------------------------

--
-- Struktur dari tabel `data_karyawan`
--

CREATE TABLE `data_karyawan` (
  `id_karyawan` char(10) NOT NULL,
  `nama_karyawan` varchar(30) NOT NULL,
  `id_divisi` char(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `data_karyawan`
--

INSERT INTO `data_karyawan` (`id_karyawan`, `nama_karyawan`, `id_divisi`) VALUES
('K001', 'Budiono', 'D002'),
('K002', 'Hariyanto', 'D001'),
('K003', 'Suyono', 'D001'),
('K004', 'Dewi', 'D002'),
('K005', 'Yuni', 'D003'),
('K006', 'Wahyono', 'D003');

-- --------------------------------------------------------

--
-- Struktur dari tabel `divisi`
--

CREATE TABLE `divisi` (
  `id_divisi` char(10) NOT NULL,
  `divisi` enum('pemolaan & pemotongan','penjahitan','finishing') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `divisi`
--

INSERT INTO `divisi` (`id_divisi`, `divisi`) VALUES
('D001', 'pemolaan & pemotongan'),
('D002', 'penjahitan'),
('D003', 'finishing');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pembagian_produksi`
--

CREATE TABLE `pembagian_produksi` (
  `id_pembagian` char(10) NOT NULL,
  `id_karyawan` char(10) NOT NULL,
  `id_produksi` char(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktur dari tabel `penggajian`
--

CREATE TABLE `penggajian` (
  `idpenggajian` char(10) NOT NULL,
  `idkaryawan` varchar(20) NOT NULL,
  `tanggal` date NOT NULL,
  `jumlahproduksi` varchar(19) NOT NULL,
  `totalgaji` char(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `penggajian`
--

INSERT INTO `penggajian` (`idpenggajian`, `idkaryawan`, `tanggal`, `jumlahproduksi`, `totalgaji`) VALUES
('G002', 'K005', '2023-07-25', '100', '100000');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengiriman`
--

CREATE TABLE `pengiriman` (
  `id_pengiriman` char(10) NOT NULL,
  `id_transaksi` char(10) NOT NULL,
  `resi` varchar(50) NOT NULL,
  `tgl_pengiriman` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `pengiriman`
--

INSERT INTO `pengiriman` (`id_pengiriman`, `id_transaksi`, `resi`, `tgl_pengiriman`) VALUES
('P001', 'T001', 'G6768HGFD77', '2023-07-17'),
('P002', 'T002', 'jkljkljkl', '2023-07-25');

-- --------------------------------------------------------

--
-- Struktur dari tabel `permintaan_produksi`
--

CREATE TABLE `permintaan_produksi` (
  `id_produksi` char(10) NOT NULL,
  `nama_barang` varchar(255) NOT NULL,
  `jumlah` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `permintaan_produksi`
--

INSERT INTO `permintaan_produksi` (`id_produksi`, `nama_barang`, `jumlah`) VALUES
('P001', 'Celana Jeans', 20),
('P002', 'Kulot Jeans', 15),
('P003', 'Jeans', 20),
('P004', 'Jaket Jeans', 40),
('P005', 'Celana Jeans', 40);

-- --------------------------------------------------------

--
-- Struktur dari tabel `progres_produksi`
--

CREATE TABLE `progres_produksi` (
  `id_progres` char(10) NOT NULL,
  `id_produksi` char(10) NOT NULL,
  `tgl_produksi` date NOT NULL,
  `status_produksi` enum('pemolaan&pemotongan','penjahitan','finishing','selesai') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `progres_produksi`
--

INSERT INTO `progres_produksi` (`id_progres`, `id_produksi`, `tgl_produksi`, `status_produksi`) VALUES
('S001', 'P002', '2023-07-26', 'selesai'),
('S002', 'P001', '2023-07-28', 'selesai'),
('S003', 'P003', '2023-07-27', 'pemolaan&pemotongan'),
('S004', 'P004', '2023-07-27', 'pemolaan&pemotongan'),
('S005', 'P005', '2023-07-28', 'pemolaan&pemotongan');

-- --------------------------------------------------------

--
-- Struktur dari tabel `request`
--

CREATE TABLE `request` (
  `id_request` char(10) NOT NULL,
  `id_transaksi` char(10) NOT NULL,
  `jumlah_pesanan` int(11) NOT NULL,
  `status_request` enum('diajukan','diterima','ditolak','pending','') NOT NULL,
  `nama_barang` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `request`
--

INSERT INTO `request` (`id_request`, `id_transaksi`, `jumlah_pesanan`, `status_request`, `nama_barang`) VALUES
('R001', 'T001', 150, 'diajukan', 'jyy');

-- --------------------------------------------------------

--
-- Struktur dari tabel `riwayat_produksi`
--

CREATE TABLE `riwayat_produksi` (
  `id_riwayat_produksi` char(10) NOT NULL,
  `id_produksi` char(10) NOT NULL,
  `nama_barang` varchar(30) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `tgl_produksi` date NOT NULL,
  `tgl_selesai` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `riwayat_produksi`
--

INSERT INTO `riwayat_produksi` (`id_riwayat_produksi`, `id_produksi`, `nama_barang`, `jumlah`, `tgl_produksi`, `tgl_selesai`) VALUES
('R001', 'P001', 'Celana Jeans', 20, '2023-07-28', '2023-07-28'),
('R002', 'P002', 'Kulot Jeans', 15, '2023-07-26', '2023-07-28');

-- --------------------------------------------------------

--
-- Struktur dari tabel `stokbarangjadi`
--

CREATE TABLE `stokbarangjadi` (
  `idStokBarangJadi` char(10) NOT NULL,
  `idBarangJadi` char(10) NOT NULL,
  `stok` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `stokbarangjadi`
--

INSERT INTO `stokbarangjadi` (`idStokBarangJadi`, `idBarangJadi`, `stok`) VALUES
('SBJ001', 'BJ001', 200),
('SBJ002', 'BJ002', 280),
('SBJ003', 'BJ003', 440),
('SBJ004', 'BJ004', 200);

-- --------------------------------------------------------

--
-- Struktur dari tabel `stokbarangmentah`
--

CREATE TABLE `stokbarangmentah` (
  `idStokBarangMentah` char(10) NOT NULL,
  `idBarangMentah` char(10) NOT NULL,
  `stok` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `stokbarangmentah`
--

INSERT INTO `stokbarangmentah` (`idStokBarangMentah`, `idBarangMentah`, `stok`) VALUES
('SBM001', 'BM001', 90),
('SBM002', 'BM002', 261),
('SBM003', 'BM003', 54),
('SBM004', 'BM004', 163);

-- --------------------------------------------------------

--
-- Struktur dari tabel `supplier`
--

CREATE TABLE `supplier` (
  `idSupplier` char(10) NOT NULL,
  `namaSupplier` varchar(100) NOT NULL,
  `alamat` text NOT NULL,
  `kontak` varchar(50) NOT NULL,
  `status` enum('Active','Inactive') NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `supplier`
--

INSERT INTO `supplier` (`idSupplier`, `namaSupplier`, `alamat`, `kontak`, `status`) VALUES
('S001', 'PT Gutex', 'Pekalongan', 'cs.gutex@gutex.co.id', 'Active'),
('S002', 'PT Jayatex', 'Pekalongan', 'cs.jayatex@jayatex.co.id', 'Active'),
('S003', 'PT Garment', 'Jl. MT. Haryono No.11 – 12, Wonodri, Semarang Selatan, Semarang City, Central Java 50242', '(024) 8314517', 'Active'),
('S004', 'CV ABC', 'Jl. MT. Haryono No.11 – 12, Wonodri, Semarang Selatan, Semarang City, Central Java 50242', '(031) 3538135', 'Active'),
('S005', 'PT Ajiwijayatex', 'Jl. MT. Haryono No.11 – 12, Wonodri, Semarang Selatan, Semarang City, Central Java 50242', 'ajiwijayatex_order@ajiwijayatex.co.id', 'Active'),
('S006', 'PT Dutatex', 'Pekajangan', 'dutatex_order@dutatex.co.id', 'Active');

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi`
--

CREATE TABLE `transaksi` (
  `tgl_transaksi` date NOT NULL,
  `id_transaksi` char(10) NOT NULL,
  `nama_customer` varchar(50) NOT NULL,
  `alamat` varchar(50) NOT NULL,
  `no_hp` varchar(13) NOT NULL,
  `nama_barang` varchar(50) NOT NULL,
  `jumlah_barang` int(10) NOT NULL,
  `total_bayar` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `transaksi`
--

INSERT INTO `transaksi` (`tgl_transaksi`, `id_transaksi`, `nama_customer`, `alamat`, `no_hp`, `nama_barang`, `jumlah_barang`, `total_bayar`) VALUES
('2023-07-14', 'T001', 'Lina', 'jl.suka maju', '082322888113', 'clana jins', 200, 5000000),
('2023-07-25', 'T002', 'asdasd', 'Jl. MT. Haryono No.11 – 12, Wonodri, Semarang Sela', '123123', 'jyy', 100, 2500000);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `userId` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`userId`, `username`, `password`, `role`, `created_at`, `updated_at`) VALUES
(1, 'admingudang', 'admin', 'Gudang', '2023-05-11 07:50:18', '2023-07-23 14:30:10'),
(2, 'adminproduksi', 'admin', 'Produksi', '2023-07-23 14:10:22', '2023-07-23 14:10:22'),
(3, 'adminpenggajian', 'admin', 'Penggajian', '2023-07-23 14:29:53', '2023-07-23 14:29:53'),
(4, 'adminpenjualan', 'admin', 'Penjualan', '2023-07-23 14:30:03', '2023-07-23 14:30:03'),
(6, 'superadmin', 'admin', 'Superadmin', '2023-07-23 14:43:03', '2023-07-23 14:44:32');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `barangjadi`
--
ALTER TABLE `barangjadi`
  ADD PRIMARY KEY (`idBarangJadi`);

--
-- Indeks untuk tabel `barangkeluarjadi`
--
ALTER TABLE `barangkeluarjadi`
  ADD PRIMARY KEY (`idTransaksi`),
  ADD KEY `idBarangMentah` (`idBarangJadi`);

--
-- Indeks untuk tabel `barangmasukmentah`
--
ALTER TABLE `barangmasukmentah`
  ADD PRIMARY KEY (`idTransaksi`),
  ADD KEY `idBarangMentah` (`idBarangMentah`),
  ADD KEY `idSupplier` (`idSupplier`);

--
-- Indeks untuk tabel `barangmentah`
--
ALTER TABLE `barangmentah`
  ADD PRIMARY KEY (`idBarangMentah`);

--
-- Indeks untuk tabel `data_karyawan`
--
ALTER TABLE `data_karyawan`
  ADD PRIMARY KEY (`id_karyawan`),
  ADD KEY `id_divisi` (`id_divisi`);

--
-- Indeks untuk tabel `divisi`
--
ALTER TABLE `divisi`
  ADD PRIMARY KEY (`id_divisi`);

--
-- Indeks untuk tabel `pembagian_produksi`
--
ALTER TABLE `pembagian_produksi`
  ADD PRIMARY KEY (`id_pembagian`);

--
-- Indeks untuk tabel `penggajian`
--
ALTER TABLE `penggajian`
  ADD PRIMARY KEY (`idpenggajian`),
  ADD KEY `penggajian_ibfk_1` (`idkaryawan`);

--
-- Indeks untuk tabel `pengiriman`
--
ALTER TABLE `pengiriman`
  ADD PRIMARY KEY (`id_pengiriman`),
  ADD KEY `pengiriman_ibfk_1` (`id_transaksi`);

--
-- Indeks untuk tabel `permintaan_produksi`
--
ALTER TABLE `permintaan_produksi`
  ADD PRIMARY KEY (`id_produksi`);

--
-- Indeks untuk tabel `progres_produksi`
--
ALTER TABLE `progres_produksi`
  ADD PRIMARY KEY (`id_progres`),
  ADD KEY `progres_produksi_ibfk_1` (`id_produksi`);

--
-- Indeks untuk tabel `request`
--
ALTER TABLE `request`
  ADD PRIMARY KEY (`id_request`),
  ADD KEY `id_transaksi` (`id_transaksi`);

--
-- Indeks untuk tabel `riwayat_produksi`
--
ALTER TABLE `riwayat_produksi`
  ADD PRIMARY KEY (`id_riwayat_produksi`),
  ADD KEY `id_produksi` (`id_produksi`);

--
-- Indeks untuk tabel `stokbarangjadi`
--
ALTER TABLE `stokbarangjadi`
  ADD PRIMARY KEY (`idStokBarangJadi`),
  ADD KEY `idBarangJadi` (`idBarangJadi`);

--
-- Indeks untuk tabel `stokbarangmentah`
--
ALTER TABLE `stokbarangmentah`
  ADD PRIMARY KEY (`idStokBarangMentah`),
  ADD KEY `stokbarangmentah_ibfk_1` (`idBarangMentah`);

--
-- Indeks untuk tabel `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`idSupplier`);

--
-- Indeks untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userId`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `userId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `barangkeluarjadi`
--
ALTER TABLE `barangkeluarjadi`
  ADD CONSTRAINT `barangkeluarjadi_ibfk_1` FOREIGN KEY (`idBarangJadi`) REFERENCES `barangjadi` (`idBarangJadi`);

--
-- Ketidakleluasaan untuk tabel `barangmasukmentah`
--
ALTER TABLE `barangmasukmentah`
  ADD CONSTRAINT `barangmasukmentah_ibfk_1` FOREIGN KEY (`idBarangMentah`) REFERENCES `barangmentah` (`idBarangMentah`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `barangmasukmentah_ibfk_2` FOREIGN KEY (`idSupplier`) REFERENCES `supplier` (`idSupplier`);

--
-- Ketidakleluasaan untuk tabel `data_karyawan`
--
ALTER TABLE `data_karyawan`
  ADD CONSTRAINT `data_karyawan_ibfk_1` FOREIGN KEY (`id_divisi`) REFERENCES `divisi` (`id_divisi`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `penggajian`
--
ALTER TABLE `penggajian`
  ADD CONSTRAINT `penggajian_ibfk_1` FOREIGN KEY (`idkaryawan`) REFERENCES `data_karyawan` (`id_karyawan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pengiriman`
--
ALTER TABLE `pengiriman`
  ADD CONSTRAINT `pengiriman_ibfk_1` FOREIGN KEY (`id_transaksi`) REFERENCES `transaksi` (`id_transaksi`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `progres_produksi`
--
ALTER TABLE `progres_produksi`
  ADD CONSTRAINT `progres_produksi_ibfk_1` FOREIGN KEY (`id_produksi`) REFERENCES `permintaan_produksi` (`id_produksi`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `request`
--
ALTER TABLE `request`
  ADD CONSTRAINT `request_ibfk_1` FOREIGN KEY (`id_transaksi`) REFERENCES `transaksi` (`id_transaksi`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `riwayat_produksi`
--
ALTER TABLE `riwayat_produksi`
  ADD CONSTRAINT `riwayat_produksi_ibfk_1` FOREIGN KEY (`id_produksi`) REFERENCES `permintaan_produksi` (`id_produksi`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `stokbarangjadi`
--
ALTER TABLE `stokbarangjadi`
  ADD CONSTRAINT `stokbarangjadi_ibfk_1` FOREIGN KEY (`idBarangJadi`) REFERENCES `barangjadi` (`idBarangJadi`);

--
-- Ketidakleluasaan untuk tabel `stokbarangmentah`
--
ALTER TABLE `stokbarangmentah`
  ADD CONSTRAINT `stokbarangmentah_ibfk_1` FOREIGN KEY (`idBarangMentah`) REFERENCES `barangmentah` (`idBarangMentah`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
