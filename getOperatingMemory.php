<?php
/**
 * @author lera
 *
 * Скрипт возвращает модели оперативной памяти, в зависимости от выбранного процессора
 *
 * @see    script.js
 */
require 'connect.php';
$processor_id = (int)$_POST['id'];

$sql1 = <<<SQL
SELECT om.operating_memory_id, om.value, om.type, om.subtype, om.form_factor, om.price
FROM operating_memory om
       INNER JOIN motherboard_operating_memory mom ON om.operating_memory_id = mom.operating_memory_id
       INNER JOIN motherboard m ON mom.motherboard_id = m.motherboard_id
       INNER JOIN motherboard_processor mp ON m.motherboard_id = mp.motherboard_id
       INNER JOIN processor p ON mp.processor_id = p.processor_id
WHERE p.processor_id = $processor_id
SQL;

$result = $mysqli->query($sql1);
$operating_memories = $result->fetch_all(MYSQLI_ASSOC);
$result->close();
$mysqli->close();

$op = '';
foreach ($operating_memories as $operating_memory) {
    $op .= "<option value='{$operating_memory['operating_memory_id']}'>{$operating_memory['value']} {$operating_memory['type']} {$operating_memory['form_factor']} - {$operating_memory['price']} руб</option>";
}

echo $op;



