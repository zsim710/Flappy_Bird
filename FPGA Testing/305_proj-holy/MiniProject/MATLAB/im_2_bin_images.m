% Binarize Image Using Global Threshold
% Read grayscale image into the workspace.
I = imread('C:\Users\deven\Documents\305\305_proj\MiniProject\Images\Original\original_flappy_bird.png');

% Convert the image into a binary image.
BW = imbinarize(I);

% Display the original image next to the binary version.
figure
imshowpair(I,BW,'montage')
% Now I wanna turn this into a .bin file:
% Open the file for writing in binary mode
fileID = fopen('og_flappy_bird.bin', 'wb');

% Write the image data to the file
fwrite(fileID, BW, 'uint8');

% Close the file
fclose(fileID);

