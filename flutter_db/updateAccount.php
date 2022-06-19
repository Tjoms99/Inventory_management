<?php
include 'conn.php';

$id = $_POST['id'];
$account_name = $_POST['account_name'];
$account_role = $_POST['account_role'];
$password = $_POST['password'];
$rfid = $_POST['rfid'];
$customer_id = $_POST['customer_id'];
$registered_customer_id = $_POST['registered_customer_id'];


$id = intval($id);


$sql = "UPDATE `accounts` SET `account_name` = '$account_name', `account_role` = '$account_role' , `password` = '$password', `rfid` = '$rfid', `customer_id` = '$customer_id', `registered_customer_id` = '$registered_customer_id' WHERE `accounts`.`id` = $id";
$conn->query($sql);
