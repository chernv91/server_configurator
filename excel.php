<?php
/**
 * @author lera
 *
 * Скрипт генерирует и сохраняет результирующую таблицу в  Excel (файл table.xlsx)
 *
 * @see    script.js
 */
require 'vendor/autoload.php';

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

$spreadsheet = new Spreadsheet();
$sheet = $spreadsheet->getActiveSheet();

$str = $_POST['str'];
$arr = json_decode($str);
$arr2 = array_chunk($arr, 4);

$row = 1;

foreach ($arr2 as $arr) {
    $sheet->setCellValue("A$row", $arr[0]);
    $sheet->setCellValue("B$row", $arr[1]);
    $sheet->setCellValue("C$row", $arr[2]);
    $sheet->setCellValue("D$row", $arr[3]);
    $row++;
}

$styleArray = [
    'borders' => [
        'allBorders' => [
            'borderStyle' => \PhpOffice\PhpSpreadsheet\Style\Border::BORDER_THIN,
            'color'       => ['argb' => '00000000'],
        ],
    ],

];
$row--;

$sheet->getStyle("A1:D$row")->applyFromArray($styleArray);
$spreadsheet->getActiveSheet()->getDefaultColumnDimension()->setWidth(30);
$spreadsheet->getActiveSheet()->getStyle('A1:D1')->getAlignment()->setHorizontal(\PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER);
$spreadsheet->getActiveSheet()->getStyle("A2:C$row")->getAlignment()->setHorizontal(\PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER);
$spreadsheet->getActiveSheet()->getStyle('A1:D1')->getFont()->setBold(true);
$writer = new Xlsx($spreadsheet);
$writer->save('table.xlsx');