import serial
import tkinter as tk

# Serial parameters
SERIAL_PORT = 'COM3'
BAUD_RATE = 115200

ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=0.01)
print(f"Connected to {SERIAL_PORT}")

# Upper = ON, Lower = OFF
# Tkinter KeySyms: 'w', 's', 'Up', 'Down'
controls = {
    'w':    {'press': b'W', 'release': b'w', 'label': 'P1 UP (W)'},
    's':    {'press': b'S', 'release': b's', 'label': 'P1 DOWN (S)'},
    'Up':   {'press': b'I', 'release': b'i', 'label': 'P2 UP (Arrow)'},
    'Down': {'press': b'K', 'release': b'k', 'label': 'P2 DOWN (Arrow)'}
}

# Track keys to filter out spam from keys auto repeating
active_keys = set()

def send_uart(byte_data):
    if ser and ser.is_open:
        ser.write(byte_data)

class PongDriver(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("FPGA Pong Input")
        self.geometry("300x400")
        
        # Labels for visual feedback
        self.ui_labels = {}
        
        tk.Label(self, text="Keyboard input", font=("Arial", 12, "bold")).pack(pady=10)
        
        for key in controls:
            lbl = tk.Label(self, text=controls[key]['label'], width=20, height=2, 
                           bg="lightgray", relief="raised")
            lbl.pack(pady=5)
            # Store reference using the keysym (e.g., 'Up')
            self.ui_labels[key] = lbl

        # Bind native window events
        self.bind('<KeyPress>', self.on_press)
        self.bind('<KeyRelease>', self.on_release)
        
        # Release all keys on close
        self.protocol("WM_DELETE_WINDOW", self.on_close)

    def on_press(self, event):
        key = event.keysym
        
        # Only act if it's a valid control key and not already held
        # Ignore repeated key presses from holding down key
        if key in controls and key not in active_keys:
            active_keys.add(key)
            send_uart(controls[key]['press'])
            self.ui_labels[key].config(bg="lime green")
            # print(f"Sent: {controls[key]['press']}")

    def on_release(self, event):
        key = event.keysym
        
        # Only act if it was previously active
        if key in controls and key in active_keys:
            active_keys.discard(key)
            send_uart(controls[key]['release'])
            self.ui_labels[key].config(bg="lightgray")

    def on_close(self):
        print("Ending input")
        if ser and ser.is_open:
            for key in controls:
                ser.write(controls[key]['release'])
            ser.close()
        self.destroy()

if __name__ == "__main__":
    app = PongDriver()
    app.mainloop()