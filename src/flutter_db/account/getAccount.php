<?php
include '../conn.php';

$account_name = $_POST['account_name'];
$password = $_POST['password'];
$rfid = $_POST['rfid'];

//Try to get account using rfid
$sql = "SELECT * FROM `accounts` WHERE `rfid` LIKE '$rfid'";
$res = $conn->query($sql);

if (mysqli_num_rows($res) != 0) {
    $res = mysqli_fetch_assoc($conn->query($sql));
    echo json_encode($res);
    return;
}


//Try to get account using name and password
$sql = "SELECT * FROM `accounts` WHERE `account_name` LIKE '$account_name'";
$res = $conn->query($sql);

if (mysqli_num_rows($res) != 0) {
    $res = mysqli_fetch_assoc($conn->query($sql));
    $hashed_password = json_encode($res['password']);
    //Needed due to somehow got extra characters in string
    $hashed_password = str_replace('\/', '/', $hashed_password);
    $hashed_password = str_replace('"', "", $hashed_password);

    if (password_verify($password, $hashed_password)) {
        echo json_encode($res);
        return;
    }
}
