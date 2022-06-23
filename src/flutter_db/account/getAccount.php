<?php
include '../conn.php';

$account_name = $_POST['account_name'];
$password = $_POST['password'];

$sql = "SELECT * FROM `accounts` WHERE `account_name` LIKE '$account_name'";

$res = mysqli_fetch_assoc($conn->query($sql));

$hashed_password = json_encode($res['password']);

//Needed due to somehow got extra characters in string
$hashed_password = str_replace('\/', '/', $hashed_password);
$hashed_password = str_replace('"', "", $hashed_password);


if (password_verify($password, $hashed_password)) {
    //echo "correct";
    echo json_encode($res);
} else {
    //echo json_encode($res);
}
