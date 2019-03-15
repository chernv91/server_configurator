$(document).ready(function () {
    $('div.count, table, #to_excel, #to_pdf').hide();

    $('.item').change(function () {
        $(this).next().show();
        // получаем и заполняем стоимость комплектующего (комплектующих)
        let val = $(this).val();
        let item = $(this).find('option[value="' + val + '"]').text();
        let price = item.match(/([0-9])+(\.[0-9]{2})?\sруб/);

        if (price) {
            price = parseFloat(price[0]);
            price = price.toFixed(2);
        } else {
            price = 0;
        }

        $(this).next().next().text(price + ' руб');
        //сбрасываем счетчик количества комплектующих
        $(this).next().find('span').text('1');

        let name = $(this).attr('name');

        // если изменился процессор, в селектах обновляются комплектующие, в зависимости от материнской платы
        if (name === 'processor') {
            $('select, #calculate').removeAttr('disabled');
            let id = $('#processor').val();
            let motherboard = $('#motherboard');
            // автоматически подставляем значение материнской платы и корпуса
            $.ajax({
                type   : "POST",
                url    : "getMotherboardAndBox.php",
                data   : {id: id},
                success: function (motherboard_box) {
                    let arr = motherboard_box.split('|');
                    // если материнская плата уже была выбрана ранее, удаляем это значение и подставляем новое
                    if (motherboard.length) {
                        motherboard.remove();
                        $('#box').remove();
                    }
                    // Подставляем значения материнской платы и корпуса
                    $('#operating_memory').prev().before('<div id="motherboard"><p>Материнская плата</p>' + arr[0] + '<span class="item_cost">' + arr[1] + ' руб</span></div>');
                    $('#motherboard').after('<div id="box"><p>Корпус</p>' + arr[2] + '<span class="item_cost">' + arr[3] + ' руб</span></div>');

                }
            });

            $.ajax({
                type   : "POST",
                url    : "getOperatingMemory.php",
                data   : {id: id},
                success: function (operating_memories) {
                    $('#operating_memory').html('<option></option>');
                    $('#operating_memory option').after(operating_memories);
                }
            });

            $.ajax({
                type   : "POST",
                url    : "getPcieCard.php",
                data   : {id: id},
                success: function (pcie_cards) {
                    $('#pcie_card').html('<option></option>');
                    $('#pcie_card option').after(pcie_cards);
                }
            });

            $.ajax({
                type   : "POST",
                url    : "getDataStorage.php",
                data   : {id: id},
                success: function (data_storages) {
                    $('#data_storage').html('<option></option>');
                    $('#data_storage option').after(data_storages);
                }
            });

        }
    });

    $('.minus, .minus_server').click(function () {
        let count = $(this).next().text();
        let cnt = +count;

        if (cnt > 1) {
            cnt--;
        }

        $(this).next().text(cnt);
        let but_class = $(this).attr('class');

        if (but_class === 'minus') {
            recalculateItemCost($(this), cnt);
        }

    });

    $('.plus, .plus_server').click(function () {
        let count = $(this).prev().text();
        let cnt = +count;
        cnt++;
        $(this).prev().text(cnt);

        let but_class = $(this).attr('class');

        if (but_class === 'plus') {
            recalculateItemCost($(this), cnt);
        }

    });

    $('#calculate').click(function () {
        $('table, #to_excel, #to_pdf').show();
        // получаем стоимость всех комплектующих и стоимость сервера (серверов)
        let prices = $('.item_cost').text();
        let arr = prices.split('руб');
        arr.pop();
        let sum = 0;

        for (let i = 0, arr_length = arr.length; i < arr_length; i++) {
            sum += parseFloat(arr[i]);
        }

        let server_count = $('#server_count').text();
        sum *= server_count;
        // получаем итоговую стоимость сервера с учетом стоимости установки и скидки, в зависимости от срока аренды
        for (let j = 1, tr_length = $('tr').length; j < tr_length; j++) {
            let discount = $('#discount_' + j).text();
            let install_count = $('#install_count_' + j).text();
            let result = sum + +install_count - sum * discount / 100;
            result = result.toFixed(2);
            $('#result_' + j).text(result);
        }
        //получаем все данные, поступившие из формы, для записи в лог
        let proc = $('#processor');
        let val = proc.val();
        let processor = proc.find('option[value="' + val + '"]').text();
        let proc_count = $('#processor_count span').text();
        let motherboard = $('#motherboard p').text();
        let motherboard_cost = $('#motherboard span').text();
        let box = $('#box p').text();
        let box_cost = $('#box span').text();
        let op_memory = $('#operating_memory');
        val = op_memory.val();
        let operating_memory = op_memory.find('option[value="' + val + '"]').text();
        let op_count = $('#operating_memory_count span').text();
        let pc_card = $('#pcie_card');
        val = pc_card.val();
        let pcie_card = pc_card.find('option[value="' + val + '"]').text();
        let pc_count = $('#pcie_card_count span').text();
        let ds = $('#data_storage');
        val = ds.val();
        let data_storage = ds.find('option[value="' + val + '"]').text();
        let ds_count = $('#data_storage_count span').text();

        $.ajax({
            type: "POST",
            url : "addToLog.php",
            data: {
                processor       : processor,
                proc_count      : proc_count,
                motherboard     : motherboard,
                motherboard_cost: motherboard_cost,
                box             : box,
                box_cost        : box_cost,
                operating_memory: operating_memory,
                op_count        : op_count,
                pcie_card       : pcie_card,
                pc_count        : pc_count,
                data_storage    : data_storage,
                ds_count        : ds_count,
                server_count    : server_count
            }
        });

    });

    $('#to_excel').click(function () {
        let table = $('table').text();
        let arr = table.split('\n');
        let new_arr = [];

        for (let i = 0, arr_length = arr.length; i < arr_length; i++) {
            arr[i] = arr[i].trim();

            if (arr[i] !== '') {
                new_arr.push(arr[i]);
            }

        }

        let str = JSON.stringify(new_arr);

        $.ajax({
            type   : "POST",
            url    : "excel.php",
            data   : {str: str},
            success: function () {
                alert("Ссылка для скачивания: " + window.location.href + "table.xlsx");
            }
        });

    });

    $('#to_pdf').click(function () {
        let table = '<table border="1">' + $('#to_pdf').next().html() + '</table>';

        $.ajax({
            type   : "POST",
            url    : "pdf.php",
            data   : {table: table},
            success: function () {
                alert("Ссылка для скачивания: " + window.location.href + "table.pdf");
            }
        });

    });

});

// функция пересчитывает стоимость комплектующего при изменении количества
function recalculateItemCost(button, cnt) {
    let val = $(button).parent().prev().val();
    let price = $(button).parent().prev().find('option[value="' + val + '"]').text();
    price = price.match(/([0-9])+(\.[0-9]{2})?\sруб/);
    price = parseFloat(price[0]);
    price *= cnt;
    price = price.toFixed(2);
    $(button).parent().next().text(price + ' руб');
    return true;
}
