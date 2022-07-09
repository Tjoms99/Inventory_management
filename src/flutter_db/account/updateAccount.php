<?php
include '../conn.php';
// Error codes:
// 0 = OK 
// 1 = Account exists
// 2 = RFID exists
$error = '0';


$id = $_POST['id'];
$account_name = $_POST['account_name'];
$account_role = $_POST['account_role'];
$password = $_POST['password'];
$rfid = $_POST['rfid'];
$customer_id = $_POST['customer_id'];
$registered_customer_id = $_POST['registered_customer_id'];

$id = intval($id);
$hashed_password = password_hash($password, PASSWORD_DEFAULT);

//Get current account info
$sql = "SELECT * FROM `accounts` WHERE `id` LIKE '$id'";
$res = $conn->query($sql);
$res = mysqli_fetch_assoc($res);
$currentRFID = $res['rfid'];
$currentName = $res['account_name'];


//Check if account exists
$sql = "SELECT * FROM `accounts` WHERE `account_name` LIKE '$account_name'";
$res = $conn->query($sql);
if ($currentName != $account_name) {
    if (mysqli_num_rows($res) != 0) {
        $error = "1";
    }
}


//Check for rfid in accounts
$sql = "SELECT * FROM `accounts` WHERE `rfid` LIKE '$rfid'";
$res = $conn->query($sql);

//Check for already existing rfid 
if ($currentRFID != $rfid) {
    if (mysqli_num_rows($res) != 0) {
        $error = "2";
    }
}

//Check for rfid in items
$sql = "SELECT * FROM `items` WHERE `rfid` LIKE '$rfid'";
$res = $conn->query($sql);

//Check for already existing rfid 
if ($currentRFID != $rfid) {
    if (mysqli_num_rows($res) != 0) {
        $error = "2";
    }
}

echo json_encode($error);
if ($error != "0") {
    return;
}


$sql = "UPDATE `accounts` SET `account_name` = '$account_name', `account_role` = '$account_role' , `password` = '$hashed_password', `rfid` = '$rfid', `customer_id` = '$customer_id', `registered_customer_id` = '$registered_customer_id' WHERE `accounts`.`id` = $id";
$conn->query($sql);


//Update items with new location if name has changed 
$sqlAll = $conn->query("SELECT * FROM ITEMS");
if ($currentName != $account_name) {
    while ($row = $sqlAll->fetch_assoc()) {
        $location = $row['location'];
        $id = $row['id'];
        $id = intval($id);
        if (hash_equals($location, $currentName)) {
            $sql = "UPDATE `items` SET  `location` = '$account_name' WHERE `items`.`id` = $id";
            $conn->query($sql);
        } else if (hash_equals($location, "$currentName (returned)")) {
            $sql = "UPDATE `items` SET  `location` = '$account_name (returned)' WHERE `items`.`id` = $id";
            $conn->query($sql);
        }
    }
}
