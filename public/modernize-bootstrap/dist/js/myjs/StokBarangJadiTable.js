// Menentukan base URL
var baseUrl = "http://localhost:8080/api/gudang";

$("#stokBarangJadiTable").DataTable({
  ajax: {
    url: baseUrl + "/stokbarangjadi/getalldata",
    dataSrc: "stokbarangjadi",
  },
  columns: [
    {
      data: null,
      render: function (data, type, row, meta) {
        // Menggunakan nomor urut dari data index pada tabel
        return meta.row + 1;
      },
    },
    { data: "idStokBarangJadi" },
    { data: "idBarangJadi" },
    { data: "namaBarangJadi" },
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
  .find("#idStokBarangJadi")
  .on("input change", function () {
    clearValidation($(this));
  })
  .closest(".modal")
  .on("hidden.bs.modal", function () {
    var inputElement = $(this).find("#idStokBarangJadi");
    clearValidation(inputElement);
  });
$("#inputModal, #editModal")
  .find("#idBarangJadi")
  .on("input change", function () {
    clearValidation($(this));
  })
  .closest(".modal")
  .on("hidden.bs.modal", function () {
    var inputElement = $(this).find("#idBarangJadi");
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
      url: baseUrl + "/stokbarangjadi/getavailablebarangjadi",
      type: "get",
      success: function (response) {
        console.log(response);

        if (response.data == null) {
          Swal.fire("Informasi", response.message, "warning");
        } else {
          $.ajax({
            url: baseUrl + "/stokbarangjadi/getnewidstokbarangjadi",
            type: "GET",
            dataType: "json",
            success: function (response) {
              console.log(response);
              $("#inputModal")
                .find("#idStokBarangJadi")
                .val(response.idStokBarangJadi);
            },
            error: function (response) {
              console.log(response);
            },
          });

          $("#inputModal").find("#idBarangJadi option").remove();
          $("#inputModal")
            .find("#idBarangJadi")
            .append('<option value="" selected>Pilih Barang Jadi</option>');
          $.each(response.data, function (index, value) {
            $("#inputModal")
              .find("#idBarangJadi")
              .append(
                '<option value="' +
                  value.idBarangJadi +
                  '">' +
                  value.idBarangJadi +
                  " - " +
                  value.namaBarangJadi +
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
      var rowIndex = $("#stokBarangJadiTable")
        .DataTable()
        .row($(this).closest("tr"))
        .index();
      var row = $("#stokBarangJadiTable").DataTable().row(rowIndex).data();
      $("#updateForm").find("#rowIndex").val(rowIndex);
      $("#updateForm").find("#idStokBarangJadi").val(row.idStokBarangJadi);
      $("#updateForm").find("#stok").attr("placeholder", row.stok);

      $("#editModal").modal("show");
    });
  $(".btn-delete")
    .off("click")
    .on("click", function () {
      var rowIndex = $("#stokBarangJadiTable")
        .DataTable()
        .row($(this).closest("tr"))
        .index();
      var row = $("#stokBarangJadiTable").DataTable().row(rowIndex).data();
      $("#deleteForm").find("#rowIndex").val(rowIndex);
      $("#deleteForm").find("#idStokBarangJadi").val(row.idStokBarangJadi);
      $("#deleteForm").find("#spanIdStokBarangJadi").text(row.idStokBarangJadi);
      $("#deleteForm").find("#spanIdBarangJadi").text(row.idBarangJadi);
      $("#deleteForm").find("#spanNamaBarangJadi").text(row.namaBarangJadi);

      $("#deleteModal").modal("show");
    });
}

// Submit form tambah data menggunakan Ajax
$("#inputForm").submit(function (e) {
  e.preventDefault();

  $.ajax({
    url: baseUrl + "/stokbarangjadi/inputdata",
    type: "POST",
    contentType: "application/json",
    data: JSON.stringify({
      idStokBarangJadi: $("#idStokBarangJadi").val(),
      idBarangJadi: $("#idBarangJadi").val(),
      namaBarangJadi: $("#namaBarangJadi").val(),
      stok: $("#stok").val(),
    }),
    success: function (response) {
      // Reset form dan hapus pesan error
      console.log(response);
      $(".form-control, .form-select").removeClass("is-invalid");
      $(".invalid-feedback").text("");
      $("#inputForm")[0].reset();

      // Menambahkan baris baru ke tabel
      $("#stokBarangJadiTable")
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
    url: baseUrl + "/stokbarangjadi/updatedata",
    type: "PUT",
    dataType: "json",
    contentType: "application/json",
    data: JSON.stringify({
      idStokBarangJadi: $("#updateForm").find("#idStokBarangJadi").val(),
      stok: $("#updateForm").find("#stok").val(),
    }),
    success: function (response) {
      console.log(response);
      // Reset form dan hapus pesan error
      $("#updateForm")[0].reset();
      $(".form-control, .form-select").removeClass("is-invalid");
      $(".invalid-feedback").text("");

      // Update baris di tabel
      $("#stokBarangJadiTable")
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
    url: baseUrl + "/stokbarangjadi/deletedata",
    type: "DELETE",
    dataType: "json",
    contentType: "application/json",
    data: JSON.stringify({
      idStokBarangJadi: $("#deleteForm").find("#idStokBarangJadi").val(),
    }),
    success: function (response) {
      console.log(response);
      // Reset form dan hapus pesan error
      $("#idStokBarangJadi").val(response.newId);

      // Update baris di tabel
      $("#stokBarangJadiTable")
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
