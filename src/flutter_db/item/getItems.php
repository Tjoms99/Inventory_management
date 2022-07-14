<?php
include '../conn.php';

$account_role = $_POST['account_role'];
$customer_id = $_POST['customer_id'];

if ($account_role = 'admin'){
    $sql = $conn->query("SELECT * FROM ITEMS");
}
else{
    $sql = $conn->query("SELECT * FROM ITEMS WHERE 'customer_id' LIKE '$customer_id'");
}

$res = array();

while ($row = $sql->fetch_assoc()) {
    $res[] = $row;
}

echo json_encode($res);
