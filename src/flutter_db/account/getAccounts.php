<?php
include '../conn.php';
$sql = $conn->query("SELECT * FROM ACCOUNTS");

//$sql_1 = "SELECT * FROM `accounts` WHERE `account_name` LIKE 'marcus.alex@live.no' AND `password` LIKE '123'";

$res = array();

while ($row = $sql->fetch_assoc()) {
    $res[] = $row;
}

echo json_encode($res);
