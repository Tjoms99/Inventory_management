<?php
include 'conn.php';


$account_name = $_POST['account_name'];
$account_role = $_POST['account_role'];
$password = $_POST['password'];
$rfid = $_POST['rfid'];
$customer_id = $_POST['customer_id'];
$registered_customer_id = $_POST['registered_customer_id'];

$hashed_password = password_hash($password, PASSWORD_DEFAULT);

$sql = "INSERT INTO `accounts`(`account_name`, `account_role`, `password`, `rfid`, `customer_id`, `registered_customer_id`) VALUES ('$account_name','$account_role','$hashed_password','$rfid','$customer_id', '$registered_customer_id')";

$conn->query($sql);
