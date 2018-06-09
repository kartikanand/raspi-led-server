<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1'>
        <title>LED Server</title>
        <style media="screen">
            html, body {
                height: 100%;
                width: 100%;
                font-size: 15px;
            }

            form {
                width: 100%;
            }

            form button {
                display: inline-block;
                width: 25%;
                height: 50px;
            }
        </style>
    </head>
    <body>
        <form action="/led" method="post">
            <h3>LED STATUS : <span id="led_status">unknown</span></h3>
            <button type="submit" name="led" value="on">ON</button>
            <button type="submit" name="led" value="off">OFF</button>

            <h3>BUZZER STATUS : <span id="buzzer_status">unknown</span></h3>
            <button type="submit" name="buzzer" value="on">ON</button>
            <button type="submit" name="buzzer" value="off">OFF</button>
        </form>
        <script type="text/javascript">
            (function () {
                window.onload = function () {
                    var formButtons = document.querySelectorAll('form button');
                    for (var i=0; i<formButtons.length; i++) {
                        formButtons[i].addEventListener('click', function (ev) {
                            this.form.device = this.name;
                            this.form.status = this.value;
                        });
                    }

                    document.querySelector('form').addEventListener('submit', function (ev) {
                        ev.preventDefault();

                        var status = this.status;
                        var device = this.device;

                        var url = this.getAttribute('action');
                        var xhr = new XMLHttpRequest();
                        xhr.open('POST', url);
                        xhr.onload = function () {
                            if (xhr.status ==  200) {
                                var response = JSON.parse(xhr.responseText);
                                if (response.status == '0') {
                                    var deviceStatus = null;
                                    if (device == 'led')
                                        deviceStatus = document.getElementById("led_status");
                                    else
                                        deviceStatus = document.getElementById("buzzer_status");

                                    deviceStatus.innerText = status;
                                }
                            }
                        };
                        xhr.onerror = function (err) {
                            console.log(err);
                        };

                        var data = {
                            status: status,
                            device: device
                        };
                        xhr.setRequestHeader("Content-type", "application/json");
                        xhr.send(JSON.stringify(data));
                    });
                };
            }(window));
        </script>
    </body>
</html>
