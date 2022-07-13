<?php
include '../conn.php';
$account_name = $_POST['account_name'];

$verified = "no";

//Verify account if the verification code matches
$sql = "SELECT * FROM `accounts` WHERE `account_name` LIKE '$account_name'";
$res = $conn->query($sql);

if (mysqli_num_rows($res) != 0) {
    $res = mysqli_fetch_assoc($conn->query($sql));
    $verified = json_encode($res['verified']);
}

echo $verified;
