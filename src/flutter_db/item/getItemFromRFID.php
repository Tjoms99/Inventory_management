<?php
include '../conn.php';

$rfid = $_POST['rfid'];

$sql = $conn->query("SELECT * FROM ITEMS WHERE 'rfid' LIKE '$rfid'");

if (mysqli_num_rows($res) != 0) {
    $res = mysqli_fetch_assoc($conn->query($sql));
    echo json_encode($res);
    return;
}