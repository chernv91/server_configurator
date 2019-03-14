<?php
/**
 * @author lera
 *
 * Скрипт возвращает устройства хранения данных, в зависимости от выбранного процессора
 *
 * @see    script.js
 */
require 'connect.php';
$processor_id = (int)$_POST['id'];

$sql1 = <<<SQL
SELECT ds.data_storage_id, ds.name, ds.type, ds.value, ds.price
FROM data_storage ds
       INNER JOIN motherboard_data_storage mds ON ds.data_storage_id = mds.data_storage_id
       INNER JOIN motherboard m ON mds.motherboard_id = m.motherboard_id
       INNER JOIN motherboard_processor mp ON m.motherboard_id = mp.motherboard_id
       INNER JOIN processor p ON mp.processor_id = p.processor_id
WHERE p.processor_id = $processor_id
SQL;

$result = $mysqli->query($sql1);
$data_storages = $result->fetch_all(MYSQLI_ASSOC);
$result->close();
$mysqli->close();

$ds = '';
foreach ($data_storages as $data_storage) {
    $ds .= "<option value='{$data_storage['data_storage_id']}'>{$data_storage['name']} {$data_storage['type']} - {$data_storage['price']} руб</option>";
}

echo $ds;



