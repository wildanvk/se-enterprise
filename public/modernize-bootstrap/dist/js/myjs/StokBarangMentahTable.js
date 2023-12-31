// Menentukan base URL
var baseUrl = "http://localhost:8080/api/gudang";

$("#stokBarangMentahTable").DataTable({
  ajax: {
    url: baseUrl + "/stokbarangmentah/getalldata",
    dataSrc: "stokbarangmentah",
  },
  columns: [
    {
      data: null,
      render: function (data, type, row, meta) {
        // Menggunakan nomor urut dari data index pada tabel
        return meta.row + 1;
      },
    },
    { data: "idStokBarangMentah" },
    { data: "idBarangMentah" },
    { data: "namaBarangMentah" },
    { data: "stok" },
    {
      data: null,
      render: function (data, type, row) {
        // Menggunakan tombol sebagai output
        return (
          '<div class="btn-group">' +
          '<button type="submit" class="btn btn-sm btn-info btn-edit">' +
          '<i class="ti ti-edit"></i> Update' +
          "</button>" +
          '<button type="button" class="btn btn-sm btn-danger btn-delete">' +
          '<i class="ti ti-trash"></i> Hapus' +
          "</button>" +
          "</div>"
        );
      },
    },
  ],
  columnDefs: [
    {
      targets: -1, // Menargetkan kolom terakhir (index -1)
      className: "text-center", // Menambahkan kelas kustom
    },
  ],
  order: [[0, "asc"]],
  responsive: true,
  lengthMenu: [
    [10, 25, 50, -1],
    [10, 25, 50, "All"],
  ],
  language: {
    lengthMenu: "Lihat :  _MENU_  Data",
    search: "Cari ",
    searchPlaceholder: "Ketikkan Kata Kunci",
  },
  dom: '<"d-flex justify-content-between px-4"fl>t<"d-flex justify-content-between px-4"ip>',
  initComplete: function () {
    refreshTombolAction();
  },
  drawCallback: function (settings) {
    var api = this.api();

    api
      .column(0, { search: "applied", order: "applied" })
      .nodes()
      .each(function (cell, i) {
        cell.innerHTML = i + 1;
      });
  },
});

// Remove Input invalid on change dan modal close
function clearValidation(element) {
  element.removeClass("is-invalid");
  element.next(".invalid-feedback").text("");
}

$("#inputModal, #editModal")
  .find("#idStokBarangMentah")
  .on("input change", function () {
    clearValidation($(this));
  })
  .closest(".modal")
  .on("hidden.bs.modal", function () {
    var inputElement = $(this).find("#idStokBarangMentah");
    clearValidation(inputElement);
  });
$("#inputModal, #editModal")
  .find("#idBarangMentah")
  .on("input change", function () {
    clearValidation($(this));
  })
  .closest(".modal")
  .on("hidden.bs.modal", function () {
    var inputElement = $(this).find("#idBarangMentah");
    clearValidation(inputElement);
  });
$("#inputModal, #editModal")
  .find("#stok")
  .on("input change", function () {
    clearValidation($(this));
  })
  .closest(".modal")
  .on("hidden.bs.modal", function () {
    var inputElement = $(this).find("#stok");
    clearValidation(inputElement);
  });

function refreshTombolAction() {
  $("#tambahDataModalButton").on("click", function () {
    $.ajax({
      url: baseUrl + "/stokbarangmentah/getavailablebarangmentah",
      type: "get",
      success: function (response) {
        console.log(response);

        if (response.data == null) {
          Swal.fire("Informasi", response.message, "warning");
        } else {
          $.ajax({
            url: baseUrl + "/stokbarangmentah/getnewidstokbarangmentah",
            type: "GET",
            dataType: "json",
            success: function (response) {
              console.log(response);
              $("#inputModal")
                .find("#idStokBarangMentah")
                .val(response.idStokBarangMentah);
            },
            error: function (response) {
              console.log(response);
            },
          });

          $("#inputModal").find("#idBarangMentah option").remove();
          $("#inputModal")
            .find("#idBarangMentah")
            .append('<option value="" selected>Pilih Barang Mentah</option>');
          $.each(response.data, function (index, value) {
            $("#inputModal")
              .find("#idBarangMentah")
              .append(
                '<option value="' +
                  value.idBarangMentah +
                  '">' +
                  value.idBarangMentah +
                  " - " +
                  value.namaBarangMentah +
                  "</option>"
              );
          });
          $("#inputModal").modal("show");
        }
      },
    });
  });
  $(".btn-edit")
    .off("click")
    .on("click", function () {
      var rowIndex = $("#stokBarangMentahTable")
        .DataTable()
        .row($(this).closest("tr"))
        .index();
      var row = $("#stokBarangMentahTable").DataTable().row(rowIndex).data();
      $("#updateForm").find("#rowIndex").val(rowIndex);
      $("#updateForm").find("#idStokBarangMentah").val(row.idStokBarangMentah);
      $("#updateForm").find("#stok").attr("placeholder", row.stok);

      $("#editModal").modal("show");
    });
  $(".btn-delete")
    .off("click")
    .on("click", function () {
      var rowIndex = $("#stokBarangMentahTable")
        .DataTable()
        .row($(this).closest("tr"))
        .index();
      var row = $("#stokBarangMentahTable").DataTable().row(rowIndex).data();
      $("#deleteForm").find("#rowIndex").val(rowIndex);
      $("#deleteForm").find("#idStokBarangMentah").val(row.idStokBarangMentah);
      $("#deleteForm")
        .find("#spanIdStokBarangMentah")
        .text(row.idStokBarangMentah);
      $("#deleteForm").find("#spanIdBarangMentah").text(row.idBarangMentah);
      $("#deleteForm").find("#spanNamaBarangMentah").text(row.namaBarangMentah);

      $("#deleteModal").modal("show");
    });
}

