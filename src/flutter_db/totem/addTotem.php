<?php
include '../conn.php';

$rfid = $_POST['rfid'];
$ip = $_SERVER['REMOTE_ADDR'];

$rfid = substr($rfid, 2, -2);

$sql = "SELECT * FROM `totems` WHERE `ip` LIKE '$ip'";
$res = $conn->query($sql);

if (mysqli_num_rows($res) == 0) {
    $sql = "INSERT INTO `totems`(`ip`, `rfid`) VALUES ('$ip','$rfid')";
} else {
    $sql = "UPDATE `totems` SET `rfid` = '$rfid' WHERE `totems`.`ip` = '$ip'";
}
$conn->query($sql);
