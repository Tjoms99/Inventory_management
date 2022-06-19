<?php
include 'conn.php';

$id = $_POST['id'];
$name = $_POST['name'];
$status = $_POST['status'];
$rfid = $_POST['rfid'];
$description = $_POST['description'];
$location = $_POST['location'];
$registered_customer_id = $_POST['registered_customer_id'];


$sql = "UPDATE `items` SET `name` = '$name', `rfid` = '$rfid', `description` = '$description', `location` = '$location', `registered_customer_id` = '$registered_customer_id' WHERE `items`.`id` = $id";

//$sql = "UPDATE `items` SET `name` = 'book_action', `rfid` = '01234567890002', `description` = 'harry potter 2', `location` = 'andreas@gmail.com', `registered_customer_id` = '2' WHERE `items`.`id` = 2"

$conn->query($sql);
