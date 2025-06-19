
%% Part A: Amplitude Modulation (AM)
% Chris Samuel Salcedo
% 2022-05055
% CMSC 137

fs = 1000;
T = 3; % time duration in seconds
t = 0:1/fs:T; % time vector

% message signal
Am = 1; % amplitude
fm = 1; % frequency in hz
message_signal = Am * sin(2 * pi * fm * t);

% carrier signal
Ac = 1; % amplitude
fc = 20; % frequency in hz
carrier_signal = Ac * sin(2 * pi * fc * t);

% plot
subplot(2,1,1);
plot(t, message_signal, "MarkerFaceColor","#231650");
grid on;
title('Message Signal (Sine Wave)');
xlabel('Time');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, carrier_signal, 'r');
grid on;
title('Carrier Signal (Sine Wave)');
xlabel('Time');
ylabel('Amplitude');

%% Part B: Amplitude Shift Keying (ASK) / On-Off Keying (OOK)

fs = 1000; % sampling frequency
bit_duration = 0.1; % duration of one bit in seconds
t_bit = 0:1/fs:bit_duration-1/fs; % time vector for one bit
fc = 20; % carrier frequency
Ac = 1; % carrier amplitude

% user input 8-bit binary sequence
bits = input('enter a 12-bit binary sequence (e.g. 101010101010): ', 's');
bits = double(bits) - '0';
if length(bits) ~= 12 || any(bits ~= 0 & bits ~= 1)
    error('invalid input! please enter exactly 12 binary values (0s and 1s).');
end

% generate binary message signal
message_signal = [];
carrier_signal = [];
ask_signal = [];
time = [];
for i = 1:length(bits)
    message_signal = [message_signal bits(i) * ones(1, length(t_bit))];
    carrier = Ac * sin(2 * pi * fc * t_bit);
    ask_signal = [ask_signal bits(i) * carrier];
    time = [time, (i-1)*bit_duration + t_bit];
end

% plot binary and carrier signals
subplot(3,1,1);
stairs(time, message_signal, 'b');
grid on;
title('Binary Message Signal');
xlabel('Time');
ylabel('Amplitude');
ylim([-0.5 1.5]);

subplot(3,1,2);
plot(time, repmat(carrier, 1, length(bits)), 'r');
grid on;
title('Carrier Signal');
xlabel('Time');
ylabel('Amplitude');

subplot(3,1,3);
plot(time, ask_signal, 'k');
grid on;
title('ASK Modulated Signal');
xlabel('Time');
ylabel('Amplitude');