// Submit form tambah data menggunakan Ajax
$("#inputForm").submit(function (e) {
  e.preventDefault();

  $.ajax({
    url: baseUrl + "/stokbarangmentah/inputdata",
    type: "POST",
    contentType: "application/json",
    data: JSON.stringify({
      idStokBarangMentah: $("#idStokBarangMentah").val(),
      idBarangMentah: $("#idBarangMentah").val(),
      namaBarangMentah: $("#namaBarangMentah").val(),
      stok: $("#stok").val(),
    }),
    success: function (response) {
      // Reset form dan hapus pesan error
      console.log(response);
      $(".form-control, .form-select").removeClass("is-invalid");
      $(".invalid-feedback").text("");
      $("#inputForm")[0].reset();

      // Menambahkan baris baru ke tabel
      $("#stokBarangMentahTable")
        .DataTable()
        .ajax.reload(function () {
          // Callback akan dijalankan setelah pembaruan data selesai
          refreshTombolAction();
        });

      // Tampilkan SweetAlert sukses
      Swal.fire("Sukses", response.message, "success");

      // Menghilangkan Modal Input
      $("#inputModal").modal("hide");
    },
    error: function (xhr, status, error) {
      // Tangani pesan kesalahan validasi
      console.log(xhr);
      if (xhr.status === 400) {
        var messages = xhr.responseJSON.messages;
        $.each(messages, function (field, message) {
          var input = $($("#inputModal").find("#" + field));
          input.addClass("is-invalid");
          input.next(".invalid-feedback").text(message);
        });
      } else if (xhr.status === 500) {
        Swal.fire(
          "Gagal",
          "Terjadi kesalahan ketika menginput data ke server",
          "error"
        );
        $("#inputModal").modal("hide");
      } else {
        Swal.fire("Gagal", "Terdapat kesalahan pada server", "error");
        $("#inputModal").modal("hide");
      }
    },
  });
});

// Submit form edit data menggunakan Ajax
$("#updateForm").submit(function (e) {
  e.preventDefault();

  $.ajax({
    url: baseUrl + "/stokbarangmentah/updatedata",
    type: "PUT",
    dataType: "json",
    contentType: "application/json",
    data: JSON.stringify({
      idStokBarangMentah: $("#updateForm").find("#idStokBarangMentah").val(),
      stok: $("#updateForm").find("#stok").val(),
    }),
    success: function (response) {
      console.log(response);
      // Reset form dan hapus pesan error
      $("#updateForm")[0].reset();
      $(".form-control, .form-select").removeClass("is-invalid");
      $(".invalid-feedback").text("");

      // Update baris di tabel
      $("#stokBarangMentahTable")
        .DataTable()
        .ajax.reload(function () {
          // Callback akan dijalankan setelah pembaruan data selesai
          refreshTombolAction();
        });

      // Tampilkan SweetAlert sukses
      Swal.fire("Sukses", response.message, "success");

      // Menghilangkan Modal Edit
      $("#editModal").modal("hide");
    },
    error: function (xhr, status, error) {
      // Tangani pesan kesalahan validasi
      console.log(xhr);
      if (xhr.status === 400) {
        var messages = xhr.responseJSON.messages;
        $.each(messages, function (field, message) {
          var input = $($("#editModal").find("#" + field));
          input.addClass("is-invalid");
          input.next(".invalid-feedback").text(message);
        });
      } else if (xhr.status === 500) {
        Swal.fire(
          "Gagal",
          "Terjadi kesalahan ketika mengupdate data ke server <br>",
          "error"
        );
        $("#editModal").modal("hide");
      } else {
        Swal.fire("Gagal", "Terdapat kesalahan pada server", "error");
        $("#editModal").modal("hide");
      }
    },
  });
});

$("#deleteForm").submit(function (e) {
  e.preventDefault();

  $.ajax({
    url: baseUrl + "/stokbarangmentah/deletedata",
    type: "DELETE",
    dataType: "json",
    contentType: "application/json",
    data: JSON.stringify({
      idStokBarangMentah: $("#deleteForm").find("#idStokBarangMentah").val(),
    }),
    success: function (response) {
      console.log(response);

      // Update baris di tabel
      $("#stokBarangMentahTable")
        .DataTable()
        .ajax.reload(function () {
          // Callback akan dijalankan setelah pembaruan data selesai
          refreshTombolAction();
        });

      // Tampilkan SweetAlert toast sukses
      const Toast = Swal.mixin({
        toast: true,
        position: "top-end",
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        didOpen: (toast) => {
          toast.addEventListener("mouseenter", Swal.stopTimer);
          toast.addEventListener("mouseleave", Swal.resumeTimer);
        },
      });

      Toast.fire({
        icon: "success",
        title: "Data berhasil dihapus",
      });

      // Menghilangkan Modal Edit
      $("#deleteModal").modal("hide");
    },
    error: function (xhr, status, error) {
      // Tangani pesan kesalahan validasi
      if (xhr.status === 500) {
        Swal.fire(
          "Gagal",
          "Terjadi kesalahan ketika menghapus data di server <br>",
          "error"
        );
        $("#deleteModal").modal("hide");
      } else {
        Swal.fire("Gagal", "Terdapat kesalahan pada server", "error");
        $("#deleteModal").modal("hide");
      }
    },
  });
});
