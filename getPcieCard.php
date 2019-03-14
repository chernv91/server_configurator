<?php
/**
 * @author lera
 *
 * Скрипт возвращает pcie карты, в зависимости от выбранного процессора
 *
 * @see    script.js
 */
require 'connect.php';
$processor_id = (int)$_POST['id'];

$sql1 = <<<SQL
SELECT pc.pcie_card_id, pc.name, pc.type, pc.price
FROM pcie_card pc
       INNER JOIN motherboard_pcie_card mpc ON pc.pcie_card_id = mpc.pcie_card_id
       INNER JOIN motherboard m ON mpc.motherboard_id = m.motherboard_id
       INNER JOIN motherboard_processor mp ON m.motherboard_id = mp.motherboard_id
       INNER JOIN processor p ON mp.processor_id = p.processor_id
WHERE p.processor_id = $processor_id
SQL;

$result = $mysqli->query($sql1);
$pcie_cards = $result->fetch_all(MYSQLI_ASSOC);
$result->close();
$mysqli->close();

$pc = '';
foreach ($pcie_cards as $pcie_card) {
    $pc .= "<option value='{$pcie_card['pcie_card_id']}'>{$pcie_card['name']} {$pcie_card['type']} - {$pcie_card['price']} руб</option>";
}

echo $pc;



