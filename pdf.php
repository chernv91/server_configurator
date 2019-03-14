<?php
/**
 * @author lera
 *
 * Скрипт генерирует и сохраняет результирующую таблицу в  Pdf (файл table.pdf)
 *
 * @see    script.js
 */
require 'TCPDF/tcpdf.php';

$table = $_POST['table'];

$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
$pdf->SetFont('dejavusans', 'B', 14, '', true);
$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
$pdf->AddPage();
$pdf->writeHTMLCell($w = 0, $h = 0, $x = '', $y = '', $table, $border = 0, $ln = 1, $fill = 0, $reseth = true,
    $align = 'C');
$pdf->Output(__DIR__ . '/table.pdf', 'FD');