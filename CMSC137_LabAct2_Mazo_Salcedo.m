% Pair # 9
% Mazo, Kristianna Isabel
% Salcedo, Chris Samuel
% Date submitted: March 16, 2025

%% Part I: Two-Dimensional Parity Check (Even Parity)
clc;
clear;

str = 'CMSC137';
n = length(str);   % number of characters (rows)
data = zeros(n, 8);  % each character will be represented by 8 bits

for i = 1:n
    ascii_val = double(str(i));
    bin_str = dec2bin(ascii_val, 8);  % get 8-bit binary string
    % Convert the char array ('0' and '1') into numeric vector (0s and 1s)
    data(i,:) = bin_str - '0';
end

disp('Original Data (ASCII binary representation):');
disp(data);

% For even parity, if the sum of the row bits is odd, parity bit = 1, else 0.
row_parity = mod(sum(data,2),2);
% Append as an extra column
data_aug = [data, row_parity];

% Compute parity on each column of data_aug
col_parity = mod(sum(data_aug,1),2);
% Append as an extra row
codeword = [data_aug; col_parity];

disp('Codeword with 2D Parity (including parity bits):');
disp(codeword);

[totalRows, totalCols] = size(codeword);

% Scenario 1: No error (transmitted correctly)
codeword_no_error = codeword;

% Scenario 2: 1 Random Bit Error
codeword_1err = codeword;
rand_row = randi(totalRows);
rand_col = randi(totalCols);
codeword_1err(rand_row, rand_col) = mod(codeword_1err(rand_row, rand_col) + 1, 2);

% Scenario 3: 2 Bits Error (both in the same row)
codeword_2err = codeword;
% Choose a random data row (avoid the parity row)
err_row = randi(n);  
% Choose two distinct columns (they could be from data or parity columns)
err_cols = randperm(totalCols, 2);
codeword_2err(err_row, err_cols) = mod(codeword_2err(err_row, err_cols) + 1, 2);

% Scenario 4: 3 Random Bits Error
codeword_3err = codeword;
% Select 3 unique positions in the entire matrix
indices = randperm(totalRows * totalCols, 3);
for k = 1:3
    [r, c] = ind2sub([totalRows, totalCols], indices(k));
    codeword_3err(r,c) = mod(codeword_3err(r,c) + 1, 2);
end

% Scenario 5: 4 Bits Error (2 in one row, 2 in one column)
codeword_4err = codeword;
% To create an error pattern that may go undetected by 2D parity,
% choose two distinct data rows and two distinct columns.
selected_rows = randperm(n, 2);     % choose among data rows only
selected_cols = randperm(totalCols, 2); % can include the parity column too
% Flip the bits at the intersections (4 positions)
for r = selected_rows
    for c = selected_cols
        codeword_4err(r, c) = mod(codeword_4err(r, c) + 1, 2);
    end
end

disp('--- Error Scenarios ---');
disp('1. Codeword with 1 random bit error:');
disp(codeword_1err);

disp('2. Codeword with 2 bits error (same row):');
disp(codeword_2err);

disp('3. Codeword with 3 random bits error:');
disp(codeword_3err);

disp('4. Codeword with 4 bits error (2 same row, 2 same column):');
disp(codeword_4err);

%% Part II: Cyclic Redundancy Check (CRC)
clc;
clear;

% 8-bit binary input
dataword_str = input('Enter an 8-bit sequence (e.g., 11010111): ', 's');
if length(dataword_str) ~= 8 || ~all(ismember(dataword_str, '01'))
    error('Input must be an 8-bit binary sequence composed of 0s and 1s.');
end

% binary string to vector
dataword = dataword_str - '0';

% define the generator polynomial
% for "1011", the polynomial degree is 3.
generator_str = '1011';
generator = generator_str - '0';
gen_length = length(generator);

% append zeros to the dataword
augmented = [dataword, zeros(1, gen_length-1)];

% perform modulo-2 division to compute the remainder 
remainder = augmented;
for i = 1:length(dataword)
    if remainder(i) == 1
        remainder(i:i+gen_length-1) = xor(remainder(i:i+gen_length-1), generator);
    end
end
crc = remainder(end-gen_length+2:end);

disp('CRC remainder bits:');
disp(crc);

% the transmitted codeword is the original dataword followed by the CRC bits.
transmitted = [dataword, crc];
disp('Transmitted codeword (dataword concatenated with CRC):');
disp(transmitted);
