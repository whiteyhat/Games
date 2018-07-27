<?php
$id = $_POST["id"]
$score = $_POST["score"]
require("Connection.php");
$sql = "INSERT INTO satodb (id, age) VALUES ('$id', '$score')";

mysqli_set_charset($connection, $sql);
echo 1;
?>