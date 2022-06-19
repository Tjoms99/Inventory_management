<?php
include 'conn.php';


$account_name = $_POST['account_name'];
$account_role = $_POST['account_role'];
$password = $_POST['password'];
$rfid = $_POST['rfid'];
$customer_id = $_POST['customer_id'];


$sql = "INSERT INTO `accounts`(`account_name`, `account_role`, `password`, `RFID`, `customer_id`, `registered_customer_id`) VALUES ('$account_name','$account_role','$password','$rfid','$customer_id',0)";

$conn->query($sql);
