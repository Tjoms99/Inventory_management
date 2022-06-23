<?php
include '../conn.php';

$ip = $_SERVER['REMOTE_ADDR'];
//$ip = '192.168.1.9';
$res = array();


$sql = "SELECT *  FROM `totems` WHERE `ip` LIKE '$ip'";

$res = $conn->query($sql);

echo json_encode($res->fetch_assoc()['rfid']);

$sql = "UPDATE `totems` SET `rfid` = '' WHERE `totems`.`ip` = '$ip'";
$conn->query($sql);
