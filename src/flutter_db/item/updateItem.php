<?php
include '../conn.php';

// Error codes:
// 0 = OK 
// 1 = RFID exists
$error = "0";

$id = $_POST['id'];
$name = $_POST['name'];
$status = $_POST['status'];
$rfid = $_POST['rfid'];
$description = $_POST['description'];
$location = $_POST['location'];
$registered_customer_id = $_POST['registered_customer_id'];

$id = intval($id);

$sql = "SELECT * FROM `items` WHERE `id` LIKE $id";
$res = $conn->query($sql);
$currentRFID = mysqli_fetch_assoc($res)['rfid'];


//Check for rfid in accounts
$sql = "SELECT * FROM `accounts` WHERE `rfid` LIKE '$rfid'";
$res = $conn->query($sql);

//Return if trying to update rfid to already existing rfid
if ($currentRFID != $rfid) {
    if (mysqli_num_rows($res) != 0) {
        $error = "1";
    }
}

//Check for rfid in items
$sql = "SELECT * FROM `items` WHERE `rfid` LIKE '$rfid'";
$res = $conn->query($sql);

//Return if trying to update rfid to already existing rfid
if ($currentRFID != $rfid) {
    if (mysqli_num_rows($res) != 0) {
        $error = "1";
    }
}

echo json_encode($error);
if ($error != "0") {
    return;
}

$sql = "UPDATE items SET `name` = '$name', `status` = '$status', `rfid` = '$rfid', `description` = '$description', `location` = '$location', `registered_customer_id` = '$registered_customer_id' WHERE `items`.`id` = $id";
$conn->query($sql);
