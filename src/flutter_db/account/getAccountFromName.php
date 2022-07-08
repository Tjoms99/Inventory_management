<?php
include '../conn.php';

$account_name = $_POST['account_name'];

//Try to get account using name and password
$sql = "SELECT * FROM `accounts` WHERE `account_name` LIKE '$account_name'";
$res = $conn->query($sql);

if (mysqli_num_rows($res) != 0) {
    $res = mysqli_fetch_assoc($conn->query($sql));

    echo json_encode($res);
    return;
}
