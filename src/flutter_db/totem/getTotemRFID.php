<?php
include '../conn.php';

$totem_id = $_POST['totem_id'];
//$ip = '192.168.1.9';
$res = array();


$sql = "SELECT *  FROM `totems` WHERE `totem_id` LIKE '$totem_id'";

$res = $conn->query($sql);

echo json_encode($res->fetch_assoc()['rfid']);

$sql = "UPDATE `totems` SET `rfid` = '' WHERE `totems`.`totem_id` = '$totem_id'";
$conn->query($sql);
