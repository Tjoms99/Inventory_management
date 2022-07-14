<?php
include '../conn.php';

$rfid = $_POST['rfid'];
$rfid = "4CE340FE";
$sql = "SELECT * FROM ITEMS WHERE rfid LIKE '$rfid'";
$res = $conn->query($sql);


if (mysqli_num_rows($res) != 0) {
    $res = mysqli_fetch_assoc($res);
    echo json_encode($res);
    return;
}
