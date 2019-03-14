<?php
/**
 * @author lera
 *
 * Скрипт возвращает название и стоимость материнской платы и корпуса, в зависимости от выбранного процессора
 *
 * @see    script.js
 */
require 'connect.php';
$processor_id = (int)$_POST['id'];

if ($processor_id > 0) {

    $sql1 = <<<SQL
SELECT m.name, m.price, m.box_id
FROM motherboard m
       INNER JOIN motherboard_processor mp ON m.motherboard_id = mp.motherboard_id
       INNER JOIN processor p ON mp.processor_id = p.processor_id
WHERE p.processor_id = $processor_id
SQL;

    try {
        if (!$mysqli->query($sql1)) {
            throw new Exception($mysqli->error);
        }
    } catch (Exception $e) {
        echo $e->getMessage() . "\n";
    }

    $result = $mysqli->query($sql1);
    $motherboard = $result->fetch_all(MYSQLI_ASSOC);
    $result->close();
    $box = $motherboard[0]['box_id'];

    $sql2 = <<<SQL
SELECT name, price
FROM box
WHERE id = $box
SQL;

    try {
        if (!$mysqli->query($sql1)) {
            throw new Exception($mysqli->error);
        }
    } catch (Exception $e) {
        echo $e->getMessage() . "\n";
    }

    $result = $mysqli->query($sql2);
    $box = $result->fetch_all(MYSQLI_ASSOC);
    $result->close();
    $mysqli->close();
    echo $motherboard[0]['name'] . '|' . $motherboard[0]['price'] . '|' . $box[0]['name'] . '|' . $box[0]['price'];

}
