// ATmega328p LED Blink
// Designed to be as minimal as possible

// vectors taken from https://github.com/FireFox317/avr-arduino-zig
comptime {
    asm (
        \\.section .vectors
        \\ jmp _start
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
    );
}

pub export fn _unhandled_vector() noreturn {
    while (true) {}
}

// _start seems to be the expected entry point
pub export fn _start() noreturn {
    main();
}

const PINB: *volatile u8 = @ptrFromInt(0x23);
const DDRB: *volatile u8 = @ptrFromInt(0x24);
const PORTB: *volatile u8 = @ptrFromInt(0x25);

fn main() noreturn {
    const LED_PIN: u8 = 5;
    var cnt: u32 = 0;
    DDRB.* |= 1 << LED_PIN; // set as output
    while (true) {
        PINB.* |= 1 << LED_PIN; // toggle
        cnt = 1_000_000; // about 1 sec
        while (cnt > 0) : (cnt -= 1){
            asm volatile ("nop");
        }
    }
}
