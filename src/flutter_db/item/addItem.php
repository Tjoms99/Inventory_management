<?php
include '../conn.php';
// Error codes:
// 0 = OK 
// 1 = RFID exists
$error = "0";

$name = $_POST['name'];
$status = $_POST['status'];
$rfid = $_POST['rfid'];
$description = $_POST['description'];
$location = $_POST['location'];
$registered_customer_id = $_POST['registered_customer_id'];


//Check if rfid in accounts exists
$sql = "SELECT * FROM `accounts` WHERE `rfid` LIKE '$rfid'";
$res = $conn->query($sql);
if (mysqli_num_rows($res) != 0 && mysqli_fetch_assoc($res)['rfid']  != "NO RFID ASSIGNED") {
    $error = "1";
}
//Check if rfid in items exists
$sql = "SELECT * FROM `items` WHERE `rfid` LIKE '$rfid'";
$res = $conn->query($sql);
if (mysqli_num_rows($res) != 0 && mysqli_fetch_assoc($res)['rfid']  != "NO RFID ASSIGNED") {
    $error = "1";
}

echo json_encode($error);
if ($error != "0") {
    return;
}

$sql = "INSERT INTO `items`(`name`, `status`, `rfid`, `description`, `location`, `registered_customer_id`) VALUES ('$name','$status','$rfid', '$description', '$location', '$registered_customer_id')";
$conn->query($sql);
