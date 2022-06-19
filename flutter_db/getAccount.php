<?php
include 'conn.php';

$account_name = $_POST['account_name'];
$password = $_POST['password'];

$sql = $conn->query("SELECT * FROM ACCOUNTS WHERE 'account_name' LIKE $account_name");

$hashed_password = $sql['password'];

if(password_verify($password, $hashed_password)) {
    echo json_encode($sql);
}

