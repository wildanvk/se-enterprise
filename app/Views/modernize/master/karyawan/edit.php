<?= $this->extend('modernize/_partials/template') ?>
<?= $this->section('content') ?>
<div class="card bg-light-info shadow-none position-relative overflow-hidden">
    <div class="card-body px-4 py-3">
        <div class="row align-items-center">
            <div class="col-9">
                <h4 class="fw-semibold mb-8">Update Karyawan</h4>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a class="text-muted">Master</a></li>
                        <li class="breadcrumb-item" aria-current="page">Karyawan</li>
                        <li class="breadcrumb-item" aria-current="page">Update Karyawan</li>
                    </ol>
                </nav>
            </div>
            <div class="col-2">
                <div class="text-center mb-n5">
                    <img src="<?php echo base_url('modernize-bootstrap'); ?>/dist/images/breadcrumb/ChatBc.png" alt="" class="img-fluid mb-n4">
                </div>
            </div>
        </div>
    </div>
</div>
<?php $errors = session()->getFlashdata('errors');
if (!empty($errors)) { ?>
    <div class="alert alert-danger alert-dismissible bg-danger text-white border-0 fade show" role="alert">
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
        <strong>Whoops! Ada kesalahan saat input data, yaitu:</strong>
        <ol class="list-group list-group-numbered">
            <?php foreach ($errors as $error) : ?>
                <li class="list-group-items m-0"><?= esc($error) ?></li>
            <?php endforeach ?>
        </ol>
    </div>
<?php } ?>
<div class="card w-100 position-relative overflow-hidden">
    <div class="px-4 py-3 border-bottom d-flex justify-content-between align-items-center bg-info">
        <h5 class="card-title fw-semibold mb-0 lh-sm text-white">Update Data Karyawan</h5>
    </div>
    <form action="/karyawan/update" method="post">
        <?= csrf_field() ?>
        <div class="card-body p-4">
            <input type="hidden" name="oldidkaryawan" value="<?= $karyawan['idkaryawan']; ?>">
            <div class="mb-4 row align-items-center">
                <label for="idkaryawan" class="form-label fw-semibold col-sm-2 col-form-label">ID Karyawan</label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="idkaryawan" placeholder="Masukkan ID Karyawan" name="idkaryawan" value="<?= $karyawan['idkaryawan'] ?>" readonly>
                </div>
            </div>
            <div class="mb-4 row align-items-center">
                <label for="nama" class="form-label fw-semibold col-sm-2 col-form-label">Nama Karyawan</label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="nama" placeholder="Masukkan Nama Karyawan" name="nama" value="<?= old('nama') ? old('nama') : $karyawan['nama'] ?>">
                </div>
            </div>
            <div class="mb-4 row align-items-center">
                <label for="bagian" class="form-label fw-semibold col-sm-2 col-form-label">Bagian</label>
                <div class="col-sm-6">
                    <select class="form-select" name="bagian" id="bagian">
                        <option>Pilih Bagian</option>
                        <option value="jahit" <?= $karyawan['bagian'] == 'jahit' ? 'selected' : '' ?>>Jahit</option>
                        <option value="desain" <?= $karyawan['bagian'] == 'desain' ? 'selected' : '' ?>>Desain</option>
                        <option value="finishing" <?= $karyawan['bagian'] == 'finishing' ? 'selected' : '' ?>>Finishing</option>
                    </select>
                </div>
            </div>
            <div class="mb-4 row align-items-center">
                <label for="jenis_kelamin" class="form-label fw-semibold col-sm-2 col-form-label">Jenis Kelamin</label>
                <div class="col-sm-6">
                    <select class="form-select" name="jenis_kelamin" id="jenis_kelamin">
                        <option value="">Pilih Jenis Kelamin</option>
                        <option value="laki-laki" <?= $karyawan['jenis_kelamin'] == 'laki-laki' ? 'selected' : '' ?>>Laki-laki</option>
                        <option value="perempuan" <?= $karyawan['jenis_kelamin'] == 'perempuan' ? 'selected' : '' ?>>Perempuan</option>
                    </select>
                </div>
            </div>
            <div class="mb-4 row align-items-center">
                <label for="alamat" class="form-label fw-semibold col-sm-2 col-form-label">Alamat </label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="alamat" placeholder="Masukkan Alamat Karyawan" name="alamat" value="<?= old('alamat') ? old('alamat') : $karyawan['alamat'] ?>">
                </div>
            </div>
            <div class="row">
                <div class="col-sm-1"></div>
                <div class="col-sm-6 d-flex justify-content-between">
                    <a href="/karyawan" class="justify-content-center btn btn-rounded btn-outline-danger d-flex align-items-center font-medium">
                        <i class="ti ti-arrow-left me-2 fs-4"></i>
                        <span>Kembali</span>
                    </a>
                    <button type="submit" class="btn btn-info font-medium">
                        <i class="ti ti-plus me-2 fs-4"></i>
                        <span>Update Data</span>
                    </button>
                </div>
            </div>
        </div>
    </form>
</div>
<?= $this->endSection() ?>