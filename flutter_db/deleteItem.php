<?php
include 'conn.php';

$id = $_POST['id'];
$id = intval($id);

$sql = "DELETE FROM `items` WHERE `items`.`id` = $id";
$conn->query($sql);
