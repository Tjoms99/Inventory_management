<?php
include '../conn.php';
$verificationCode = $_POST['verificationCode'];

// Error codes:
// 0 = OK 
// 1 = Verification code does not exist
$error = '0';

//Verify account if the verification code matches
$sql = "SELECT * FROM `accounts` WHERE `verified` LIKE '$verificationCode'";
$res = $conn->query($sql);

if (mysqli_num_rows($res) == 0) {
    $error = "1";
}

echo $error;
if ($error != "0") {
    return;
}

$sql = "UPDATE `accounts` SET `verified` = 'yes' WHERE `accounts`.`verified` = '$verificationCode'";
$conn->query($sql);
