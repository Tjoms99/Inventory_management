<?php
include 'conn.php';

$account_name = $_POST['account_name'];

$account_name = "user2";
$sql = "SELECT * FROM `accounts` WHERE `account_name` LIKE '$account_name'";

$res = mysqli_fetch_assoc($conn->query($sql));

echo json_encode($res);
