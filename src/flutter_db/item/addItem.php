<?php
include '../conn.php';


$name = $_POST['name'];
$status = $_POST['status'];
$rfid = $_POST['rfid'];
$description = $_POST['description'];
$location = $_POST['location'];
$registered_customer_id = $_POST['registered_customer_id'];


$sql = "INSERT INTO `items`(`name`, `status`, `rfid`, `description`, `location`, `registered_customer_id`) VALUES ('$name','$status','$rfid', '$description', '$location', '$registered_customer_id')";

$conn->query($sql);
