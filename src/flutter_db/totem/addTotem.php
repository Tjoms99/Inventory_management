<?php
include '../conn.php';

$rfid = $_POST['rfid'];
$totem_id = $_POST['totem_id'];

$rfid = substr($rfid, 2, -2);

$sql = "SELECT * FROM `totems` WHERE `totem_id` LIKE '$totem_id'";
$res = $conn->query($sql);

if (mysqli_num_rows($res) == 0) {
    $sql = "INSERT INTO `totems`(`totem_id`, `rfid`) VALUES ('$totem_id','$rfid')";
} else {
    $sql = "UPDATE `totems` SET `rfid` = '$rfid' WHERE `totems`.`totem_id` = '$totem_id'";
}
$conn->query($sql);
