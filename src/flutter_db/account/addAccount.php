<?php
include '../conn.php';

// Error codes:
// 0 = OK 
// 1 = Account exists
// 2 = RFID exists
// 3 = No info
$error = "0";

$account_name = $_POST['account_name'];
$account_role = $_POST['account_role'];
$password = $_POST['password'];
$rfid = $_POST['rfid'];
$customer_id = $_POST['customer_id'];
$registered_customer_id = $_POST['registered_customer_id'];
$verified = $_POST['verified'];

$hashed_password = password_hash($password, PASSWORD_DEFAULT);

//Check if account exists
$sql = "SELECT * FROM `accounts` WHERE `account_name` LIKE '$account_name'";
$res = $conn->query($sql);
if (mysqli_num_rows($res) != 0) {
    $error = "1";
}

//Check if rfid in accounts exists
$sql = "SELECT * FROM `accounts` WHERE `rfid` LIKE '$rfid'";
$res = $conn->query($sql);
if (mysqli_num_rows($res) != 0 && mysqli_fetch_assoc($res)['rfid']  != "NO RFID ASSIGNED") {
    $error = "2";
}

//Check if rfid in items exists
$sql = "SELECT * FROM `items` WHERE `rfid` LIKE '$rfid'";
$res = $conn->query($sql);
if (mysqli_num_rows($res) != 0 && mysqli_fetch_assoc($res)['rfid']  != "NO RFID ASSIGNED") {
    $error = "2";
}

if ($username == "" || $password == "") {
    $error = "3";
}
echo json_encode($error);
if ($error != "0") {
    return;
}
//Insert account
$sql = "INSERT INTO `accounts`(`account_name`, `account_role`, `password`, `rfid`, `customer_id`, `registered_customer_id`, `verified`) VALUES ('$account_name','$account_role','$hashed_password','$rfid','$customer_id', '$registered_customer_id', '$verified')";
$conn->query($sql);
