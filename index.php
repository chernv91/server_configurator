<?php
/**
 * @author lera
 *
 * Скрипт заполняет значениями из БД  select для процессора и результирующую таблицу
 */
require 'connect.php';
$sql1 = <<<SQL
SELECT processor_id, name, price
FROM processor
SQL;
$sql2 = <<<SQL
SELECT months_count, discount, install_cost
FROM install_information
SQL;
try {
    if (!$mysqli->query($sql1)) {
        throw new Exception($mysqli->error);
    }
    if (!$mysqli->query($sql2)) {
        throw new Exception($mysqli->error);
    }
} catch (Exception $e) {
    echo $e->getMessage() . "\n";
    exit();
}
$processors = $mysqli->query($sql1);
$install_information = $mysqli->query($sql2);
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Конфигуратор серверов</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="style.css">
    <script
            src="https://code.jquery.com/jquery-3.3.1.js"
            integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60="
            crossorigin="anonymous"></script>
    <script src="script.js"></script>
</head>
<body>
<h1>Конфигуратор серверов</h1>
<form action="<?= $_SERVER['PHP_SELF'] ?>">
    <p>Процессор</p>
    <select class="item" id="processor" name="processor">
        <option></option>
        <?php
        while ($row = $processors->fetch_assoc()) {
            ?>
            <option value="<?= $row['processor_id'] ?>"><?= "{$row['name']} - {$row['price']} руб" ?></option>
            <?php
        }
        $processors->close();
        ?>
    </select>
    <div id="processor_count" class="count">
        <button type="button" class="minus">-</button>
        <span class="count">1</span>
        <button type="button" class="plus">+</button>
    </div>
    <span class="item_cost"></span>
    <p>Оперативная память</p>
    <select class="item" id="operating_memory" name="operating_memory" disabled="disabled">
        <option></option>
    </select>
    <div id="operating_memory_count" class="count">
        <button type="button" class="minus">-</button>
        <span class="count">1</span>
        <button type="button" class="plus">+</button>
    </div>
    <span class="item_cost"></span>
    <p>PCIE карта</p>
    <select class="item" id="pcie_card" name="pcie_card" disabled="disabled">
        <option></option>
    </select>
    <div id="pcie_card_count" class="count">
        <button type="button" class="minus">-</button>
        <span class="count">1</span>
        <button type="button" class="plus">+</button>
    </div>
    <span class="item_cost"></span>
    <p>Устройство хранения данных</p>
    <select class="item" id="data_storage" name="data_storage" disabled="disabled">
        <option></option>
    </select>
    <div id="data_storage_count" class="count">
        <button type="button" class="minus">-</button>
        <span class="count">1</span>
        <button type="button" class="plus">+</button>
    </div>
    <span class="item_cost"></span>
</form>
<p>Количество серверов:</p>
<div class="count_server">
    <button type="button" class="minus_server">-</button>
    <span id="server_count">1</span>
    <button type="button" class="plus_server">+</button>
</div>
<button type="button" id="calculate" disabled="disabled">Рассчитать</button>
<br>
<button type="button" id="to_excel">Выгрузить в Excel</button>
<button type="button" id="to_pdf">Выгрузить в PDF</button>
<table>
    <tr>
        <th>Срок аренды, мес</th>
        <th>Скидка, %</th>
        <th>Стоимость установки, руб</th>
        <th>Итого, руб:</th>
    </tr>
    <?php
    $i = 0;
    foreach ($install_information as $information) {
        $i++;
        ?>
        <tr>
            <td id="<?= "months_count_$i" ?>"><?= $information['months_count'] ?></td>
            <td id="<?= "discount_$i" ?>"><?= $information['discount'] ?></td>
            <td id="<?= "install_count_$i" ?>"><?= $information['install_cost'] ?></td>
            <td id="<?= "result_$i" ?>"></td>
        </tr>
        <?php
    }
    $install_information->close();
    $mysqli->close();
    ?>
</table>
</body>
</html>