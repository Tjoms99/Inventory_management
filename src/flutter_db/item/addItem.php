<?php
include '../conn.php';


$name = $_POST['name'];
$status = $_POST['status'];
$rfid = $_POST['rfid'];
$description = $_POST['description'];
$location = $_POST['location'];
$registered_customer_id = $_POST['registered_customer_id'];


//Check if rfid in accounts exists
$sql = "SELECT * FROM `accounts` WHERE `rfid` LIKE '$rfid'";
$res = $conn->query($sql);
if (mysqli_num_rows($res) != 0) {
    return;
}

//Check if rfid in items exists
$sql = "SELECT * FROM `items` WHERE `rfid` LIKE '$rfid'";
$res = $conn->query($sql);
if (mysqli_num_rows($res) != 0) {
    return;
}


$sql = "INSERT INTO `items`(`name`, `status`, `rfid`, `description`, `location`, `registered_customer_id`) VALUES ('$name','$status','$rfid', '$description', '$location', '$registered_customer_id')";
$conn->query($sql);
