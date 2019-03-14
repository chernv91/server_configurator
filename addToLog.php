<?php
/**
 * @author lera
 *
 * Скрипт записывает данные, пришедшие из формы, в лог server_configuration.log
 *
 * @see    script.js
 */
require 'vendor/autoload.php';

use Monolog\Logger;
use Monolog\Handler\StreamHandler;

$ip = $_SERVER['REMOTE_ADDR'];
$processor = $_POST['processor'];
$proc_count = $_POST['proc_count'];
$motherboard = $_POST['motherboard'];
$motherboard_cost = $_POST['motherboard_cost'];
$box = $_POST['box'];
$box_cost = $_POST['box_cost'];
$operating_memory = $_POST['operating_memory'];
$op_count = $_POST['op_count'];
$pcie_card = $_POST['pcie_card'];
$pc_count = $_POST['pc_count'];
$data_storage = $_POST['data_storage'];
$ds_count = $_POST['ds_count'];
$server_count = $_POST['server_count'];

$log = new Logger('server_configuration');
$log->pushHandler(new StreamHandler('server_configuration.log', Logger::INFO));

$log->info("$ip, $processor, $proc_count шт, 
$motherboard - $motherboard_cost,
$box - $box_cost,
$operating_memory, $op_count шт,
$pcie_card, $pc_count шт,
$data_storage, $ds_count шт,
Количество серверов - $server_count");