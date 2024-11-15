var acc = document.getElementsByClassName("accordion");
var i;

for (i = 0; i < acc.length; i++) {
    acc[i].addEventListener("click", function() {
        this.classList.toggle("active");
        var panel = this.nextElementSibling;
        if (panel.style.display === "block") {
            panel.style.display = "none";
        } else {
            panel.style.display = "block";
        }
    });
}

function confirmDelete(noticeId) {
    if (confirm("Are you sure you want to delete this notice?")) {
        fetch("/queenscollege/api/notice/delete?id=" + noticeId, {
            method: "DELETE"
        }).then(response => {
            if (response.ok) {
                alert("Notice deleted successfully!");
                window.location.reload();
            } else {
                alert("Failed to delete notice.");
            }
        }).catch(error => {
            console.error("Error deleting notice:", error);
            alert("Error deleting notice.");
        });
    }
}

function searchNotices() {
    // Get the search input value
    var searchInput = document.getElementById("searchInput").value.trim().toLowerCase();

    // Send a fetch request to the server
    fetch("/queenscollege/api/notice/search?query=" + searchInput)
        .then(response => {
            if (response.ok) {
                return response.json();
            } else {
                throw new Error("Failed to fetch notices");
            }
        })
        .then(data => {
            // Update the notices table
            updateNoticesTable(data);
        })
        .catch(error => {
            console.error("Error fetching notices:", error);
        });
}


function updateNoticesTable(notices) {
    // Clear the existing table rows
    var tableBody = document.getElementById("notices").getElementsByTagName('tbody')[0];
    tableBody.innerHTML = "";

    // Populate the table with the filtered notices
    for (var i = 0; i < notices.length; i++) {
        var notice = notices[i];
        var row = "<tr>" +
            "<td class=\"centre-text-table\">" + notice.id + "</td>" +
            "<td>" + notice.module_name + "</td>" +
            "<td><a class='notice-topic-admin' href='admin-noticeView.jsp?id=" + notice.id + "'>" + notice.topic + "</a></td>" +
            "<td class=\"centre-text-table\">" + notice.create_date + "</td>" +
            "<td class=\"centre-text-table\">" + notice.update_date + "</td>" +
            "<td class='action-table-body'>" +
            "<div class='action-edit-box'>" +
            "<a class='notice-edit-btn' href='admin-noticeUpdate.jsp?id=" + notice.id + "'>Edit</a>" +
            "&nbsp;" +
            "<a class='notice-dlt-btn' onclick='confirmDelete(" + notice.id + ")'>Delete</a>" +
            "</div>" +
            "</td>" +
            "</tr>";
        tableBody.insertAdjacentHTML('beforeend', row);
    }
}

