from bottle import Bottle, run, template, request
from gpiozero import LED

# class LED():
#     def __init__(self, pin):
#         self.pin = pin
#     def on (self):
#         print('turning it on')
#     def off(self):
#         print('turning it off')

app = Bottle()
led = LED(2)
buzzer = LED(3)

@app.route('/')
def index():
    led_status = 'unknown'
    return template('index', led_status=led_status)

@app.route('/led', method='POST')
def led_control():
    device = request.json.get('device')
    status = request.json.get('status')

    if device is None or status is None:
        print("None")
        return {'status': 1}

    print ('device {0} status {1}'.format(device, status))

    device_obj = None
    if device == 'led':
        device_obj = led
    elif device == 'buzzer':
        device_obj = buzzer
    else:
        return {'status': 1}

    if status == 'on':
        print("turning it on")
        device_obj.on()
    elif status == 'off':
        print("turning it off")
        device_obj.off()
    else:
        return {'status': 1}

    return {'status': 0}

app.run(host='0.0.0.0', port=8080, debug=True)
