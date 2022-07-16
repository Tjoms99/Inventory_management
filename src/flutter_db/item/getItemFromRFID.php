<?php
include '../conn.php';

$rfid = $_POST['rfid'];
$customer_id = $_POST['customer_id'];
$account_role = $_POST['account_role'];


$pos = strpos($customer_id, '1');

$sql = "SELECT * FROM ITEMS WHERE rfid LIKE '$rfid'";
$res = $conn->query($sql);


if (mysqli_num_rows($res) != 0) {
    $res = mysqli_fetch_assoc($res);
    if ($account_role == "customer") {
        if (substr($res['registered_customer_id'], $pos, 1) == "1" && $pos !== false) {
            echo json_encode($res);
        }
    } else {
        echo json_encode($res);
    }
}
